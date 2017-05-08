Imports IntranetPortal
Imports IntranetPortal.Data

''' <summary>
'''     The interface for property service provider
''' </summary>
Public Interface IPropertyServiceProvider
    ''' <summary>
    '''     Update leads general data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Function UpdateLeadsGeneralData(bble As String) As LeadsInfo

    ''' <summary>
    '''     Update leads mortgage, tax, water, zillow etc.
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="assessment">Indicate if general data is included</param>
    ''' <param name="order">The Custom Order</param>
    ''' <returns></returns>
    Function UpdateLeadInfo(bble As String, assessment As Boolean, order As APIOrder) As Boolean

    ''' <summary>
    '''     Update the leads servicer
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    Sub UpdateServicer(bble As String)

    ''' <summary>
    '''     Update external data to portal
    ''' </summary>
    ''' <param name="externalData">The external data object</param>
    ''' <returns></returns>
    Function UpdateExternalData(externalData As ExternalData) As Boolean

    ''' <summary>
    '''     Update zillow estimate data to leads
    ''' </summary>
    ''' <param name="bble"></param>
    ''' <returns></returns>
    Function UpdateZillowValue(bble As String) As LeadsInfo

    ''' <summary>
    '''     Return leads lispends list
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Function GetLiensInfo(bble As String) As List(Of PortalLisPen)

    ''' <summary>
    '''     Return property all liens data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Function GetAllLiens(bble As String) As AllLiens

    ''' <summary>
    '''     Update leads owner data to latest
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    Sub LoadLatestOwner(bble As String)

    ''' <summary>
    '''     Return property data on street number, street name and borough
    ''' </summary>
    ''' <param name="num">Street Number</param>
    ''' <param name="strName">Street Name</param>
    ''' <param name="borough">Borough</param>
    ''' <returns></returns>
    Function GetPropbyAddress(num As String, strName As String, borough As String) As PhysicalData

    ''' <summary>
    '''     Return property information base on BBLE
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Function GetPropGeneralInfo(bble As String) As GeneralPropertyInformation
End Interface

''' <summary>
'''     Provide lead property data
''' </summary>
Public Class PropertyServiceProvider
    Implements IPropertyServiceProvider
    Implements IDisposable

#Region "Private member"

    Private svr As New PropertyService
    Private ctx As New Entities

#End Region

#Region "leads general info"
    ''' <summary>
    '''     Load property generate information
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="li">LeadsInfo Object</param>
    ''' <returns></returns>
    Public Function GetFullAssessInfo(bble As String, Optional li As LeadsInfo = Nothing) As LeadsInfo

        Try
            Dim result = svr.GetGeneralInformation(bble)

            If li Is Nothing Then
                li = New LeadsInfo
                li.BBLE = bble
                li.CreateDate = DateTime.Now
                li.CreateBy = GetCurrentIdentityName()
            End If

            If result IsNot Nothing Then
                li.Number = result.propertyInformation.StreetNumber
                li.StreetName = result.propertyInformation.StreetName
                li.NeighName = result.propertyInformation.NTA
                li.State = result.address.state
                li.ZipCode = result.propertyInformation.ZipCode
                li.City = result.address.city

                If Not String.IsNullOrEmpty(result.propertyInformation.UnitNumber) AndAlso Not String.IsNullOrEmpty(result.propertyInformation.UnitNumber) Then
                    li.UnitNum = result.propertyInformation.UnitNumber.Trim
                End If

                li.PropertyAddress = result.address.FormatAddress
                li.Borough = result.propertyInformation.Borough
                li.Zoning = result.propertyInformation.Zoning
                li.MaxFar = String.Format("{0:0.##}", (result.propertyInformation.MaxResidentialFAR))
                li.ActualFar = String.Format("{0:0.##}", (result.propertyInformation.BuiltFAR))
                li.NYCSqft = result.propertyInformation.BuildingGrossArea
                li.Latitude = result.propertyInformation.Latitude
                li.Longitude = result.propertyInformation.Longitude

                If result.propertyInformation.UnbuiltSqft.HasValue Then
                    li.UnbuiltSqft = result.propertyInformation.UnbuiltSqft
                    LeadsInfo.AddIndicator("UnderBuilt", li, GetCurrentIdentityName())
                End If

                li.Block = result.propertyInformation.Block
                li.Lot = result.propertyInformation.Lot
                li.YearBuilt = result.propertyInformation.YearBuilt
                li.TaxClass = result.propertyInformation.TaxClass
                li.PropertyClass = result.propertyInformation.BuildingClassCode
                li.NumFloors = result.propertyInformation.Stories
                li.BuildingDem = result.propertyInformation.BuildingDem
                li.LotDem = result.propertyInformation.LotDem
                li.LastUpdate = DateTime.Now

                If result.owners IsNot Nothing AndAlso result.owners.Count > 0 Then
                    Dim owner = result.owners(0)
                    li.Owner = owner.Name
                    UpdateDeedParty(bble, result.owners(0))

                    If result.owners.Count > 1 Then
                        li.CoOwner = result.owners(1).Name
                        UpdateDeedParty(bble, result.owners(1))
                    End If
                End If

                li.UpdateBy = GetCurrentIdentityName()
                Return li
            End If
            Return li
        Catch ex As Exception
            Throw New Exception("Error in GetFullAssessInfo: " + ex.Message, ex)
        End Try
    End Function

    ''' <summary>
    '''     Update Aparment building data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function UpdateApartmentBuildingInfo(bble As String) As LeadsInfo
        Try
            Dim li As LeadsInfo = ctx.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault
            Dim tmpBBL = li.BBLE
            li = GetFullAssessInfo(li.BuildingBBLE, li)
            li.BBLE = tmpBBL

            If Not String.IsNullOrEmpty(li.UnitNum) Then
                li.Number = li.AptBuildingInfo.Number
                li.StreetName = li.AptBuildingInfo.StreetName
                li.NeighName = li.AptBuildingInfo.NeighName
                li.State = li.AptBuildingInfo.State
                li.ZipCode = li.AptBuildingInfo.ZipCode
                li.PropertyAddress = li.AptBuildingInfo.Address
            End If

            ctx.SaveChanges()

            'Update Home owner info
            SaveHomeOwner(bble, li.Owner, li.Address1, "", li.NeighName, li.State, "US", li.ZipCode, ctx)

            If String.IsNullOrEmpty(li.CoOwner) Then
                SaveHomeOwner(bble, li.CoOwner, li.Address1, "", li.NeighName, li.State, "US", li.ZipCode, ctx)
            End If

            ctx.SaveChanges()

            'Update leads neighborhood info
            Dim lead = ctx.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
            If lead IsNot Nothing Then
                lead.Neighborhood = li.NeighName
                lead.LeadsName = li.LeadsName
                lead.LastUpdate = DateTime.Now
                lead.UpdateBy = GetCurrentIdentityName()
                ctx.SaveChanges()
            End If
            Return li

        Catch ex As System.ServiceModel.EndpointNotFoundException
            Throw New Exception("The data serice is not avaiable. Please refresh later.")
        Catch ex As Exception
            Throw New Exception("Exception happened during updating Apartment. Please try later. Exception: " & ex.Message)
        End Try
    End Function

    ''' <summary>
    '''     Update general property info and lispendas data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function UpdateLeadsGeneralData(bble As String) As LeadsInfo Implements IPropertyServiceProvider.UpdateLeadsGeneralData
        Try
            ' this is apartment
            If bble.StartsWith("A") Then
                Return UpdateApartmentBuildingInfo(bble)
            End If


            Dim li As LeadsInfo = ctx.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault
            If li Is Nothing Then
                li = GetFullAssessInfo(bble, li)
                ctx.LeadsInfoes.Add(li)
            Else
                li = GetFullAssessInfo(bble, li)
            End If

            ' Update Liens Info
            Dim lisPens = GetLiensInfo(bble)
            If lisPens IsNot Nothing Then
                Dim localLispens = ctx.PortalLisPens.Where(Function(lp) lp.BBLE = bble)
                ctx.PortalLisPens.RemoveRange(localLispens)

                If lisPens.Count > 0 Then
                    ctx.PortalLisPens.AddRange(lisPens)
                End If
            End If

            ctx.SaveChanges()

            li = ctx.LeadsInfoes.Find(bble)
            ' LeadsInfo.AddIndicator("LPDefandant", li, GetCurrentIdentityName())

            ' Update leads neighborhood info
            Dim lead = ctx.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
            If lead IsNot Nothing Then
                lead.Neighborhood = li.NeighName
                lead.LeadsName = li.LeadsName
                lead.LastUpdate = DateTime.Now
                lead.UpdateBy = GetCurrentIdentityName()
                ctx.SaveChanges()
            End If

            Return li

        Catch ex As System.ServiceModel.EndpointNotFoundException
            Throw New Exception("The data serice is not avaiable. Please refresh later.")
        Catch ex As Exception
            Throw New Exception("Exception happened during updating. Please try later. Exception: " & ex.Message, ex)
        End Try
    End Function

    ''' <summary>
    '''     Get property lispends data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function GetLiensInfo(bble As String) As List(Of PortalLisPen) Implements IPropertyServiceProvider.GetLiensInfo
        Dim lisPens As New List(Of PortalLisPen)

        Try
            Dim newLPs = svr.GetLpLiens(bble)
            If newLPs IsNot Nothing Then
                For Each item In newLPs
                    Dim lisPen As New PortalLisPen
                    lisPen.LpType = item.LisPendensType
                    lisPen.Expiration = item.ExpirationDate
                    lisPen.BBLE = item.BBL
                    lisPen.CollectedOn = item.DataEntryDateTime
                    lisPen.County = item.CountyName
                    lisPen.CountyNum = item.CountyId
                    lisPen.Defendant = item.Debtor
                    lisPen.Docket_Number = item.CCISCaseIndexNumber
                    lisPen.FileDate = item.DataEntryDateTime
                    lisPen.Mortgage_Date = item.EffectiveDateTime
                    lisPen.Number = item.Seq
                    lisPen.Plaintiff = item.Creditor
                    lisPen.CreateTime = DateTime.Now

                    If item.CaseStatus = "Active" OrElse item.CaseStatus = "Restored" Then
                        lisPen.Active = True
                    Else
                        lisPen.Active = False
                    End If

                    lisPens.Add(lisPen)
                Next
            End If

            Return lisPens
        Catch ex As Exception
            Throw New Exception("Exception happend when Load liens.", ex)
        End Try

        Return lisPens
    End Function

    Public Function GetAllLiens(bble As String) As AllLiens Implements IPropertyServiceProvider.GetAllLiens
        Return svr.GetAllLiens(bble)
    End Function

    ''' <summary>
    '''     Update the apartment homeowner data from TLO
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function UpdateApartmentHomeOwner(bble As String) As Boolean

        Dim li = ctx.LeadsInfoes.Find(bble)

        Using client As New DataAPI.WCFMacrosClient
            For Each owner In ctx.HomeOwners.Where(Function(ho) ho.BBLE = bble).ToList
                Dim apiOrderNum = New Random().Next(1, 100)
                Dim result = client.Get_LocateReport(apiOrderNum, li.BuildingBBLE, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country, "", "")
                If result IsNot Nothing Then
                    owner.TLOLocateReport = result
                    owner.UserModified = False
                End If
            Next
        End Using

        ctx.SaveChanges()
        Return True
    End Function

#End Region

#Region "mortgage data, tax, water, zestimate, servicer etc."

    ''' <summary>
    '''     Update leads info data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="assessment">Indicate if general info is included</param>
    ''' <param name="apiOrder">API Order</param>
    ''' <returns></returns>
    Public Function UpdateLeadInfo(bble As String, assessment As Boolean, apiOrder As APIOrder) As Boolean Implements IPropertyServiceProvider.UpdateLeadInfo
        If assessment Then
            UpdateLeadsGeneralData(bble)
        End If

        apiOrder.OrderTime = DateTime.Now
        apiOrder.Orderby = GetCurrentIdentityName()

        Return OrderPropData(apiOrder)
    End Function

    ''' <summary>
    '''     Update servicer data of given property
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    Public Sub UpdateServicer(bble As String) Implements IPropertyServiceProvider.UpdateServicer
        Dim order = APIOrder.NewOrder(bble)
        LoadServicer(bble, order.ApiOrderID)
        ctx.SaveChanges()
    End Sub

    ''' <summary>
    '''     Update the property zillow value
    ''' </summary>
    ''' <param name="bble"></param>
    Public Function UpdateZillowValue(bble As String) As LeadsInfo Implements IPropertyServiceProvider.UpdateZillowValue
        Dim order = APIOrder.NewOrder(bble, False, False, False, False, True, False, GetCurrentIdentityName())
        Dim ld = ctx.LeadsInfoes.Find(bble)
        LoadZEstimate(ld, order)
        ctx.SaveChanges()
        order.Save(ctx)
        Return ld
    End Function

    Private Sub LoadMortgages(lead As LeadsInfo, apiOrder As APIOrder)
        lead.AcrisOrderTime = DateTime.Now
        lead.AcrisOrderStatus = APIOrder.ItemStatus.Calling.ToString

        ' load mortgage from new services
        Dim mtgs = svr.GetMortgages(lead.BBLE)
        If mtgs IsNot Nothing AndAlso mtgs.Count > 0 Then
            Dim amounts = mtgs.Select(Function(a) a.DocumentAmount).OrderByDescending(Function(a) a).ToArray
            If amounts IsNot Nothing AndAlso amounts.Count > 0 Then
                lead.C1stMotgrAmt = amounts(0)
                If lead.C1stMotgrAmt.HasValue AndAlso lead.C1stMotgrAmt > 0 AndAlso amounts.Count > 1 Then
                    lead.C2ndMotgrAmt = amounts(1)

                    If lead.C2ndMotgrAmt.HasValue AndAlso lead.C2ndMotgrAmt > 0 AndAlso amounts.Count > 2 Then
                        lead.C3rdMortgrAmt = amounts(2)
                    End If
                End If
            End If
        End If

        lead.AcrisOrderStatus = APIOrder.ItemStatus.Complete.ToString
        apiOrder.Acris = APIOrder.ItemStatus.Complete
        apiOrder.UpdateOrderStatus()
    End Sub

    Private Sub LoadTaxbill(lead As LeadsInfo, apiOrder As APIOrder)
        lead.TaxesOrderTime = DateTime.Now
        lead.TaxesOrderStatus = APIOrder.ItemStatus.Calling.ToString

        ' load tax bills from service
        Dim bills = svr.GetBills(lead.BBLE, apiOrder.ApiOrderID)
        SaveTaxBill(bills.taxBill, lead, apiOrder)
    End Sub

    Private Sub SaveTaxBill(bills As Taxbill, Optional lead As LeadsInfo = Nothing, Optional apiOrder As APIOrder = Nothing)
        If bills IsNot Nothing AndAlso bills.status = "Success" Then
            If lead Is Nothing Then
                lead = ctx.LeadsInfoes.Find(bills.BBL)
            End If

            If lead IsNot Nothing Then
                lead.TaxesAmt = bills.billAmount
                lead.TaxesOrderStatus = APIOrder.ItemStatus.Complete.ToString
            End If

            If apiOrder Is Nothing Then
                apiOrder = ctx.APIOrders.Find(CInt(bills.externalReferenceId))
            End If

            If apiOrder IsNot Nothing Then
                apiOrder.TaxBill = APIOrder.ItemStatus.Complete
                apiOrder.UpdateOrderStatus()
            End If
        End If
    End Sub

    Private Sub LoadViolation(lead As LeadsInfo, apiOrder As APIOrder)
        lead.ECBOrderTime = DateTime.Now
        lead.ECBOrderStatus = APIOrder.ItemStatus.Calling.ToString

        ' load the violation data
        Dim violation = svr.GetViolations(lead.BBLE, apiOrder.ApiOrderID)
        If violation IsNot Nothing AndAlso violation.dobPenaltiesAndViolations IsNot Nothing Then
            SaveViolations(violation.dobPenaltiesAndViolations, lead, apiOrder)
        End If
    End Sub

    Private Function SaveViolations(dobViolations As Dobpenaltiesandviolations, Optional lead As LeadsInfo = Nothing, Optional apiOrder As APIOrder = Nothing) As LeadsInfo
        If dobViolations IsNot Nothing AndAlso dobViolations.status = "Success" Then
            If lead Is Nothing Then
                lead = ctx.LeadsInfoes.Find(dobViolations.BBL)
            End If

            If apiOrder Is Nothing Then
                apiOrder = ctx.APIOrders.Find(CInt(dobViolations.externalReferenceId))
            End If

            If lead IsNot Nothing Then
                lead.DOBViolationsAmt = dobViolations.DOBViolationAmount
                lead.ECBOrderStatus = APIOrder.ItemStatus.Complete.ToString
            End If

            If apiOrder IsNot Nothing Then
                apiOrder.ECBViolation = APIOrder.ItemStatus.Complete
                apiOrder.UpdateOrderStatus()
            End If
        End If

        Return lead
    End Function

    Private Sub LoadWaterBill(lead As LeadsInfo, apiOrder As APIOrder)
        lead.WaterOrderTime = DateTime.Now
        lead.WaterOrderStatus = APIOrder.ItemStatus.Calling.ToString

        Dim bills = svr.GetBills(lead.BBLE, apiOrder.ApiOrderID)
        SaveWaterBill(bills.waterBill, lead, apiOrder)
    End Sub

    Private Sub SaveWaterBill(bills As Waterbill, Optional lead As LeadsInfo = Nothing, Optional apiOrder As APIOrder = Nothing)
        If bills IsNot Nothing AndAlso bills.status = "Success" Then
            If lead Is Nothing Then
                lead = ctx.LeadsInfoes.Find(bills.BBL)
            End If

            If lead IsNot Nothing Then
                lead.WaterAmt = bills.billAmount
                lead.WaterOrderStatus = APIOrder.ItemStatus.Complete.ToString
            End If

            If apiOrder Is Nothing Then
                apiOrder = ctx.APIOrders.Find(CInt(bills.externalReferenceId))
            End If

            If apiOrder IsNot Nothing Then
                apiOrder.WaterBill = APIOrder.ItemStatus.Complete
                apiOrder.UpdateOrderStatus()
            End If
        End If
    End Sub

    Public Sub LoadZEstimate(lead As LeadsInfo, apiOrder As APIOrder)
        Dim zestimate = svr.GetZestimate(lead.BBLE, apiOrder.ApiOrderID)
        SaveZEstimate(zestimate, lead, apiOrder)
    End Sub

    Private Function SaveZEstimate(zestimate As ZillowProperty, Optional lead As LeadsInfo = Nothing, Optional apiOrder As APIOrder = Nothing)
        If zestimate IsNot Nothing AndAlso zestimate.status = "Success" Then
            If lead Is Nothing Then
                lead = ctx.LeadsInfoes.Find(zestimate.BBL)
            End If

            If apiOrder Is Nothing Then
                apiOrder = ctx.APIOrders.Find(CInt(zestimate.externalReferenceId))
            End If

            If lead IsNot Nothing Then
                lead.EstValue = zestimate.zEstimate
            End If

            If apiOrder IsNot Nothing Then
                apiOrder.Zillow = APIOrder.ItemStatus.Complete
                apiOrder.UpdateOrderStatus()
            End If
        End If

        Return lead
    End Function

    Private Sub LoadServicer(lead As LeadsInfo, apiOrder As APIOrder)
        LoadServicer(lead.BBLE, apiOrder.ApiOrderID)
    End Sub

    Private Function LoadServicer(bble As String, orderId As Integer) As Boolean
        ' load servicer data
        Dim result = svr.GetServicer(bble, orderId)
        SaveMortgageServicer(result)
    End Function

    Private Function SaveMortgageServicer(result As MortgageServicer) As LeadsMortgageData
        If result IsNot Nothing AndAlso result.status = "Success" Then
            Dim lmd = ctx.LeadsMortgageDatas.Find(result.BBL)

            If lmd IsNot Nothing Then
                lmd.C1stServicer = result.servicerName
            Else
                lmd = New LeadsMortgageData
                lmd.BBLE = result.BBL
                lmd.C1stServicer = result.servicerName
                lmd.CreateBy = "DataService"
                lmd.CreateDate = DateTime.Now

                ctx.LeadsMortgageDatas.Add(lmd)
            End If

            Return lmd
        End If

        Return Nothing
    End Function

    Private Function OrderPropData(apiOrder As APIOrder, Optional needWait As Boolean = True) As Boolean
        Try
            apiOrder = apiOrder.Save(ctx)

            Dim bble = apiOrder.BBLE
            Dim lead = ctx.LeadsInfoes.Where(Function(li) li.BBLE = bble).SingleOrDefault

            If lead IsNot Nothing Then
                If apiOrder.Acris = APIOrder.ItemStatus.Calling Then
                    LoadMortgages(lead, apiOrder)
                Else
                    apiOrder.Acris = APIOrder.ItemStatus.NonCall
                End If

                If apiOrder.TaxBill = APIOrder.ItemStatus.Calling Then
                    LoadTaxbill(lead, apiOrder)
                Else
                    apiOrder.TaxBill = APIOrder.ItemStatus.NonCall
                End If

                If apiOrder.ECBViolation = APIOrder.ItemStatus.Calling Then
                    LoadViolation(lead, apiOrder)
                Else
                    apiOrder.ECBViolation = APIOrder.ItemStatus.NonCall
                End If

                If apiOrder.WaterBill = APIOrder.ItemStatus.Calling Then
                    LoadWaterBill(lead, apiOrder)
                Else
                    apiOrder.WaterBill = APIOrder.ItemStatus.NonCall
                End If

                If apiOrder.Zillow = APIOrder.ItemStatus.Calling Then
                    ' load zestimate data
                    LoadZEstimate(lead, apiOrder)
                Else
                    apiOrder.Zillow = APIOrder.ItemStatus.NonCall
                End If

                LoadServicer(lead, apiOrder)

                ctx.SaveChanges()
            End If

            'Update HomeOwnerInfo
            'If apiOrder.TLO = APIOrder.ItemStatus.Calling Then
            '    Return LoadHomeOwner(lead, apiOrder)
            'End If

            Return True

        Catch ex As System.TimeoutException
            Throw New Exception("Time is out. The data services is busy now. Please try later.")
        Catch ex As Exception
            Throw New Exception("Data Services isnot avaiable now. Please try later. Error messager: " & ex.Message)
        End Try
    End Function

#End Region

#Region "Update external data"

    ''' <summary>
    '''     Update the external data into Portal
    ''' </summary>
    ''' <param name="externalData">External Data</param>
    ''' <returns></returns>
    Public Function UpdateExternalData(externalData As ExternalData) As Boolean Implements IPropertyServiceProvider.UpdateExternalData
        If externalData Is Nothing Then
            Return False
        End If

        ' mortgage servicer
        If externalData.mortgageServicer IsNot Nothing Then
            SaveMortgageServicer(externalData.mortgageServicer)
        End If

        ' DOB violation
        If externalData.dobPenaltiesAndViolationsSummary IsNot Nothing Then
            SaveViolations(externalData.dobPenaltiesAndViolationsSummary)
        End If

        ' Tax bill
        If externalData.taxbill IsNot Nothing Then
            SaveTaxBill(externalData.taxbill)
        End If

        ' zestimate
        If externalData.zillowProperty IsNot Nothing Then
            SaveZEstimate(externalData.zillowProperty)
        End If

        ' Water bill
        If externalData.waterbill IsNot Nothing Then
            SaveWaterBill(externalData.waterbill)
        End If

        ctx.SaveChanges()
    End Function

#End Region

#Region "Get latest homeowner info"

    ''' <summary>
    '''     Load latest homeowner address data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    Public Sub LoadLatestOwner(bble As String) Implements IPropertyServiceProvider.LoadLatestOwner
        Dim li = ctx.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault
        If li Is Nothing Then
            Return
        End If

        Dim info = svr.GetGeneralInformation(bble)
        If info Is Nothing OrElse info.owners Is Nothing OrElse info.owners.Count = 0 Then
            Return
        End If

        Dim results = info.owners

        If results IsNot Nothing AndAlso results.Count > 0 Then
            If Not String.IsNullOrEmpty(results(0).Name) AndAlso Not String.IsNullOrEmpty(results(0).Name.TrimStart.TrimEnd) Then
                If Not IsSameName(li.Owner, results(0).Name.Trim) Then
                    li.Owner = results(0).Name.Trim
                End If

                li.Owner = li.Owner.Trim
                'Dim add1 = String.Format("{0} {1}", results(0).ADDRESS_1, results(0).Street).TrimStart.TrimEnd

                SaveHomeOwner(bble, li.Owner, results(0).Address1, results(0).Address2, results(0).City, results(0).State, results(0).Country, results(0).Zip, ctx)
            End If

            If results.Count > 1 AndAlso Not String.IsNullOrEmpty(results(1).Name) AndAlso Not String.IsNullOrEmpty(results(1).Name.Trim) Then
                Dim coOwner = results(1).Name.Trim
                If Not String.IsNullOrEmpty(coOwner) AndAlso coOwner <> li.Owner Then
                    li.CoOwner = results(1).Name.Trim
                    SaveHomeOwner(bble, results(1).Name.Trim, results(1).Address1, results(1).Address2, results(1).City, results(1).State, results(1).Country, results(1).Zip, ctx)
                Else
                    li.CoOwner = ""
                End If
            Else
                li.CoOwner = ""
            End If
        End If

        Dim lead = ctx.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
        If lead IsNot Nothing Then
            lead.LeadsName = li.LeadsName
            lead.LastUpdate = DateTime.Now
            lead.UpdateBy = GetCurrentIdentityName()
        End If

        ctx.SaveChanges()
    End Sub

    Private Sub UpdateDeedParty(bble As String, party As DeedParty)
        Using context As New Entities
            Dim results = party
            SaveHomeOwner(bble, party.Name, party.Address1, party.Address2, party.City, party.State, party.Country, party.Zip, context)
            context.SaveChanges()
        End Using
    End Sub

    Private Function IsSameName(name As String, nameToCompare As String)
        Return Utility.IsSimilarName(name, nameToCompare)

        If String.IsNullOrEmpty(name) Then
            Return False
        End If

        name = name.Replace(",", " ")

        For Each Part In name.Split(" ")
            If Not nameToCompare.Contains(Part) Then
                Return False
            End If
        Next

        Return True
    End Function

    Private Sub SaveHomeOwner(bble As String, name As String, add1 As String, add2 As String, city As String, state As String, country As String, zip As String, context As Entities)
        Try
            Dim localOwner = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Name = name And ho.Active = True).FirstOrDefault

            If String.IsNullOrEmpty(add1) OrElse String.IsNullOrEmpty(add1.Trim) Then
                Dim ld = LeadsInfo.GetInstance(bble)
                If ld IsNot Nothing Then
                    add1 = ld.Address1
                End If
            End If

            If String.IsNullOrEmpty(city) OrElse String.IsNullOrEmpty(city.Trim) Then
                Dim ld = LeadsInfo.GetInstance(bble)
                If ld IsNot Nothing Then
                    city = ld.NeighName
                End If
            End If

            If Not String.IsNullOrEmpty(city) Then
                If (city.Trim.ToUpper.Contains("BK")) Then
                    city = "Brooklyn"
                ElseIf city.Trim.ToUpper.Contains("BX")
                    city = "Bronx"
                End If
            End If

            If localOwner IsNot Nothing Then
                localOwner.Name = Trim(name)
                localOwner.Address1 = Trim(add1)
                localOwner.Address2 = Trim(add2)
                localOwner.City = Trim(city)
                localOwner.Country = country
                localOwner.State = state
                localOwner.Zip = zip
            Else
                If context.HomeOwners.Local.Where(Function(ho) ho.BBLE = bble And ho.Name = name).Count = 0 Then
                    context.HomeOwners.Add(New HomeOwner With {
                                                       .BBLE = bble,
                                                       .Name = Trim(name),
                                                       .Address1 = Trim(add1),
                                                       .Address2 = Trim(add2),
                                                       .City = city,
                                                       .Country = country,
                                                       .State = state,
                                                       .Zip = zip,
                                                       .Active = True,
                                                       .CreateDate = DateTime.Now,
                                                       .CreateBy = "DataService"
                                                       })
                End If

            End If
        Catch ex As Exception
            Throw New Exception("Error occure in SaveHomeOwner. Error: " + ex.Message)
        End Try
    End Sub

#End Region

#Region "Get BBLE by Address"

    ''' <summary>
    '''     Return property data on street number, street name and borough
    ''' </summary>
    ''' <param name="num">Street Number</param>
    ''' <param name="strName">Street Name</param>
    ''' <param name="borough">Borough</param>
    ''' <returns></returns>
    Public Function GetPropbyAddress(num As String, strName As String, borough As String) As PhysicalData Implements IPropertyServiceProvider.GetPropbyAddress
        Dim result = svr.GetPropByAddress(num, strName, borough)
        Return result
    End Function

    ''' <summary>
    '''     Return property information base on BBLE
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function GetPropGeneralInfo(bble As String) As GeneralPropertyInformation Implements IPropertyServiceProvider.GetPropGeneralInfo
        Dim result = svr.GetGeneralInformation(bble)
        Return result
    End Function

#End Region

#Region "Utils"

    ''' <summary>
    '''     Load context user name
    ''' </summary>
    ''' <returns></returns>
    Private Function GetCurrentIdentityName() As String
        Try
            If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing AndAlso Not String.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) Then
                Return HttpContext.Current.User.Identity.Name
            Else
                Return "Dataloop"
            End If
        Catch ex As Exception
            Throw New Exception("Get Current Identity Name: " & ex.Message)
        End Try
    End Function

#End Region

#Region "IDisposable Support"
    Private disposedValue As Boolean ' To detect redundant calls

    ' IDisposable
    Protected Overridable Sub Dispose(disposing As Boolean)
        If Not disposedValue Then
            If disposing Then
                ' TODO: dispose managed state (managed objects).
                ctx.Dispose()
                svr.Dispose()
            End If

            ' TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
            ' TODO: set large fields to null.
        End If
        disposedValue = True
    End Sub

    ' TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
    'Protected Overrides Sub Finalize()
    '    ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
    '    Dispose(False)
    '    MyBase.Finalize()
    'End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        Dispose(True)
        ' TODO: uncomment the following line if Finalize() is overridden above.
        ' GC.SuppressFinalize(Me)
    End Sub

#End Region


End Class

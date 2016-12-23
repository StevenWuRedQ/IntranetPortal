Imports System.Threading.Tasks
Imports IntranetPortal.Data

''' <summary>
''' The data service integration object
''' </summary>
Public Class DataWCFService

#Region "TLO Related"
    Public Shared Function GetLocateReport(apiOrderNum As Integer, bble As String, owner As HomeOwner) As DataAPI.TLOLocateReportOutput
        If String.IsNullOrEmpty(owner.Address1) AndAlso String.IsNullOrEmpty(owner.Address2) AndAlso String.IsNullOrEmpty(owner.City) Then
            Return Nothing
        End If

        Using client As New DataAPI.WCFMacrosClient
            Dim result = GetLocateReport(apiOrderNum, bble, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country)

            If result Is Nothing Then
                Dim propOwners = client.NYC_NameAndAddress(bble)
                If propOwners IsNot Nothing And propOwners.Count > 0 Then
                    Dim newAds = propOwners(0)
                    If newAds.Owner1.Trim = owner.Name Or newAds.Owner2.Trim = owner.Name Then
                        Dim add1 = String.Format("{0} {1}", newAds.Mail_Num.Trim, newAds.Mail_ST1.Trim).TrimStart.TrimEnd
                        result = GetLocateReport(apiOrderNum, bble, owner.Name, add1, newAds.Mail_ST2, newAds.Mail_City, newAds.Mail_State, newAds.Mail_Zip, "US")
                    End If
                End If
            End If

            Return result
        End Using
    End Function

    Public Shared Function GetOwnerInfoByTLOId(tloId As String, bble As String) As HomeOwner

        'If Not Core.TLOApiLog.IsServiceOn Then
        '    Throw New Exception("HomeOwner Service is temporary closed. Please try later.")
        'End If

        'If Core.TLOApiLog.LimiteIsExceed Then
        '    Throw New Exception("HomeOwner Load Limit is reached. Please contact Admin!")
        'End If

        Using client As New DataAPI.WCFMacrosClient
            Dim orderId = 1

            Using ctx As New Entities
                Dim order As New APIOrder
                order.BBLE = bble
                order.Orderby = GetCurrentIdentityName()
                order.OrderTime = DateTime.Now
                order.Status = APIOrder.OrderStatus.Complete
                ctx.APIOrders.Add(order)
                ctx.SaveChanges()

                orderId = order.ApiOrderID
            End Using

            Dim result = client.Get_TLO_Person(orderId, Nothing, Nothing, False, False, Nothing, tloId, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing)

            If result Is Nothing Then
                Throw New Exception("Can't find the user. Please check.")
            End If

            'LogTloApiCall



            If result.numberOfRecordsFoundField > 0 Then
                Dim person = result.personSearchOutputRecordsField(0)



                'relative.nameField.firstNameField & If(relative.nameField.middleNameField isnot Nothing,relative.nameField.middleNameField, " ") &" "& relative.nameField.lastNameField 
                If person IsNot Nothing AndAlso person.namesField IsNot Nothing AndAlso person.namesField.Length > 0 Then
                    Dim owner As New HomeOwner
                    Dim name = person.namesField(0)
                    owner.Name = name.firstNameField & If(name.middleNameField IsNot Nothing, " " & name.middleNameField & " ", " ") & name.lastNameField
                    owner.Address1 = person.addressesField(0).addressField.line1Field
                    owner.Address2 = person.addressesField(0).addressField.line2Field
                    owner.City = person.addressesField(0).addressField.cityField
                    owner.Country = person.addressesField(0).addressField.countryNameField
                    owner.State = person.addressesField(0).addressField.stateField
                    owner.Zip = person.addressesField(0).addressField.zipField
                    If person.datesOfBirthField IsNot Nothing AndAlso person.datesOfBirthField.Length > 0 Then
                        owner.AgeString = person.datesOfBirthField(0).currentAgeField
                    End If

                    If person.datesOfDeathField IsNot Nothing Then
                        owner.DeathIndicator = If(person.datesOfDeathField.Length > 0, "Death", "Alive")
                    End If

                    If Not String.IsNullOrEmpty(person.numberOfBankruptciesField) Then
                        owner.BankruptcyString = If(CInt(person.numberOfBankruptciesField) > 0, "Yes", "No")
                    End If

                    'tlo log
                    Core.TLOApiLog.Log(bble, owner.Name, "UniqueId:" & tloId, Nothing, Nothing, Nothing, Nothing, Nothing, True, GetCurrentIdentityName)

                    Return owner
                End If
            End If

            Core.TLOApiLog.Log(bble, Nothing, "UniqueId:" & tloId, Nothing, Nothing, Nothing, Nothing, Nothing, False, GetCurrentIdentityName)

            Return Nothing
        End Using
    End Function

    Public Shared Function GetLocateReport(orderNum As Integer, bble As String, name As String, address1 As String, address2 As String, city As String, state As String, zip As String, country As String, Optional checkTLO As Boolean = True) As DataAPI.TLOLocateReportOutput

        If Not Core.TLOApiLog.IsServiceOn Then
            Throw New Exception("HomeOwner Service is temporary closed. Please try later.")
        End If

        If checkTLO Then
            If Core.TLOApiLog.LimiteIsExceed Then
                Throw New Exception("HomeOwner Load Limit is reached. Please contact Admin!")
            End If
        End If

        Using client As New DataAPI.WCFMacrosClient

            Dim result = client.Get_LocateReport(orderNum, bble, name, address1, address2, city, state, zip, country, "", "")

            'LogTloApiCall
            Core.TLOApiLog.Log(bble, name, address1, address2, city, state, zip, country, result IsNot Nothing, GetCurrentIdentityName)
            Return result
        End Using
    End Function

    Private Shared Sub UpdateHomeOwnerApi(orderId As Integer, Optional result As String = "Done")
        APIOrder.UpdateOrderInfo(orderId, "TLO", result)
    End Sub

#End Region

#Region "Leads Info"

    ''' <summary>
    '''     Load property generate information
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="li">LeadsInfo Object</param>
    ''' <returns></returns>
    Public Shared Function GetFullAssessInfo(bble As String, Optional li As LeadsInfo = Nothing) As LeadsInfo

        Try
            Using client As New PropertyService

                Dim result = client.GetGeneralInformation(bble)
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

                    If Not String.IsNullOrEmpty(result.propertyInformation.UnitNumber) AndAlso Not String.IsNullOrEmpty(result.propertyInformation.UnitNumber) Then
                        li.UnitNum = result.propertyInformation.UnitNumber.Trim
                    End If

                    li.PropertyAddress = result.address.FormatAddress
                    li.Borough = result.propertyInformation.Borough
                    li.Zoning = result.propertyInformation.Zoning
                    li.MaxFar = CDbl(result.propertyInformation.MaxResidentialFAR)
                    li.ActualFar = CDbl(result.propertyInformation.BuiltFAR)
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

                    Try
                        li.UpdateBy = GetCurrentIdentityName()
                    Catch ex As Exception
                        Throw New Exception("Exception Occured in GetIdentityName(). Error: " + ex.Message)
                    End Try

                    Return li
                End If
                Return li
            End Using
        Catch ex As Exception
            Throw New Exception("Error in GetFullAssessInfo: " + ex.Message)
        End Try
    End Function

    ''' <summary>
    '''     Update general property info and lispendas data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function UpdateAssessInfo(bble As String) As LeadsInfo
        Try
            'this is apartment
            If bble.StartsWith("A") Then
                Return UpdateApartmentBuildingInfo(bble)
            End If

            Using context As New Entities

                Dim li As LeadsInfo = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault
                If li Is Nothing Then
                    li = GetFullAssessInfo(bble, li)
                    context.LeadsInfoes.Add(li)
                Else
                    li = GetFullAssessInfo(bble, li)
                End If

                'Update Liens Info
                Dim lisPens = GetLiensInfo(bble)
                If lisPens IsNot Nothing Then
                    Dim localLispens = context.PortalLisPens.Where(Function(lp) lp.BBLE = bble)
                    context.PortalLisPens.RemoveRange(localLispens)

                    If lisPens.Count > 0 Then
                        context.PortalLisPens.AddRange(lisPens)
                    End If
                End If

                context.SaveChanges()

                context.Entry(li).Reload()
                LeadsInfo.AddIndicator("LPDefandant", li, GetCurrentIdentityName())

                'Update leads neighborhood info
                Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                If lead IsNot Nothing Then
                    lead.Neighborhood = li.NeighName
                    lead.LeadsName = li.LeadsName
                    lead.LastUpdate = DateTime.Now
                    lead.UpdateBy = GetCurrentIdentityName()
                    context.SaveChanges()
                End If

                Return li
            End Using
        Catch ex As System.ServiceModel.EndpointNotFoundException
            Throw New Exception("The data serice is not avaiable. Please refresh later.")
        Catch ex As Exception
            Throw New Exception("Exception happened during updating. Please try later. Exception: " & ex.Message)
        End Try
    End Function

    ''' <summary>
    '''     Get property lispends data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function GetLiensInfo(bble As String) As List(Of PortalLisPen)
        Dim lisPens As New List(Of PortalLisPen)

        Using client As New PropertyService
            Try
                Dim newLPs = client.GetLpLiens(bble)

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
                    lisPens.Add(lisPen)
                Next

                Return lisPens
            Catch ex As Exception

            End Try

            Return lisPens
        End Using
    End Function

    Public Shared Function GetBBLEByAddress(num As String, streetName As String, borough As String) As String()
        Using client As New DataAPI.WCFMacrosClient
            Dim strName = streetName.Trim
            num = num.Trim.Replace(" ", "")

            Dim result = client.NYC_Address_Search(borough, num, strName)

            If result.Length = 0 Then
                strName = strName.ToLower.Replace("street", "ST").Replace("avenue", "Ave")
                If strName.EndsWith(".") Then
                    strName = strName.Remove(strName.Length - 1, 1)
                End If
                result = client.NYC_Address_Search(borough, num.Trim, strName)
            End If

            If result.Length = 0 Then
                strName = strName.Replace("th", "").Replace("rd", "").Replace("nd", "")
                result = client.NYC_Address_Search(borough, num.Trim, strName)
            End If

            If result.Length = 0 Then
                strName = strName.Replace("east", "E")
                result = client.NYC_Address_Search(borough, num.Trim, strName)
            End If

            Return result.Select(Function(r) r.BBLE).ToArray
        End Using
    End Function

    Public Shared Function UpdateBasicInfo(bble As String) As LeadsInfo
        Try
            'this is apartment
            If bble.StartsWith("A") Then
                Return UpdateApartmentBuildingInfo(bble)
            End If

            Using context As New Entities

                Dim li As LeadsInfo = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault
                If li Is Nothing Then
                    li = GetFullAssessInfo(bble, li)
                    context.LeadsInfoes.Add(li)
                Else
                    li = GetFullAssessInfo(bble, li)
                End If
                context.SaveChanges()

                GetLatestSalesInfo(bble)
                Return li
            End Using
        Catch ex As System.ServiceModel.EndpointNotFoundException
            Throw New Exception("The data serice is not avaiable. Please refresh later.")
        Catch ex As Exception
            Throw New Exception("Exception happened during updating. Please try later. Exception: " & ex.Message)
        End Try
    End Function

    Public Shared Function UpdateApartmentBuildingInfo(bble As String) As LeadsInfo
        Try
            Using context As New Entities

                Dim li As LeadsInfo = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault
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

                context.SaveChanges()

                'Update Home owner info
                SaveHomeOwner(bble, li.Owner, li.Address1, "", li.NeighName, li.State, "US", li.ZipCode, context)

                If String.IsNullOrEmpty(li.CoOwner) Then
                    SaveHomeOwner(bble, li.CoOwner, li.Address1, "", li.NeighName, li.State, "US", li.ZipCode, context)
                End If

                context.SaveChanges()

                'Update leads neighborhood info
                Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                If lead IsNot Nothing Then
                    lead.Neighborhood = li.NeighName
                    lead.LeadsName = li.LeadsName
                    lead.LastUpdate = DateTime.Now
                    lead.UpdateBy = GetCurrentIdentityName()
                    context.SaveChanges()
                End If
                Return li
            End Using
        Catch ex As System.ServiceModel.EndpointNotFoundException
            Throw New Exception("The data serice is not avaiable. Please refresh later.")
        Catch ex As Exception
            Throw New Exception("Exception happened during updating Apartment. Please try later. Exception: " & ex.Message)
        End Try
    End Function

    Public Shared Function UpdateApartmentHomeOwner(bble As String) As Boolean
        Using context As New Entities
            Dim li = context.LeadsInfoes.Find(bble)

            Using client As New DataAPI.WCFMacrosClient
                For Each owner In context.HomeOwners.Where(Function(ho) ho.BBLE = bble).ToList
                    Dim apiOrderNum = New Random().Next(1, 100)
                    Dim result = client.Get_LocateReport(apiOrderNum, li.BuildingBBLE, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country, "", "")
                    If result IsNot Nothing Then
                        owner.TLOLocateReport = result
                        owner.UserModified = False
                    End If
                Next
            End Using

            context.SaveChanges()
            Return True
        End Using
    End Function

#End Region

    Public Shared Function GetZillowValue(bble As String) As Boolean
        Using ctx As New Entities
            Dim li = ctx.LeadsInfoes.Find(bble)

            If li IsNot Nothing Then
                Using client As New DataAPI.WCFMacrosClient
                    Try
                        Dim value = client.Zillow_Estimate_By_BBLE(bble)
                        li.EstValue = value
                        ctx.SaveChanges()
                        LeadsInfo.AddIndicator("Mortgage", li)
                        Return True
                    Catch ex As Exception
                        Throw New Exception("Exception Occured in GetZillowValue. Exception: " & ex.Message)
                    End Try
                End Using
            End If
        End Using

        Return False
    End Function

    Public Shared Function IsServerBusy(Optional serverAddress As String = Nothing) As Boolean
        Using client As New DataAPI.WCFMacrosClient()
            If Not String.IsNullOrEmpty(serverAddress) Then
                client.Endpoint.Address = New ServiceModel.EndpointAddress(serverAddress)
            End If

            Try
                Dim waitingRequest = client.Requests_Waiting
                Return waitingRequest > 50
            Catch ex As TimeoutException
                'Throw New Exception("Check Server is busy. Time out exception: " & ex.Message)
                Return True
            Catch ex As Exception
                'Throw New Exception("Check Server is busy. exception: " & ex.Message)
                Return True
            End Try
        End Using
    End Function

    Public Shared Sub UpdateServicer(bble As String)
        Using client As New DataAPI.WCFMacrosClient
            Try
                Dim orderId = New Random().Next(1000)
                client.Get_Servicer(orderId, bble)
            Catch ex As Exception
                Throw New Exception("Exception Occured in get Servicer: " & ex.Message)
            End Try
        End Using
    End Sub

    Public Shared Sub UpdateTaxLiens(bble As String)
        UpdateTaxLiens2(bble)
        Return
    End Sub

    Public Shared Sub UpdateTaxLiens2(bble As String)
        Using client As New DataAPI.WCFMacrosClient

            Dim taxLiens = client.Get_NYC_TaxLien(bble, "")

            If taxLiens IsNot Nothing AndAlso taxLiens.Length > 0 Then
                Using ctx As New Entities
                    Dim liens = ctx.LeadsTaxLiens.Where(Function(lt) lt.BBLE = bble)
                    ctx.LeadsTaxLiens.RemoveRange(liens)

                    For Each lien In taxLiens
                        Dim newLien As New LeadsTaxLien
                        newLien.BBLE = bble

                        If lien.Year > 0 Then
                            newLien.TaxLiensYear = lien.Year
                        End If

                        If lien.LienTotal.HasValue Then
                            newLien.Amount = lien.LienTotal
                        End If
                        ctx.LeadsTaxLiens.Add(newLien)
                    Next

                    ctx.SaveChanges()
                End Using
            End If
        End Using
    End Sub

    Private Shared Sub UpdateDeedParty(bble As String, party As DeedParty)
        Using context As New Entities
            Dim results = party
            SaveHomeOwner(bble, party.Name, party.Address1, party.Address2, party.City, party.State, party.Country, party.Zip, context)
            context.SaveChanges()
        End Using
    End Sub

    Public Shared Function UpdateHomeOwner(bble As String, orderid As Integer) As Boolean
        GetLatestSalesInfo(bble)

        Using context As New Entities
            Dim li = context.LeadsInfoes.Find(bble)
            'GetLatestSalesInfo(bble)
            If String.IsNullOrEmpty(li.Owner) Then
                GetLatestSalesInfo(bble)
            End If

            If Not String.IsNullOrEmpty(li.Owner) AndAlso Not String.IsNullOrEmpty(li.CoOwner) Then
                If li.Owner.Trim = li.CoOwner.Trim Then
                    li.Owner = li.Owner.Trim
                    li.CoOwner = Nothing
                    context.SaveChanges()
                End If
            End If

            Dim owners = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True And ho.Name = li.Owner).ToList
            If owners Is Nothing Or owners.Count = 0 Then
                GetLatestSalesInfo(bble)
                'Return False
            End If

            'Used to check if homeowner is refreshed before
            Dim homeOwnerRefreshInternal As Integer = CInt(Core.PortalSettings.GetValue("TLOCallInterval"))

            Dim loaded = False
            For Each owner In context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True And (ho.Name = li.Owner Or ho.Name = li.CoOwner)).ToList
                If Not String.IsNullOrEmpty(owner.LocateReportContent) Then
                    If Not owner.LastUpdate.HasValue Then
                        owner.LastUpdate = DateTime.Now
                        loaded = True
                        Continue For
                    Else
                        If owner.LastUpdate.Value.AddDays(homeOwnerRefreshInternal) > DateTime.Now Then
                            loaded = True
                            'if homeowner is refreshed in 3 month. don't refresh again.
                            Continue For
                        End If
                    End If
                End If

                Dim result = GetLocateReport(orderid, bble, owner)
                If result IsNot Nothing Then
                    loaded = True
                    owner.TLOLocateReport = result
                    owner.UserModified = False
                    owner.LastUpdate = DateTime.Now
                End If
            Next

            'Reload latest sales owner info and try again
            If Not loaded Then
                GetLatestSalesInfo(bble)
                For Each owner In context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True).ToList
                    If Not String.IsNullOrEmpty(owner.LocateReportContent) Then
                        If Not owner.LastUpdate.HasValue Then
                            owner.LastUpdate = DateTime.Now
                            loaded = True
                            Continue For
                        Else
                            If owner.LastUpdate.Value.AddDays(homeOwnerRefreshInternal) > DateTime.Now Then
                                loaded = True
                                'if homeowner is refreshed in 3 month. don't refresh again.
                                Continue For
                            End If
                        End If
                    End If

                    Dim result = GetLocateReport(orderid, bble, owner)
                    If result IsNot Nothing Then
                        loaded = True
                        owner.TLOLocateReport = result
                        owner.UserModified = False
                    End If
                Next
            End If

            Dim contextError = context.GetValidationErrors()
            If contextError.Count = 0 Then
                context.SaveChanges()
            Else
                Throw New Exception(contextError(0).ValidationErrors(0).ErrorMessage)
            End If

            Return loaded
        End Using
    End Function

    Public Shared Function UpdateLeadInfo(bble As String, Optional assessment As Boolean = False,
                                          Optional acris As Boolean = True,
                                          Optional taxBill As Boolean = True,
                                          Optional EcbViolation As Boolean = True,
                                          Optional waterBill As Boolean = True,
                                          Optional zillow As Boolean = True,
                                          Optional TLO As Boolean = True) As Boolean

        If bble.StartsWith("A") Then
            If assessment Then
                UpdateAssessInfo(bble)
            End If

            If TLO Then
                UpdateApartmentHomeOwner(bble)
            End If

            Return True
        End If

        Dim apiOrder As New APIOrder

        If assessment Then
            UpdateAssessInfo(bble)
        End If

        apiOrder.BBLE = bble
        Dim needWait = False

        If acris Then
            apiOrder.Acris = APIOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.Acris = APIOrder.ItemStatus.NonCall
        End If

        If taxBill Then
            apiOrder.TaxBill = APIOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.TaxBill = APIOrder.ItemStatus.NonCall
        End If

        If EcbViolation Then
            apiOrder.ECBViolation = APIOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.ECBViolation = APIOrder.ItemStatus.NonCall
        End If

        If waterBill Then
            apiOrder.WaterBill = APIOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.WaterBill = APIOrder.ItemStatus.NonCall
        End If

        If zillow Then
            apiOrder.Zillow = APIOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.Zillow = APIOrder.ItemStatus.NonCall
        End If

        If TLO Then
            apiOrder.TLO = APIOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.TLO = APIOrder.ItemStatus.NonCall
        End If

        If needWait Then
            apiOrder.Status = APIOrder.OrderStatus.Active
        Else
            apiOrder.Status = APIOrder.OrderStatus.Complete
        End If

        apiOrder.OrderTime = DateTime.Now
        apiOrder.Orderby = GetCurrentIdentityName()

        Return OrderPropData(apiOrder)
    End Function

    Public Shared Sub GetLatestSalesInfo(bble As String)
        Try
            'Get lastest owner through NameAndAddress, because the result is not latest in Acris (see email: 1/13/2015 from George), change to service "GetAcrisLatestOwner" -- add by Chris 1/13/2015
            'SaveNameandAddress(bble)
            GetAcrisLatestOwner(bble)
        Catch ex As Exception
            Throw New Exception("Erron occure in Get Latest Sales Info: " + ex.Message)
        End Try

        Return
    End Sub

    Private Shared Sub GetAcrisLatestOwner(bble As String)
        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault

            If li Is Nothing Then
                Return
            End If

            Using client As New PropertyService
                Dim info = client.GetGeneralInformation(bble)
                Dim results = info.owners
                If results IsNot Nothing AndAlso results.Count > 0 Then
                    If Not String.IsNullOrEmpty(results(0).Name) AndAlso Not String.IsNullOrEmpty(results(0).Name.TrimStart.TrimEnd) Then
                        If Not IsSameName(li.Owner, results(0).Name.Trim) Then
                            li.Owner = results(0).Name.Trim
                        End If

                        li.Owner = li.Owner.Trim
                        'Dim add1 = String.Format("{0} {1}", results(0).ADDRESS_1, results(0).Street).TrimStart.TrimEnd

                        SaveHomeOwner(bble, li.Owner, results(0).Address1, results(0).Address2, results(0).City, results(0).State, results(0).Country, results(0).Zip, context)
                    End If

                    If results.Count > 1 AndAlso Not String.IsNullOrEmpty(results(1).Name) AndAlso Not String.IsNullOrEmpty(results(1).Name.Trim) Then
                        Dim coOwner = results(1).Name.Trim
                        If Not String.IsNullOrEmpty(coOwner) AndAlso coOwner <> li.Owner Then
                            li.CoOwner = results(1).Name.Trim
                            SaveHomeOwner(bble, results(1).Name.Trim, results(1).Address1, results(1).Address2, results(1).City, results(1).State, results(1).Country, results(1).Zip, context)
                        Else
                            li.CoOwner = ""
                        End If
                    Else
                        li.CoOwner = ""
                    End If
                End If
            End Using

            Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
            If lead IsNot Nothing Then
                lead.LeadsName = li.LeadsName
                lead.LastUpdate = DateTime.Now
                lead.UpdateBy = GetCurrentIdentityName()
            End If

            context.SaveChanges()
        End Using
    End Sub

    Shared Sub SaveHomeOwner(bble As String, name As String, add1 As String, add2 As String, city As String, state As String, country As String, zip As String, context As Entities)
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

    Public Shared Function UpdateExternalData(externalData As ExternalData) As Boolean
        If externalData Is Nothing Then
            Return False
        End If

        If externalData.dobViolation IsNot Nothing Then
            Dim dob = externalData.dobViolation
            If dob.status = "Success" Then
                Dim ld = LeadsInfo.GetInstance(dob.BBL)
                ld.DOBViolationsAmt = dob.DOBViolationAmount
                ld.ECBOrderStatus = APIOrder.ItemStatus.Complete.ToString

                APIOrder.UpdateOrderInfo(dob.externalReferenceId, "AcrisMtgrs", "Task-Done")
            End If
        End If

        If externalData.taxbill IsNot Nothing Then
            Dim taxbill = externalData.taxbill
            If taxbill.status = "Success" Then
                Dim ld = LeadsInfo.GetInstance(taxbill.BBL)
                ld.TaxesAmt = taxbill.billAmount
                ld.TaxesOrderStatus = APIOrder.ItemStatus.Complete.ToString
                APIOrder.UpdateOrderInfo(taxbill.externalReferenceId, "PROP_TAX", "Task-Done")
            End If
        End If

        If externalData.waterbill IsNot Nothing Then
            Dim waterbill = externalData.waterbill
            If waterbill.status = "Success" Then
                Dim ld = LeadsInfo.GetInstance(waterbill.BBL)
                ld.WaterAmt = waterbill.billAmount
                ld.WaterOrderStatus = APIOrder.ItemStatus.Complete.ToString
                APIOrder.UpdateOrderInfo(waterbill.externalReferenceId, "WATER_SEWER", "Task-Done")
            End If
        End If

    End Function

    Public Shared Function OrderPropData(apiOrder As APIOrder, Optional needWait As Boolean = True) As Boolean

        Try
            Using Context As New Entities
                If apiOrder.Status = APIOrder.OrderStatus.Active Then
                    Dim tmpApiOrder = Context.APIOrders.Where(Function(ap) ap.BBLE = apiOrder.BBLE And Not ap.Status = APIOrder.OrderStatus.Complete).FirstOrDefault
                    If tmpApiOrder IsNot Nothing Then
                        apiOrder.ApiOrderID = tmpApiOrder.ApiOrderID
                        Context.APIOrders.Attach(tmpApiOrder)
                        Context.Entry(tmpApiOrder).CurrentValues.SetValues(apiOrder)
                        apiOrder = tmpApiOrder
                    Else
                        Context.APIOrders.Add(apiOrder)
                    End If
                Else
                    Context.APIOrders.Add(apiOrder)
                End If

                Context.SaveChanges()

                Dim svr = New PropertyService

                Dim bble = apiOrder.BBLE
                Dim lead = Context.LeadsInfoes.Where(Function(li) li.BBLE = bble).SingleOrDefault
                Dim needCallService = False
                If lead IsNot Nothing Then
                    If apiOrder.Acris = APIOrder.ItemStatus.Calling Then
                        lead.AcrisOrderTime = DateTime.Now
                        lead.AcrisOrderStatus = APIOrder.ItemStatus.Calling.ToString

                        ' load mortgage from new services
                        Dim mtgs = svr.GetMortgages(bble)
                        lead.C1stMotgrAmt = mtgs.Max(Function(a) a.DocumentAmount)
                        If lead.C1stMotgrAmt.HasValue AndAlso lead.C1stMotgrAmt > 0 Then
                            lead.C2ndMotgrAmt = mtgs.Where(Function(a) a.DocumentAmount < lead.C1stMotgrAmt).Max(Function(a) a.DocumentAmount)

                            If lead.C2ndMotgrAmt.HasValue AndAlso lead.C2ndMotgrAmt > 0 Then
                                lead.C3rdMortgrAmt = mtgs.Where(Function(a) a.DocumentAmount < lead.C2ndMotgrAmt).Max(Function(a) a.DocumentAmount)
                            End If
                        End If
                        lead.AcrisOrderStatus = APIOrder.ItemStatus.Complete.ToString
                        apiOrder.Acris = APIOrder.ItemStatus.Complete
                    Else
                        apiOrder.Acris = APIOrder.ItemStatus.NonCall
                    End If

                    If apiOrder.TaxBill = APIOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.TaxesOrderTime = DateTime.Now
                        lead.TaxesOrderStatus = APIOrder.ItemStatus.Calling.ToString

                        ' load tax bills from service
                        Dim bills = svr.GetBills(bble, apiOrder.ApiOrderID)
                        If bills.taxBill.status = "Success" Then
                            ' if tax data was ready before, the data status is success
                            lead.TaxesAmt = bills.taxBill.billAmount
                            lead.TaxesOrderStatus = APIOrder.ItemStatus.Complete.ToString
                            apiOrder.TaxBill = APIOrder.ItemStatus.Complete
                        End If
                    Else
                        apiOrder.TaxBill = APIOrder.ItemStatus.NonCall
                    End If

                    If apiOrder.ECBViolation = APIOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.ECBOrderTime = DateTime.Now
                        lead.ECBOrderStatus = APIOrder.ItemStatus.Calling.ToString

                        ' load the violation data
                        Dim violation = svr.GetViolations(bble, apiOrder.ApiOrderID)
                        If violation IsNot Nothing AndAlso violation.dobPenaltiesAndViolations IsNot Nothing Then
                            If violation.dobPenaltiesAndViolations.status = "Success" Then
                                lead.DOBViolationsAmt = violation.dobPenaltiesAndViolations.DOBViolationAmount
                                lead.ECBOrderStatus = APIOrder.ItemStatus.Complete.ToString
                                apiOrder.ECBViolation = APIOrder.ItemStatus.Complete
                            End If
                        End If
                    Else
                        apiOrder.ECBViolation = APIOrder.ItemStatus.NonCall
                    End If

                    If apiOrder.WaterBill = APIOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.WaterOrderTime = DateTime.Now
                        lead.WaterOrderStatus = APIOrder.ItemStatus.Calling.ToString
                    End If

                    If apiOrder.Zillow = APIOrder.ItemStatus.Calling Then
                        needCallService = True

                        ' load zestimate data
                        Dim zestimate = svr.GetZestimate(bble, apiOrder.ApiOrderID)
                        If zestimate.status = "Success" Then
                            lead.EstValue = zestimate.zEstimate
                        End If
                    End If

                    ' load servicer data
                    Dim result = svr.GetServicer(bble, apiOrder.ApiOrderID)
                    If result.status = "Success" Then

                        Dim lmd = Context.LeadsMortgageDatas.Find(bble)

                        If lmd IsNot Nothing Then
                            lmd.C1stServicer = result.servicerName
                        Else
                            lmd = New LeadsMortgageData
                            lmd.BBLE = bble
                            lmd.C1stServicer = result.servicerName
                            lmd.CreateBy = "DataService"
                            lmd.CreateDate = DateTime.Now

                            Context.LeadsMortgageDatas.Add(lmd)
                        End If
                    End If
                End If

                Context.SaveChanges()

                'Update HomeOwnerInfo
                'check if current request is sent by portal user
                If apiOrder.TLO = APIOrder.ItemStatus.Calling Then
                    If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing AndAlso Not String.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) Then

                        'client.Acris_Get_LatestSale(apiOrder.ApiOrderID, bble)
                        'Dim ldinfo = LeadsInfo.GetInstance(apiOrder.BBLE)
                        Dim stateObj = New With {
                              .BBLE = bble,
                              .OrderId = apiOrder.ApiOrderID,
                              .Context = HttpContext.Current
                              }
                        Dim userName = HttpContext.Current.User.Identity.Name

                        Dim callBack = Sub(state)
                                           HttpContext.Current = state.Context
                                           Try
                                               UpdateHomeOwner(bble, state.OrderId)
                                               UpdateHomeOwnerApi(state.OrderId)
                                               'UserMessage.AddNewMessage(GetCurrentIdentityName, "Refresh", "HomeOwner info is ready. BBLE: " & state.BBLE, state.BBLE)
                                           Catch ex As Exception
                                               UserMessage.AddNewMessage(userName, "Error", "Error happened on refresh. Message: " & ex.Message, state.BBLE, DateTime.Now, GetCurrentIdentityName, Nothing)
                                               UpdateHomeOwnerApi(state.OrderId, "Error")
                                           End Try
                                       End Sub

                        System.Threading.ThreadPool.QueueUserWorkItem(callBack, stateObj)
                        Return True
                    Else
                        'Sent by Data loop service
                        Dim result = UpdateHomeOwner(bble, apiOrder.ApiOrderID)
                        UpdateHomeOwnerApi(apiOrder.ApiOrderID)
                        Return result
                    End If
                End If
                Return True
            End Using

        Catch ex As System.TimeoutException
            Throw New Exception("Time is out. The data services is busy now. Please try later.")
        Catch ex As Exception
            Throw New Exception("Data Services isnot avaiable now. Please try later. Error messager: " & ex.Message)
        End Try
    End Function

    Public Shared Function GetCurrentIdentityName() As String
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

    Public Shared Function GeoCode(address As String) As String
        Using client As New DataAPI.WCFMacrosClient

            Dim result = client.DCPGeododerBySingleLine(address)
            Return result
        End Using
    End Function

    Public Shared Sub SaveNameandAddress(bble As String)
        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault

            If li IsNot Nothing Then
                Using client As New DataAPI.WCFMacrosClient
                    Dim results = client.NYC_NameAndAddress(bble)

                    If results IsNot Nothing And results.Count > 0 Then
                        If Not String.IsNullOrEmpty(results(0).Owner1) AndAlso Not String.IsNullOrEmpty(results(0).Owner1.TrimStart.TrimEnd) Then
                            li.Owner = results(0).Owner1.TrimStart.TrimEnd
                            Dim add1 = String.Format("{0} {1}", results(0).Number, results(0).Street).TrimStart.TrimEnd
                            SaveHomeOwner(bble, results(0).Owner1.TrimStart.TrimEnd, add1, "", results(0).City, results(0).State, "US", results(0).Zip, context)
                        End If

                        If Not String.IsNullOrEmpty(results(0).Owner2) AndAlso Not String.IsNullOrEmpty(results(0).Owner2.TrimStart.TrimEnd) Then
                            Dim coOwner = results(0).Owner2.TrimStart.TrimEnd
                            If Not String.IsNullOrEmpty(coOwner) AndAlso coOwner <> li.Owner Then
                                li.CoOwner = results(0).Owner2.TrimStart.TrimEnd
                                Dim add1 = String.Format("{0} {1}", results(0).Number, results(0).Street).TrimStart.TrimEnd
                                SaveHomeOwner(bble, results(0).Owner2.TrimStart.TrimEnd, add1, "", results(0).City, results(0).State, "US", results(0).Zip, context)
                            Else
                                li.CoOwner = ""
                            End If
                        Else
                            li.CoOwner = ""
                        End If

                        'For Each item In results
                        '    If Not String.IsNullOrEmpty(item.Name) Then
                        '        Dim add1 = String.Format("{0} {1}", item.Number, item.Street).Trim
                        '        SaveHomeOwner(bble, item.Name.TrimEnd.TrimStart, add1, item.Mail_ST2, item.Mail_City, item.Mail_State, "US", item.Mail_Zip, context)
                        '    End If
                        'Next
                    Else
                        Dim prop = client.NYC_Assessment_Full(bble).SingleOrDefault
                        If prop IsNot Nothing AndAlso Not String.IsNullOrEmpty(prop.OWNER_NAME) Then
                            li.Owner = prop.OWNER_NAME.Trim
                            SaveHomeOwner(bble, prop.OWNER_NAME.Trim, prop.OWNER_ADDRESS1, prop.OWNER_ADDRESS2, prop.OWNER_CITY, prop.OWNER_STATE, prop.OWNER_COUNTRY, prop.OWNER_ZIP, context)
                        End If
                    End If
                End Using

                Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                If lead IsNot Nothing Then
                    lead.LeadsName = li.LeadsName
                    lead.LastUpdate = DateTime.Now
                    lead.UpdateBy = GetCurrentIdentityName()
                End If

                context.SaveChanges()
            End If
            ''Update Owner Info
            'UpdateHomeOwner(li.BBLE, 1)
        End Using
    End Sub

    Private Shared Function IsSameName(name As String, nameToCompare As String)
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

    Private Shared Function TrimString(Str As String) As String
        If String.IsNullOrEmpty(Str) Then
            Return Str
        End If

        Return Str.Trim
    End Function

    Public Shared Property ServiceAddress

End Class

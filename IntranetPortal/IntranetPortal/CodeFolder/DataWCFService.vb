Imports System.Threading.Tasks
Imports IntranetPortal.Data

Public Class DataWCFService

#Region "Complains"

    Public Shared Function RunComplains() As Boolean

        Using client As New DataAPI.WCFMacrosClient

            Dim data As New DataAPI.DOB_Complaints_In
            data.BBLE = "1022150377"
            data.DOB_PenOnly = True

            Dim result = client.DOB_Complaints_Get(data)

        End Using

    End Function



#End Region

    Public Shared Function GetLeadInfo(bble As String) As LeadsInfo
        Using client As New DataAPI.WCFMacrosClient
            'Dim result = client.GetPropdata(bble, False, False, False, False, False, False)
            Dim leadResult = client.ALL_NYC_Tax_Liens_By_BBLE(bble).SingleOrDefault

            If leadResult IsNot Nothing Then
                Dim li As New LeadsInfo
                li.BBLE = leadResult.BBLE
                li = FieldMap(li, leadResult)

                Return li
            End If
            Return Nothing
        End Using
    End Function

    Public Shared Function GetLocateReport(apiOrderNum As Integer, bble As String, owner As HomeOwner) As DataAPI.TLOLocateReportOutput
        If String.IsNullOrEmpty(owner.Address1) AndAlso String.IsNullOrEmpty(owner.Address2) AndAlso String.IsNullOrEmpty(owner.City) Then
            Return Nothing
            'Throw New Exception("Get Owner Error: the owner's address is empty, please refresh the General Property Info and try later. BBLE: " + bble)
        End If

        Using client As New DataAPI.WCFMacrosClient
            Dim result = GetLocateReport(apiOrderNum, bble, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country)

            If result Is Nothing Then
                Dim propOwners = client.NYC_NameAndAddress(bble)
                If propOwners IsNot Nothing And propOwners.Count > 0 Then
                    Dim newAds = propOwners(0)
                    If newAds.Owner1.Trim = owner.Name Or newAds.Owner2.Trim = owner.Name Then
                        Dim add1 = String.Format("{0} {1}", newAds.Mail_Num.Trim, newAds.Mail_ST1.Trim).TrimStart.TrimEnd
                        'result = client.Get_LocateReport(apiOrderNum, bble, owner.Name, add1, newAds.Mail_ST2, newAds.Mail_City, newAds.Mail_State, newAds.Mail_Zip, "US", "", "")
                        result = GetLocateReport(apiOrderNum, bble, owner.Name, add1, newAds.Mail_ST2, newAds.Mail_City, newAds.Mail_State, newAds.Mail_Zip, "US")

                        'Log the ower
                        'If result IsNot Nothing Then
                        '    Dim desc = String.Format("Owner Name: {0}, Address1: {1}, City: {2}, State: {3}, Zip: {4},HomeOwnerId:{5}", owner.Name, add1, newAds.Mail_City, newAds.Mail_State, newAds.Mail_Zip, owner.OwnerID)
                        '    Core.SystemLog.Log("TLO Locate Report", desc, "TLO API", bble, GetCurrentIdentityName)
                        'End If

                    End If
                End If
            Else
                'Dim desc = String.Format("Owner Name: {0}, Address1: {1}, City: {2}, State: {3}, Zip: {4},HomeOwnerId:{5}", owner.Name, owner.Address1, owner.City, owner.State, owner.Zip, owner.OwnerID)
                'Core.SystemLog.Log("TLO Locate Report", desc, "TLO API", bble, GetCurrentIdentityName)
            End If

            Return result
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

    Public Shared Function CopyDsObjectToLocal(localObj As Object, dsObj As Object) As Object
        Dim dsType = dsObj.GetType
        Dim portalType = localObj.GetType
        For Each propertyInfo In dsType.GetProperties
            Dim prop = portalType.GetProperty(propertyInfo.Name)
            If prop IsNot Nothing Then
                If prop.CanWrite Then
                    prop.SetValue(localObj, propertyInfo.GetValue(dsObj))
                End If
            End If
        Next

        Return localObj
    End Function

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

    Public Shared Function GetLiensInfo(bble As String) As List(Of PortalLisPen)
        Dim lisPens As New List(Of PortalLisPen)
        Using client As New DataAPI.WCFMacrosClient
            For Each item In client.Get_LisPendens(bble)
                Dim lisPen As New PortalLisPen
                lisPen.Active = item.Active
                lisPen.Attorney = item.Attorney
                lisPen.Attorney_Phone = item.Attorney_Phone
                lisPen.BBLE = item.BBLE
                lisPen.Block = item.Block
                lisPen.CollectedOn = item.CollectedOn
                lisPen.County = item.County
                lisPen.CountyNum = item.CountyNum
                lisPen.Defendant = item.Defendant
                lisPen.Docket_Number = item.Docket_Number
                lisPen.FileDate = item.FileDate
                lisPen.Interest_Rate = item.Interest_Rate
                lisPen.Lot = item.Lot
                lisPen.Monthly_Payment = item.Monthly_Payment
                lisPen.Mortgage_Date = item.Mortgage_Date
                lisPen.NEIGH_NAME = item.NEIGH_NAME
                lisPen.Number = item.Number
                lisPen.Original_Mortgage = item.Original_Mortgage
                lisPen.Plaintiff = item.Plaintiff
                lisPen.Section = item.Section
                lisPen.ST_Name = item.ST_Name
                lisPen.Terms = item.Terms
                lisPen.Zip = item.Zip

                lisPens.Add(lisPen)
            Next
            Return lisPens
        End Using
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

    Public Shared Function IsServerBusy(Optional serverAddress As String = Nothing) As Boolean
        Using client As New DataAPI.WCFMacrosClient()
            If Not String.IsNullOrEmpty(serverAddress) Then
                client.Endpoint.Address = New ServiceModel.EndpointAddress(serverAddress)
            End If

            Try
                Dim waitingRequest = client.Requests_Waiting
                Return waitingRequest > 20
            Catch ex As TimeoutException
                'Throw New Exception("Check Server is busy. Time out exception: " & ex.Message)
                Return True
            Catch ex As Exception
                'Throw New Exception("Check Server is busy. exception: " & ex.Message)
                Return True
            End Try
        End Using
    End Function

    Public Shared Function GetTaxlien(bble As String) As DataAPI.TaxLien_Info
        Using client As New DataAPI.WCFMacrosClient
            'Dim data = client.Get_Acris_TaxLien(bble)
            'Return data
            Return Nothing
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
        'Dim ct As New DataAPI.TLOLocateReportOutput
        'Using client As New DataAPI.WCFMacrosClient

        '    Dim taxLiens = client.Get_Acris_TaxLien(bble)

        '    If taxLiens IsNot Nothing AndAlso taxLiens.TaxLienAmt.HasValue Then
        '        Using ctx As New Entities
        '            Dim liens = ctx.LeadsTaxLiens.Where(Function(lt) lt.BBLE = bble)
        '            ctx.LeadsTaxLiens.RemoveRange(liens)

        '            Dim newLien As New LeadsTaxLien
        '            newLien.BBLE = bble
        '            If taxLiens.TaxLienCertDate.HasValue Then
        '                newLien.TaxLiensYear = taxLiens.TaxLienCertDate
        '            End If

        '            If taxLiens.TaxLienAmt.HasValue Then
        '                newLien.Amount = taxLiens.TaxLienAmt
        '            End If
        '            ctx.LeadsTaxLiens.Add(newLien)

        '            ctx.SaveChanges()
        '        End Using
        '    End If
        'End Using
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

    Public Shared Function GetFullAssessInfo(bble As String, Optional li As LeadsInfo = Nothing) As LeadsInfo

        Try
            Using client As New DataAPI.WCFMacrosClient

                Dim result = client.NYC_Assessment_Full(bble).SingleOrDefault
                If li Is Nothing Then
                    li = New LeadsInfo
                    li.BBLE = bble
                    li.CreateDate = DateTime.Now
                    li.CreateBy = GetCurrentIdentityName()
                End If

                If result IsNot Nothing Then
                    li.BBLE = result.BBLE
                    li.Number = result.NUMBER
                    li.StreetName = result.ST_NAME
                    li.NeighName = result.NEIGH_NAME
                    li.State = "NY"
                    li.ZipCode = result.ZIP

                    If Not String.IsNullOrEmpty(result.APT_NO) AndAlso Not String.IsNullOrEmpty(result.APT_NO.Trim) Then
                        li.UnitNum = result.APT_NO.Trim
                    End If

                    li.PropertyAddress = BuildPropertyAddress(result) 'String.Format("{0} {1},{2},{3} {4}", result.NUMBER, result.ST_NAME, result.NEIGH_NAME, "NY", result.ZIP)
                    li.Borough = result.BOROUGH
                    li.Zoning = result.ZONING
                    li.MaxFar = CDbl(result.MAX_FAR)
                    li.ActualFar = CDbl(result.ACTUAL_FAR)
                    li.NYCSqft = result.ORIG_SQFT
                    li.Latitude = result.Latitude
                    li.Longitude = result.Longitude

                    'result.LAND_SQFT  as Land_SF
                    'result.ORIG_SQFT as NYC_GLA
                    If result.LAND_SQFT.HasValue AndAlso Not String.IsNullOrEmpty(result.MAX_FAR) AndAlso result.ORIG_SQFT.HasValue Then
                        li.UnbuiltSqft = result.LAND_SQFT * CDbl(result.MAX_FAR) - result.ORIG_SQFT

                        LeadsInfo.AddIndicator("UnderBuilt", li, GetCurrentIdentityName())
                    End If

                    'Dim salesInfo = client.Acris_Get_LatestSale(bble)
                    'li.SaleDate = salesInfo.SALE_DATE

                    li.Block = result.BLOCK
                    li.Lot = result.LOT
                    li.YearBuilt = result.AGE
                    li.TaxClass = result.TAX_CLASS
                    li.PropertyClass = result.CLASS
                    li.NumFloors = result.STORIES
                    li.BuildingDem = result.BLDG_DIM
                    li.LotDem = result.LOT_DIM
                    li.LastUpdate = DateTime.Now

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
                If owner.LocateReport IsNot Nothing Then
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
                    If owner.LocateReport IsNot Nothing Then
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

    'Used to create new leads
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
                If lisPens IsNot Nothing And lisPens.Count > 0 Then
                    Dim localLispens = context.PortalLisPens.Where(Function(lp) lp.BBLE = bble)
                    context.PortalLisPens.RemoveRange(localLispens)
                    context.PortalLisPens.AddRange(lisPens)
                End If

                context.SaveChanges()

                'Get latest sale info
                GetLatestSalesInfo(bble)

                context.Entry(li).Reload()
                LeadsInfo.AddIndicator("LPDefandant", li, GetCurrentIdentityName())

                Try
                    'Update Taxliens data
                    UpdateTaxLiens(bble)
                Catch ex As Exception

                End Try

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
            apiOrder.Acris = apiOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.Acris = apiOrder.ItemStatus.NonCall
        End If

        If taxBill Then
            apiOrder.TaxBill = apiOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.TaxBill = apiOrder.ItemStatus.NonCall
        End If

        If EcbViolation Then
            apiOrder.ECBViolation = apiOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.ECBViolation = apiOrder.ItemStatus.NonCall
        End If

        If waterBill Then
            apiOrder.WaterBill = apiOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.WaterBill = apiOrder.ItemStatus.NonCall
        End If

        If zillow Then
            apiOrder.Zillow = apiOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.Zillow = apiOrder.ItemStatus.NonCall
        End If

        If TLO Then
            apiOrder.TLO = apiOrder.ItemStatus.Calling
            needWait = True
        Else
            apiOrder.TLO = apiOrder.ItemStatus.NonCall
        End If

        If needWait Then
            apiOrder.Status = apiOrder.OrderStatus.Active
        Else
            apiOrder.Status = apiOrder.OrderStatus.Complete
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

        ''The old services 
        'Dim apiOrder As New APIOrder
        'apiOrder.LatestSale = apiOrder.ItemStatus.Calling
        'apiOrder.BBLE = bble
        'apiOrder.OrderTime = DateTime.Now
        'apiOrder.Orderby = HttpContext.Current.User.Identity.Name

        'Using context As New Entities
        '    context.APIOrders.Add(apiOrder)
        '    context.SaveChanges()

        '    Using client As New DataAPI.WCFMacrosClient
        '        client.Acris_Get_LatestSaleAsync(apiOrder.ApiOrderID, bble)
        '    End Using
        'End Using
    End Sub

    Private Shared Sub GetAcrisLatestOwner(bble As String)
        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault

            If li Is Nothing Then
                Return
            End If

            Using client As New DataAPI.WCFMacrosClient
                Dim results = client.Get_Acris_Latest_OwnerName(bble)
                If results IsNot Nothing AndAlso results.Count > 0 Then
                    If Not String.IsNullOrEmpty(results(0).NAME) AndAlso Not String.IsNullOrEmpty(results(0).NAME.TrimStart.TrimEnd) Then
                        If Not IsSameName(li.Owner, results(0).NAME.Trim) Then
                            li.Owner = results(0).NAME.Trim
                        End If

                        li.Owner = li.Owner.Trim
                        'Dim add1 = String.Format("{0} {1}", results(0).ADDRESS_1, results(0).Street).TrimStart.TrimEnd
                        SaveHomeOwner(bble, li.Owner, results(0).ADDRESS_1, results(0).ADDRESS_2, results(0).CITY, results(0).STATE, results(0).COUNTRY, results(0).ZIP, context)
                    End If

                    If results.Count > 1 AndAlso Not String.IsNullOrEmpty(results(1).NAME) AndAlso Not String.IsNullOrEmpty(results(1).NAME.Trim) Then
                        Dim coOwner = results(1).NAME.Trim
                        If Not String.IsNullOrEmpty(coOwner) AndAlso coOwner <> li.Owner Then
                            li.CoOwner = results(1).NAME.Trim
                            SaveHomeOwner(bble, results(1).NAME.Trim, results(1).ADDRESS_1, results(1).ADDRESS_2, results(1).CITY, results(1).STATE, results(1).COUNTRY, results(1).ZIP, context)
                        Else
                            li.CoOwner = ""
                        End If
                    Else
                        li.CoOwner = ""
                    End If
                Else
                    Dim prop = client.NYC_Assessment_Full(bble).SingleOrDefault
                    If prop IsNot Nothing AndAlso Not String.IsNullOrEmpty(prop.OWNER_NAME) Then
                        If Not IsSameName(li.Owner, prop.OWNER_NAME) Then
                            li.Owner = prop.OWNER_NAME.Trim
                        End If
                        li.Owner = li.Owner.Trim
                        SaveHomeOwner(bble, li.Owner, prop.OWNER_ADDRESS1, prop.OWNER_ADDRESS2, prop.OWNER_CITY, prop.OWNER_STATE, prop.OWNER_COUNTRY, prop.OWNER_ZIP, context)
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

    Shared Sub SaveHomeOwner(bble As String, name As String, add1 As String, add2 As String, city As String, state As String, country As String, zip As String, context As Entities)
        Try
            Dim localOwner = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Name = name And ho.Active = True).FirstOrDefault

            If bble.StartsWith("3") Then
                If Not String.IsNullOrEmpty(city) Then
                    city = "Brooklyn"
                End If
            End If

            If bble.StartsWith("2") Then
                If Not String.IsNullOrEmpty(city) AndAlso (city.Trim = "BX" Or city.Contains("BX")) Then
                    city = "Bronx"
                End If
            End If

            'If bble.StartsWith("4") Then
            '    If Not String.IsNullOrEmpty(city) AndAlso (city.Trim = "BX") Then
            '        city = "Bronx"
            '    End If
            'End If

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

    Private Shared Function TrimString(Str As String) As String
        If String.IsNullOrEmpty(Str) Then
            Return Str
        End If

        Return Str.Trim
    End Function

    Public Shared Function OrderPropData(apiOrder As APIOrder, Optional needWait As Boolean = True) As Boolean

        Try
            Using Context As New Entities
                If apiOrder.Status = apiOrder.OrderStatus.Active Then
                    Dim tmpApiOrder = Context.APIOrders.Where(Function(ap) ap.BBLE = apiOrder.BBLE And Not ap.Status = apiOrder.OrderStatus.Complete).FirstOrDefault
                    If tmpApiOrder IsNot Nothing Then
                        apiOrder.ApiOrderID = tmpApiOrder.ApiOrderID
                        Context.APIOrders.Attach(tmpApiOrder)
                        Context.Entry(tmpApiOrder).CurrentValues.SetValues(apiOrder)
                    Else
                        Context.APIOrders.Add(apiOrder)
                    End If
                Else
                    Context.APIOrders.Add(apiOrder)
                End If

                Dim bble = apiOrder.BBLE

                Dim lead = Context.LeadsInfoes.Where(Function(li) li.BBLE = bble).SingleOrDefault
                Dim needCallService = False
                If lead IsNot Nothing Then
                    If apiOrder.Acris = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.AcrisOrderTime = DateTime.Now
                        lead.AcrisOrderStatus = apiOrder.ItemStatus.Calling.ToString
                    Else
                        apiOrder.Acris = apiOrder.ItemStatus.NonCall
                    End If

                    If apiOrder.TaxBill = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.TaxesOrderTime = DateTime.Now
                        lead.TaxesOrderStatus = apiOrder.ItemStatus.Calling.ToString
                    Else
                        apiOrder.TaxBill = apiOrder.ItemStatus.NonCall
                    End If

                    If apiOrder.ECBViolation = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.ECBOrderTime = DateTime.Now
                        lead.ECBOrderStatus = apiOrder.ItemStatus.Calling.ToString
                    Else
                        apiOrder.ECBViolation = apiOrder.ItemStatus.NonCall
                    End If

                    If apiOrder.WaterBill = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.WaterOrderTime = DateTime.Now
                        lead.WaterOrderStatus = apiOrder.ItemStatus.Calling.ToString
                    End If

                    If apiOrder.Zillow = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                    End If
                End If

                Context.SaveChanges()

                If needCallService Then
                    Try
                        If HttpContext.Current IsNot Nothing Then
                            Dim callback = Sub()
                                               Using client As New DataAPI.WCFMacrosClient
                                                   client.GetPropdata(bble,
                                                                  apiOrder.ApiOrderID,
                                                                  apiOrder.Acris = apiOrder.ItemStatus.Calling,
                                                                  apiOrder.TaxBill = apiOrder.ItemStatus.Calling,
                                                                  apiOrder.ECBViolation = apiOrder.ItemStatus.Calling,
                                                                  apiOrder.WaterBill = apiOrder.ItemStatus.Calling,
                                                                  apiOrder.Zillow = apiOrder.ItemStatus.Calling, False)

                                                   Try
                                                       client.Get_Servicer(apiOrder.ApiOrderID, bble)
                                                   Catch ex As Exception

                                                   End Try
                                               End Using
                                           End Sub

                            System.Threading.ThreadPool.QueueUserWorkItem(callback)
                        Else
                            Using client As New DataAPI.WCFMacrosClient
                                client.GetPropdata(bble,
                                               apiOrder.ApiOrderID,
                                               apiOrder.Acris = apiOrder.ItemStatus.Calling,
                                               apiOrder.TaxBill = apiOrder.ItemStatus.Calling,
                                               apiOrder.ECBViolation = apiOrder.ItemStatus.Calling,
                                               apiOrder.WaterBill = apiOrder.ItemStatus.Calling,
                                               apiOrder.Zillow = apiOrder.ItemStatus.Calling, False)

                                Try
                                    client.Get_Servicer(apiOrder.ApiOrderID, bble)
                                Catch ex As Exception

                                End Try
                            End Using
                        End If
                    Catch ex As System.TimeoutException
                        Throw New Exception("Time is out. The data services is busy now. Please try later. Data Service: GetPropdata " & ex.Message)
                    End Try
                End If

                'Update HomeOwnerInfo
                'check if current request is sent by portal user
                If apiOrder.TLO = apiOrder.ItemStatus.Calling Then
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

    Public Shared Sub RefreshServicer(bble)
        Using client As New DataAPI.WCFMacrosClient
            client.Get_Servicer(1, bble)
        End Using
    End Sub

    Public Shared Sub UpdateJudgmentSearchInfo(bble As String)
        Using client As New DataAPI.WCFMacrosClient
            'client.AAbs_GetEmergencyRepair()  -- Emergency Repair
            'client.


        End Using

    End Sub

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

    Private Shared Function FieldMap(li As LeadsInfo, leadResult As DataAPI.ALL_NYC_Tax_Liens_CO_Info) As LeadsInfo
        'li.BBLE = leadResult.BBLE
        li.IsLisPendens = leadResult.IsLisPendens
        li.IsOtherLiens = leadResult.IsOtherLiens
        li.IsTaxesOwed = leadResult.IsTaxesOwed
        li.IsWaterOwed = leadResult.IsWaterOwed
        li.IsECBViolations = leadResult.IsECBViolations
        li.IsDOBViolations = leadResult.IsDOBViolations
        li.C1stMotgrAmt = leadResult.C1stMotgrAmt
        li.C2ndMotgrAmt = leadResult.C2ndMotgrAmt
        li.TaxesAmt = leadResult.TaxesAmt
        li.TaxesOrderStatus = leadResult.TaxesOrderStatus
        li.TaxesOrderStatus = leadResult.TaxesOrderStatus
        li.TaxesOrderTime = leadResult.TaxesOrderTime
        li.TaxesOrderDeliveryTime = leadResult.TaxesOrderDeliveryTime
        li.WaterAmt = leadResult.WaterAmt
        li.WaterOrderTime = leadResult.WaterOrderTime
        li.WaterOrderDeliveryTime = leadResult.WaterOrderDeliveryTime
        li.ECBViolationsAmt = leadResult.ECBViolationsAmt
        li.ECBOrderStatus = leadResult.ECBOrderStatus
        li.ECBOrderTime = leadResult.ECBOrderTime
        li.ECBOrderDeliveryTime = leadResult.ECBOrderDeliveryTime
        li.DOBViolationsAmt = leadResult.DOBViolationsAmt
        li.DOBOrderStatus = leadResult.DOBOrderStatus
        li.DOBOrderTime = leadResult.DOBOrderTime
        li.DOBOrderDeliveryTime = leadResult.DOBOrderDeliveryTime
        li.AcrisOrderStatus = leadResult.AcrisOrderStatus
        li.AcrisOrderTime = leadResult.AcrisOrderTime
        li.AcrisOrderDeliveryTime = leadResult.AcrisOrderDeliveryTime
        li.LastPaid = leadResult.LastPaid
        li.IsCoOnFile = leadResult.IsCoOnFile
        li.TypeOfCo = leadResult.TypeOfCo
        li.Owner = leadResult.Owner
        li.CoOwner = leadResult.CoOwner
        li.Date = leadResult.Date
        li.PropertyAddress = leadResult.PropertyAddress
        li.SaleDate = leadResult.SaleDate
        li.TaxClass = leadResult.TaxClass
        li.SaleType = leadResult.SaleType
        li.Condition = leadResult.Condition
        li.Block = leadResult.Block
        li.Lot = leadResult.Lot
        li.DOBViolation = leadResult.DOBViolation
        li.Remark1 = leadResult.Remark1
        li.Remark2 = leadResult.Remark2
        li.Remark3 = leadResult.Remark3
        li.Remark4 = leadResult.Remark4
        li.Deed = leadResult.Deed
        li.LPindex = leadResult.LPindex

        Return li
    End Function

    Private Shared Function BuildPropertyAddress(asessment As DataAPI.NYC_Assessment) As String
        Try
            Return IntranetPortal.Core.PropertyHelper.BuildPropertyAddress(asessment.NUMBER, asessment.ST_NAME, asessment.BOROUGH, asessment.NEIGH_NAME, asessment.ZIP)
        Catch ex As Exception
            Throw New Exception("Exception Occured in BuildPropertyAddress: " + ex.Message)
        End Try
    End Function

    Private Shared Sub UpdateHomeOwnerApi(orderId As Integer, Optional result As String = "Done")
        APIOrder.UpdateOrderInfo(orderId, "TLO", result)
    End Sub

    Public Shared Sub TestNewAPI()
        Using client As New DataAPI.WCFMacrosClient
            'Dim table = client.AB_GetJugments("Test123", "Manhattan", "0000-00-00", "0000-00-00", "234", "1")
        End Using
    End Sub

    Public Shared Function GeoCode(address As String) As String
        Using client As New DataAPI.WCFMacrosClient

            Dim result = client.DCPGeododerBySingleLine(address)
            Return result
        End Using
    End Function

    Private Shared Function GetServiceClient()
        Return New DataAPI.WCFMacrosClient()
    End Function

    Public Shared Property ServiceAddress
End Class

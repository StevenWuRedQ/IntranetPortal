Imports System.Threading.Tasks

Public Class DataWCFService
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
            Dim result = client.Get_LocateReport(apiOrderNum, bble, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country, "", "")
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

    Public Shared Function GetFullAssessInfo(bble As String, Optional li As LeadsInfo = Nothing) As LeadsInfo
        Using client As New DataAPI.WCFMacrosClient
            Dim result = client.NYC_Assessment_Full(bble).SingleOrDefault
            If li Is Nothing Then
                li = New LeadsInfo
                li.CreateDate = DateTime.Now
                li.CreateBy = HttpContext.Current.User.Identity.Name
            End If

            If result IsNot Nothing Then
                li.BBLE = result.BBLE

                li.Number = result.NUMBER
                li.StreetName = result.ST_NAME
                li.NeighName = result.NEIGH_NAME
                li.State = "NY"
                li.ZipCode = result.ZIP
                li.PropertyAddress = String.Format("{0} {1},{2},{3} {4}", result.NUMBER, result.ST_NAME, result.NEIGH_NAME, "NY", result.ZIP)
                li.Borough = result.BOROUGH
                li.Zoning = result.ZONING
                li.MaxFar = CDbl(result.MAX_FAR)
                li.ActualFar = CDbl(result.ACTUAL_FAR)
                li.NYCSqft = result.GROSS_SQFT
                'li.UnbuiltSqft
                'Dim salesInfo = client.Acris_Get_LatestSale(bble)
                'li.SaleDate = salesInfo.SALE_DATE

                li.Block = result.BLOCK
                li.Lot = result.LOT
                li.YearBuilt = result.AGE
                li.TaxClass = result.TAX_CLASS
                li.NumFloors = result.STORIES
                li.BuildingDem = result.BLDG_DIM
                li.LotDem = result.LOT_DIM
                li.EstValue = client.Zillow_Estimate_By_BBLE(bble)
                'li.Owner = client.Get_Acris_Latest_OwnerName(bble)(0).NAME 'result.OWNER_NAME
                'Dim owners = client.Get_Acris_Latest_OwnerName(bble)
                'If owners.Count > 0 Then
                '    li.Owner = owners(0).NAME
                '    li.HomeOwners = New List(Of HomeOwner)

                '    If owners.Count > 1 Then
                '        li.CoOwner = owners(1).NAME
                '    End If

                '    For Each item In owners
                '        Dim homeOwner As New HomeOwner
                '        homeOwner.Name = item.NAME
                '        homeOwner.BBLE = bble
                '        If String.IsNullOrEmpty(item.ADDRESS_1) AndAlso String.IsNullOrEmpty(item.ADDRESS_2) AndAlso String.IsNullOrEmpty(item.CITY) Then
                '            homeOwner.Address1 = li.Number
                '            homeOwner.Address2 = li.StreetName
                '            homeOwner.City = li.NeighName
                '            homeOwner.State = "NY"
                '            homeOwner.Country = "US"
                '            homeOwner.Zip = item.ZIP
                '        Else
                '            homeOwner.Address1 = item.ADDRESS_1
                '            homeOwner.Address2 = item.ADDRESS_2
                '            homeOwner.City = item.CITY
                '            homeOwner.State = item.STATE
                '            homeOwner.Country = item.COUNTRY
                '            homeOwner.Zip = item.ZIP
                '        End If
                '        homeOwner.Active = True
                '        homeOwner.CreateDate = DateTime.Now
                '        homeOwner.CreateBy = HttpContext.Current.User.Identity.Name

                '        li.HomeOwners.Add(homeOwner)
                '    Next
                'End If

                li.LastUpdate = DateTime.Now
                li.UpdateBy = HttpContext.Current.User.Identity.Name

                Return li
            End If
        End Using

        Return li
    End Function

    Public Shared Function UpdateHomeOwner(bble As String, orderid As Integer) As Boolean
        Using context As New Entities
            Dim owners = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True).ToList

            If owners Is Nothing Or owners.Count = 0 Then
                GetLatestSalesInfo(bble)
                Return False
            End If

            For Each owner In owners

                Dim result = GetLocateReport(orderid, bble, owner)
                If result IsNot Nothing Then
                    owner.TLOLocateReport = result
                End If
            Next

            Dim contextError = context.GetValidationErrors()
            If contextError.Count = 0 Then
                context.SaveChanges()
            Else
                Throw New Exception(contextError(0).ValidationErrors(0).ErrorMessage)
            End If
        End Using
    End Function

    Public Shared Function UpdateAssessInfo(bble As String) As LeadsInfo
        Try
            Using context As New Entities
                Dim li As LeadsInfo = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault

                If li Is Nothing Then
                    li = GetFullAssessInfo(bble, li)
                    context.LeadsInfoes.Add(li)
                Else
                    li = GetFullAssessInfo(bble, li)
                End If

                'If li.HomeOwners IsNot Nothing Then
                '    If context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True).Count = 0 Then
                '        context.HomeOwners.AddRange(li.HomeOwners)
                '    Else
                '        For Each owner In li.HomeOwners
                '            Dim localOwner = context.HomeOwners.Where(Function(ho) ho.BBLE = owner.BBLE And ho.Name = owner.Name And ho.Active = True).SingleOrDefault

                '            If localOwner IsNot Nothing Then
                '                localOwner.Name = owner.Name
                '                localOwner.Address1 = owner.Address1
                '                localOwner.Address2 = owner.Address2
                '                localOwner.City = owner.City
                '                localOwner.Country = owner.Country
                '                localOwner.State = owner.State
                '                localOwner.Zip = owner.Zip
                '            Else
                '                context.HomeOwners.Add(owner)
                '            End If
                '        Next
                '    End If
                'End If

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

                'Update leads neighborhood info
                Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                If lead IsNot Nothing Then
                    lead.Neighborhood = li.NeighName
                    lead.LeadsName = li.LeadsName
                    lead.LastUpdate = DateTime.Now
                    lead.UpdateBy = HttpContext.Current.User.Identity.Name
                    context.SaveChanges()
                End If

                Return li
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function UpdateLeadInfo(bble As String, Optional assessment As Boolean = False,
                                          Optional acris As Boolean = True,
                                          Optional taxBill As Boolean = True,
                                          Optional EcbViolation As Boolean = True,
                                          Optional waterBill As Boolean = True,
                                          Optional zillow As Boolean = True,
                                          Optional TLO As Boolean = True) As Boolean

        Dim apiOrder As New APIOrder

        If assessment Then
            UpdateAssessInfo(bble)
        End If

        apiOrder.BBLE = bble
        Dim needWait = False

        If acris Then
            apiOrder.Acris = apiOrder.ItemStatus.Calling
            needWait = True
        End If

        If taxBill Then
            apiOrder.TaxBill = apiOrder.ItemStatus.Calling
            needWait = True
        End If

        If EcbViolation Then
            apiOrder.ECBViolation = apiOrder.ItemStatus.Calling
            needWait = True
        End If

        If waterBill Then
            apiOrder.WaterBill = apiOrder.ItemStatus.Calling
            needWait = True
        End If

        If zillow Then
            apiOrder.Zillow = apiOrder.ItemStatus.Calling
            needWait = True
        End If

        If TLO Then
            apiOrder.TLO = apiOrder.ItemStatus.Calling
        End If

        If needWait Then
            apiOrder.Status = apiOrder.OrderStatus.Active
        Else
            apiOrder.Status = apiOrder.OrderStatus.Complete
        End If

        apiOrder.OrderTime = DateTime.Now
        apiOrder.Orderby = HttpContext.Current.User.Identity.Name

        Return OrderPropData(apiOrder)
    End Function

    Public Shared Sub GetLatestSalesInfo(bble As String)
        SaveNameandAddress(bble)
        Return

        'The old services 
        Dim apiOrder As New APIOrder
        apiOrder.LatestSale = apiOrder.ItemStatus.Calling
        apiOrder.BBLE = bble
        apiOrder.OrderTime = DateTime.Now
        apiOrder.Orderby = HttpContext.Current.User.Identity.Name

        Using context As New Entities
            context.APIOrders.Add(apiOrder)
            context.SaveChanges()

            Using client As New DataAPI.WCFMacrosClient
                client.Acris_Get_LatestSaleAsync(apiOrder.ApiOrderID, bble)
            End Using
        End Using
    End Sub

    Public Shared Sub SaveNameandAddress(bble As String)
        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(l) l.BBLE = bble).SingleOrDefault

            Using client As New DataAPI.WCFMacrosClient
                Dim results = client.NYC_NameAndAddress(bble)

                If results IsNot Nothing And results.Count > 0 Then
                    If Not String.IsNullOrEmpty(results(0).Owner1.TrimStart.TrimEnd) Then
                        li.Owner = results(0).Owner1.TrimStart.TrimEnd
                        Dim add1 = String.Format("{0} {1}", results(0).Number, results(0).Street).TrimStart.TrimEnd
                        SaveHomeOwner(bble, results(0).Owner1.TrimStart.TrimEnd, add1, "", results(0).City, results(0).State, "US", results(0).Zip, context)
                    End If

                    If Not String.IsNullOrEmpty(results(0).Owner2.TrimStart.TrimEnd) Then
                        li.CoOwner = results(0).Owner2.TrimStart.TrimEnd
                        Dim add1 = String.Format("{0} {1}", results(0).Number, results(0).Street).TrimStart.TrimEnd
                        SaveHomeOwner(bble, results(0).Owner2.TrimStart.TrimEnd, add1, "", results(0).City, results(0).State, "US", results(0).Zip, context)
                    End If
                End If

                For Each item In results
                    SaveHomeOwner(bble, item.Name.TrimEnd.TrimStart, item.Mail_ST1, item.Mail_ST2, item.Mail_City, item.Mail_State, "US", item.Mail_Zip, context)
                Next
            End Using

            Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
            If lead IsNot Nothing Then
                lead.LeadsName = li.LeadsName
                lead.LastUpdate = DateTime.Now
                lead.UpdateBy = "DataService"
            End If

            context.SaveChanges()

            ''Update Owner Info
            'UpdateHomeOwner(li.BBLE, 1)
        End Using
    End Sub

    Shared Sub SaveHomeOwner(bble As String, name As String, add1 As String, add2 As String, city As String, state As String, country As String, zip As String, context As Entities)
        Dim localOwner = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Name = name And ho.Active = True).SingleOrDefault

        If localOwner IsNot Nothing Then
            localOwner.Name = name
            localOwner.Address1 = add1
            localOwner.Address2 = add2
            localOwner.City = city
            localOwner.Country = country
            localOwner.State = state
            localOwner.Zip = zip
        Else
            If context.HomeOwners.Local.Where(Function(ho) ho.BBLE = bble And ho.Name = name).Count = 0 Then
                context.HomeOwners.Add(New HomeOwner With {
                                                   .BBLE = bble,
                                                   .Name = name,
                                                   .Address1 = add1,
                                                   .Address2 = add2,
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
    End Sub

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
                    End If

                    If apiOrder.TaxBill = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.TaxesOrderTime = DateTime.Now
                        lead.TaxesOrderStatus = apiOrder.ItemStatus.Calling.ToString
                    End If

                    If apiOrder.ECBViolation = apiOrder.ItemStatus.Calling Then
                        needCallService = True
                        lead.ECBOrderTime = DateTime.Now
                        lead.ECBOrderStatus = apiOrder.ItemStatus.Calling.ToString
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
                Using client As New DataAPI.WCFMacrosClient

                    If needCallService Then

                        client.GetPropdata(bble,
                                               apiOrder.ApiOrderID,
                                               apiOrder.Acris = apiOrder.ItemStatus.Calling,
                                               apiOrder.TaxBill = apiOrder.ItemStatus.Calling,
                                               apiOrder.ECBViolation = apiOrder.ItemStatus.Calling,
                                               apiOrder.WaterBill = apiOrder.ItemStatus.Calling,
                                                apiOrder.Zillow = apiOrder.ItemStatus.Calling, False)
                        'Dim owner = client.Get_TLO(apiOrder.ApiOrderID, bble, )

                    End If

                    'Update Homeownerinfo
                    If apiOrder.TLO = apiOrder.ItemStatus.Calling Then
                        'client.Acris_Get_LatestSale(apiOrder.ApiOrderID, bble)
                        'Dim ldinfo = LeadsInfo.GetInstance(apiOrder.BBLE)
                        UpdateHomeOwner(bble, apiOrder.ApiOrderID)
                    End If
                End Using
                Return True
            End Using

        Catch ex As Exception
            Throw ex
            'Return False
        End Try
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



End Class

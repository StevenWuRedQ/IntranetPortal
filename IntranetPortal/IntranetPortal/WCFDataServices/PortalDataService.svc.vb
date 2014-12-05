' NOTE: You can use the "Rename" command on the context menu to change the class name "PortalDataService" in code, svc and config file together.
' NOTE: In order to launch WCF Test Client for testing this service, please select PortalDataService.svc or PortalDataService.svc.vb at the Solution Explorer and start debugging.
Public Class PortalDataService
    Implements IPortalDataService

    Public Shared Orderid As Integer

    Function CompleteServicer(bble As String, billLine1 As String, billLine2 As String, billLine3 As String, billLine4 As String) As Boolean Implements IPortalDataService.CompleteServicer
        Dim address As New StringBuilder
        If Not String.IsNullOrEmpty(billLine1) Then
            address.Append(billLine1 + ",")
        End If

        If Not String.IsNullOrEmpty(billLine2) Then
            address.Append(billLine2 & ",")
        End If

        If Not String.IsNullOrEmpty(billLine3) Then
            address.Append(billLine3 & ",")
        End If

        If Not String.IsNullOrEmpty(billLine4) Then
            address.Append(billLine4)
        End If

        'Dim servicer = address.ToString
        Dim servicer = billLine1

        If servicer.EndsWith(",") Then
            servicer = servicer.Remove(servicer.Length - 1)
        End If

        Try
            Using ctx As New Entities
                Dim lmd = ctx.LeadsMortgageDatas.Find(bble)

                If lmd IsNot Nothing Then
                    lmd.C1stServicer = servicer
                Else
                    lmd = New LeadsMortgageData
                    lmd.BBLE = bble
                    lmd.C1stServicer = servicer
                    lmd.CreateBy = "DataService"
                    lmd.CreateDate = DateTime.Now

                    ctx.LeadsMortgageDatas.Add(lmd)
                End If

                ctx.SaveChanges()
            End Using

            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Function CompleteDataLoad(bble As String, apiOrderNo As Integer, infoType As String, status As String, updateTime As DateTime, C1stMotgrAmt As Double, C2ndMotgrAmt As Double, TaxesAmt As Double, WaterAmt As Double, ECBViolationsAmt As Double, DOBViolationsAmt As Double, zEstimate As Integer, salesInfo As DataAPI.Acris_Last_Sales_Info) As Boolean Implements IPortalDataService.CompleteDataLoad
        Orderid = apiOrderNo

        Using context As New Entities
            Dim OrderRep As New OrderRespons
            OrderRep.BBLE = bble
            OrderRep.APIOrderNo = apiOrderNo
            OrderRep.InfoType = infoType
            OrderRep.Status = status
            OrderRep.Updatetime = updateTime
            context.OrderResponses.Add(OrderRep)

            Try
                context.SaveChanges()
                UpdateOrderInfo(apiOrderNo, infoType, status)
                UpdateLeadInfo(bble, infoType, status, updateTime, C1stMotgrAmt, C2ndMotgrAmt, TaxesAmt, WaterAmt, ECBViolationsAmt, DOBViolationsAmt, zEstimate, salesInfo)
                Return True
            Catch ex As Exception
                Throw ex
            End Try
        End Using
    End Function

    Function UpdateSalesInfo(salesInfo As DataAPI.Acris_Last_Sales_Info) As Boolean
        Dim bble = salesInfo.BBLE
        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

            If li IsNot Nothing Then
                li.SaleDate = salesInfo.SALE_DATE

                Dim owners = salesInfo.Owner_List

                If owners IsNot Nothing Then

                    If owners.Count > 0 Then
                        li.Owner = owners(0).OWNER_NAME

                        If owners.Count > 1 Then
                            li.CoOwner = owners(1).OWNER_NAME
                        End If

                        For Each owner In owners
                            Dim localOwner = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Name = owner.OWNER_NAME And ho.Active = True).SingleOrDefault
                            Dim tmpOwner = GetHomeOwner(li, owner)

                            If localOwner IsNot Nothing Then
                                localOwner.Name = tmpOwner.Name
                                localOwner.Address1 = tmpOwner.Address1
                                localOwner.Address2 = tmpOwner.Address2
                                localOwner.City = tmpOwner.City
                                localOwner.Country = tmpOwner.Country
                                localOwner.State = tmpOwner.State
                                localOwner.Zip = tmpOwner.Zip
                            Else
                                context.HomeOwners.Add(New HomeOwner With {
                                                       .BBLE = bble,
                                                       .Name = tmpOwner.Name,
                                                       .Address1 = tmpOwner.Address1,
                                                       .Address2 = tmpOwner.Address2,
                                                       .City = tmpOwner.City,
                                                       .Country = tmpOwner.Country,
                                                       .State = tmpOwner.State,
                                                       .Zip = tmpOwner.Zip,
                                                       .Active = True,
                                                       .CreateDate = DateTime.Now,
                                                       .CreateBy = "DataService"
                                                       })
                            End If

                            'Update leads neighborhood info
                            Dim lead = context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                            If lead IsNot Nothing Then
                                lead.Neighborhood = li.NeighName
                                lead.LeadsName = li.LeadsName
                                lead.LastUpdate = DateTime.Now
                                lead.UpdateBy = "DataService"

                            End If

                            context.SaveChanges()

                            'Update Owner Info
                            DataWCFService.UpdateHomeOwner(li.BBLE, Orderid)

                        Next
                    End If
                End If

                context.SaveChanges()
            End If
        End Using
    End Function

    Private Function GetHomeOwner(li As LeadsInfo, item As DataAPI.OwnerNameAddress) As HomeOwner
        Dim homeOwner As New HomeOwner
        homeOwner.Name = item.OWNER_NAME
        homeOwner.BBLE = li.BBLE
        If String.IsNullOrEmpty(item.ADDR1) AndAlso String.IsNullOrEmpty(item.ADDR2) AndAlso String.IsNullOrEmpty(item.CITY) Then
            homeOwner.Address1 = li.Number
            homeOwner.Address2 = li.StreetName
            homeOwner.City = li.NeighName
            homeOwner.State = "NY"
            homeOwner.Country = "US"
            homeOwner.Zip = item.ZIP
        Else
            homeOwner.Address1 = item.ADDR1
            homeOwner.Address2 = item.ADDR2
            homeOwner.City = item.CITY
            homeOwner.State = item.STATE
            homeOwner.Country = item.COUNTRY
            homeOwner.Zip = item.ZIP
        End If

        Return homeOwner
    End Function


    Public Function UpdateLeadInfo(bble As String, infoType As String, status As String, updateTime As DateTime, C1stMotgrAmt As Double, C2ndMotgrAmt As Double, TaxesAmt As Double, WaterAmt As Double, ECBViolationsAmt As Double, DOBViolationsAmt As Double, zEstimate As Integer, salesInfo As DataAPI.Acris_Last_Sales_Info) As Boolean
        'Dim newlead = DataWCFService.GetLeadInfo(bble)

        Using context As New Entities
            Dim lead = context.LeadsInfoes.Where(Function(li) li.BBLE = bble).SingleOrDefault

            If lead IsNot Nothing Then
                Select Case infoType
                    Case "AcrisMtgrs"
                        If C1stMotgrAmt > 0 Then
                            lead.IsLisPendens = True
                        End If

                        If C1stMotgrAmt > C2ndMotgrAmt Then
                            lead.C1stMotgrAmt = C1stMotgrAmt
                            lead.C2ndMotgrAmt = C2ndMotgrAmt
                        Else
                            lead.C1stMotgrAmt = C2ndMotgrAmt
                            lead.C2ndMotgrAmt = C1stMotgrAmt
                        End If



                        lead.AcrisOrderDeliveryTime = updateTime
                        lead.AcrisOrderStatus = status
                    Case "ECB_Violations"
                        If ECBViolationsAmt > 0 Then
                            lead.IsECBViolations = True
                        End If

                        lead.ECBViolationsAmt = ECBViolationsAmt
                        lead.ECBOrderDeliveryTime = updateTime
                        lead.ECBOrderStatus = status
                    Case "DOBPenalty"
                        If DOBViolationsAmt > 0 Then
                            lead.IsDOBViolations = True
                        End If

                        lead.DOBViolationsAmt = DOBViolationsAmt
                        lead.DOBOrderDeliveryTime = updateTime
                        lead.DOBOrderStatus = status
                    Case "PROP_TAX"
                        If TaxesAmt > 0 Then
                            lead.IsTaxesOwed = True
                        End If

                        lead.TaxesAmt = TaxesAmt
                        lead.TaxesOrderDeliveryTime = updateTime
                        lead.TaxesOrderStatus = status
                    Case "WATER_SEWER"
                        If WaterAmt > 0 Then
                            lead.IsWaterOwed = True
                        End If

                        lead.WaterAmt = WaterAmt
                        lead.WaterOrderDeliveryTime = updateTime
                        lead.WaterOrderStatus = status

                        LeadsInfo.AddIndicator("Water", lead)
                    Case "Zillow"
                        If zEstimate > 0 Then
                            lead.EstValue = zEstimate
                            LeadsInfo.AddIndicator("UnderBuilt", lead)

                        End If
                    Case "ACRIS_LatestSale"
                        UpdateSalesInfo(salesInfo)
                End Select

                lead.LastUpdate = DateTime.Now
                lead.UpdateBy = "Data Services"
                context.SaveChanges()


                LeadsInfo.AddIndicator("Mortgage", lead)
                Return True
            End If
        End Using

        Return False
    End Function

    Public Function UpdateOrderInfo(orderId As Integer, infoType As String, status As String) As Boolean
        Using context As New Entities

            Dim apiOrder = context.APIOrders.Where(Function(order) order.ApiOrderID = orderId).SingleOrDefault

            If apiOrder IsNot Nothing Then

                Select Case infoType
                    Case "AcrisMtgrs"
                        If status = "Task-Done" Then
                            apiOrder.Acris = apiOrder.ItemStatus.Complete
                        End If

                    Case "ECB_Violations", "DOBPenalty"
                        If status = "Task-Done" Then
                            apiOrder.ECBViolation = apiOrder.ItemStatus.Complete
                        End If

                    Case "PROP_TAX"
                        If status = "Task-Done" Then
                            apiOrder.TaxBill = apiOrder.ItemStatus.Complete
                        End If

                    Case "WATER_SEWER"
                        If status = "Task-Done" Then
                            apiOrder.WaterBill = apiOrder.ItemStatus.Complete
                        End If
                    Case "Zillow"
                        If status = "Task-Done" Then
                            apiOrder.Zillow = apiOrder.ItemStatus.Complete
                        End If
                    Case "ACRIS_LatestSale"
                        If status = "Done" Then
                            apiOrder.LatestSale = apiOrder.ItemStatus.Complete
                        End If
                End Select

                Dim result As Boolean = (Not (apiOrder.Acris.HasValue AndAlso apiOrder.Acris = apiOrder.ItemStatus.Calling) And
                                         Not (apiOrder.ECBViolation.HasValue AndAlso apiOrder.ECBViolation = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.TaxBill.HasValue AndAlso apiOrder.TaxBill = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.WaterBill.HasValue AndAlso apiOrder.WaterBill = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.Zillow.HasValue AndAlso apiOrder.Zillow = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.LatestSale.HasValue AndAlso apiOrder.LatestSale = apiOrder.ItemStatus.Calling))

                If result Then
                    apiOrder.Status = apiOrder.OrderStatus.Complete
                Else
                    apiOrder.Status = apiOrder.OrderStatus.PartialComplete
                End If

                context.SaveChanges()
                Return True
            End If
        End Using

        Return False
    End Function
End Class

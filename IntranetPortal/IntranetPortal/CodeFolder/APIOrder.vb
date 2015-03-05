Partial Public Class APIOrder
    Public Enum ItemStatus
        NonCall = 0
        Calling = 1
        Complete = 2
    End Enum

    Public Enum OrderStatus
        Active = 0
        PartialComplete = 1
        Complete = 2
        [Error] = 3
    End Enum

    Public Shared Function UpdateOrderInfo(orderId As Integer, infoType As String, status As String) As Boolean
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
                    Case "TLO"
                        If status = "Done" Then
                            apiOrder.TLO = apiOrder.ItemStatus.Complete
                        End If
                End Select

                Dim result As Boolean = (Not (apiOrder.Acris.HasValue AndAlso apiOrder.Acris = apiOrder.ItemStatus.Calling) And
                                         Not (apiOrder.ECBViolation.HasValue AndAlso apiOrder.ECBViolation = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.TaxBill.HasValue AndAlso apiOrder.TaxBill = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.WaterBill.HasValue AndAlso apiOrder.WaterBill = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.Zillow.HasValue AndAlso apiOrder.Zillow = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.LatestSale.HasValue AndAlso apiOrder.LatestSale = apiOrder.ItemStatus.Calling) And
                                              Not (apiOrder.TLO.HasValue AndAlso apiOrder.TLO = apiOrder.ItemStatus.Calling))

                If result Then
                    apiOrder.Status = apiOrder.OrderStatus.Complete
                Else
                    apiOrder.Status = apiOrder.OrderStatus.PartialComplete
                End If

                context.SaveChanges()

                If apiOrder.Status = OrderStatus.Complete Then
                    Dim ld = LeadsInfo.GetInstance(apiOrder.BBLE)
                    If ld IsNot Nothing Then
                        UserMessage.AddNewMessage(apiOrder.Orderby, "Property Data is ready", String.Format("Property ({0}) Data is ready. Please check.", ld.LeadsName), apiOrder.BBLE, DateTime.Now, "Portal")
                    End If
                End If

                Return True
            End If
        End Using

        Return False
    End Function

    Public ReadOnly Property IsComplete As Boolean
        Get
            Return True
        End Get
    End Property

End Class

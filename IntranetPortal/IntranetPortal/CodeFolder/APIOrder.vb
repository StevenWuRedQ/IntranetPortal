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

    Public Function Save(context As Entities) As APIOrder
        Dim result = Me
        If Status = OrderStatus.Active Then

            Dim tmpApiOrder = context.APIOrders.Any(Function(ap) ap.ApiOrderID = ApiOrderID)
            If tmpApiOrder Then
                If context.APIOrders.Local.Any(Function(ap) ap.ApiOrderID = ApiOrderID) Then
                    Dim tmpOrder = context.APIOrders.Local.SingleOrDefault(Function(ap) ap.ApiOrderID = ApiOrderID)
                    context.Entry(tmpOrder).CurrentValues.SetValues(Me)
                    result = tmpOrder
                Else
                    context.Entry(Me).State = Entity.EntityState.Modified
                End If
            Else
                context.APIOrders.Add(Me)
            End If
        Else
            context.APIOrders.Add(Me)
        End If

        context.SaveChanges()

        Return result
    End Function

    ''' <summary>
    '''     Return the new API order
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function NewOrder(bble As String) As APIOrder
        Using ctx As New Entities
            Dim order = ctx.APIOrders.Where(Function(ap) ap.BBLE = bble And Not ap.Status = OrderStatus.Complete).FirstOrDefault
            If order IsNot Nothing Then
                Return order
            Else
                order = New APIOrder
                order.BBLE = bble
                order.Status = OrderStatus.Active
                order.OrderTime = DateTime.Now
                ctx.APIOrders.Add(order)
                ctx.SaveChanges()
                Return order
            End If
        End Using
    End Function

    Public Shared Function NewOrder(bble As String,
                                    acris As Boolean,
                                    taxBill As Boolean,
                                    EcbViolation As Boolean,
                                    waterBill As Boolean,
                                    zillow As Boolean,
                                    TLO As Boolean,
                                    orderBy As String) As APIOrder

        Dim apiOrder = NewOrder(bble)

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
        apiOrder.Orderby = orderBy

        Return apiOrder
    End Function

    Public Sub UpdateOrderStatus()
        Dim result As Boolean = (Not (Acris.HasValue AndAlso Acris = ItemStatus.Calling) And
                                         Not (ECBViolation.HasValue AndAlso ECBViolation = ItemStatus.Calling) And
                                              Not (TaxBill.HasValue AndAlso TaxBill = ItemStatus.Calling) And
                                              Not (WaterBill.HasValue AndAlso WaterBill = ItemStatus.Calling) And
                                              Not (Zillow.HasValue AndAlso Zillow = ItemStatus.Calling) And
                                              Not (LatestSale.HasValue AndAlso LatestSale = ItemStatus.Calling) And
                                              Not (TLO.HasValue AndAlso TLO = ItemStatus.Calling))

        If result Then
            Status = OrderStatus.Complete
        Else
            Status = OrderStatus.PartialComplete
        End If
    End Sub

    Public Shared Function UpdateOrderInfo(orderId As Integer, infoType As String, status As String) As Boolean
        Using context As New Entities
            Dim apiOrder = context.APIOrders.Where(Function(order) order.ApiOrderID = orderId).SingleOrDefault

            If apiOrder IsNot Nothing Then

                Select Case infoType
                    Case "AcrisMtgrs"
                        If status = "Task-Done" Then
                            apiOrder.Acris = APIOrder.ItemStatus.Complete
                        End If

                    Case "ECB_Violations", "DOBPenalty"
                        If status = "Task-Done" Then
                            apiOrder.ECBViolation = APIOrder.ItemStatus.Complete
                        End If

                    Case "PROP_TAX"
                        If status = "Task-Done" Then
                            apiOrder.TaxBill = APIOrder.ItemStatus.Complete
                        End If

                    Case "WATER_SEWER"
                        If status = "Task-Done" Then
                            apiOrder.WaterBill = APIOrder.ItemStatus.Complete
                        End If
                    Case "Zillow"
                        If status = "Task-Done" Then
                            apiOrder.Zillow = APIOrder.ItemStatus.Complete
                        End If
                    Case "ACRIS_LatestSale"
                        If status = "Done" Then
                            apiOrder.LatestSale = APIOrder.ItemStatus.Complete
                        End If
                    Case "TLO"
                        If status = "Done" OrElse status = "Error" Then
                            apiOrder.TLO = APIOrder.ItemStatus.Complete
                        End If
                End Select

                apiOrder.UpdateOrderStatus()

                context.SaveChanges()

                If apiOrder.Status = OrderStatus.Complete AndAlso status <> "Error" Then
                    Dim ld = LeadsInfo.GetInstance(apiOrder.BBLE)
                    If ld IsNot Nothing Then
                        UserMessage.AddNewMessage(apiOrder.Orderby, "Property Data is ready", String.Format("Property ({0}) Data is ready. Please check.", ld.LeadsName), apiOrder.BBLE, DateTime.Now, "Portal", Nothing)
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

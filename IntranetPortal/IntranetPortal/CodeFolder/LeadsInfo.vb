Public Class LeadsInfo
    Public Enum LeadsType
        DevelopmentOpportunity = 0
        Foreclosure = 1
        HasEquity = 2
        TaxLien = 3
    End Enum

    'Get assign leads type
    Public Function GetLeadsType(type As String) As LeadsType
        Dim retType = Nothing
        If [Enum].TryParse(Of LeadsType)(type.Replace(" ", ""), retType) Then
            Return retType
        End If

        Return Nothing
    End Function

    Public ReadOnly Property LisPens As List(Of PortalLisPen)
        Get
            Using context As New Entities
                Return context.PortalLisPens.Where(Function(li) li.BBLE = BBLE).ToList
            End Using
        End Get
    End Property

    Public ReadOnly Property OwnerPhoneNo As String
        Get
            Using context As New Entities
                Dim phones = context.OwnerContacts.Where(Function(hp) hp.BBLE = BBLE And hp.ContactType = OwnerContact.OwnerContactType.Phone And hp.Status = OwnerContact.ContactStatus.Right).Select(Function(hp) hp.Contact).ToArray

                If phones.Length > 0 Then
                    Return String.Join(",", phones)
                End If

            End Using
            Return ""
        End Get
    End Property

    Public Property HomeOwners As List(Of HomeOwner)
    Public ReadOnly Property LeadsName As String
        Get
            Return Utility.GetLeadsName(Me)
        End Get
    End Property

    'Leadsinfo status
    Public ReadOnly Property Status As String
        Get
            If Lead.Status.HasValue Then
                Return CType(Lead.Status.Value, LeadStatus).ToString
            End If

            Return ""
        End Get
    End Property

    'the finder name or agent name of this leadsinfo
    Public ReadOnly Property AgentName As String
        Get
            If Lead IsNot Nothing Then
                Return Lead.EmployeeName
            End If

            Return ""
        End Get
    End Property



    Public ReadOnly Property CallAttemps As Integer
        Get
            Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.CallOwner).Count
        End Get
    End Property

    Public ReadOnly Property DoorKnockAttemps As Integer
        Get
            Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.DoorKnock).Count
        End Get
    End Property

    Public ReadOnly Property FollowupAttemps As Integer
        Get
            Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.FollowUp).Count
        End Get
    End Property

    Public ReadOnly Property HasOwnerInfo As Boolean
        Get
            Using context As New Entities
                Return context.HomeOwners.Where(Function(ho) ho.BBLE = BBLE And ho.Active = True And ho.LocateReport IsNot Nothing And ho.Name = Owner).Count > 0
            End Using
        End Get
    End Property

    Public ReadOnly Property PropertyClassCode As String
        Get
            Using context As New Entities
                Dim bc = context.BuildingCodes.Find(PropertyClass)
                If bc IsNot Nothing Then
                    Return String.Format("{0}-{1}", bc.Code, bc.Description)
                End If

                Return PropertyClass
            End Using
        End Get
    End Property

    Public ReadOnly Property Neighborhood As String
        Get
            'Dim neighbor = ""
            ''If Not String.IsNullOrEmpty(PropertyAddress) Then
            ''    If PropertyAddress.Split(",").Count > 1 Then
            ''        neighbor = PropertyAddress.Split(",")(1)
            ''        Return neighbor
            ''    End If
            ''End If

            Return NeighName
        End Get
    End Property

    Public ReadOnly Property LastIssuedOn As String
        Get
            If CreateDate.HasValue Then
                Return String.Format("Last Issued On: {0:g}", CreateDate)
            Else
                Return ""
            End If
        End Get
    End Property

    Public ReadOnly Property IndicatorOfLiens As String
        Get
            If Me.C1stMotgrAmt = 0 Then
                Return ""
            End If

            Return "<span style=""color:red"">Liens higher than Value</span>"
        End Get
    End Property

    Public ReadOnly Property IndicatorOfWater As String
        Get
            If Me.WaterAmt = 0 Then
                Return ""
            End If

            Return "<span style=""color:red"">High Water Indicator</span>"
        End Get
    End Property

    Public ReadOnly Property IsUpdating As Boolean
        Get
            Using context As New Entities

                If context.APIOrders.Where(Function(order) order.BBLE = BBLE And order.Status <> APIOrder.OrderStatus.Complete).Count > 0 Then
                    Return True
                Else
                    Return False
                End If
            End Using
        End Get
    End Property

    Public ReadOnly Property UpdateInfo As String
        Get
            Using context As New Entities

                If context.APIOrders.Where(Function(order) order.BBLE = BBLE And order.Status <> APIOrder.OrderStatus.Complete).Count > 0 Then
                    Return "<span style=""color:red"">Lead is waiting to update. It will complete in few minuties.</span>"
                Else
                    If LastUpdate Is Nothing Then
                        Return ""
                    Else
                        Return String.Format("Last Update: {0:g}", Me.LastUpdate.Value)
                    End If
                End If
            End Using
        End Get
    End Property

    Public Shared Function GetInstance(bble As String) As LeadsInfo
        Using context As New Entities
            Return context.LeadsInfoes.Where(Function(b) b.BBLE = bble).SingleOrDefault
        End Using
    End Function

    Public ReadOnly Property Violation As String
        Get
            If ECBViolationsAmt.HasValue AndAlso ECBViolationsAmt.Value > 0 Then
                Return "ECB"
            End If

            If DOBViolationsAmt.HasValue AndAlso DOBViolationsAmt.Value > 0 Then
                Return "DOB"
            End If

            Return ""
        End Get
    End Property

    Public ReadOnly Property ViolationAmount As Double
        Get
            If ECBViolationsAmt.HasValue AndAlso ECBViolationsAmt.Value > 0 Then
                Return ECBViolationsAmt.Value
            End If

            If DOBViolationsAmt.HasValue AndAlso DOBViolationsAmt.Value > 0 Then
                Return DOBViolationsAmt.Value
            End If

            Return Nothing
        End Get
    End Property
End Class

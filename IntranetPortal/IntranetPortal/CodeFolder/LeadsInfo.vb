Public Class LeadsInfo
    Public Enum LeadsType
        DevelopmentOpportunity = 0
        Foreclosure = 1
        HasEquity = 2
        TaxLien = 3
        VacantLand = 4
        WaterLien = 5
        UnbuiltProperty = 6
        VacantHouse = 7
        StalledProject = 8
        AEP = 9
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

    Public ReadOnly Property UserComments As List(Of LeadsComment)
        Get
            Using context As New Entities
                Return context.LeadsComments.Where(Function(li) li.BBLE = BBLE).OrderBy(Function(li) li.OrderIndex).ToList
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

    Public ReadOnly Property ReferrelName As String
        Get
            Return Referrel.ReferrelName
        End Get
    End Property

    Private _referrel As PropertyReferrel
    Public ReadOnly Property Referrel As PropertyReferrel
        Get
            If _referrel Is Nothing Then
                Using context As New Entities
                    Dim tmpRef = context.PropertyReferrels.Find(BBLE)

                    If tmpRef Is Nothing Then
                        _referrel = New PropertyReferrel

                        If Lead IsNot Nothing Then
                            _referrel.ReferrelName = Lead.AssignBy
                        End If
                    Else
                        _referrel = tmpRef
                    End If
                End Using
            End If

            Return _referrel
        End Get
    End Property

    Private _mortgageData As LeadsMortgageData
    Public ReadOnly Property MortgageData As LeadsMortgageData
        Get
            If _mortgageData Is Nothing Then
                Using context As New Entities
                    Dim tmpMort = context.LeadsMortgageDatas.Find(BBLE)

                    If tmpMort IsNot Nothing Then
                        _mortgageData = tmpMort
                    Else
                        _mortgageData = New LeadsMortgageData
                    End If
                End Using
            End If

            Return _mortgageData
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
            Using context As New Entities
                Return context.LeadsActivityLogs.Where(Function(log) log.BBLE = BBLE And (log.ActionType.HasValue AndAlso log.ActionType = 0)).Count
            End Using

            'Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType.HasValue AndAlso log.ActionType = LeadsActivityLog.EnumActionType.CallOwner).Count
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
            Return NeighName
        End Get
    End Property

    Public ReadOnly Property LastUpdate2 As DateTime
        Get
            Return Lead.LastUpdate2
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

    Public ReadOnly Property TotalDebt As Double
        Get
            Dim debt = 0

            If C1stMotgrAmt.HasValue Then
                debt += C1stMotgrAmt
            End If

            If C2ndMotgrAmt.HasValue Then
                debt += C2ndMotgrAmt
            End If

            If TaxesAmt.HasValue Then
                debt += TaxesAmt
            End If

            If WaterAmt.HasValue Then
                debt += WaterAmt
            End If

            Return debt
        End Get
    End Property

    Public ReadOnly Property IsHighLiens As Boolean
        Get
            If EstValue.HasValue And EstValue > 0 Then
                Return TotalDebt > EstValue
            Else
                Return False
            End If
        End Get
    End Property

    'Public ReadOnly Property IndicatorOfLiens As String
    '    Get
    '        If Me.C1stMotgrAmt.HasValue AndAlso C1stMotgrAmt > 0 Then
    '            Return "HasLiens"
    '        End If

    '        Return ""
    '    End Get
    'End Property

    Public ReadOnly Property IndicatorOfWater As String
        Get
            If Me.WaterAmt.HasValue AndAlso WaterAmt > 1000 Then
                Return "HasWaterLiens"
            End If

            Return ""
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

    Public ReadOnly Property OtherProperties As List(Of LeadsInfo)
        Get
            Using context As New Entities
                If Not String.IsNullOrEmpty(Owner) Then
                    Return context.LeadsInfoes.Where(Function(li) (li.Owner = Owner) And li.BBLE <> BBLE).ToList
                End If

                Return Nothing
            End Using
        End Get
    End Property

    Public Shared Function GetInstance(bble As String) As LeadsInfo
        Using context As New Entities
            Return context.LeadsInfoes.Where(Function(b) b.BBLE = bble).SingleOrDefault
        End Using
    End Function

    Public Sub AddComments(comments As String, userName As String)
        Using Context As New Entities
            Dim lc As New LeadsComment
            lc.Comments = comments
            lc.CreateBy = userName
            lc.CreateTime = DateTime.Now
            lc.BBLE = BBLE

            Context.LeadsComments.Add(lc)
            Context.SaveChanges()
        End Using
    End Sub

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

    Public Shared Sub AddIndicator(name As String, li As LeadsInfo)
        Indicators.Where(Function(indi) indi.Name = name).FirstOrDefault.AddIndicator(li)
    End Sub

    Public Shared ReadOnly Property Indicators As List(Of Indicator)
        Get
            Dim str As New List(Of Indicator)
            str.Add(New Indicator("Mortgage", "Liens higher than Value", Function(li)
                                                                             Return li.IsHighLiens
                                                                         End Function))

            str.Add(New Indicator("Water", "Water Lien is High - Possible Tenant Issues", Function(li)
                                                                                              If li.WaterAmt.HasValue AndAlso li.WaterAmt > 1000 Then
                                                                                                  Return True
                                                                                              End If

                                                                                              Return False
                                                                                          End Function))
            str.Add(New Indicator("LeadsType", "Leads type: ", Function(li)
                                                                   If li.Type.HasValue Then
                                                                       Return True
                                                                   End If

                                                                   Return False
                                                               End Function))

            str.Add(New Indicator("UnderBuilt", "The hourse has more underbuilt", Function(li)
                                                                                      If li.UnbuiltSqft.HasValue And li.NYCSqft.HasValue Then
                                                                                          Return li.UnbuiltSqft / li.NYCSqft >= 0.5
                                                                                      End If

                                                                                      Return False
                                                                                  End Function))

            Return str
        End Get
    End Property

    Public Class Indicator
        Public Property Name As String
        Public Property Message As String
        Public Property Formular As IndicatorFormular

        Public Delegate Function IndicatorFormular(li As LeadsInfo) As Boolean

        Public Sub New(indicatorName As String, indicatorMessage As String, visible As IndicatorFormular)
            Name = indicatorName
            Message = indicatorMessage
            Formular = visible
        End Sub

        Public Sub AddIndicator(leadsData As LeadsInfo)
            If Formular(leadsData) Then
                If leadsData.UserComments.Where(Function(um) um.Comments = Message And um.BBLE = leadsData.BBLE).Count = 0 Then
                    leadsData.AddComments(Message, HttpContext.Current.User.Identity.Name)
                End If
            End If
        End Sub
    End Class

End Class

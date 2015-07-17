Partial Public Class PropertyMortgage

    Private _shortSaleDeptContact As PartyContact
    Public Property ShortSaleDeptContact As PartyContact
        Get
            If ShortSaleDept.HasValue Then
                _shortSaleDeptContact = PartyContact.GetContact(ShortSaleDept)
            End If

            Return _shortSaleDeptContact
        End Get
        Set(value As PartyContact)
            _shortSaleDeptContact = value
        End Set
    End Property

    Private _processorContact As PartyContact
    Public Property ProcessorContact As PartyContact
        Get
            If Processor.HasValue Then
                _processorContact = PartyContact.GetContact(Processor)
            End If

            Return _processorContact
        End Get
        Set(value As PartyContact)
            _processorContact = value
        End Set
    End Property

    Private _negotiatorContact As PartyContact
    Public Property NegotiatorContact As PartyContact
        Get
            If Negotiator.HasValue Then
                _negotiatorContact = PartyContact.GetContact(Negotiator)
            End If

            Return _negotiatorContact
        End Get
        Set(value As PartyContact)
            _negotiatorContact = value
        End Set
    End Property

    Private _supervisorContact As PartyContact
    Public Property SupervisorContact As PartyContact
        Get
            If Supervisor.HasValue Then
                _supervisorContact = PartyContact.GetContact(Supervisor)
            End If

            Return _supervisorContact
        End Get
        Set(value As PartyContact)
            _supervisorContact = value
        End Set
    End Property

    Private _closerContact As PartyContact
    Public Property CloserContact As PartyContact
        Get
            If Closer.HasValue Then
                _closerContact = PartyContact.GetContact(Closer)
            End If

            Return _closerContact
        End Get
        Set(value As PartyContact)
            _closerContact = value
        End Set
    End Property

    Private _lenderContact As PartyContact

    Public Property LenderContact As PartyContact
        Get
            If (LenderContactId.HasValue) Then
                _lenderContact = PartyContact.GetContact(LenderContactId)
            End If
            Return _lenderContact
        End Get
        Set(value As PartyContact)
            _lenderContact = value
        End Set
    End Property

    Private _lenderAttorneyContact As PartyContact
    Public Property LeaderAttorneyContact As PartyContact
        Get
            If LenderAttorney.HasValue Then
                _lenderAttorneyContact = PartyContact.GetContact(LenderAttorney)
            End If

            Return _lenderAttorneyContact
        End Get
        Set(value As PartyContact)
            _lenderAttorneyContact = value
        End Set
    End Property

    Public Shared ReadOnly Property StatusCategory As String()
        Get
            Return StatusData.Select(Function(s) s.Category).Where(Function(s) Not String.IsNullOrEmpty(s)).Distinct.OrderBy(Function(s) s).ToArray
        End Get
    End Property

    Public Shared _statusData As List(Of MortgageStatusData)
    Public Shared ReadOnly Property StatusData As List(Of MortgageStatusData)
        Get
            If _statusData Is Nothing Then
                _statusData = LoadStatusData()
            End If

            Return _statusData
        End Get
    End Property

    Public Shared Sub RefreshMortgageStatusData()
        If _statusData IsNot Nothing Then
            _statusData = LoadStatusData()
        End If
    End Sub

    Private Shared Function LoadStatusData() As List(Of MortgageStatusData)
        Using ctx As New ShortSaleEntities
            Return ctx.MortgageStatusDatas.Where(Function(a) a.Category IsNot Nothing).ToList
        End Using
    End Function


    Public Property DataStatus As ModelStatus

    Public Shared Function GetMortgage(caseId As Integer, loanNum As String) As PropertyMortgage
        Using ctx As New ShortSaleEntities
            Dim mort = ctx.PropertyMortgages.Where(Function(mt) mt.CaseId = caseId And mt.Loan = loanNum).FirstOrDefault

            If mort Is Nothing Then
                mort = New PropertyMortgage
            End If

            Return mort
        End Using
    End Function

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = context.PropertyMortgages.Find(MortgageId)

            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                If DataStatus = ModelStatus.Deleted Then
                    context.PropertyMortgages.Remove(pbi)
                Else
                    pbi = ShortSaleUtility.SaveChangesObj(pbi, Me)
                End If
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class

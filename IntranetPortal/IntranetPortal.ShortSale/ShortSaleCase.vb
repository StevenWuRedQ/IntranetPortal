Partial Public Class ShortSaleCase

    Public Sub New(propBaseinfo As PropertyBaseInfo)
        _propInfo = propBaseinfo
    End Sub

    Public Sub New()

    End Sub

    Private _propInfo As PropertyBaseInfo
    Public ReadOnly Property PropertyInfo As PropertyBaseInfo
        Get
            If _propInfo Is Nothing Then
                _propInfo = PropertyBaseInfo.GetInstance(BBLE)

                If _propInfo Is Nothing Then
                    _propInfo = New PropertyBaseInfo
                End If

            End If

            Return _propInfo
        End Get
        'Set(value As PropertyBaseInfo)
        '    _propInfo = value
        'End Set
    End Property

    Private _mortgages As List(Of PropertyMortgage)
    Public ReadOnly Property Mortgages As List(Of PropertyMortgage)
        Get
            If _mortgages Is Nothing Then
                Using context As New ShortSaleEntities
                    _mortgages = context.PropertyMortgages.Where(Function(mg) mg.CaseId = CaseId).ToList
                End Using
            End If

            Return _mortgages
        End Get
    End Property

    Private _sellerTitle As PropertyTitle
    Public ReadOnly Property SellerTitle As PropertyTitle
        Get
            If _sellerTitle Is Nothing Then
                _sellerTitle = PropertyTitle.GetTitle(CaseId, PropertyTitle.TitleType.Seller)
            End If

            Return _sellerTitle
        End Get
    End Property

    Private _buyerTitle As PropertyTitle
    Public ReadOnly Property BuyerTitle As PropertyTitle
        Get
            If _buyerTitle Is Nothing Then
                _buyerTitle = PropertyTitle.GetTitle(CaseId, PropertyTitle.TitleType.Buyer)
            End If

            Return _buyerTitle
        End Get
    End Property

    Private _clearences As List(Of TitleClearence)
    Public ReadOnly Property Clearences As List(Of TitleClearence)
        Get
            Return TitleClearence.GetCaseClearences(CaseId)
        End Get
    End Property

    Private _processorContact As PartyContact
    Public ReadOnly Property ProcessorContact As PartyContact
        Get
            If _processorContact Is Nothing AndAlso Processor.HasValue Then
                _processorContact = PartyContact.GetContact(Processor)
            End If

            Return _processorContact
        End Get
    End Property

    Private _comments As List(Of ShortSaleCaseComment)
    Public ReadOnly Property Comments As List(Of ShortSaleCaseComment)
        Get
            If _comments Is Nothing Then
                _comments = ShortSaleCaseComment.GetCaseComments(CaseId)
            End If

            Return _comments
        End Get
    End Property

    Public Sub Save()
        Using context As New ShortSaleEntities
            If CaseId = 0 Then
                If Not String.IsNullOrEmpty(BBLE) Then
                    Dim tmpCase = context.ShortSaleCases.Where(Function(ss) ss.BBLE = BBLE).FirstOrDefault
                    If tmpCase IsNot Nothing Then
                        CaseId = tmpCase.CaseId
                    End If
                End If
            End If

            If CaseId = 0 Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.ShortSaleCases.Find(CaseId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
                context.SaveChanges()
            End If

            context.SaveChanges()

            If _mortgages IsNot Nothing Then
                For Each mg In _mortgages
                    If mg.CaseId = 0 Then
                        mg.CaseId = CaseId
                    End If

                    mg.Save()
                Next
            End If

            If _propInfo IsNot Nothing Then
                _propInfo.Save()
            End If
        End Using
    End Sub

    Public Sub SaveStatus(status As CaseStatus)
        Me.Status = status
        Save()
    End Sub

    Public Sub SaveChanges()
        Save()
        'If CaseId > 0 Then
        '    Using context As New ShortSaleEntities
        '        Dim origCase = context.ShortSaleCases.Find(CaseId)
        '        origCase = Utility.SaveChangesObj(origCase, Me)
        '        context.SaveChanges()
        '    End Using
        'End If
    End Sub

    Public Shared Function SaveCase(ssCase As ShortSaleCase) As Boolean
        Try
            ssCase.Save()
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Shared Function DeleteCase(caseId As Integer) As Boolean
        Return True
    End Function

    Public Shared Function GetCase(caseId As Integer) As ShortSaleCase
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Find(caseId)
        End Using
    End Function

    Public Shared Function GetAllCase() As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.ToList
        End Using
    End Function

    Public Shared Function GetCaseByStatus(status As CaseStatus) As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Where(Function(ss) ss.Status = status).ToList
        End Using
    End Function

    Public Shared Function GetCaseCount(status As CaseStatus)
        Return GetCaseByStatus(status).Count
    End Function
End Class

Public Enum CaseStatus
    NewFile = 0
    FollowUp = 1
    Active = 2
    Eviction = 3
    OnHold = 4
    Closed = 5
End Enum

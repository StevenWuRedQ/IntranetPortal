Partial Public Class ShortSaleCase

    Public Sub New(propBaseinfo As PropertyBaseInfo)
        _propInfo = propBaseinfo
    End Sub

    Public Sub New()

    End Sub

    Private _propInfo As PropertyBaseInfo
    Public Property PropertyInfo As PropertyBaseInfo
        Get
            If _propInfo Is Nothing Then
                _propInfo = PropertyBaseInfo.GetInstance(BBLE)
            End If

            Return _propInfo
        End Get
        Set(value As PropertyBaseInfo)
            _propInfo = value
        End Set
    End Property

    Private _mortgages As List(Of PropertyMortgage)
    Public Property Mortgages As List(Of PropertyMortgage)
        Get
            If _mortgages Is Nothing Then
                Using context As New ShortSaleEntities
                    Return context.PropertyMortgages.Where(Function(mg) mg.CaseId = CaseId).ToList
                End Using
            End If

            Return _mortgages
        End Get
        Set(value As List(Of PropertyMortgage))
            _mortgages = value
        End Set
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

    Public Sub Save()
        Using context As New ShortSaleEntities
            'context.ShortSaleCases.Attach(Me)
            If CaseId = 0 Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.ShortSaleCases.Find(CaseId)
                obj = Utility.SaveChangesObj(obj, Me)
                context.SaveChanges()
            End If

            context.SaveChanges()

            If _mortgages IsNot Nothing Then
                For Each mg In _mortgages
                    mg.Save()
                Next
            End If

            If _propInfo IsNot Nothing Then
                _propInfo.Save()
            End If
        End Using
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
End Class

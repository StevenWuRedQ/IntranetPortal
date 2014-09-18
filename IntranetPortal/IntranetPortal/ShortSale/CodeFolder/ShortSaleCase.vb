Partial Public Class ShortSaleCase

    Private _propInfo As PropertyInfo
    Public ReadOnly Property PropertyInfo As PropertyInfo
        Get
            If _propInfo Is Nothing Then
                _propInfo = New PropertyInfo
            End If

            Return _propInfo
        End Get
    End Property

    Public Sub Save()
        Using context As New Entities
            'context.ShortSaleCases.Attach(Me)
            context.Entry(Me).State = Entity.EntityState.Modified
            context.SaveChanges()
        End Using
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
        Using context As New Entities
            Return context.ShortSaleCases.Find(caseId)
        End Using
    End Function

    Public Shared Function GetAllCase() As List(Of ShortSaleCase)
        Using context As New Entities
            Return context.ShortSaleCases.ToList
        End Using
    End Function
End Class

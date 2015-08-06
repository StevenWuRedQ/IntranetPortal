Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(LawReferenceMetadata))>
Partial Public Class LawReference

    Public Shared Function GetReference(RefId As Integer) As LawReference
        Using ctx As New LegalModelContainer
            Return ctx.LawReferences.Find(RefId)
        End Using
    End Function

    Public Shared Function GetAllReference() As List(Of LawReference)
        Using ctx As New LegalModelContainer
            Return ctx.LawReferences.ToList
        End Using
    End Function

    Public Sub Delete()
        Using ctx As New LegalModelContainer
            Dim lRef = ctx.LawReferences.Find(RefId)
            ctx.LawReferences.Remove(lRef)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Save()
        Using ctx As New LegalModelContainer
            If RefId = 0 Then
                Me.CreateTime = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Added
            Else
                'Dim lRef = ctx.LawReferences.Find(RefId)
                'If lRef IsNot Nothing Then
                '    lRef = Core.Utility.SaveChangesObj(lRef, Me)
                'End If
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If

            ctx.SaveChanges()
        End Using

    End Sub
End Class

Public Class LawReferenceMetadata
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsArrayToStringConverter))>
    Public Property Notes As String

End Class

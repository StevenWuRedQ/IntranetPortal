
Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(ConstructionInitialFormMetaData))>
Partial Public Class ConstructionInitialForm

    Public Shared Function GetForms(BBLE As String) As ConstructionInitialForm
        Using ctx As New ConstructionEntities
            Return ctx.ConstructionInitialForms.Where(Function(F) F.BBLE = BBLE).FirstOrDefault
        End Using
    End Function

    Public Sub SaveForms(userName As String)
        Using ctx As New ConstructionEntities
            If ctx.ConstructionInitialForms.Any(Function(t) t.BBLE = BBLE) Then
                Me.UpdateDate = DateTime.Now
                Me.UpdateBy = userName
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = userName
                Me.CreateDate = DateTime.Now
                ctx.ConstructionInitialForms.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub


End Class

Public Class ConstructionInitialFormMetaData

    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property Form As String

End Class
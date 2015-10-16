﻿Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(ConstructionBudgetMetaData))>
Partial Public Class ConstructionBudget
    Public Shared Function GetForms(BBLE As String) As ConstructionBudget
        Using ctx As New ConstructionEntities
            Return ctx.ConstructionBudgets.Where(Function(B) B.BBLE = BBLE).FirstOrDefault
        End Using
    End Function

    Public Sub SaveForms(userName As String)
        Using ctx As New ConstructionEntities
            If ctx.ConstructionBudgets.Any(Function(t) t.BBLE = BBLE) Then
                Me.UpdateDate = DateTime.Now
                Me.UpdateBy = userName
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = userName
                Me.CreateDate = DateTime.Now
                ctx.ConstructionBudgets.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub
End Class


Public Class ConstructionBudgetMetaData

    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property Form As String

End Class
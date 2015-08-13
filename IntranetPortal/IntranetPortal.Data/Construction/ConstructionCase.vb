Imports System.ComponentModel.DataAnnotations
Imports System.Data.Entity.Infrastructure

<MetadataType(GetType(ConstructionCaseMetaData))>
Partial Public Class ConstructionCase

    Private Const LogTitleOpen As String = "ConstructionOpen"
    Private Const LogTitleSave As String = "ConstructionSave"

    Public Shared Function GetAllCases() As ConstructionCase()
        Using ctx As New ConstructionEntities
            Return ctx.ConstructionCases.ToArray
        End Using
    End Function

    Public Shared Function GetAllCases(userName As String) As ConstructionCase()
        Using ctx As New ConstructionEntities
            Return ctx.ConstructionCases.Where(Function(c) c.Owner = userName).ToArray
        End Using
    End Function

    Public Shared Function GetCase(BBLE As String) As ConstructionCase
        Using ctx As New ConstructionEntities
            Return ctx.ConstructionCases.Find(BBLE)
        End Using
    End Function

    Public Shared Function GetCase(BBLE As String, userName As String) As ConstructionCase
        Using ctx As New ConstructionEntities
            Dim csCase = ctx.ConstructionCases.Find(BBLE)

            If csCase IsNot Nothing Then
                Core.SystemLog.Log(LogTitleOpen, Nothing, Core.SystemLog.LogCategory.Operation, BBLE, userName)
                Return csCase
            End If
        End Using

        Return Nothing
    End Function


    Public Sub Delete()
        Using ctx As New ConstructionEntities
            ctx.Entry(Me).State = Entity.EntityState.Deleted
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Save(userName As String)
        Using db As New ConstructionEntities
            If db.ConstructionCases.Any(Function(c) c.BBLE = BBLE) Then
                Me.UpdateBy = userName
                Me.LastUpdate = DateTime.Now
                db.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = userName
                Me.CreateTime = DateTime.Now
                db.ConstructionCases.Add(Me)
            End If

            Try
                db.SaveChanges()
                Core.SystemLog.Log(LogTitleSave, Newtonsoft.Json.JsonConvert.SerializeObject(Me), Core.SystemLog.LogCategory.SaveData, BBLE, userName)
            Catch ex As Exception
                Throw
            End Try
        End Using
    End Sub

    Public Shared Function Exists(bble As String) As Boolean
        Using ctx As New ConstructionEntities
            Return ctx.ConstructionCases.Any(Function(c) c.BBLE = bble)
        End Using
    End Function
End Class


Public Class ConstructionCaseMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property CSCase As String
End Class
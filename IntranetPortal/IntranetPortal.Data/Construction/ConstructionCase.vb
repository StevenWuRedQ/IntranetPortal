Imports System.ComponentModel
Imports System.ComponentModel.DataAnnotations
Imports System.Data.Entity.Infrastructure

''' <summary>
''' Construction case object
''' </summary>
<MetadataType(GetType(ConstructionCaseMetaData))>
Partial Public Class ConstructionCase

    Private Const LogTitleOpen As String = "ConstructionOpen"
    Private Const LogTitleSave As String = "ConstructionSave"

    Public ReadOnly Property StatusStr As String
        Get
            If Status.HasValue Then
                Return CType(Status, CaseStatus).ToString
            End If

            Return CaseStatus.Intake.ToString
        End Get
    End Property

    Public Shared Function GetAllCasesByStatus(Optional status1 As CaseStatus = CaseStatus.All) As ConstructionCase()
        Using ctx As New PortalEntities
            Return ctx.ConstructionCases.Where(Function(c) c.Status = status1 Or status1 = CaseStatus.All).ToArray
        End Using
    End Function

    Public Shared Function GetAllCases() As ConstructionCase()
        Using ctx As New PortalEntities
            Return ctx.ConstructionCases.ToArray()
        End Using
    End Function

    Public Shared Function GetAllCases(userName As String, Optional status1 As CaseStatus = CaseStatus.All) As ConstructionCase()
        Using ctx As New PortalEntities
            Return ctx.ConstructionCases.Where(Function(c) c.Owner = userName Or (c.Status = status1 Or status1 = CaseStatus.All)).ToArray
        End Using
    End Function

    Public Shared Function GetLightCasesByStatus(Optional status1 As CaseStatus = CaseStatus.All) As ConstructionCase()
        Using ctx As New PortalEntities
            Dim result = (From cCase In ctx.ConstructionCases.Where(Function(c) c.Status = status1 Or status1 = CaseStatus.All)
                          Select cCase.BBLE, cCase.Status, cCase.CaseName, cCase.CreateBy, cCase.CreateTime, cCase.LastUpdate, cCase.Owner, cCase.UpdateBy, cCase.IntakeCompleted)

            Return result.AsEnumerable.Select(Function(cCase)
                                                  Return New ConstructionCase With {
                                                             .BBLE = cCase.BBLE,
                                                             .CaseName = cCase.CaseName,
                                                             .CreateBy = cCase.CreateBy,
                                                             .CreateTime = cCase.CreateTime,
                                                             .LastUpdate = cCase.LastUpdate,
                                                             .Owner = cCase.Owner,
                                                             .UpdateBy = cCase.UpdateBy,
                                                             .IntakeCompleted = cCase.IntakeCompleted
                                                             }
                                              End Function).ToArray
        End Using
    End Function

    Public Shared Function GetLightCases(userName As String, Optional status1 As CaseStatus = CaseStatus.All) As ConstructionCase()
        Using ctx As New PortalEntities
            Dim result = From cCase In ctx.ConstructionCases.Where(Function(c) c.Owner = userName Or (c.Status = status1 Or status1 = CaseStatus.All))
                         Select cCase.BBLE, cCase.Status, cCase.CaseName, cCase.CreateBy, cCase.CreateTime, cCase.LastUpdate, cCase.Owner, cCase.UpdateBy, cCase.IntakeCompleted

            Return result.AsEnumerable.Select(Function(cCase)
                                                  Return New ConstructionCase With {
                                                             .BBLE = cCase.BBLE,
                                                             .CaseName = cCase.CaseName,
                                                             .CreateBy = cCase.CreateBy,
                                                             .CreateTime = cCase.CreateTime,
                                                             .LastUpdate = cCase.LastUpdate,
                                                             .Owner = cCase.Owner,
                                                             .UpdateBy = cCase.UpdateBy,
                                                             .IntakeCompleted = cCase.IntakeCompleted
                                                             }
                                              End Function).ToArray
        End Using
    End Function

    Public Shared Function GetCase(BBLE As String) As ConstructionCase
        Using ctx As New PortalEntities
            Return ctx.ConstructionCases.Find(BBLE)
        End Using
    End Function

    Public Shared Function GetCase(BBLE As String, userName As String) As ConstructionCase
        Using ctx As New PortalEntities
            Dim csCase = ctx.ConstructionCases.Find(BBLE)

            If csCase IsNot Nothing Then
                Core.SystemLog.Log(LogTitleOpen, Nothing, Core.SystemLog.LogCategory.Operation, BBLE, userName)
                Return csCase
            End If
        End Using

        Return Nothing
    End Function

    Public Shared Sub UpdateOwner(BBLE As String, Owner As String)
        Using ctx As New PortalEntities
            Dim CCase = ctx.ConstructionCases.Find(BBLE)
            If (CCase.Owner <> Owner) Then
                CCase.Owner = Owner
            End If
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Delete()
        Using ctx As New PortalEntities
            ctx.Entry(Me).State = Entity.EntityState.Deleted
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub UpdateStatus(status As CaseStatus, updateBy As String)
        If Me.Status <> status Or Not Me.Status.HasValue Then
            Me.Status = status
            Me.Save(updateBy)
        End If
    End Sub

    Public Sub Save(userName As String)

        Using db As New PortalEntities
            If db.ConstructionCases.Any(Function(c) c.BBLE = BBLE) Then
                Me.UpdateBy = userName
                Me.LastUpdate = DateTime.Now
                db.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = userName
                Me.CreateTime = DateTime.Now
                db.ConstructionCases.Add(Me)
            End If

            If Not Me.CSCase Is Nothing Then
                Dim violation = New ConstructionViolation
                violation.Save(Me, userName)
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
        Using ctx As New PortalEntities
            Return ctx.ConstructionCases.Any(Function(c) c.BBLE = bble)
        End Using
    End Function

    Public Enum CaseStatus
        <Description("All Case")>
        All = -1
        <Description("Intake")>
        Intake = 0
        <Description("Construction")>
        Construction = 1
        <Description("Completed")>
        Completed = 2
    End Enum
End Class


Public Class ConstructionCaseMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property CSCase As String
End Class
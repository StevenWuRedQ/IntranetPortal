﻿Public Class DataLoopRule
    Public Shared Function GetAllActiveRule() As List(Of DataLoopRule)
        Using ctx As New CoreEntities
            Return ctx.DataLoopRules.Where(Function(dl) dl.Status Is Nothing Or dl.Status <> RuleStatus.Completed).ToList
        End Using
    End Function

    Public Shared Function GetRefreshRule() As List(Of DataLoopRule)
        Return Nothing
    End Function

    Public Shared Sub AddRules(bblesToLoop As String(), loopType As DataLoopType, createBy As String)
        AddRules(bblesToLoop, loopType, createBy, RuleStatus.Active)
    End Sub

    Public Shared Sub AddRefreshRule(BBLE As String, loopType As DataLoopType, createBy As String)
        AddRules(New String() {BBLE}, loopType, createBy, RuleStatus.Refresh)
    End Sub

    Public Shared Function IsInUpdate(bble As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.DataLoopRules.Any(Function(r) r.BBLE = bble And (r.Status = RuleStatus.Active Or r.Status = RuleStatus.Running))
        End Using
    End Function

    Public Shared Sub AddRules(bble As String, loopType As DataLoopType, createby As String)
        AddRules(New String() {bble}, loopType, createby)
    End Sub

    Public Shared Sub AddRules(bblesToLoop As String(), loopType As DataLoopType, createBy As String, ruleStatus As RuleStatus)
        Using ctx As New CoreEntities
            For Each tmpBBLE In bblesToLoop
                Dim rule As New DataLoopRule
                rule.BBLE = tmpBBLE
                rule.LoopType = loopType
                rule.CreateBy = createBy
                rule.CreateDate = DateTime.Now
                rule.Status = ruleStatus
                ctx.DataLoopRules.Add(rule)
            Next

            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Complete()
        Using ctx As New CoreEntities
            Dim rule = ctx.DataLoopRules.Find(Id)
            rule.Status = RuleStatus.Completed
            rule.FinishDate = DateTime.Now
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub InProcess()
        Using ctx As New CoreEntities
            Dim rule = ctx.DataLoopRules.Find(Id)
            rule.Status = RuleStatus.Running
            rule.FinishDate = DateTime.Now
            ctx.SaveChanges()
        End Using
    End Sub

    Enum RuleStatus
        Active = 0
        Running = 1
        Completed = 2
        Refresh = 3
    End Enum

    Enum DataLoopType
        All = 0
        Mortgage = 1
        Servicer = 2
        HomeOwner = 3
        GeneralData = 4
    End Enum
End Class

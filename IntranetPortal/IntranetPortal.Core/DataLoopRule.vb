Public Class DataLoopRule
    Public Shared Function GetAllActiveRule() As List(Of DataLoopRule)
        Using ctx As New CoreEntities
            Return ctx.DataLoopRules.Where(Function(dl) dl.Status Is Nothing Or dl.Status <> RuleStatus.Completed).ToList
        End Using
    End Function

    Public Shared Sub AddRules(bblesToLoop As String(), loopType As DataLoopType, createBy As String)
        Using ctx As New CoreEntities
            For Each tmpBBLE In bblesToLoop
                Dim rule As New DataLoopRule
                rule.BBLE = tmpBBLE
                rule.LoopType = loopType
                rule.CreateBy = createBy
                rule.CreateDate = DateTime.Now
                rule.Status = RuleStatus.Active
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
    End Enum

    Enum DataLoopType
        All = 0
        Mortgage = 1
        Servicer = 2
        HomeOwner = 3
        GeneralData = 4
    End Enum
End Class

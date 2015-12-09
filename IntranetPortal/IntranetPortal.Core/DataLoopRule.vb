Public Class DataLoopRule
    Public Shared Function GetAllActiveRule() As List(Of DataLoopRule)
        Using ctx As New CoreEntities
            Return ctx.DataLoopRules.Where(Function(dl) dl.Status Is Nothing Or dl.Status = RuleStatus.Active Or dl.Status = RuleStatus.Running Or dl.Status = RuleStatus.Refresh).ToList
        End Using
    End Function

    Public Shared Function GetRefreshRule() As List(Of DataLoopRule)
        Return Nothing
    End Function

    Public Shared Sub AddRulesUnique(bblesToLoop As String(), loopType As DataLoopType, createBy As String)
        Using context As New CoreEntities
            Dim bbleRuningList = context.DataLoopRules.Where(Function(r) r.Status = 0 AndAlso bblesToLoop.Contains(r.BBLE)).Select(Function(r) r.BBLE).ToArray
            Dim uniqueBBles = bblesToLoop.ToList.Where(Function(b) Not bbleRuningList.Contains(b)).ToArray()
            AddRules(uniqueBBles, loopType, createBy, RuleStatus.Active)
        End Using
    End Sub

    Public Shared Sub AddRules(bblesToLoop As String(), loopType As DataLoopType, createBy As String)
        AddRules(bblesToLoop, loopType, createBy, RuleStatus.Active)
    End Sub

    Public Shared Sub AddRefreshRule(BBLE As String, loopType As DataLoopType, createBy As String)
        AddRules(New String() {BBLE}, loopType, createBy, RuleStatus.Refresh)
    End Sub

    Public Shared Function IsInUpdate(bble As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.DataLoopRules.Any(Function(r) r.BBLE = bble And (r.Status = RuleStatus.Active Or r.Status = RuleStatus.Running Or r.Status = RuleStatus.Pending))
        End Using
    End Function

    Public Shared Sub AddRules(bble As String, loopType As DataLoopType, createby As String)
        AddRules(New String() {bble}, loopType, createby)
    End Sub

    Public Shared Sub AddRules(bblesToLoop As String(), loopType As DataLoopType, createBy As String, ruleStatus As RuleStatus)
        Using ctx As New CoreEntities
            For Each tmpBBLE In bblesToLoop
                Dim rule = ctx.DataLoopRules.Where(Function(r) r.BBLE = tmpBBLE AndAlso r.Status = ruleStatus).FirstOrDefault
                If rule Is Nothing Then
                    rule = New DataLoopRule
                    rule.BBLE = tmpBBLE
                    rule.LoopType = loopType
                    rule.CreateBy = createBy
                    rule.CreateDate = DateTime.Now
                    rule.Status = ruleStatus

                    If ctx.DataLoopRules.Local.Where(Function(r) r.BBLE = tmpBBLE).Count = 0 Then
                        ctx.DataLoopRules.Add(rule)
                    End If
                End If
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

    Public Sub Complete(type As DataLoopType)
        Using ctx As New CoreEntities
            Dim rule = ctx.DataLoopRules.Find(Id)
            rule.LoopType = type
            'rule.FinishDate = DateTime.Now
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
        Pending = 4
    End Enum

    Enum DataLoopType
        All = 0
        AllHomeOwner = 5
        AllMortgage = 6
        Mortgage = 1
        Servicer = 2
        HomeOwner = 3
        GeneralData = 4
    End Enum
End Class

Public Class TaskEscalationRule
    Public Shared Sub Excute(t As UserTask)
        Dim rule = GetRule(t)
        If rule.IsDateDue(If(t.NotifyDate.HasValue, t.NotifyDate, t.CreateDate), Nothing) Then
            ServiceLog.Log("Execute Task Rule: " & t.BBLE & ", Task Id: " & t.TaskID)
            rule.Execute(t)
        End If
    End Sub

    Private Shared Function GetRule(t As UserTask) As EscalationRule
        Return TaskRules.Where(Function(r) r.Name = t.Important).FirstOrDefault
    End Function

    Private Shared Function TaskRules() As List(Of EscalationRule)
        Dim rules As New List(Of EscalationRule)
        rules.Add(New EscalationRule("Normal", "5.00:00:00", Sub(task)
                                                                 Dim tk = CType(task, UserTask)
                                                                 Using ctx As New Entities
                                                                     Dim tmpTask = ctx.UserTasks.Where(Function(obj) obj.TaskID = tk.TaskID).FirstOrDefault
                                                                     tmpTask.Important = "Important"
                                                                     tmpTask.NotifyDate = DateTime.Now
                                                                     ctx.SaveChanges()
                                                                 End Using
                                                             End Sub))

        rules.Add(New EscalationRule("Important", "3.00:00:00", Sub(task)
                                                                    Dim tk = CType(task, UserTask)
                                                                    Using ctx As New Entities
                                                                        Dim tmpTask = ctx.UserTasks.Where(Function(obj) obj.TaskID = tk.TaskID).FirstOrDefault
                                                                        tmpTask.Important = "Urgent"
                                                                        tmpTask.NotifyDate = DateTime.Now
                                                                        ctx.SaveChanges()
                                                                    End Using
                                                                End Sub))

        rules.Add(New EscalationRule("Urgent", "02:00:00", Sub(task)
                                                               Dim tk = CType(task, UserTask)
                                                               Using ctx As New Entities
                                                                   Dim tmpTask = ctx.UserTasks.Where(Function(obj) obj.TaskID = tk.TaskID).FirstOrDefault
                                                                   tmpTask.NotifyDate = DateTime.Now
                                                                   ctx.SaveChanges()
                                                               End Using
                                                           End Sub))

        Return rules
    End Function
End Class

Public Class EscalationRule
    Public Property Name As String
    Public Property StartDate As RuleStartDate
    Public Property EscalationAfter As TimeSpan
    Public Property Action As RuleAction
    Public Property Sequence As Integer
    Public Property Condition As RuleCondition

    Public Delegate Sub RuleAction(objData As Object)
    Public Delegate Function RuleCondition(objData As Object) As Boolean
    Public Delegate Function RuleStartDate(objedata As Object) As DateTime

    Public Sub New(name As String, escalationAfterTimeSpan As String, act As RuleAction)
        Me.Name = name
        EscalationAfter = TimeSpan.Parse(escalationAfterTimeSpan)
        Action = act
    End Sub

    Public Sub New(name As String, escalationAfterTimeSpan As String, act As RuleAction, condition As RuleCondition, seq As Integer)
        Me.New(name, escalationAfterTimeSpan, act)
        Me.Condition = condition
        Me.Sequence = seq
    End Sub

    Public Sub New(name As String, escalationAfterTimeSpan As String, act As RuleAction, condition As RuleCondition, seq As Integer, sDate As RuleStartDate)
        Me.New(name, escalationAfterTimeSpan, act)
        Me.Condition = condition
        Me.Sequence = seq
        Me.StartDate = sDate
    End Sub

    Public Function IsDateDue(dt As DateTime, emp As String) As Boolean
        Return WorkingHours.GetWorkingDays(dt, DateTime.Now, emp) > EscalationAfter
    End Function

    Public Function IsDateDue(dt As DateTime, objData As Object, emp As String) As Boolean
        If StartDate Is Nothing Then
            Return IsDateDue(dt, emp)
        End If

        dt = Me.StartDate(objData)
        Return IsDateDue(dt, emp)
    End Function

    Public Sub Execute(objData As Object)
        If Condition IsNot Nothing Then
            If Condition(objData) Then
                Action.Invoke(objData)
            End If
            Return
        End If
        Me.Action.Invoke(objData)
    End Sub
End Class


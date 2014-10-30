
Public Class TaskEscalationRule
    Public Shared Sub Excute(t As UserTask)
        Dim rule = GetRule(t)
        If rule.IsDateDue(If(t.NotifyDate.HasValue, t.NotifyDate, t.CreateDate)) Then
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
    Public Property CreateDate As DateTime
    Public Property EscalationAfter As TimeSpan
    Public Property Action As RuleAction
    Public Property Sequence As Integer
    Public Property Condition As RuleCondition

    Public Delegate Sub RuleAction(objData As Object)
    Public Delegate Function RuleCondition(objData As Object) As Boolean

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

    Public Function IsDateDue(dt As DateTime) As Boolean
        Return WorkingHours.GetWorkingDays(dt, DateTime.Now) > EscalationAfter
    End Function

    Public Sub Execute(objData As Object)

        If Condition IsNot Nothing Then
            If Condition(objData) Then
                Action.Invoke(objData)
                Return
            End If
        End If

        Me.Action.Invoke(objData)
    End Sub
End Class

Public Class WorkingHours
    Public Shared Function GetWorkingDays(startDate As DateTime, endDate As DateTime) As TimeSpan
        Return endDate - startDate
    End Function
End Class
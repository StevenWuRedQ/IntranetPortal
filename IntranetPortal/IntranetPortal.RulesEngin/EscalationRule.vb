Imports IntranetPortal.Core


Public Class TaskEscalationRule
    Public Shared Sub Excute(t As UserTask)
        Dim rule = GetRule(t)

        If rule.IsDateDue(If(t.Schedule.HasValue, t.Schedule, t.CreateDate), Nothing) Then
            If (rule.Execute(t)) Then
                ServiceLog.Log(String.Format("Task Rule, {3}, {4}, {0}, {1}, {2}", t.BBLE, t.TaskID, t.EmployeeName, rule.Name, rule.EscalationAfter))
            End If
        End If
    End Sub

    Public Shared Sub Excute(taskId As Integer)
        Dim t = UserTask.GetTaskById(taskId)
        Excute(t)
    End Sub

    Private Shared Function GetRule(t As UserTask) As EscalationRule
        Dim rule = TaskRules.Where(Function(r) r.Name = t.Important).FirstOrDefault
        If rule Is Nothing Then
            rule = TaskRules.First
        End If

        Return rule
    End Function

    Private Shared Function TaskRules() As List(Of EscalationRule)
        Dim rules As New List(Of EscalationRule)
        rules.Add(New EscalationRule("Normal", "7.00:00:00", Sub(task)
                                                                 Dim tk = CType(task, UserTask)
                                                                 Using ctx As New Entities
                                                                     Dim tmpTask = ctx.UserTasks.Where(Function(obj) obj.TaskID = tk.TaskID).FirstOrDefault
                                                                     tmpTask.Important = "Important"
                                                                     tmpTask.Schedule = DateTime.Now
                                                                     tmpTask.NotifyDate = DateTime.Now
                                                                     ctx.SaveChanges()
                                                                 End Using
                                                             End Sub))

        rules.Add(New EscalationRule("Important", "5.00:00:00", Sub(task)
                                                                    Dim tk = CType(task, UserTask)
                                                                    Using ctx As New Entities
                                                                        Dim tmpTask = ctx.UserTasks.Where(Function(obj) obj.TaskID = tk.TaskID).FirstOrDefault
                                                                        tmpTask.Important = "Urgent"
                                                                        tmpTask.Schedule = DateTime.Now
                                                                        tmpTask.NotifyDate = DateTime.Now
                                                                        ctx.SaveChanges()
                                                                    End Using
                                                                End Sub))

        rules.Add(New EscalationRule("Urgent", "02:00:00", Sub(task)
                                                               Dim tk = CType(task, UserTask)
                                                               Dim ld = LeadsInfo.GetInstance(tk.BBLE)
                                                               'Dim procInst = 

                                                               For Each empName In tk.EmployeeName.Split(";")
                                                                   Dim emp = Employee.GetInstance(empName)
                                                                   If Not emp Is Nothing AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                                                                       Dim email = emp.Email
                                                                       Dim emailData As New Dictionary(Of String, String)
                                                                       emailData.Add("UserName", empName)
                                                                       emailData.Add("Action", tk.Action)
                                                                       emailData.Add("Address", ld.PropertyAddress)
                                                                       emailData.Add("Priority", tk.Important)
                                                                       emailData.Add("CreateBy", tk.CreateBy)
                                                                       emailData.Add("CreatedDate", If(tk.CreateDate.HasValue, tk.CreateDate.Value.ToString("g"), ""))
                                                                       emailData.Add("BBLE", tk.BBLE)
                                                                       emailData.Add("Description", tk.Description)
                                                                       emailData.Add("ApprovalLink", WorkflowService.GetUserTaskApprovalLink(tk.TaskID, empName))

                                                                       'IntranetPortal.Core.EmailService.SendMail(email, "", "UrgentTaskNotify", emailData)
                                                                   End If
                                                               Next
                                                           End Sub))
        Return rules
    End Function
End Class

''' <summary>
''' The basic escalation rule for Task and Leads
''' </summary>
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

    Public Function Execute(objData As Object) As Boolean
        If Condition IsNot Nothing Then
            If Condition(objData) Then
                'ServiceLog.Log("ExecuteAction")
                If Not ServiceLog.Debug Then
                    Action.Invoke(objData)
                End If
                Return True
            End If

            Return False
        End If

        'ServiceLog.Log("Execute Rule Action")
        If Not ServiceLog.Debug Then
            Me.Action.Invoke(objData)
        End If
        Return True
    End Function
End Class


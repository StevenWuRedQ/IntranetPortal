
''' <summary>
''' Represents a task related to user
''' </summary>
Partial Public Class UserTask
    Public Shared Sub UpdateNotify()
        Using context As New Entities
            Dim task = context.UserTasks.Where(Function(a) a.EmployeeName.Contains(HttpContext.Current.User.Identity.Name) And a.Status = TaskStatus.Active And a.NotifyDate < DateTime.Now).FirstOrDefault
            If task IsNot Nothing Then
                Dim emps = task.EmployeeName

                For Each emp In emps.Split(";")
                    Dim title = String.Format("A Task is due.")
                    UserMessage.AddNewMessage(emp, "A task need you process.", task.Description, task.BBLE)
                Next

                Dim nextNodifyTime = DateTime.Now
                Select Case task.Important
                    Case "Important"
                        nextNodifyTime = nextNodifyTime.AddHours(72)
                    Case "Urgent"
                        nextNodifyTime = nextNodifyTime.AddHours(6)
                    Case "Normal"
                        nextNodifyTime = nextNodifyTime.AddDays(5)
                End Select

                task.NotifyDate = nextNodifyTime
                context.SaveChanges()
            End If
        End Using
    End Sub

    Public Shared Function AddUserTask(bble As String, name As String, action As String, Important As String, location As String, schedule As DateTime, description As String, logId As Integer) As UserTask
        Dim createBy = ""

        If HttpContext.Current IsNot Nothing Then
            createBy = HttpContext.Current.User.Identity.Name
        Else
            createBy = "Portal"
        End If
        Return AddUserTask(bble, name, action, Important, location, schedule, description, logId, createBy)
    End Function

    Public Shared Function AddUserTask(bble As String, name As String, action As String, Important As String, location As String, schedule As DateTime, description As String, logId As Integer, createUser As String) As UserTask
        Using context As New Entities
            Dim task As New UserTask
            task.BBLE = bble
            task.EmployeeName = name
            task.Action = action
            task.Important = Important
            task.Location = location
            task.Schedule = schedule
            task.EndDate = schedule.AddHours(2)
            task.Description = description
            task.Status = UserTask.TaskStatus.Active
            task.CreateDate = DateTime.Now
            task.CreateBy = createUser
            task.LogID = logId

            context.UserTasks.Add(task)
            context.SaveChanges()

            Return task
        End Using
    End Function

    Public Shared Function AddUserTask(bble As String, name As String, action As String, Important As String, location As String, schedule As DateTime, description As String, logId As Integer, createUser As String, mode As UserTaskMode, taskData As String) As UserTask
        Using context As New Entities
            Dim task As New UserTask
            task.BBLE = bble
            task.EmployeeName = name
            task.Action = action
            task.Important = Important
            task.Location = location
            task.Schedule = schedule
            task.EndDate = schedule.AddHours(2)
            task.Description = description
            task.Status = UserTask.TaskStatus.Active
            task.CreateDate = DateTime.Now
            task.CreateBy = createUser
            task.LogID = logId

            task.TaskMode = mode
            task.TaskData = taskData

            context.UserTasks.Add(task)
            context.SaveChanges()

            Return task
        End Using
    End Function

    Public Shared Sub AddUserTask(bble As String, name As String, description As String, logId As Integer)
        AddUserTask(bble, name, "", Nothing, "In Office", Nothing, description, logId)
        Return

        'Using context As New Entities
        '    Dim task As New UserTask
        '    task.BBLE = bble
        '    task.EmployeeName = name
        '    task.Description = description
        '    task.CreateDate = DateTime.Now
        '    task.CreateBy = HttpContext.Current.User.Identity.Name
        '    task.LogID = logId

        '    context.UserTasks.Add(task)
        '    context.SaveChanges()

        'End Using
    End Sub

    Public Shared Function GetDocumentRequestTask(bble As String) As List(Of UserTask)
        Using ctx As New Entities
            Return ctx.UserTasks.Where(Function(tk) tk.BBLE = bble AndAlso tk.Status = TaskStatus.Active AndAlso tk.Action = "Documents Request").ToList
        End Using
    End Function

    ''' <summary>
    ''' Expired the active Task and realted worklist item
    ''' </summary>
    ''' <param name="taskId">The Task Id</param>
    Public Shared Sub ExpiredTaskAndWorklist(taskId As Integer)
        Dim task = GetTaskById(taskId)
        Dim approver = task.EmployeeName

        If Not String.IsNullOrEmpty(approver) AndAlso approver.Contains(";") Then
            approver = approver.Split(";")(0)
        End If

        Dim wliItem = WorkflowService.GetUserTaskWorklist(taskId, approver)
        If wliItem IsNot Nothing Then
            WorkflowService.ExpireProcessInstance(wliItem.ProcInstId)
        End If

        ExpiredTask(taskId)
    End Sub

    Public Shared Function GetActiveTasks() As List(Of UserTask)
        Using ctx As New Entities
            Return ctx.UserTasks.Where(Function(t) t.Status = TaskStatus.Active).ToList
        End Using
    End Function

    Public Shared Function GetTaskById(taskId As Integer) As UserTask
        Using ctx As New Entities
            Return ctx.UserTasks.Find(taskId)
        End Using
    End Function

    ''' <summary>
    ''' Expired all the task created by Agents
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    Public Shared Sub ExpiredAgentTasks(bble As String)
        Using ctx As New Entities
            Dim agentCategory = LeadsActivityLog.LogCategory.SalesAgent.ToString
            Dim tasks = From tk In ctx.UserTasks.Where(Function(t) t.BBLE = bble And t.Status = TaskStatus.Active)
                        Join log In ctx.LeadsActivityLogs.Where(Function(l) l.BBLE = bble AndAlso l.Category = agentCategory) On tk.LogID Equals log.LogID
                        Select tk

            For Each task In tasks.ToList
                CompleteTask(task)
            Next

            ctx.SaveChanges()
        End Using
    End Sub

    Private Shared Sub CompleteTask(task As UserTask)
        If task IsNot Nothing AndAlso (task.TaskMode Is Nothing OrElse task.TaskMode <> UserTaskMode.Approval) Then
            task.Status = UserTask.TaskStatus.Complete
        End If
    End Sub

    ''' <summary>
    ''' Expired all tasks created by specific user
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="createBy">The user who created the task</param>
    Public Shared Sub ExpiredTasks(bble As String, createBy As String)
        Using ctx As New Entities
            Dim tasks = ctx.UserTasks.Where(Function(t) t.BBLE = bble And t.Status = TaskStatus.Active And t.CreateBy = createBy)

            For Each task In tasks
                CompleteTask(task)
            Next

            ctx.SaveChanges()
        End Using
    End Sub

    ''' <summary>
    ''' Expired the specific task by task Id
    ''' </summary>
    ''' <param name="taskId">The task Id</param>
    Public Shared Sub ExpiredTask(taskId As Integer)
        Using ctx As New Entities
            Dim tasks = ctx.UserTasks.Where(Function(t) t.TaskID = taskId And t.Status = TaskStatus.Active)

            For Each task In tasks
                If task IsNot Nothing Then
                    task.Status = UserTask.TaskStatus.Complete
                End If
            Next

            ctx.SaveChanges()
        End Using
    End Sub

    ''' <summary>
    ''' Return the amount of task related to user
    ''' </summary>
    ''' <param name="empName">The User Name</param>
    ''' <param name="userContext">The current Http Context</param>
    ''' <returns></returns>
    Public Shared Function GetTaskCount(empName As String, Optional userContext As HttpContext = Nothing) As Integer
        If userContext Is Nothing AndAlso HttpContext.Current IsNot Nothing Then
            userContext = HttpContext.Current
        End If

        Dim newVersionDate = DateTime.Parse("2014-12-31")

        Using context As New Entities
            'Dim count = context.UserTasks.Where(Function(t) t.EmployeeName.Contains(empName) And t.Status = TaskStatus.Active).Select(Function(t) t.BBLE).Distinct().Count
            Dim emps = Employee.GetSubOrdinateWithoutMgr(userContext.User.Identity.Name)

            Dim count = (From lead In context.Leads
                         Join task In context.UserTasks On task.BBLE Equals lead.BBLE
                         Where task.Status = UserTask.TaskStatus.Active And task.EmployeeName.Contains(empName) And task.CreateDate < newVersionDate
                         Select lead.BBLE).Union(
                                      From al In context.Leads
                                      Join appoint In context.UserAppointments On appoint.BBLE Equals al.BBLE
                                      Where appoint.Status = UserAppointment.AppointmentStatus.NewAppointment And (appoint.Agent = empName Or appoint.Manager = empName) And appoint.CreateDate < newVersionDate
                                      Select al.BBLE).Union(
                                    From lead In context.Leads.Where(Function(ld) ld.Status = LeadStatus.MgrApproval And emps.Contains(ld.EmployeeID))
                                    Select lead.BBLE
                                       ).Distinct.Count
            Return count
        End Using
    End Function

    Public Sub ApprovalTask(approvalStatus As TaskStatus)

    End Sub

    Public Sub ExecuteAction()
        'execute shortsale task action
        ShortSaleProcess.ExecuteAction(Me)

        Using ctx As New Entities
            Dim t = ctx.UserTasks.Find(TaskID)
            t.Status = Status
            t.Comments = Comments
            t.CompleteBy = CompleteBy
            t.CompleteDate = DateTime.Now
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetTaskByLogID(logId As Integer) As UserTask
        Using context As New Entities
            Return context.UserTasks.Where(Function(t) t.LogID = logId).SingleOrDefault
        End Using
    End Function

    ''' <summary>
    ''' The status of User Task
    ''' </summary>
    Public Enum TaskStatus
        Active
        Complete
        Resend
        Approved
        Declined
    End Enum

    ''' <summary>
    ''' The task operation mode
    ''' </summary>
    Public Enum UserTaskMode
        Complete
        Approval
    End Enum
End Class

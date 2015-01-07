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

    Public Shared Sub AddUserTask(bble As String, name As String, action As String, Important As String, location As String, schedule As DateTime, description As String, logId As Integer)
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
            task.CreateBy = HttpContext.Current.User.Identity.Name
            task.LogID = logId

            context.UserTasks.Add(task)
            context.SaveChanges()

        End Using
    End Sub

    Public Shared Sub AddUserTask(bble As String, name As String, description As String, logId As Integer)
        Using context As New Entities
            Dim task As New UserTask
            task.BBLE = bble
            task.EmployeeName = name
            task.Description = description
            task.CreateDate = DateTime.Now
            task.CreateBy = HttpContext.Current.User.Identity.Name
            task.LogID = logId

            context.UserTasks.Add(task)
            context.SaveChanges()

        End Using
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

    Public Shared Function GetTaskByLogID(logId As Integer) As UserTask
        Using context As New Entities
            Return context.UserTasks.Where(Function(t) t.LogID = logId).SingleOrDefault
        End Using

    End Function

    Public Enum TaskStatus
        Active
        Complete
        Resend
    End Enum
End Class

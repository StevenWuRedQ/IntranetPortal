Imports DevExpress.Web.ASPxEditors
Imports System.Globalization
Imports DevExpress.Web.ASPxCallbackPanel
Imports DevExpress.Web.ASPxPopupControl
Imports DevExpress.Web.ASPxHtmlEditor

Public Class ActivityLogs
    Inherits System.Web.UI.UserControl

    Private Const CommentTypeIconFormat As String = "<div class=""activity_log_item_icon {0}"">" &
                                                        "<i class=""{1}""></i>" &
                                                    "</div>"

    Public Property DisplayMode As ActivityLogMode
    Public Event MortgageStatusUpdateEvent As OnMortgageStatusUpdate
    Public Delegate Sub OnMortgageStatusUpdate(updateType As String, status As String, bble As String)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If (DispalyMode <> ActivityLogMode.ShortSale) Then
        '    EmailBody2.setHeight = 130
        'End If
    End Sub

    Public Sub BindData(bble As String)
        hfBBLE.Value = bble
        Using Context As New Entities
            gridTracking.DataSource = Context.LeadsActivityLogs.Where(Function(log) log.BBLE = bble).OrderByDescending(Function(log) log.ActivityDate).ToList
            gridTracking.DataBind()

            'If Not gridTracking.IsNewRowEditing Then
            '    gridTracking.AddNewRow()
            'End If
        End Using
    End Sub

    Sub BindEmpList()
        Using Context As New Entities
            'cbEmps.DataSource = Context.Employees.ToList
            'cbEmps.DataBind()

            Dim lbEmps = TryCast(empsDropDownEdit.FindControl("tabPageEmpSelect").FindControl("lbEmps"), ASPxListBox)
            lbEmps.DataSource = Employee.GetAllActiveEmps()
            lbEmps.DataBind()

            Dim lbRecentEmps = TryCast(empsDropDownEdit.FindControl("tabPageEmpSelect").FindControl("lbRecentEmps"), ASPxListBox)

            lbRecentEmps.DataSource = Employee.GetProfile(Page.User.Identity.Name).RecentEmps.Select(Function(str) str.Trim).Distinct
            lbRecentEmps.DataBind()
        End Using
    End Sub

    Protected Sub gridTracking_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs) Handles gridTracking.RowInserting
        Dim aspxdate = TryCast(gridTracking.FindEditFormTemplateControl("dateActivity"), ASPxDateEdit)
        Dim txtComments = TryCast(gridTracking.FindEditFormTemplateControl("txtComments"), ASPxMemo)
        Dim getdate As DateTime = DateTime.Now

        If (aspxdate IsNot Nothing) Then
            If aspxdate.Date.Date = DateTime.Now.Date Then
                aspxdate.Date = DateTime.Now
            End If

            If aspxdate.Date < DateTime.Now Then
                aspxdate.Date = aspxdate.Date.Date
            End If
            getdate = aspxdate.Date
        End If

        If String.IsNullOrEmpty(txtComments.Text) Then
            Throw New Exception("Comments can not be empty.")
        End If

        LeadsActivityLog.AddActivityLog(getdate, txtComments.Text, hfBBLE.Value, LeadsActivityLog.LogCategory.SalesAgent.ToString, LeadsActivityLog.EnumActionType.Comments)
        'AddActivityLog(aspxdate.Date, txtComments.Text, hfBBLE.Value, LeadsActivityLog.LogCategory.SalesAgent.ToString)
        e.Cancel = True

        BindData(hfBBLE.Value)
    End Sub

    Public Function AddActivityLog2(logDate As DateTime, comments As String, bble As String, category As String) As LeadsActivityLog
        Using Context As New Entities
            Dim log As New LeadsActivityLog
            log.BBLE = bble
            log.EmployeeID = CInt(Membership.GetUser(Page.User.Identity.Name).ProviderUserKey)
            log.EmployeeName = Page.User.Identity.Name
            log.Category = category
            log.ActivityDate = logDate
            log.Comments = comments

            Context.LeadsActivityLogs.Add(log)
            Context.SaveChanges()

            Return log
        End Using
    End Function

    Protected Sub gridTracking_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs) Handles gridTracking.CustomCallback
        If (e.Parameters = "Task") Then
            SetAsTask()
        End If

        'Complete Task
        If (e.Parameters.StartsWith("CompleteTask")) Then
            Dim logId = CInt(e.Parameters.Split("|")(1))

            'If String.IsNullOrEmpty(Request.QueryString("sn")) Then
            '    Return
            'End If

            Using Context As New Entities
                Dim task = Context.UserTasks.Where(Function(t) t.LogID = logId).SingleOrDefault

                If task IsNot Nothing Then
                    task.Status = UserTask.TaskStatus.Complete
                    Context.SaveChanges()
                End If

                LeadsActivityLog.AddActivityLog(DateTime.Now, "Task is completed by " & Page.User.Identity.Name, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.SetAsTask)

                If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                    Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                    If wli IsNot Nothing Then
                        wli.ProcessInstance.DataFields("Result") = "Completed"
                        wli.Finish()
                    End If
                End If
            End Using

            BindData(hfBBLE.Value)
        End If

        'Approve New Lead
        If (e.Parameters.StartsWith("ApproveNewLead")) Then
            Dim logId = CInt(e.Parameters.Split("|")(1))

            Using Context As New Entities
                Dim log = Context.LeadsActivityLogs.Where(Function(t) t.LogID = logId).SingleOrDefault

                If log IsNot Nothing Then
                    log.Category = LeadsActivityLog.LogCategory.Approved.ToString

                    Dim lead = Context.Leads.Where(Function(ld) ld.BBLE = log.BBLE).SingleOrDefault
                    lead.Status = LeadStatus.NewLead

                    Context.SaveChanges()

                    LeadsActivityLog.AddActivityLog(DateTime.Now, "New Lead is approved by " & Page.User.Identity.Name, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Approved)

                    If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                        Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                        If wli IsNot Nothing Then
                            wli.ProcessInstance.DataFields("Result") = "Approve"
                            wli.Finish()
                        End If
                    End If

                    'Add Notify Message
                    Dim title = "New lead is Approved"
                    Dim msg = String.Format("New Lead (BBLE: {0}) is Approved by " & Page.User.Identity.Name, lead.BBLE)
                    UserMessage.AddNewMessage(lead.EmployeeName, title, msg, lead.BBLE)
                End If
            End Using

            BindData(hfBBLE.Value)
        End If

        'Decline New Lead
        If (e.Parameters.StartsWith("DeclineNewLead")) Then
            Dim logId = CInt(e.Parameters.Split("|")(1))

            Using Context As New Entities
                Dim log = Context.LeadsActivityLogs.Where(Function(t) t.LogID = logId).SingleOrDefault

                If log IsNot Nothing Then
                    log.Category = LeadsActivityLog.LogCategory.Declined.ToString
                    Context.SaveChanges()

                    LeadsActivityLog.AddActivityLog(DateTime.Now, "New Lead is declined by " & Page.User.Identity.Name, log.BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Declined)

                    'Connect to Workflow Server
                    If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                        Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                        If wli IsNot Nothing Then
                            wli.ProcessInstance.DataFields("Result") = "Decline"
                            wli.Finish()
                        End If
                    End If

                    Dim lead = Context.Leads.Where(Function(ld) ld.BBLE = log.BBLE).SingleOrDefault
                    lead.EmployeeID = Employee.GetInstance(Page.User.Identity.Name).EmployeeID
                    lead.EmployeeName = Page.User.Identity.Name
                    lead.Status = LeadStatus.NewLead
                    lead.AssignDate = DateTime.Now
                    lead.AssignBy = Page.User.Identity.Name
                    Context.SaveChanges()

                    LeadsActivityLog.AddActivityLog(DateTime.Now, "The Leads status changes to new leads of " & Page.User.Identity.Name, log.BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)

                    'Add Notify Message
                    Dim title = "Your lead is declined"
                    Dim msg = String.Format("New Lead (BBLE: {0}) is declined by " & Page.User.Identity.Name, log.BBLE)
                    UserMessage.AddNewMessage(lead.EmployeeName, title, msg, log.BBLE)

                    'Don't remove leads logs
                    'Dim logs = Context.LeadsActivityLogs.Where(Function(l) l.BBLE = log.BBLE)

                    'Context.LeadsActivityLogs.RemoveRange(logs)
                    'Context.Leads.Remove(lead)
                    'Context.SaveChanges()
                End If
            End Using

            BindData(hfBBLE.Value)
        End If

        'AcceptAppointment
        If (e.Parameters.StartsWith("AcceptAppointment")) Then
            Dim logId = CInt(e.Parameters.Split("|")(1))

            UserAppointment.UpdateAppointmentStatus(logId, UserAppointment.AppointmentStatus.Accepted)
            LeadsActivityLog.AddActivityLog(DateTime.Now, "Appointment is accepted by " & Page.User.Identity.Name, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString)

            'Connect to Workflow Server
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                If wli IsNot Nothing Then
                    wli.ProcessInstance.DataFields("Result") = "Approve"
                    wli.Finish()
                End If
            End If

            'Add Notify Message
            Dim userApoint = UserAppointment.GetAppointmentBylogID(logId)
            If userApoint IsNot Nothing Then
                Dim title = "Appointment Accepted"
                Dim msg = userApoint.Subject & " is accepted by " & Page.User.Identity.Name
                UserMessage.AddNewMessage(userApoint.Agent, title, msg, userApoint.BBLE)
            End If

            Lead.UpdateLeadStatus(userApoint.BBLE, LeadStatus.Priority, Nothing)

            BindData(hfBBLE.Value)
        End If

        'Decline Appointment
        If (e.Parameters.StartsWith("DeclineAppointment")) Then
            Dim logId = CInt(e.Parameters.Split("|")(1))

            UserAppointment.UpdateAppointmentStatus(logId, UserAppointment.AppointmentStatus.Declined)
            LeadsActivityLog.AddActivityLog(DateTime.Now, "Appointment is Decline by " & Page.User.Identity.Name, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString)

            'Connect to Workflow Server
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                If wli IsNot Nothing Then
                    wli.ProcessInstance.DataFields("Result") = "Decline"
                    wli.Finish()
                End If
            End If

            'Add Notify Message
            Dim userApoint = UserAppointment.GetAppointmentBylogID(logId)
            If userApoint IsNot Nothing Then
                Dim title = "Appointment Declined"
                Dim msg = userApoint.Subject & " is declined by " & Page.User.Identity.Name
                UserMessage.AddNewMessage(userApoint.Agent, title, msg, userApoint.BBLE)
            End If

            BindData(hfBBLE.Value)
        End If

        'ReSchedule Appointment
        If (e.Parameters.StartsWith("ReScheduleAppointment")) Then
            Dim logId = CInt(e.Parameters.Split("|")(1))

            UserAppointment.UpdateAppointmentStatus(logId, UserAppointment.AppointmentStatus.ReScheduled)
            LeadsActivityLog.AddActivityLog(DateTime.Now, "Appointment is Rescheduled by " & Page.User.Identity.Name, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString)

            'Connect to Workflow Server
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                If wli IsNot Nothing Then
                    wli.ProcessInstance.DataFields("Result") = "Reschedule"
                    wli.Finish()
                End If
            End If

            'Add Notify Message
            Dim userApoint = UserAppointment.GetAppointmentBylogID(logId)
            If userApoint IsNot Nothing Then
                Dim title = "Appointment ReScheduled"
                Dim msg = userApoint.Subject & " is ReScheduled by " & Page.User.Identity.Name
                UserMessage.AddNewMessage(userApoint.Agent, title, msg, userApoint.BBLE)
            End If

            BindData(hfBBLE.Value)
        End If

        'Postpone the recycle date
        If (e.Parameters.StartsWith("PostponeRecylce")) Then
            If e.Parameters.Split("|").Length = 3 Then
                Dim logId = CInt(e.Parameters.Split("|")(1))
                Dim days = CInt(e.Parameters.Split("|")(2))

                If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                    Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                    If wli IsNot Nothing Then
                        wli.ProcessInstance.DataFields("Result") = "Completed"
                        wli.Finish()

                        Dim recycle = Core.RecycleLead.GetInstanceByLogId(logId)
                        Dim rDate = recycle.PostponeDays(days)

                        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("Recycle action is postponed to {0} by {1} ", rDate.ToShortDateString, Page.User.Identity.Name), hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString)
                    End If
                End If
            End If
        End If
    End Sub

    Sub SetAsTask()
        If Not String.IsNullOrEmpty(hfResend.Value) Then
            Dim logId = CInt(hfResend.Value)
            ResendTask(logId)
        End If
        Dim employees = ""

        If empsDropDownEdit.Text.ToLower.Contains(Page.User.Identity.Name.ToLower) Then
            employees = empsDropDownEdit.Text
        Else
            employees = empsDropDownEdit.Text
        End If

        'SetAsTask(employees, cbTaskImportant.Text, cbTaskAction.Text, txtTaskDes.Text, hfBBLE.Value, Page.User.Identity.Name)
        'Return

        'Dim scheduleDate = DateTime.Now

        'If cbTaskImportant.Text = "Normal" Then
        '    scheduleDate = scheduleDate.AddDays(3)
        'End If

        'If cbTaskImportant.Text = "Important" Then
        '    scheduleDate = scheduleDate.AddDays(1)
        'End If

        'If cbTaskImportant.Text = "Urgent" Then
        '    scheduleDate = scheduleDate.AddHours(2)
        'End If

        'Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td style=""width:100px;"">Employees:</td>" &
        '                             "<td>{0}</td></tr>" &
        '                             "<tr><td>Action:</td><td>{1}</td></tr>" &
        '                             "<tr><td>Important:</td><td>{2}</td></tr>" &
        '                           "<tr><td>Description:</td><td>{3}</td></tr>" &
        '                           "</table>", employees, cbTaskAction.Text, cbTaskImportant.Text, txtTaskDes.Text)

        'Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LeadsActivityLog.LogCategory.Task.ToString, LeadsActivityLog.EnumActionType.SetAsTask)

        'Dim taskId As Integer
        'Using Context As New Entities
        '    Dim task = Context.UserTasks.Add(AddTask(hfBBLE.Value, employees, cbTaskAction.Text, cbTaskImportant.Text, scheduleDate, txtTaskDes.Text, log.LogID))
        '    Context.SaveChanges()
        '    taskId = task.TaskID
        'End Using

        Dim taskId = CreateTask(employees, cbTaskImportant.Text, cbTaskAction.Text, txtTaskDes.Text, hfBBLE.Value, Page.User.Identity.Name)

        Dim emps = employees.Split(";").Distinct.ToArray
        Dim upData = Employee.GetProfile(Page.User.Identity.Name)
        Dim ld = LeadsInfo.GetInstance(hfBBLE.Value)

        Dim taskName = String.Format("{0} {1}", cbTaskAction.Text, ld.StreetNameWithNo)
        If DisplayMode = ActivityLogMode.Leads Then
            WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text)
        ElseIf DisplayMode = ActivityLogMode.ShortSale Then
            WorkflowService.StartTaskProcess("ShortSaleTask", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text)
        End If

        For i = 0 To emps.Count - 1
            If Not emps(i) = Page.User.Identity.Name Then
                Dim tmpName = emps(i).Trim
                'Dim title = String.Format("A New Task has been assigned by {0}  regarding {1} for {2}", Page.User.Identity.Name, cbTaskAction.Text, ld.PropertyAddress)
                'UserMessage.AddNewMessage(tmpName, title, comments, hfBBLE.Value)

                'Add recently choose employee list
                If upData.RecentEmps.Contains(tmpName) Then
                    upData.RecentEmps.Remove(tmpName)
                End If
                upData.RecentEmps.Insert(0, tmpName)
            End If
        Next

        Employee.SaveProfile(Page.User.Identity.Name, upData)
        BindData(hfBBLE.Value)
    End Sub

    Public Sub SetAsTask(employees As String, taskPriority As String, taskAction As String, taskDescription As String, bble As String, createUser As String)
        'Dim scheduleDate = DateTime.Now

        'If taskPriority = "Normal" Then
        '    scheduleDate = scheduleDate.AddDays(3)
        'End If

        'If taskPriority = "Important" Then
        '    scheduleDate = scheduleDate.AddDays(1)
        'End If

        'If taskPriority = "Urgent" Then
        '    scheduleDate = scheduleDate.AddHours(2)
        'End If

        'Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td style=""width:100px;"">Employees:</td>" &
        '                             "<td>{0}</td></tr>" &
        '                             "<tr><td>Action:</td><td>{1}</td></tr>" &
        '                             "<tr><td>Important:</td><td>{2}</td></tr>" &
        '                           "<tr><td>Description:</td><td>{3}</td></tr>" &
        '                           "</table>", employees, taskAction, taskPriority, taskDescription)

        'Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Task.ToString, Nothing, createUser, LeadsActivityLog.EnumActionType.SetAsTask)

        'Dim taskId As Integer
        'Using Context As New Entities
        '    Dim task = Context.UserTasks.Add(AddTask(bble, employees, taskAction, taskPriority, scheduleDate, taskDescription, log.LogID, createUser))
        '    Context.SaveChanges()
        '    taskId = task.TaskID
        'End Using

        Dim taskId = CreateTask(employees, taskPriority, taskAction, taskDescription, bble, createUser)

        Dim ld = LeadsInfo.GetInstance(bble)
        Dim taskName = String.Format("{0} {1}", taskAction, ld.StreetNameWithNo)
        WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, bble, employees, taskPriority)
    End Sub

    Public Sub SetAsReminder(employees As String, taskPriority As String, taskAction As String, taskDescription As String, bble As String, createUser As String)
        Dim taskId = CreateTask(employees, taskPriority, taskAction, taskDescription, bble, createUser)

        Dim ld = LeadsInfo.GetInstance(bble)
        Dim taskName = String.Format("{0} {1}", taskAction, ld.StreetNameWithNo)
        WorkflowService.StartTaskProcess("ReminderProcess", taskName, taskId, bble, employees, taskPriority)
    End Sub

    Private Function CreateTask(employees As String, taskPriority As String, taskAction As String, taskDescription As String, bble As String, createUser As String) As Integer
        Dim scheduleDate = DateTime.Now

        If taskPriority = "Normal" Then
            scheduleDate = scheduleDate.AddDays(3)
        End If

        If taskPriority = "Important" Then
            scheduleDate = scheduleDate.AddDays(1)
        End If

        If taskPriority = "Urgent" Then
            scheduleDate = scheduleDate.AddHours(2)
        End If

        Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td style=""width:100px;"">Employees:</td>" &
                                     "<td>{0}</td></tr>" &
                                     "<tr><td>Action:</td><td>{1}</td></tr>" &
                                     "<tr><td>Important:</td><td>{2}</td></tr>" &
                                   "<tr><td>Description:</td><td>{3}</td></tr>" &
                                   "</table>", employees, taskAction, taskPriority, taskDescription)

        Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Task.ToString, Nothing, createUser, LeadsActivityLog.EnumActionType.SetAsTask)
        Dim task = UserTask.AddUserTask(bble, employees, taskAction, taskPriority, "In Office", scheduleDate, taskDescription, log.LogID, createUser)
        Return task.TaskID
    End Function

    Function GetCommentsIconClass(type As String)
        If String.IsNullOrEmpty(type) Then
            Return GetIcon("activity_green_bg", "fa fa-info")
        End If

        Return CommentIconList(type)
    End Function

    Function ShowTaskPanel(cate As String) As Boolean
        Return cate = "Task"
    End Function

    Function AddTask(bble As String, name As String, action As String, important As String, schedule As Date, description As String, logid As Integer) As UserTask
        Return AddTask(bble, name, action, important, schedule, description, logid, Page.User.Identity.Name)
    End Function

    Function AddTask(bble As String, name As String, action As String, important As String, schedule As Date, description As String, logid As Integer, createUser As String) As UserTask

        Dim task As New UserTask
        task.BBLE = bble
        task.EmployeeName = name
        task.Action = action
        task.Important = important
        task.Location = "In Office"
        task.Schedule = schedule
        task.EndDate = schedule.AddHours(2)
        task.Description = description
        task.Status = UserTask.TaskStatus.Active
        task.CreateDate = DateTime.Now
        task.CreateBy = createUser
        task.LogID = logid

        Return task
    End Function

    Protected Sub cbCateLog_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Protected Sub gridTracking_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs) Handles gridTracking.HtmlRowPrepared
        If Not e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Data Then
            Return
        End If

        Dim category = e.GetValue("Category").ToString

        If category = "Approval" Then
            Dim logId = CInt(e.GetValue("LogID"))
            Dim pnlApproval = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlAptButton"), Panel)
            Dim pnlAptButton = TryCast(pnlApproval.FindControl("pnlAptButton"), Panel)

            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
                If wli IsNot Nothing AndAlso wli.ProcessName.ToString = "NewLeadsRequest" Then
                    pnlAptButton.Visible = True
                Else
                    pnlAptButton.Visible = False
                End If
            End If
        End If

        If category = "DoorknockTask" Then
            If e.GetValue("LogID") IsNot Nothing Then
                Dim logId = CInt(e.GetValue("LogID"))

                Dim task = UserTask.GetTaskByLogID(logId)
                Dim pnlTask = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlDoorknockTask"), Panel)
                Dim btnTaskComplete = TryCast(pnlTask.FindControl("btnDoorkncokComplete"), HtmlControl)
                Dim ltDoorknockResult = TryCast(pnlTask.FindControl("ltDoorknockResult"), Literal)
                Dim ltDoorknockAddress = TryCast(pnlTask.FindControl("ltDoorknockAddress"), Literal)


                If task Is Nothing Then
                    ltDoorknockAddress.Text = e.GetValue("Comments")
                Else
                    ltDoorknockAddress.Text = task.Description
                End If

                If task.Status = UserTask.TaskStatus.Active Then
                    btnTaskComplete.Visible = True
                Else
                    btnTaskComplete.Visible = False
                    ltDoorknockResult.Visible = True
                    ltDoorknockResult.Text = "Complete"
                End If
            End If
        End If

        If category = "RecycleTask" Then
            If e.GetValue("LogID") IsNot Nothing Then
                Dim logId = CInt(e.GetValue("LogID"))

                Dim recyle = Core.RecycleLead.GetInstanceByLogId(logId)
                Dim pnlTask = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlRecycleTask"), Panel)
                Dim cbRecycleDays = TryCast(pnlTask.FindControl("cbRecycleDays"), ASPxComboBox)
                Dim ltRecycleDays = TryCast(pnlTask.FindControl("ltRecycleDays"), Literal)

                If recyle IsNot Nothing AndAlso recyle.Status = Core.RecycleLead.RecycleStatus.Active Then

                    'check if this is recycle page
                    If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                        Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
                        If wli IsNot Nothing AndAlso wli.ProcessName.ToString = "RecycleProcess" AndAlso CInt(wli.ProcessInstance.DataFields("TaskId")) = recyle.RecycleId Then
                            cbRecycleDays.Visible = True
                            cbRecycleDays.ClientSideEvents.SelectedIndexChanged = String.Format("function(s,e){{PostponeRecylce({0}, s);}}", logId)
                        Else

                        End If
                    End If
                Else
                    cbRecycleDays.Visible = False
                    ltRecycleDays.Visible = True
                    ltRecycleDays.Text = If(recyle IsNot Nothing, CType(recyle.Status, Core.RecycleLead.RecycleStatus).ToString, "")
                End If
            End If
        End If

        If category = "Task" Then
            If e.GetValue("LogID") IsNot Nothing Then
                Dim logId = CInt(e.GetValue("LogID"))

                Dim task = UserTask.GetTaskByLogID(logId)
                Dim pnlTask = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlTask"), Panel)
                Dim btnTaskComplete = TryCast(pnlTask.FindControl("btnTaskComplete"), HtmlControl)
                Dim btnResend = TryCast(pnlTask.FindControl("btnResend"), HtmlControl)

                Dim ltTaskResult = TryCast(pnlTask.FindControl("ltTaskResult"), Literal)

                If task Is Nothing Then

                    Dim tblTask = TryCast(pnlTask.FindControl("tblTask"), HtmlControl)
                    tblTask.Visible = False

                    Dim ltTasklogData = TryCast(pnlTask.FindControl("ltTasklogData"), Literal)
                    ltTasklogData.Text = e.GetValue("Comments")
                    Return
                Else
                    'Bind task data
                    Dim ltTaskEmp = TryCast(pnlTask.FindControl("ltTaskEmp"), Literal)
                    ltTaskEmp.Text = task.EmployeeName

                    Dim ltTaskAction = TryCast(pnlTask.FindControl("ltTaskAction"), Literal)
                    ltTaskAction.Text = task.Action

                    Dim ltTaskImpt = TryCast(pnlTask.FindControl("ltTaskImpt"), Literal)
                    ltTaskImpt.Text = task.Important

                    Dim ltTaskComments = TryCast(pnlTask.FindControl("ltTaskComments"), Literal)
                    ltTaskComments.Text = task.Description
                End If

                If task.Status = UserTask.TaskStatus.Active Then
                    Dim approvalView = False

                    'check if it's approval page
                    If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                        Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
                        If wli IsNot Nothing Then
                            If wli.ProcessName.ToString = "TaskProcess" OrElse wli.ProcessName = "ShortSaleTask" OrElse wli.ProcessName = "ReminderProcess" Then
                                If CInt(wli.ProcessInstance.DataFields("TaskId")) = task.TaskID Then
                                    If btnTaskComplete IsNot Nothing Then
                                        btnTaskComplete.Visible = True
                                    End If

                                    If btnResend IsNot Nothing Then
                                        btnResend.Visible = True
                                    End If

                                    approvalView = True
                                End If
                            End If
                        End If
                    Else
                        If task.CreateDate < DateTime.Parse("2014-12-31 12:59") Then
                            If btnTaskComplete IsNot Nothing Then
                                btnTaskComplete.Visible = True
                            End If

                            If btnResend IsNot Nothing Then
                                btnResend.Visible = True
                            End If

                            approvalView = True
                        End If
                    End If

                    If Not approvalView Then
                        If ltTaskResult IsNot Nothing Then
                            ltTaskResult.Text = "Waiting to Answer"
                        End If
                    End If

                    'e.Row.BackColor = System.Drawing.Color.FromArgb(255, 197, 197)
                    e.Row.CssClass = "activity_log_high_light dxgvDataRow_MetropolisBlue1"

                    If task.Schedule < DateTime.Now Then
                        e.Row.ForeColor = Drawing.Color.Red
                    End If
                Else
                    btnTaskComplete.Visible = False

                    If ltTaskResult IsNot Nothing Then
                        Select Case task.Status
                            Case UserTask.TaskStatus.Complete
                                ltTaskResult.Text = "Complete"
                            Case UserTask.TaskStatus.Resend
                                ltTaskResult.Text = "Resend"
                        End Select
                    End If
                End If
            End If
        End If


        If category = "Appointment" Then
            Dim logId = CInt(e.GetValue("LogID"))
            Dim userAppoint = UserAppointment.GetAppointmentBylogID(logId)

            Dim pnlAppointment = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlAppointment"), Panel)

            If userAppoint IsNot Nothing Then
                'Bind Data
                Dim lblOwnerName = TryCast(pnlAppointment.FindControl("lblOwnerName"), Label)
                lblOwnerName.Text = LeadsInfo.GetInstance(userAppoint.BBLE).Owner
                Dim ltAptType = TryCast(pnlAppointment.FindControl("ltAptType"), Literal)
                ltAptType.Text = userAppoint.Type
                Dim ltStartTime = TryCast(pnlAppointment.FindControl("ltStartTime"), Literal)
                ltStartTime.Text = userAppoint.ScheduleDate
                Dim ltEndTime = TryCast(pnlAppointment.FindControl("ltEndTime"), Literal)
                ltEndTime.Text = userAppoint.EndDate
                Dim ltAptLocation = TryCast(pnlAppointment.FindControl("ltAptLocation"), Literal)
                ltAptLocation.Text = userAppoint.Location
                Dim ltAptMgr = TryCast(pnlAppointment.FindControl("ltAptMgr"), Literal)
                ltAptMgr.Text = userAppoint.Manager
                Dim ltAptComments = TryCast(pnlAppointment.FindControl("ltAptComments"), Literal)
                ltAptComments.Text = userAppoint.Description

                Dim btnAccept = TryCast(pnlAppointment.FindControl("btnAccept"), HtmlControl)
                Dim btnDecline = TryCast(pnlAppointment.FindControl("btnDecline"), HtmlControl)
                Dim btnReschedule = TryCast(pnlAppointment.FindControl("btnReschedule"), HtmlControl)

                'Dim chkAptAccept = TryCast(pnlAppointment.FindControl("chkAptAccept"), ASPxCheckBox)
                'Dim chkAptDecline = TryCast(pnlAppointment.FindControl("chkAptDecline"), ASPxCheckBox)
                'Dim chkAptReschedule = TryCast(pnlAppointment.FindControl("chkAptReschedule"), ASPxCheckBox)

                Dim ltResult = TryCast(pnlAppointment.FindControl("ltResult"), Literal)


                If userAppoint.Status = UserAppointment.AppointmentStatus.NewAppointment Then
                    'e.Row.BackColor = Drawing.Color.FromArgb(204, 255, 200)
                    Dim approvalView = False
                    If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                        If WorkflowService.IsAppointmentProcess(Request.QueryString("sn"), userAppoint.AppoitID) Then
                            e.Row.CssClass = "activity_log_high_light dxgvDataRow_MetropolisBlue1"
                            btnAccept.Visible = True
                            btnDecline.Visible = True
                            btnReschedule.Visible = True

                            approvalView = True
                        End If
                    Else
                        If userAppoint.CreateDate < DateTime.Parse("2014-12-31 12:59") Then
                            e.Row.CssClass = "activity_log_high_light dxgvDataRow_MetropolisBlue1"
                            btnAccept.Visible = True
                            btnDecline.Visible = True
                            btnReschedule.Visible = True

                            approvalView = True
                        End If
                    End If

                    If Not approvalView Then
                        ltResult.Text = "Waiting Process"
                    End If

                    Return
                Else
                    btnAccept.Visible = False
                    btnDecline.Visible = False
                    btnReschedule.Visible = False
                End If

                If userAppoint.Status = UserAppointment.AppointmentStatus.Accepted Then
                    ltResult.Text = "Accepted"
                    'chkAptAccept.Visible = True
                    'chkAptAccept.ReadOnly = True
                    'chkAptAccept.Checked = True
                End If

                If userAppoint.Status = UserAppointment.AppointmentStatus.Declined Then
                    ltResult.Text = "Declined"
                    'chkAptDecline.Visible = True
                    'chkAptDecline.ReadOnly = True
                    'chkAptDecline.Checked = True
                End If

                If userAppoint.Status = UserAppointment.AppointmentStatus.ReScheduled Then
                    ltResult.Text = "Rescheduled"
                    'chkAptReschedule.Visible = True
                    'chkAptReschedule.ReadOnly = True
                    'chkAptReschedule.Checked = True
                End If
            Else
                Dim tblApt = TryCast(pnlAppointment.FindControl("tblApt"), HtmlControl)
                Dim ltApt = TryCast(pnlAppointment.FindControl("ltApt"), Literal)

                tblApt.Visible = False
                ltApt.Text = e.GetValue("Comments")
            End If
        End If
    End Sub

    Protected Sub gridTracking_AfterPerformCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewAfterPerformCallbackEventArgs)
        If Not String.IsNullOrEmpty(hfBBLE.Value) Then
            BindData(hfBBLE.Value)
        End If
    End Sub

    Public _commentIconList As StringDictionary
    Public ReadOnly Property CommentIconList As StringDictionary
        Get
            If _commentIconList Is Nothing Then
                _commentIconList = New StringDictionary
                _commentIconList.Add(LeadsActivityLog.EnumActionType.CallOwner, GetIcon("activity_green_bg", "fa fa-phone"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.DoorKnock, GetIcon("activity_red_bg", "fa fa-info"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.FollowUp, GetIcon("activity_green_bg", "fa fa-info"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.Appointment, GetIcon("activity_color_clock-o", "fa fa-clock-o"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.Email, GetIcon("activity_color_envelope", "fa fa-envelope"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.Comments, GetIcon("activity_color_comment", "fa fa-comment"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.SetAsTask, GetIcon("activity_color_tasks", "fa fa-tasks"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.UpdateInfo, GetIcon("activity_color_refresh", "fa fa-refresh"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.DealClosed, GetIcon("activity_color_check", "fa fa-check"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.HotLeads, GetIcon("activity_color_info", "fa fa-info"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.Print, GetIcon("activity_color_print", "fa fa-print"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.Reassign, GetIcon("activity_color_check", "fa fa-mail-forward"))
                _commentIconList.Add(LeadsActivityLog.EnumActionType.DeadLead, GetIcon("activity_red_bg", "fa fa-times-circle"))
            End If

            Return _commentIconList
        End Get
    End Property

    Function GetIcon(bgColor As String, fontClass As String) As String
        Return String.Format(CommentTypeIconFormat, bgColor, fontClass)
    End Function

    Protected Sub addCommentsCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If String.IsNullOrEmpty(e.Parameter) Then
            Return
        End If

        Dim aspxdate = CDate(e.Parameter.Split("|")(0))
        Dim txtComments = e.Parameter.Split("|")(1)

        If aspxdate.Date = DateTime.Now.Date Then
            aspxdate = DateTime.Now
        End If

        If aspxdate < DateTime.Now Then
            aspxdate = aspxdate.Date
        End If

        If String.IsNullOrEmpty(txtComments) Then
            Throw New Exception("Comments can not be empty.")
        End If

        If Me.DisplayMode = ActivityLogMode.ShortSale Then
            aspxdate = DateTime.Now
            Dim typeOfUpdate = e.Parameter.Split("|")(2)
            Dim statusOfUpdate = e.Parameter.Split("|")(3)

            RaiseEvent MortgageStatusUpdateEvent(typeOfUpdate, statusOfUpdate, hfBBLE.Value)

            txtComments = String.Format("Type of Update: {0}<br />{1}", typeOfUpdate, txtComments)
            LeadsActivityLog.AddActivityLog(aspxdate, txtComments, hfBBLE.Value, LeadsActivityLog.LogCategory.SalesAgent, LeadsActivityLog.EnumActionType.Comments)
        Else
            LeadsActivityLog.AddActivityLog(aspxdate, txtComments, hfBBLE.Value, LeadsActivityLog.LogCategory.SalesAgent.ToString, LeadsActivityLog.EnumActionType.Comments)
        End If

        'BindData(hfBBLE.Value)
    End Sub

    'Set as task popup call back
    Protected Sub ASPxPopupControl1_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        Dim popup = CType(source, ASPxPopupControl)
        PopupContentSetAsTask.Visible = True
        hfResend.Value = ""
        BindEmpList()

        If e.Parameter.StartsWith("ResendTask") Then
            Dim logId = e.Parameter.Split("|")(1)
            Dim task = UserTask.GetTaskByLogID(logId)
            empsDropDownEdit.Text = task.CreateBy
            cbTaskAction.Text = task.Action
            cbTaskImportant.Text = task.Important
            txtTaskDes.Text = task.Description
            hfResend.Value = logId

            'ResendTask(logId)
        End If
    End Sub

    Private Sub ResendTask(logId As Integer)
        Using Context As New Entities
            Dim task = Context.UserTasks.Where(Function(t) t.LogID = logId).SingleOrDefault

            If task IsNot Nothing Then
                task.Status = UserTask.TaskStatus.Complete
                Context.SaveChanges()
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
                wli.ProcessInstance.DataFields("Result") = "Completed"
                wli.Finish()
            End If

            LeadsActivityLog.AddActivityLog(DateTime.Now, "Task is Resend by " & Page.User.Identity.Name, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.SetAsTask)
        End Using
    End Sub

    Enum ActivityLogMode
        Leads
        ShortSale
    End Enum

    Protected Sub EmailBody2_Load(sender As Object, e As EventArgs)
        Dim htmlEditor = CType(sender, ASPxHtmlEditor)
        If htmlEditor.Toolbars.Count = 0 Then
            htmlEditor.Toolbars.Add(Utility.CreateCustomToolbar("Custom"))
        End If
    End Sub

    Protected Sub callbackGetEmployeesByAction_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim action = e.Parameter

        If action = "Lookup Request" Then
            Dim emp = Employee.GetInstance(Page.User.Identity.Name)
            If emp IsNot Nothing AndAlso emp.Department = "RonTeam" Then
                e.Result = "Princess Simeon"
            Else
                e.Result = "Jamie Ventura"
            End If
        End If

        If action = "Judgement Search Request" Then
            e.Result = String.Join(";", Roles.GetUsersInRole("Judgment Searches"))
        End If
    End Sub
End Class
Imports DevExpress.Web
Imports System.Globalization
Imports DevExpress.Web.ASPxHtmlEditor
Imports IntranetPortal.Data
Imports ShortSale = IntranetPortal.Data

Public Class ActivityLogs
    Inherits System.Web.UI.UserControl

    Private Const CommentTypeIconFormat As String = "<div class=""activity_log_item_icon {0}"">" &
                                                        "<i class=""{1}""></i>" &
                                                    "</div>"
    Public Property DisplayMode As ActivityLogMode
    Public Property ActivityLogProvider As ActivityManageBase

    Public Event MortgageStatusUpdateEvent As OnMortgageStatusUpdate
    Public Delegate Sub OnMortgageStatusUpdate(updateType As String, status As String, category As String, bble As String)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If DisplayMode = ActivityLogMode.ShortSale Then
            gridTracking.Settings.VerticalScrollableHeight = 510
        Else
            gridTracking.Settings.VerticalScrollableHeight = 600
        End If

        If DisplayMode = ActivityLogMode.Construction Then
            ActivityLogProvider = New ConstructionManage(True)
        End If

        If DisplayMode = ActivityLogMode.Title Then
            ActivityLogProvider = New TitleManage(True)
        End If

        If DisplayMode = ActivityLogMode.Leads Then
            ActivityLogProvider = New LeadManage(True)
        End If

        If ActivityLogProvider IsNot Nothing Then
            If ActivityLogProvider.CommentsControlName IsNot Nothing Then
                Dim commentControl = Page.LoadControl(ActivityLogProvider.CommentsControlName)
                commentControl.ID = "CommentsCtl"
                ActivityLogProvider.CommentsControl = commentControl
                pnlCommentCtr.Controls.Add(commentControl)
            End If
        End If

        If Not Page.IsPostBack Then
            If ActivityLogProvider IsNot Nothing Then
                If ActivityLogProvider.LogCategoryFilter IsNot Nothing Then
                    cbCateLog.Items.Clear()
                    For Each cate In ActivityLogProvider.LogCategoryFilter
                        cbCateLog.Items.Add(cate.ToString)
                    Next
                End If
            End If
        End If
    End Sub

    Private Sub ActivityLogs_Init(sender As Object, e As EventArgs) Handles Me.Init

    End Sub

    Public Sub BindData(bble As String, activityMng As ActivityManageBase)
        Me.ActivityLogProvider = activityMng
        Me.BindData(bble)
    End Sub

    Public Sub BindLogsByCategories(bble As String, categories As String())
        If categories Is Nothing Then
            BindData(bble)
        Else
            hfBBLE.Value = bble
            gridTracking.DataSource = LeadsActivityLog.GetLeadsActivityLogs(bble, categories)
            gridTracking.DataBind()
        End If
    End Sub

    Public Sub BindData(bble As String)
        hfBBLE.Value = bble

        If ActivityLogProvider IsNot Nothing Then
            gridTracking.DataSource = ActivityLogProvider.LogDataSource(bble)

            If ActivityLogProvider.LogCategoryFilter IsNot Nothing Then

                cbCateLog.Items.Clear()
                For Each cate In ActivityLogProvider.LogCategoryFilter
                    cbCateLog.Items.Add(cate.ToString)
                Next

                cbCateLog.Items(0).Selected = True
            End If
        Else
            Select Case DisplayMode
                Case ActivityLogMode.ShortSale
                    Dim appId = Employee.CurrentAppId
                    Dim ssLogs = LeadsActivityLog.GetLeadsActivityLogs(bble, {LeadsActivityLog.LogCategory.ShortSale.ToString, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.LogCategory.Task.ToString, LeadsActivityLog.LogCategory.PublicUpdate.ToString})
                    gridTracking.DataSource = ssLogs.Where(Function(log) log.AppId = appId).ToList
                Case ActivityLogMode.Legal
                    gridTracking.DataSource = LeadsActivityLog.GetLeadsActivityLogs(bble, {LeadsActivityLog.LogCategory.ShortSale.ToString, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.LogCategory.Eviction.ToString, LeadsActivityLog.LogCategory.PublicUpdate.ToString})
                Case ActivityLogMode.Construction
                    gridTracking.DataSource = LeadsActivityLog.GetLeadsActivityLogs(bble, {LeadsActivityLog.LogCategory.Construction.ToString, LeadsActivityLog.LogCategory.PublicUpdate.ToString})
                Case ActivityLogMode.Eviction
                    gridTracking.DataSource = LeadsActivityLog.GetLeadsActivityLogs(bble, {LeadsActivityLog.LogCategory.Eviction.ToString, LeadsActivityLog.LogCategory.PublicUpdate.ToString})
                Case Else
                    gridTracking.DataSource = LeadsActivityLog.GetLeadsActivityLogs(bble, Nothing)
            End Select
        End If

        gridTracking.DataBind()
    End Sub

    Public Sub BindFilter()

    End Sub

    Sub BindEmpList()
        Using Context As New Entities
            'cbEmps.DataSource = Context.Employees.ToList
            'cbEmps.DataBind()

            Dim lbEmps = TryCast(empsDropDownEdit.FindControl("tabPageEmpSelect").FindControl("lbEmps"), ASPxListBox)
            lbEmps.DataSource = Employee.GetAllActiveEmps(Employee.CurrentAppId)
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

        LeadsActivityLog.AddActivityLog(getdate, txtComments.Text, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.Comments)
        'AddActivityLog(aspxdate.Date, txtComments.Text, hfBBLE.Value, LeadsActivityLog.LogCategory.SalesAgent.ToString)
        e.Cancel = True

        BindData(hfBBLE.Value)
    End Sub

    'Public Function AddActivityLog2(logDate As DateTime, comments As String, bble As String, category As String) As LeadsActivityLog
    '    Using Context As New Entities
    '        Dim log As New LeadsActivityLog
    '        log.BBLE = bble
    '        log.EmployeeID = CInt(Membership.GetUser(Page.User.Identity.Name).ProviderUserKey)
    '        log.EmployeeName = Page.User.Identity.Name
    '        log.Category = category
    '        log.ActivityDate = logDate
    '        log.Comments = comments

    '        Context.LeadsActivityLogs.Add(log)
    '        Context.SaveChanges()

    '        Return log
    '    End Using
    'End Function

    Protected Sub gridTracking_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gridTracking.CustomCallback
        If (e.Parameters = "Task") Then
            SetAsTask()
            BindData(hfBBLE.Value)
        End If

        If e.Parameters.StartsWith("Filter") Then
            Dim categories = e.Parameters.Split("|")(1)
            gridTracking.FilterExpression = ""
            BindLogsByCategories(hfBBLE.Value, categories.Split(";"))

            Return
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
                    task.CompleteBy = Page.User.Identity.Name
                    task.CompleteDate = DateTime.Now
                    Context.SaveChanges()
                End If

                LeadsActivityLog.AddActivityLog(DateTime.Now, "Task is completed by " & Page.User.Identity.Name, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.SetAsTask)

                CompleteWorklistItem(task.TaskID)
            End Using

            BindData(hfBBLE.Value)
        End If

        'Approve User Task
        If e.Parameters.StartsWith("ApprovalTask") Then
            Dim logId = CInt(e.Parameters.Split("|")(1))
            Dim result = e.Parameters.Split("|")(2)
            Dim task = UserTask.GetTaskByLogID(logId)

            Dim comments = task.Action & " is " & result & " by " & Page.User.Identity.Name

            If Not String.IsNullOrEmpty(EmailBody2.Html) Then
                comments = comments + "<br /> Comments: " & EmailBody2.Html
            End If

            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.SetAsTask)

            If result = "Approved" Then
                task.Status = UserTask.TaskStatus.Approved
            Else
                task.Status = UserTask.TaskStatus.Declined
            End If
            task.CompleteBy = Page.User.Identity.Name
            task.Comments = EmailBody2.Html
            task.ExecuteAction()
            CompleteWorklistItem(task.TaskID)

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
                    If lead Is Nothing Then
                        Throw New CallbackException("The leads was removed.")
                        Return
                    End If

                    lead.Status = LeadStatus.NewLead

                    Context.SaveChanges()

                    LeadsActivityLog.AddActivityLog(DateTime.Now, "New Lead is approved by " & Page.User.Identity.Name, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.Approved)

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

                    LeadsActivityLog.AddActivityLog(DateTime.Now, "New Lead is declined by " & Page.User.Identity.Name, log.BBLE, LogCategory.ToString, LeadsActivityLog.EnumActionType.Declined)

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

                    LeadsActivityLog.AddActivityLog(DateTime.Now, "The Leads status changes to new leads of " & Page.User.Identity.Name, log.BBLE, LogCategory.ToString, LeadsActivityLog.EnumActionType.Reassign)

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

            Dim appointment = UserAppointment.UpdateAppointmentStatus(logId, UserAppointment.AppointmentStatus.Accepted)
            LeadsActivityLog.AddActivityLog(DateTime.Now, "Appointment is accepted by " & Page.User.Identity.Name, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.AcceptAppoitment)

            Dim sn = ""
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                sn = Request.QueryString("sn").ToString
            Else
                Dim wliItem = WorkflowService.GetUserAppointmentWorklist(appointment.AppoitID, Page.User.Identity.Name)
                If wliItem IsNot Nothing Then
                    sn = String.Format("{0}_{1}", wliItem.ProcInstId, wliItem.ActInstId)
                End If
            End If

            'Connect to Workflow Server
            If Not String.IsNullOrEmpty(sn) Then
                Dim wli = WorkflowService.LoadTaskProcess(sn)
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

            Dim appointment = UserAppointment.UpdateAppointmentStatus(logId, UserAppointment.AppointmentStatus.Declined)
            LeadsActivityLog.AddActivityLog(DateTime.Now, "Appointment is Decline by " & Page.User.Identity.Name, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.DeclineAppointment)

            Dim sn = ""
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                sn = Request.QueryString("sn").ToString
            Else
                Dim wliItem = WorkflowService.GetUserAppointmentWorklist(appointment.AppoitID, Page.User.Identity.Name)
                If wliItem IsNot Nothing Then
                    sn = String.Format("{0}_{1}", wliItem.ProcInstId, wliItem.ActInstId)
                End If
            End If

            'Connect to Workflow Server
            If Not String.IsNullOrEmpty(sn) Then
                Dim wli = WorkflowService.LoadTaskProcess(sn)
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

            Dim appointment = UserAppointment.UpdateAppointmentStatus(logId, UserAppointment.AppointmentStatus.ReScheduled)
            LeadsActivityLog.AddActivityLog(DateTime.Now, "Appointment is Rescheduled by " & Page.User.Identity.Name, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.Reschedule)

            Dim sn = ""
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                sn = Request.QueryString("sn").ToString
            Else
                Dim wliItem = WorkflowService.GetUserAppointmentWorklist(appointment.AppoitID, Page.User.Identity.Name)
                If wliItem IsNot Nothing Then
                    sn = String.Format("{0}_{1}", wliItem.ProcInstId, wliItem.ActInstId)
                End If
            End If

            'Connect to Workflow Server
            If Not String.IsNullOrEmpty(sn) Then
                Dim wli = WorkflowService.LoadTaskProcess(sn)
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
                Dim recycle = Core.RecycleLead.GetInstanceByLogId(logId)

                Dim sn = ""
                If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                    sn = Request.QueryString("sn").ToString
                Else
                    Dim wliItem = WorkflowService.GetUserRecycleWorklist(recycle.RecycleId, Page.User.Identity.Name)
                    If wliItem IsNot Nothing Then
                        sn = String.Format("{0}_{1}", wliItem.ProcInstId, wliItem.ActInstId)
                    End If
                End If

                If Not String.IsNullOrEmpty(sn) Then
                    Dim wli = WorkflowService.LoadTaskProcess(sn)
                    If wli IsNot Nothing Then
                        wli.ProcessInstance.DataFields("Result") = "Completed"
                        wli.Finish()

                        Dim rDate = recycle.PostponeDays(days)

                        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("Recycle action is postponed to {0} by {1} ", rDate.ToShortDateString, Page.User.Identity.Name), hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.ExtendRecycle)
                    End If
                End If
            End If

            BindData(hfBBLE.Value)
        End If

        If e.Parameters.StartsWith("ShowArchieved") Then
            Dim logs = LeadsActivityLog.GetLeadsActivityLogWithArchieved(hfBBLE.Value)
            gridTracking.DataSource = logs
            gridTracking.DataBind()
        End If
    End Sub

    Public Function ShowArchieveBox() As Boolean

        If Not String.IsNullOrEmpty(hfBBLE.Value) Then
            If LogCategory = LeadsActivityLog.LogCategory.SalesAgent Then
                If Page.User.IsInRole("Admin") Then
                    If Lead.HasArchieved(hfBBLE.Value) Then
                        Return True
                    End If
                End If
            End If
        End If

        Return False
    End Function

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

        Dim taskId = CreateTask(employees, cbTaskImportant.Text, cbTaskAction.Text, txtTaskDes.Text, hfBBLE.Value, Page.User.Identity.Name)

        Dim emps = employees.Split(";").Distinct.ToArray
        Dim upData = Employee.GetProfile(Page.User.Identity.Name)
        Dim ld = LeadsInfo.GetInstance(hfBBLE.Value)

        Dim taskName = String.Format("{0} {1}", cbTaskAction.Text, ld.StreetNameWithNo)
        If DisplayMode = ActivityLogMode.Leads Then
            WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text, "", "/ViewLeadsInfo.aspx")
        ElseIf DisplayMode = ActivityLogMode.ShortSale Then
            WorkflowService.StartTaskProcess("ShortSaleTask", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text)
        ElseIf DisplayMode = ActivityLogMode.Legal Then
            WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text, "", "/LegalUI/LegalUI.aspx")
        ElseIf DisplayMode = ActivityLogMode.Construction Then
            WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text, "", "/Construction/ConstructionUI.aspx")
        ElseIf DisplayMode = ActivityLogMode.Title
            WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, ld.BBLE, employees, cbTaskImportant.Text, "", "/BusinessForm/Default.aspx")
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

        Dim taskId = CreateTask(employees, taskPriority, taskAction, taskDescription, bble, createUser)

        Dim ld = LeadsInfo.GetInstance(bble)
        Dim taskName = String.Format("{0} {1}", taskAction, ld.StreetNameWithNo)
        WorkflowService.StartTaskProcess("TaskProcess", taskName, taskId, bble, employees, taskPriority, "", "/ViewLeadsinfo.aspx")
    End Sub

    Public Sub SetAsReminder(employees As String, taskPriority As String, taskAction As String, taskDescription As String, bble As String, createUser As String)
        Dim taskId = CreateTask(employees, taskPriority, taskAction, taskDescription, bble, createUser)

        Dim ld = LeadsInfo.GetInstance(bble)
        Dim taskName = String.Format("{0} {1}", taskAction, ld.StreetNameWithNo)
        WorkflowService.StartTaskProcess("ReminderProcess", taskName, taskId, bble, employees, taskPriority)
    End Sub

    Private Function CreateTask(employees As String, taskPriority As String, taskAction As String, taskDescription As String, bble As String, createUser As String) As Integer
        Dim tk = Lead.CreateTask(employees, taskPriority, taskAction, taskDescription, bble, createUser, LogCategory)

        If tk IsNot Nothing Then
            Return tk.TaskID
        End If

        Return 0

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
        'Dim emp = Employee.GetInstance(createUser)
        'Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LogCategory.ToString, emp.EmployeeID, createUser, LeadsActivityLog.EnumActionType.SetAsTask)
        'Dim task = UserTask.AddUserTask(bble, employees, taskAction, taskPriority, "In Office", scheduleDate, taskDescription, log.LogID, createUser)
        'Return task.TaskID
    End Function

    Function GetCommentsIconClass(type As String)
        If String.IsNullOrEmpty(type) Then
            Return GetIcon("activity_green_bg", "fa fa-info")
        End If

        If CommentIconList.ContainsKey(type) Then
            Return CommentIconList(type)
        Else
            Return GetIcon("activity_green_bg", "fa fa-info")
        End If
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

    Protected Sub gridTracking_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridViewTableRowEventArgs) Handles gridTracking.HtmlRowPrepared
        If Not e.RowType = DevExpress.Web.GridViewRowType.Data Then
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
                    Else

                    End If
                Else
                    cbRecycleDays.Visible = False
                    ltRecycleDays.Visible = True
                    ltRecycleDays.Text = If(recyle IsNot Nothing, CType(recyle.Status, Core.RecycleLead.RecycleStatus).ToString, "")
                End If
            End If
        End If

        Dim action = CType(e.GetValue("ActionType"), LeadsActivityLog.EnumActionType)

        If category = "Task" OrElse action = LeadsActivityLog.EnumActionType.SetAsTask Then
            If e.GetValue("LogID") IsNot Nothing Then
                Dim logId = CInt(e.GetValue("LogID"))

                Dim task = UserTask.GetTaskByLogID(logId)
                Dim pnlTask = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlTask"), Panel)

                Dim btnTaskComplete = TryCast(pnlTask.FindControl("btnTaskComplete"), HtmlControl)
                Dim btnResend = TryCast(pnlTask.FindControl("btnResend"), HtmlControl)
                Dim btnTaskApprove = TryCast(pnlTask.FindControl("btnTaskApprove"), HtmlControl)
                Dim btnTaskDecline = TryCast(pnlTask.FindControl("btnTaskDecline"), HtmlControl)

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
                                    If task.TaskMode = UserTask.UserTaskMode.Approval Then
                                        btnTaskApprove.Visible = True
                                        btnTaskDecline.Visible = True
                                    Else
                                        If btnTaskComplete IsNot Nothing Then
                                            btnTaskComplete.Visible = True
                                        End If

                                        If btnResend IsNot Nothing Then
                                            btnResend.Visible = True
                                        End If
                                    End If

                                    approvalView = True
                                End If
                            End If
                        End If
                    Else
                        If task.CreateDate < DateTime.Parse("2014-12-31 12:59") OrElse task.EmployeeName.ToLower.Contains(Page.User.Identity.Name.ToLower) Then
                            If task.TaskMode = UserTask.UserTaskMode.Approval Then
                                btnTaskApprove.Visible = True
                                btnTaskDecline.Visible = True
                            Else
                                If btnTaskComplete IsNot Nothing Then
                                    btnTaskComplete.Visible = True
                                End If

                                If btnResend IsNot Nothing Then
                                    btnResend.Visible = True
                                End If
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
                            Case UserTask.TaskStatus.Approved
                                ltTaskResult.Text = "Approved"
                            Case UserTask.TaskStatus.Declined
                                ltTaskResult.Text = "Declined"
                        End Select
                    End If
                End If
            End If
        End If

        If category = "Appointment" OrElse action = LeadsActivityLog.EnumActionType.Appointment Then
            Dim logId = CInt(e.GetValue("LogID"))
            Dim userAppoint = UserAppointment.GetAppointmentBylogID(logId)

            Dim pnlAppointment = TryCast(gridTracking.FindRowCellTemplateControl(e.VisibleIndex, gridTracking.Columns("Comments"), "pnlAppointment"), Panel)
            pnlAppointment.Visible = True
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
                        If userAppoint.CreateDate < DateTime.Parse("2014-12-31 12:59") OrElse userAppoint.Manager.ToLower.Contains(Page.User.Identity.Name.ToLower) Then
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

    Protected Sub gridTracking_AfterPerformCallback(sender As Object, e As DevExpress.Web.ASPxGridViewAfterPerformCallbackEventArgs)
        If Not String.IsNullOrEmpty(hfBBLE.Value) Then
            If e.CallbackName = "REFRESH" Then
                'BindData(hfBBLE.Value)
            End If
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

    Protected Sub addCommentsCallback_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        If String.IsNullOrEmpty(e.Parameter) Then
            Return
        End If

        Dim updateLevel = e.Parameter.Split("|")(0)

        Dim logCategoryStr = LogCategory.ToString
        If updateLevel = "Public" Then
            logCategoryStr = LeadsActivityLog.LogCategory.PublicUpdate.ToString
        End If

        Dim aspxdate As DateTime

        If Not DateTime.TryParse(e.Parameter.Split("|")(1), aspxdate) Then
            aspxdate = DateTime.Now
        End If

        'Dim aspxdate = CDate(e.Parameter.Split("|")(0))

        Dim txtComments = EmailBody2.Html 'e.Parameter.Split("|")(1)

        If aspxdate.Date = DateTime.Now.Date Then
            aspxdate = DateTime.Now
        End If

        If aspxdate < DateTime.Now Then
            aspxdate = aspxdate.Date
        End If

        If String.IsNullOrEmpty(txtComments) Then
            Throw New Exception("Comments can not be empty.")
        End If

        If ActivityLogProvider IsNot Nothing Then
            If ActivityLogProvider.AddComments(hfBBLE.Value, txtComments, Page.User.Identity.Name) Then
                Return
            End If
        End If

        Select Case DisplayMode
            Case ActivityLogMode.ShortSale
                aspxdate = DateTime.Now
                Dim typeOfUpdate = e.Parameter.Split("|")(2)
                Dim statusOfUpdate = e.Parameter.Split("|")(3)
                Dim category = e.Parameter.Split("|")(4)

                If Not String.IsNullOrEmpty(typeOfUpdate) Then
                    If category = "Assign" AndAlso Not ShortSaleManage.IsShortSaleManager(Page.User.Identity.Name) Then
                        Dim taskData = New With {
                            .TypeofUpdate = typeOfUpdate,
                            .Category = category,
                            .StatusUpdate = statusOfUpdate,
                            .Reviewer = Nothing}

                        Dim assignComments = String.Format("{0} want to change {1} status to {2} - {3}. Please Approval. <br /> Comments: {4}", Page.User.Identity.Name, typeOfUpdate, category, statusOfUpdate, txtComments)

                        Dim emp = Employee.GetInstance(Page.User.Identity.Name)
                        Dim reviewer = If(emp IsNot Nothing, emp.Manager, Nothing)
                        taskData.Reviewer = reviewer

                        ShortSaleManage.AssignProcess.ProcessStart(hfBBLE.Value, taskData.ToJsonString, Page.User.Identity.Name, assignComments, reviewer)

                        'Start AssignUpdate process

                        'Dim users = Roles.GetUsersInRole("ShortSale-AssignReviewer")
                        'If users IsNot Nothing AndAlso users.Count > 0 Then
                        '    ShortSaleCase.ReassignOwner(hfBBLE.Value, users(0))
                        'End If
                    Else
                        If Not String.IsNullOrEmpty(statusOfUpdate) Then
                            RaiseEvent MortgageStatusUpdateEvent(typeOfUpdate, statusOfUpdate, category, hfBBLE.Value)
                        End If

                        Dim comments = String.Format("Type of Update: {0}", typeOfUpdate)

                        If Not String.IsNullOrEmpty(category) AndAlso Not String.IsNullOrEmpty(statusOfUpdate) Then
                            comments = comments & String.Format("<br />Status Update: {0} - {1}", category, statusOfUpdate)
                        End If

                        If dtFollowup.Date > DateTime.Now Then
                            comments = comments & String.Format("<br />Follow Up Date: {0:d}", dtFollowup.Date)
                            Dim ssCase = ShortSaleCase.GetCaseByBBLE(hfBBLE.Value)
                            ssCase.SaveFollowUp(dtFollowup.Date)
                        End If

                        If Not String.IsNullOrEmpty(txtComments) Then
                            comments = comments & "<br />" & txtComments
                        End If

                        LeadsActivityLog.AddActivityLog(aspxdate, comments, hfBBLE.Value, logCategoryStr, LeadsActivityLog.EnumActionType.Comments)

                        'ShortSale.ShortSaleActivityLog.AddLog(hfBBLE.Value, Page.User.Identity.Name, typeOfUpdate, category & " - " & statusOfUpdate, txtComments)
                        ShortSaleManage.AddActivityLog(hfBBLE.Value, Page.User.Identity.Name, typeOfUpdate, category, statusOfUpdate, txtComments)

                    End If
                Else
                    LeadsActivityLog.AddActivityLog(aspxdate, txtComments, hfBBLE.Value, logCategoryStr, LeadsActivityLog.EnumActionType.Comments)
                    ShortSale.ShortSaleActivityLog.AddLog(hfBBLE.Value, Page.User.Identity.Name, "Comments", "Comments", txtComments, Employee.CurrentAppId)
                End If
            Case ActivityLogMode.Legal, ActivityLogMode.Construction, ActivityLogMode.Eviction

                LeadsActivityLog.AddActivityLog(aspxdate, txtComments, hfBBLE.Value, logCategoryStr, LeadsActivityLog.EnumActionType.Comments)

            Case Else
                LeadsActivityLog.AddActivityLog(aspxdate, txtComments, hfBBLE.Value, logCategoryStr, LeadsActivityLog.EnumActionType.Comments)

                'Notify leads owner messager 
                Dim ld = Lead.GetInstance(hfBBLE.Value)
                If ld IsNot Nothing AndAlso Not ld.EmployeeName.ToLower = Page.User.Identity.Name.ToLower Then
                    Dim comments = String.Format("{0} just added new comments on {1}", Page.User.Identity.Name, ld.LeadsName)
                    UserMessage.AddNewMessage(ld.EmployeeName, "New Comments", comments, hfBBLE.Value)
                End If
        End Select

        'BindData(hfBBLE.Value)
    End Sub

    Protected Sub addLogsCallback_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Dim comments = e.Parameter
        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.Comments)
    End Sub

    'Set as task popup call back
    Protected Sub ASPxPopupControl1_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        Dim popup = CType(source, ASPxPopupControl)

        PopupContentSetAsTask.Visible = True
        hfResend.Value = ""
        BindEmpList()
        If e.Parameter.StartsWith("Show") Then
            If ActivityLogProvider IsNot Nothing Then
                Me.cbTaskAction.DataSource = ActivityLogProvider.TaskActionList
                Me.cbTaskAction.DataBind()
            End If
        End If

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
                task.CompleteBy = Page.User.Identity.Name
                task.CompleteDate = DateTime.Now
                task.Comments = "Resend"
                Context.SaveChanges()
            End If

            CompleteWorklistItem(task.TaskID)

            'Dim sn = ""
            'If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            '    sn = Request.QueryString("sn").ToString
            'Else
            '    Dim wliItem = WorkflowService.GetUserTaskWorklist(task.TaskID, Page.User.Identity.Name)
            '    If wliItem IsNot Nothing Then
            '        sn = String.Format("{0}_{1}", wliItem.ProcInstId, wliItem.ActInstId)
            '    End If
            'End If

            'If Not String.IsNullOrEmpty(sn) Then
            '    Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn").ToString)
            '    wli.ProcessInstance.DataFields("Result") = "Completed"
            '    wli.Finish()
            'End If

            LeadsActivityLog.AddActivityLog(DateTime.Now, "Task is Resend by " & Page.User.Identity.Name, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.SetAsTask)
        End Using
    End Sub

    Public ReadOnly Property LogCategory As LeadsActivityLog.LogCategory
        Get
            If ActivityLogProvider IsNot Nothing Then
                Return ActivityLogProvider.LogCategory
            End If

            Select Case DisplayMode
                Case ActivityLogMode.Leads
                    Return LeadsActivityLog.LogCategory.SalesAgent
                Case ActivityLogMode.ShortSale
                    Return LeadsActivityLog.LogCategory.ShortSale
                Case ActivityLogMode.Legal
                    Return LeadsActivityLog.LogCategory.Legal
                Case ActivityLogMode.Construction
                    Return LeadsActivityLog.LogCategory.Construction
                Case ActivityLogMode.Eviction
                    Return LeadsActivityLog.LogCategory.Eviction
                Case Else
                    Return LeadsActivityLog.LogCategory.SalesAgent
            End Select
        End Get
    End Property


    Public Enum ActivityLogMode
        Leads
        ShortSale
        Legal
        Construction
        Eviction
        Title
    End Enum

    Protected Sub EmailBody2_Load(sender As Object, e As EventArgs)
        If Not Page.IsPostBack Then
            Dim htmlEditor = CType(sender, ASPxHtmlEditor)
            If htmlEditor.Toolbars.Count = 0 Then
                htmlEditor.Toolbars.Add(Utility.CreateCustomToolbar("Custom"))
            End If

            If DisplayMode = ActivityLogMode.ShortSale Then
                htmlEditor.Height = 220
            End If
        End If
    End Sub

    Protected Sub callbackGetEmployeesByAction_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
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

    Protected Sub ASPxPopupControl2_WindowCallback(source As Object, e As PopupWindowCallbackArgs)
        popupContentBpo.Visible = True

        If e.Parameter.StartsWith("Add") Then
            Dim bble = hfBBLE.Value
            Dim propValue As New PropertyValueInfo
            propValue.BBLE = bble
            propValue.Method = cbMethods.Text
            propValue.BankValue = CDec(txtBankValue.Text)
            propValue.DateOfValue = CDate(txtDateofValue.Value)
            propValue.ExpiredOn = CDate(txtExpiredDate.Value)

            propValue.Save()

            Dim comments = String.Format("Value Info: {0}, {1} - {2}, Expired on {3}", propValue.Method, String.Format("{0:C0}", propValue.BankValue),
                                         String.Format("{0:d}", propValue.DateOfValue), String.Format("{0:d}", propValue.ExpiredOn))

            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LogCategory.ToString, LeadsActivityLog.EnumActionType.Comments)

            cbMethods.Text = ""
            txtBankValue.Text = ""
            txtDateofValue.Value = ""
            txtExpiredDate.Value = ""
        End If
    End Sub

    Protected Sub popupPreviousNotes_WindowCallback(source As Object, e As PopupWindowCallbackArgs)
        popupCtontrlPreviousNotes.Visible = True
        gvPreviousNotes.DataSource = ShortSaleActivityLog.GetLogs(hfBBLE.Value, Employee.CurrentAppId)
        gvPreviousNotes.DataBind()
    End Sub

    Protected Sub gvPreviousNotes_DataBinding(sender As Object, e As EventArgs)
        If gvPreviousNotes.DataSource Is Nothing AndAlso gvPreviousNotes.IsCallback Then
            gvPreviousNotes.DataSource = ShortSaleActivityLog.GetLogs(hfBBLE.Value, Employee.CurrentAppId)
        End If
    End Sub

    Protected Sub cmbStatus_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)

    End Sub

    Private Sub CompleteWorklistItem(taskId As Integer)
        Dim sn = ""
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            sn = Request.QueryString("sn").ToString
        Else
            Dim wliItem = WorkflowService.GetUserTaskWorklist(taskId, Page.User.Identity.Name)
            If wliItem IsNot Nothing Then
                sn = String.Format("{0}_{1}", wliItem.ProcInstId, wliItem.ActInstId)
            End If
        End If

        If Not String.IsNullOrEmpty(sn) Then
            Dim wli = WorkflowService.LoadTaskProcess(sn)
            If wli IsNot Nothing Then
                wli.ProcessInstance.DataFields("Result") = "Completed"
                wli.Finish()
            End If
        End If
    End Sub

    Protected Sub aspxPopupSchedule_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        popupContentSchedule.Visible = True
        cbMgr.DataBind()
        If Not String.IsNullOrEmpty(e.Parameter) Then
            If (e.Parameter.StartsWith("Clear")) Then
                ClearSchedulePopup()
            End If

            If e.Parameter.StartsWith("BindAppointment") Then
                Dim logId = CInt(e.Parameter.Split("|")(1))

                If logId > 0 Then
                    If HiddenFieldLogId.Contains("logId") Then
                        HiddenFieldLogId.Set("logId", logId)
                    Else
                        HiddenFieldLogId.Add("logId", logId)
                    End If

                    Using Context As New Entities
                        Dim appoint = Context.UserAppointments.Where(Function(ua) ua.LogID = logId).SingleOrDefault

                        If appoint IsNot Nothing Then
                            cbScheduleType.Text = appoint.Type
                            dateEditSchedule.Date = appoint.ScheduleDate
                            txtLocation.Text = appoint.Location
                            cbMgr.Text = appoint.Manager
                            txtScheduleDescription.Text = appoint.Description
                        End If
                    End Using
                End If
            End If

            If e.Parameter.StartsWith("Schedule") Then
                CreateAppointment()
                ClearSchedulePopup()
            End If
        End If
    End Sub

    Private Sub CreateAppointment()
        Dim comments = String.Format("<table style=""width:100%;line-weight:25px;"">" &
                                      "<tr><td>Type</td><td>{4}</td></tr>" &
                                     " <tr><td>Date Time:</td>" &
                             "<td>{0}</td></tr>" &
                             "<tr><td>Location:</td><td>{1}</td></tr>" &
                             "<tr><td>Manager:</td><td>{2}</td></tr>" &
                           "<tr><td>Comments:</td><td>{3}</td></tr>" &
                           "</table>", dateEditSchedule.Date, txtLocation.Text, cbMgr.Text, txtScheduleDescription.Text, cbScheduleType.Text)
        Dim emps = Page.User.Identity.Name & ";" & cbMgr.Text
        Dim subject As String = "Appointment of " + hfBBLE.Value
        Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LogCategory.ToString, LeadsActivityLog.EnumActionType.Appointment)

        Dim ld = Lead.GetInstance(hfBBLE.Value)

        Dim userAppoint As New UserAppointment
        userAppoint.BBLE = hfBBLE.Value
        userAppoint.Subject = String.Format("Appointment of {0}", ld.LeadsName)
        userAppoint.Type = cbScheduleType.Text
        userAppoint.ScheduleDate = dateEditSchedule.Date

        If cbScheduleType.Text = "Signing" Then
            userAppoint.EndDate = dateEditSchedule.Date.AddMinutes(90)
        Else
            userAppoint.EndDate = dateEditSchedule.Date.AddMinutes(30)
        End If

        userAppoint.Location = txtLocation.Text
        userAppoint.Manager = cbMgr.Text
        userAppoint.Agent = ld.EmployeeName
        userAppoint.Description = txtScheduleDescription.Text
        userAppoint.Status = UserAppointment.AppointmentStatus.NewAppointment
        userAppoint.LogID = log.LogID
        userAppoint.NewAppointment()

        Dim needApproval = False
        Dim approvers = New List(Of String)
        'Add Message
        If Not cbMgr.Value = "*" And Not cbMgr.Value = "" Then
            If cbMgr.Value <> Page.User.Identity.Name Then
                Dim title = String.Format("A New Appointment has been created by {0} regarding {1} for {2}", Page.User.Identity.Name, cbScheduleType.Text, ld.LeadsName)
                UserMessage.AddNewMessage(cbMgr.Value, title, comments, hfBBLE.Value)
                approvers.Add(cbMgr.Value)
                'WorkflowService.StartNewAppointmentProcess(ld.LeadsName, ld.BBLE, userAppoint.AppoitID, cbMgr.Value)
                needApproval = True
            End If
        End If

        If Not Page.User.Identity.Name = ld.EmployeeName Then
            Dim title = String.Format("A New Appointment has been created by {0} regarding {1} for {2}", Page.User.Identity.Name, cbScheduleType.Text, ld.LeadsName)
            UserMessage.AddNewMessage(ld.EmployeeName, title, comments, hfBBLE.Value)
            approvers.Add(ld.EmployeeName)
            needApproval = True
        End If

        'Appointment set by agent self
        If Not needApproval Then
            UserAppointment.UpdateAppointmentStatus(log.LogID, UserAppointment.AppointmentStatus.Accepted)
        Else
            If approvers.Count > 0 Then
                Dim name = String.Format("{0} {1}", userAppoint.Type, LeadsInfo.GetInstance(ld.BBLE).StreetNameWithNo)
                WorkflowService.StartNewAppointmentProcess(name, ld.BBLE, userAppoint.AppoitID, String.Join(";", approvers.ToArray))
            End If
        End If

        If LogCategory = LeadsActivityLog.LogCategory.SalesAgent Then
            'Update status to Priority
            UpdateLeadStatus(hfBBLE.Value, LeadStatus.Priority, Nothing)
        End If
    End Sub

    Sub UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime)
        Lead.UpdateLeadStatus(bble, status, callbackDate)
    End Sub

    Private Sub ClearSchedulePopup()
        HiddenFieldLogId.Clear()
        cbScheduleType.Text = ""
        dateEditSchedule.Date = DateTime.Today
        txtLocation.Text = ""
        cbMgr.Text = ""
        txtScheduleDescription.Text = ""
    End Sub


    Protected Sub cbMgr_DataBinding(sender As Object, e As EventArgs)
        If cbMgr.Items.Count <= 0 Then
            Dim managerDataScorce = Employee.GetEmpOfficeManagers(Page.User.Identity.Name).Where(Function(n) n <> Page.User.Identity.Name).Distinct.ToList
            Dim dataScorce = managerDataScorce.Select(Function(l) New With {.Text = l, .Value = l}).ToList
            dataScorce.Insert(0, New With {.Text = "Any Manager", .Value = "*"})
            dataScorce.Add(New With {.Text = "No Manager Needed", .Value = ""})
            For Each it In dataScorce
                cbMgr.Items.Add(New ListEditItem(it.Text, it.Value))
            Next
        End If
    End Sub

    Protected Sub gridTracking_DataBinding(sender As Object, e As EventArgs)
        If gridTracking.IsCallback AndAlso gridTracking.DataSource Is Nothing Then
            If hfBBLE.Value IsNot Nothing Then
                BindData(hfBBLE.Value)
            End If
        End If
    End Sub


End Class
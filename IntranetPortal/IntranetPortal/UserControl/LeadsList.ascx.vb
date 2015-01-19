Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxTabControl
Imports DevExpress.Web.ASPxCallbackPanel

Public Class LeadsList
    Inherits System.Web.UI.UserControl

    Public Property LeadsListView As ControlView = ControlView.UserView
    Public Property OfficeName As String
    Public Property TeamMgr As String
    Public Property TeamId As Integer

    ' Dim CategoryName As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Sub BindLeadsListMgr(category As LeadStatus, mgrName As String)

        If String.IsNullOrEmpty(mgrName) Then
            Return
        End If

        Using Context As New Entities
            Dim subOridates = Employee.GetManagedEmployees(mgrName)

            If category = LeadStatus.InProcess Then
                subOridates = Employee.GetManagedEmployees(mgrName, False)
                Dim leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeName) And e.Status = category).ToList.OrderByDescending(Function(e) e.LastUpdate)
                gridLeads.DataSource = leads
                gridLeads.DataBind()

            Else
                Dim leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeName) And e.Status = category).ToList.OrderByDescending(Function(e) e.LastUpdate)
                gridLeads.DataSource = leads
                gridLeads.DataBind()

            End If
        End Using

        If Not Page.IsPostBack Then
            If category = LeadStatus.Callback Then
                gridLeads.GroupBy(gridLeads.Columns("CallbackDate"))
                gridLeads.ExpandAll()
            Else
                gridLeads.UnGroup(gridLeads.Columns("CallbackDate"))
            End If

            If category = LeadStatus.DoorKnocks Then
                gridLeads.Columns("colSelect").Visible = True
                gridLeads.GroupBy(gridLeads.Columns("Neighborhood"))
                gridLeads.ClientSideEvents.FocusedRowChanged = ""
                gridLeads.ClientSideEvents.SelectionChanged = "OnGridLeadsSelectionChanged"

                'Show View Lead Menu
                LeadsSubMenu.PopupMenu.Items.FindByName("ViewLead").Visible = True
            Else
                gridLeads.Columns("colSelect").Visible = False
            End If

            gridLeads.GroupBy(gridLeads.Columns("EmployeeName"))
            divExpand.Visible = True

            'Show Manager Menu
            LeadsSubMenu.PopupMenu.Items.FindByName("Reassign").Visible = True
            'BindEmployeeList()
        End If
    End Sub

    Sub BindLeadsListMgr(category As LeadStatus)
        BindLeadsListMgr(category, Page.User.Identity.Name)
    End Sub

    Sub BindLeadsListByTeam(category As LeadStatus)
        If TeamId = 0 Then
            Return
        End If

        Using Context As New Entities
            Dim subOridates = Employee.GetTeamUsers(TeamId)

            Dim leads As Object

            If category = LeadStatus.InProcess Then
                subOridates = Employee.GetAllDeptUsers(OfficeName)
                leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeName) And e.Status = category).ToList.OrderByDescending(Function(e) e.LastUpdate)
            Else
                leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeName) And e.Status = category).ToList.OrderByDescending(Function(e) e.LastUpdate)
            End If

            gridLeads.DataSource = leads
            gridLeads.DataBind()
        End Using

        If Not Page.IsPostBack Then
            If category = LeadStatus.Callback Then
                gridLeads.GroupBy(gridLeads.Columns("CallbackDate"))
                gridLeads.ExpandAll()
            Else
                gridLeads.UnGroup(gridLeads.Columns("CallbackDate"))
            End If

            If category = LeadStatus.DoorKnocks Then
                gridLeads.Columns("colSelect").Visible = True
                gridLeads.GroupBy(gridLeads.Columns("Neighborhood"))
                gridLeads.ClientSideEvents.FocusedRowChanged = ""
                gridLeads.ClientSideEvents.SelectionChanged = "OnGridLeadsSelectionChanged"

                'Show View Lead Menu
                LeadsSubMenu.PopupMenu.Items.FindByName("ViewLead").Visible = True
            Else
                gridLeads.Columns("colSelect").Visible = False
            End If

            gridLeads.GroupBy(gridLeads.Columns("EmployeeName"))
            divExpand.Visible = True

            'Show Manager Menu
            LeadsSubMenu.PopupMenu.Items.FindByName("Reassign").Visible = True
        End If
    End Sub

    Sub BindLeadsListByOffice(category As LeadStatus)
        If String.IsNullOrEmpty(OfficeName) Then
            Return
        End If

        Using Context As New Entities
            Dim subOridates = Employee.GetDeptUsers(OfficeName)
            Dim leads As Object

            If category = LeadStatus.InProcess Then
                subOridates = Employee.GetAllDeptUsers(OfficeName)
                leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeName) And e.Status = category).ToList.OrderByDescending(Function(e) e.LastUpdate)
            Else
                leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeName) And e.Status = category).ToList.OrderByDescending(Function(e) e.LastUpdate)
            End If

            gridLeads.DataSource = leads
            gridLeads.DataBind()
        End Using

        If Not Page.IsPostBack Then
            If category = LeadStatus.Callback Then
                gridLeads.GroupBy(gridLeads.Columns("CallbackDate"))
                gridLeads.ExpandAll()
            Else
                gridLeads.UnGroup(gridLeads.Columns("CallbackDate"))
            End If

            If category = LeadStatus.DoorKnocks Then
                gridLeads.Columns("colSelect").Visible = True
                gridLeads.GroupBy(gridLeads.Columns("Neighborhood"))
                gridLeads.ClientSideEvents.FocusedRowChanged = ""
                gridLeads.ClientSideEvents.SelectionChanged = "OnGridLeadsSelectionChanged"

                'Show View Lead Menu
                LeadsSubMenu.PopupMenu.Items.FindByName("ViewLead").Visible = True
            Else
                gridLeads.Columns("colSelect").Visible = False
            End If

            gridLeads.GroupBy(gridLeads.Columns("EmployeeName"))
            divExpand.Visible = True

            'Show Manager Menu
            LeadsSubMenu.PopupMenu.Items.FindByName("Reassign").Visible = True

        End If
    End Sub

    Public Sub DisableClientEventOnLoad()
        gridLeads.SettingsBehavior.AllowClientEventsOnLoad = False
    End Sub

    Sub SearchLeadsList()
        Dim key = ""

        If Not String.IsNullOrEmpty(Request.QueryString("key")) Then
            key = Request.QueryString("key").ToString
        End If

        BindLeadsListByKey(key)

        gridLeads.Columns("EmployeeName").Visible = True
        gridLeads.Columns("Neighborhood").Visible = True

        gridLeads.Settings.ShowColumnHeaders = True
        gridLeads.Settings.ShowFilterRow = True

        Dim txtkeyword = TryCast(gridLeads.FindFilterRowTemplateControl("txtkeyword"), ASPxTextBox)
        If txtkeyword IsNot Nothing AndAlso txtkeyword.Text = "" Then
            txtkeyword.Text = key
        End If

        gridLeads.FocusedRowIndex = -1
        'Show Manager Menu
        LeadsSubMenu.PopupMenu.Items.FindByName("Reassign").Visible = True
        'BindEmployeeList()
    End Sub

    Sub BindLeadsListByKey(key As String)
        Using Context As New Entities
            Dim subOridates = Employee.GetSubOrdinate(Page.User.Identity.Name)

            Dim leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeID) And (e.LeadsName.Contains(key) Or e.BBLE.StartsWith(key))).ToList.OrderByDescending(Function(e) e.LastUpdate)
            gridLeads.DataSource = leads
            gridLeads.DataBind()
        End Using
    End Sub
    Sub BindLeadsColor()
        Using Context As New Entities
            Dim subOridates = Employee.GetSubOrdinate(Page.User.Identity.Name)

            Dim leads = Context.Leads.Where(Function(e) subOridates.Contains(e.EmployeeID)).OrderBy(Function(e) e.MarkColor).ToList
            gridLeads.DataSource = leads
            gridLeads.DataBind()
        End Using
    End Sub
    Sub BindSharedList()
        Using Context As New Entities
            Dim leads = (From lead In Context.Leads
                                      Join sharedItem In Context.SharedLeads.Where(Function(s) s.UserName = Page.User.Identity.Name).Distinct On sharedItem.BBLE Equals lead.BBLE
                                      Select lead).Distinct.ToList
            gridLeads.DataSource = leads
            gridLeads.DataBind()

            If Not Page.IsPostBack Then
                gridLeads.GroupBy(gridLeads.Columns("EmployeeName"))
            End If
        End Using
    End Sub

    Sub BindLeadsList(CategoryName As String)

        If CategoryName = "Call Back" Then
            lblLeadCategory.Text = "Follow Up"
        Else
            If CategoryName = "Priority" Then
                lblLeadCategory.Text = "Hot Leads"
            Else
                lblLeadCategory.Text = CategoryName
            End If
        End If

        If CategoryName = "Search" Then
            SearchLeadsList()
            Return
        End If

        If CategoryName = "Shared" Then
            BindSharedList()
            Return
        End If

        Dim category = Utility.GetLeadStatus(CategoryName)

        If CategoryName = "Create" AndAlso Not Page.IsCallback Then
            gridLeads.SettingsBehavior.AllowClientEventsOnLoad = False
            gridLeads.AddNewRow()
            lblLeadCategory.Text = "Create"
            Return
            'Show Delete Leads Menu
            'popupMenuLeads.Items.FindByName("Delete").Visible = True
        End If

        If LeadsListView = ControlView.OfficeView Or (Not String.IsNullOrEmpty(hfView.Value) And hfView.Value = "2") Then
            hfView.Value = ControlView.OfficeView
            BindLeadsListByOffice(category)
            Return
        End If

        If LeadsListView = ControlView.TeamView Or (Not String.IsNullOrEmpty(hfView.Value) And hfView.Value = "3") Then
            hfView.Value = ControlView.TeamView
            BindLeadsListMgr(category, TeamMgr)
            Return
        End If

        If LeadsListView = ControlView.TeamView2 Or (Not String.IsNullOrEmpty(hfView.Value) And hfView.Value = "4") Then
            hfView.Value = ControlView.TeamView2
            BindLeadsListByTeam(category)
            Return
        End If

        If LeadsListView = ControlView.ManagerView Then
            BindLeadsListMgr(category)
            Return
        End If

        Dim emps = Employee.GetSubOrdinateWithoutMgr(Page.User.Identity.Name)

        Dim newVersionDate = DateTime.Parse("2014-12-31")

        If CategoryName = "Task" Then
            Using Context As New Entities
                Dim leads = (From lead In Context.Leads
                                       Join task In Context.UserTasks On task.BBLE Equals lead.BBLE
                                       Where task.Status = UserTask.TaskStatus.Active And task.EmployeeName.Contains(Page.User.Identity.Name) And task.CreateDate < newVersionDate
                                       Select lead).Union(
                                       From al In Context.Leads
                                       Join appoint In Context.UserAppointments On appoint.BBLE Equals al.BBLE
                                       Where appoint.Status = UserAppointment.AppointmentStatus.NewAppointment And (appoint.Agent = Page.User.Identity.Name Or appoint.Manager = Page.User.Identity.Name) And appoint.CreateDate < newVersionDate
                                       Select al).Union(
                                       From lead In Context.Leads.Where(Function(ld) ld.Status = LeadStatus.MgrApproval And emps.Contains(ld.EmployeeID))
                                       Select lead
                                       ).Distinct.ToList.OrderByDescending(Function(ld) ld.LastUpdate2)

                ' ).Distinct.ToList
                'leads.AddRange((From lead In Context.Leads
                '                Join appoint In Context.UserAppointments On appoint.BBLE Equals lead.BBLE
                '                Where appoint.Status = UserAppointment.AppointmentStatus.NewAppointment And appoint.Agent = Page.User.Identity.Name
                '                Select lead).Distinct.ToList)

                gridLeads.DataSource = leads
                gridLeads.DataBind()
            End Using
        Else

            Using Context As New Entities
                gridLeads.DataSource = Context.Leads.Where(Function(ld) ld.Status = category And ld.EmployeeName = Page.User.Identity.Name).ToList.OrderByDescending(Function(e) e.LastUpdate2)
                gridLeads.DataBind()
            End Using
        End If

        If Not Page.IsPostBack Then
            SettingGridLeads(category)
        End If
    End Sub

    Public Sub SettingGridLeads(category As LeadStatus)
        If category = LeadStatus.Callback Then
            gridLeads.GroupBy(gridLeads.Columns("CallbackDate"))
            gridLeads.ExpandAll()
            divExpand.Visible = True
        Else
            gridLeads.UnGroup(gridLeads.Columns("CallbackDate"))
        End If

        If category = LeadStatus.DoorKnocks Then
            gridLeads.Columns("colSelect").Visible = True
            gridLeads.GroupBy(gridLeads.Columns("Neighborhood"))
            divExpand.Visible = True

            gridLeads.ClientSideEvents.FocusedRowChanged = ""
            gridLeads.ClientSideEvents.SelectionChanged = "OnGridLeadsSelectionChanged"

            'Show View Lead Menu
            LeadsSubMenu.PopupMenu.Items.FindByName("ViewLead").Visible = True
        Else
            gridLeads.Columns("colSelect").Visible = False
        End If
    End Sub

    Public Function GroupText(groupDateText As String) As String
        Dim today = DateTime.Now.Date
        Dim groupDate = Date.Parse(groupDateText)
        If today.Equals(groupDate) Then
            Return "Today"
        Else
            If today.AddDays(1).Equals(groupDate) Then
                Return "Tomorrow"
            Else
                Return groupDateText
            End If
        End If
    End Function

    Protected Sub gridLeads_CustomDataCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomDataCallbackEventArgs)

        e.Result = gridLeads.GetRowValues(CInt(e.Parameters), "BBLE")


        Return
    End Sub

    Protected Sub ASPxCallbackPanel1_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        'BindLeadsList("")
    End Sub

    Protected Sub gridLeads_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs) Handles gridLeads.RowInserting
        Dim pageRootControl = TryCast(gridLeads.FindEditFormTemplateControl("pageControlNewLeads"), ASPxPageControl)
        Dim lbNewBBLE = TryCast(pageRootControl.FindControl("lbNewBBLE"), ASPxListBox)
        Dim bble = TryCast(pageRootControl.FindControl("txtNewBBLE"), ASPxTextBox).Text
        Dim leadsName = TryCast(pageRootControl.FindControl("txtNewLeadsName"), ASPxTextBox).Text

        'Dim bble = lbNewBBLE.SelectedItem.GetValue("BBLE").ToString
        'Dim leadsName = lbNewBBLE.SelectedItem.GetValue("LeadsName").ToString

        If String.IsNullOrEmpty(bble.Trim) Then
            Throw New Exception("BBLE is not correct format! Please check.")
        End If

        Using Context As New Entities
            If Context.Leads.Where(Function(l) l.BBLE = bble).Count > 0 Then
                Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                Throw New Exception(String.Format("You cann't create this leads. Lead is already created by {0}. <a href=""#"" id=""linkRequestUpdate"" onclick=""OnRequestUpdate('{1}');return false;"">Request update?</a>", lead.EmployeeName, lead.BBLE))
            End If

            Dim lf As LeadsInfo = DataWCFService.UpdateAssessInfo(bble)
            DataWCFService.UpdateLeadInfo(bble)

            'Save Lead
            Dim ld = New Lead
            ld.BBLE = bble
            ld.LeadsName = lf.LeadsName
            ld.EmployeeID = Employee.GetInstance(Page.User.Identity.Name).EmployeeID
            ld.EmployeeName = Page.User.Identity.Name
            ld.Neighborhood = lf.NeighName
            ld.AssignDate = DateTime.Now
            ld.AssignBy = Page.User.Identity.Name

            If Employee.IsManager(Page.User.Identity.Name) Or Page.User.IsInRole("SeniorAgent") Then
                ld.Status = LeadStatus.NewLead

                Context.Leads.Add(ld)
                Context.SaveChanges()
            Else
                'use workflow engine to approval 
                ld.Status = LeadStatus.MgrApprovalInWf
                'ld.Status = LeadStatus.MgrApproval

                Context.Leads.Add(ld)
                Context.SaveChanges()

                'Add need approval logs
                Dim commtents = String.Format("{0} create a new lead (BBLE: {1}). Pending your approval.", Page.User.Identity.Name, bble)
                LeadsActivityLog.AddActivityLog(DateTime.Now, commtents, bble, LeadsActivityLog.LogCategory.Approval.ToString, LeadsActivityLog.EnumActionType.Approval)

                'Add notify message
                Dim mgr = Employee.GetReportToManger(Page.User.Identity.Name).Name

                WorkflowService.StartNewLeadsRequest(ld.LeadsName, bble, mgr)

                UserMessage.AddNewMessage(Page.User.Identity.Name, "New Lead", String.Format("The new lead {1} is waiting manager ({0}) approval.", mgr, bble), bble)
                UserMessage.AddNewMessage(mgr, "New Lead Approval", commtents, bble)
            End If

            e.Cancel = True
            gridLeads.CancelEdit()

            gridLeads.DataSource = Context.Leads.Where(Function(l) l.Status = LeadStatus.NewLead And l.EmployeeName = Page.User.Identity.Name).ToList.OrderByDescending(Function(l) l.LastUpdate2)
            gridLeads.DataBind()
        End Using
    End Sub

    Protected Sub pageControlNewLeads_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)

    End Sub

    Function GetBBLEData() As DataTable
        Dim pageRootControl = TryCast(gridLeads.FindEditFormTemplateControl("pageControlNewLeads"), ASPxPageControl)
        Dim pageInputData = TryCast(pageRootControl.FindControl("pageControlInputData"), ASPxPageControl)

        Using client As New DataAPI.WCFMacrosClient
            Dim dt = New DataTable
            dt.Columns.Add("BBLE")
            dt.Columns.Add("LeadsName")

            'Dim wdr = dt.NewRow
            'wdr(0) = "4065270030 "
            'wdr(1) = "25-29 96 ST - Chris"
            'dt.Rows.Add(wdr)

            'Return dt

            'Search by address
            If pageInputData.ActiveTabIndex = 0 Then
                Dim cbStreetlookup = TryCast(pageInputData.FindControl("cbStreetlookup"), ASPxComboBox)
                Dim cbStreetBorough = TryCast(pageInputData.FindControl("cbStreetBorough"), ASPxComboBox)
                Dim txtHouseNum = TryCast(pageInputData.FindControl("txtHouseNum"), ASPxTextBox)

                Dim streenAddress = client.NYC_Address_Search(cbStreetBorough.Value, txtHouseNum.Text, cbStreetlookup.Text)

                For Each item In streenAddress.ToList
                    Dim newdr = dt.NewRow
                    newdr(0) = item.BBLE
                    newdr(1) = String.Format("{0} {1} - {2}", item.NUMBER, item.ST_NAME, item.OWNER_NAME)
                    dt.Rows.Add(newdr)
                Next
            End If

            'Search by legal info
            If pageInputData.ActiveTabIndex = 1 Then
                Dim cblegalBorough = TryCast(pageInputData.FindControl("cblegalBorough"), ASPxComboBox)
                Dim txtlegalBlock = TryCast(pageInputData.FindControl("txtlegalBlock"), ASPxTextBox)
                Dim txtLegalLot = TryCast(pageInputData.FindControl("txtLegalLot"), ASPxTextBox)

                For Each item In client.NYC_Legal_Search(cblegalBorough.Value, txtlegalBlock.Text, txtLegalLot.Text)
                    Dim newdr = dt.NewRow
                    newdr(0) = item.BBLE
                    newdr(1) = String.Format("{0} {1} - {2}", item.NUMBER, item.ST_NAME, item.OWNER_NAME)
                    dt.Rows.Add(newdr)
                Next
            End If

            'Search by Owner
            If pageInputData.ActiveTabIndex = 2 Then
                Dim cbNameBorough = TryCast(pageInputData.FindControl("cbNameBorough"), ASPxComboBox)
                Dim txtNameFirst = TryCast(pageInputData.FindControl("txtNameFirst"), ASPxTextBox)
                Dim txtNameLast = TryCast(pageInputData.FindControl("txtNameLast"), ASPxTextBox)

                For Each item In client.NYC_Owner_Search(cbNameBorough.Value, String.Format("{0} {1}", txtNameFirst.Text, txtNameLast.Text))
                    Dim newdr = dt.NewRow
                    newdr(0) = item.BBLE
                    newdr(1) = String.Format("{0} {1} - {2}", item.NUMBER, item.ST_NAME, item.OWNER_NAME)
                    dt.Rows.Add(newdr)
                Next
            End If

            Return dt
        End Using
    End Function

    Protected Sub lbNewBBLE_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        Dim pageRootControl = TryCast(gridLeads.FindEditFormTemplateControl("pageControlNewLeads"), ASPxPageControl)
        Dim pageInputData = TryCast(pageRootControl.FindControl("pageControlInputData"), ASPxPageControl)
        'Dim borough = TryCast(pageInputData.FindControl("txtStreetBorough"), ASPxTextBox).Text

        Dim lbBBLE = TryCast(sender, ASPxListBox)

        Dim returnData = GetBBLEData()

        If returnData.Rows.Count = 0 Then
            Throw New Exception("No data matched, Please check!")
        End If

        lbBBLE.DataSource = returnData.DefaultView
        lbBBLE.DataBind()
    End Sub

    Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Using Context As New Entities
            Dim lead = Context.LeadsInfoes.Where(Function(ld) ld.BBLE = e.Parameter).SingleOrDefault
            e.Result = lead.PropertyAddress
        End Using
    End Sub

    'Protected Sub ASPxCallback1_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
    '    Dim borough = e.Parameter

    '    Using client As New DataAPI.WCFMacrosClient
    '        Dim streetLookup = client.NYC_Streets_lookup(borough, True, "")
    '        'Dim addressResults = client.NYC_Address_Search(borough, "", "")
    '        e.Result = String.Join(";", streetLookup)
    '    End Using
    'End Sub

    Protected Sub callbackPanelRequestUpdate_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If e.Parameter = "SendRequest" Then
            Dim bble = hfRequestUpdateBBLE.Value

            If Not String.IsNullOrEmpty(bble) Then
                SendRequest(bble)

                'Cancel Edit, Notify User
                'gridLeads.CancelEdit()
            End If
        Else
            Dim bble = e.Parameter
            hfRequestUpdateBBLE.Value = bble

            Using Context As New Entities
                Dim lead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

                TryCast(requestUpdateFormlayout.FindControl("txtRequestUpdateLeadsName"), ASPxTextBox).Text = lead.LeadsName
                TryCast(requestUpdateFormlayout.FindControl("txtRequestUpdateCreateby"), ASPxTextBox).Text = lead.EmployeeName
                TryCast(requestUpdateFormlayout.FindControl("txtRequestUpdateManager"), ASPxTextBox).Text = Employee.GetReportToManger(Page.User.Identity.Name).Name

            End Using
        End If
    End Sub

    Sub SendRequest(bble)

        Dim employees = New List(Of String)
        employees.Add(Page.User.Identity.Name.ToLower)
        employees.Add(txtRequestUpdateCreateby.Text.ToLower)
        employees.Add(txtRequestUpdateManager.Text.ToLower)
        Dim emps = String.Join(";", employees.Distinct().ToArray)

        'Dim cbTaskImportant = TryCast(requestUpdateFormlayout.FindControl("cbTaskImportant"), ASPxComboBox)
        'Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td>Employees:</td>" &
        '                             "<td>{0}</td></tr>" &
        '                             "<tr><td>Action:</td><td>{1}</td></tr>" &
        '                             "<tr><td>Important:</td><td>{2}</td></tr>" &
        '                           "<tr><td>Description:</td><td>{3}</td></tr>" &
        '                           "</table>", employees, "Request Update", cbTaskImportant.Text, txtTaskDes.Text)

        'Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Task.ToString)

        'Dim scheduleDate = DateTime.Now
        'If cbTaskImportant.Text = "Normal" Then
        '    scheduleDate = scheduleDate.AddDays(2)
        'End If

        'If cbTaskImportant.Text = "Importal" Then
        '    scheduleDate = scheduleDate.AddDays(1)
        'End If

        'If cbTaskImportant.Text = "Urgent" Then
        '    scheduleDate = scheduleDate.AddHours(2)
        'End If

        'Start new task
        Dim actlog As New ActivityLogs
        actlog.SetAsTask(emps, cbTaskImportant.Text, "Request Update", txtTaskDes.Text, bble, Page.User.Identity.Name)

        'UserTask.AddUserTask(bble, employees, "Request Update", cbTaskImportant.Text, "In Office", scheduleDate, txtTaskDes.Text, log.LogID)

        ''Add New message
        'Dim ld = LeadsInfo.GetInstance(bble)
        'Dim emps = employees.Split(";").Distinct.ToArray
        'For i = 0 To emps.Count - 1
        '    If emps(i) <> Page.User.Identity.Name Then
        '        Dim title = String.Format("A New Task has been assigned by {0} regarding {1} for {2}", Page.User.Identity.Name, "Lead Update", ld.PropertyAddress)
        '        UserMessage.AddNewMessage(emps(i), title, comments, bble)
        '    End If
        'Next
    End Sub

    Protected Sub cbStreetlookup_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If String.IsNullOrEmpty(e.Parameter) Then
            Return
        End If

        Dim cbStreetlookup = TryCast(sender, ASPxComboBox)
        Using Context As New Entities
            cbStreetlookup.DataSource = Context.NYC_St_Names.Where(Function(st) st.BOROUGH = e.Parameter).ToList()
            cbStreetlookup.DataBind()
        End Using
    End Sub

    Protected Sub gridLeads_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters.StartsWith("Search") Then
            Dim key = e.Parameters.Split("|")(1)
            BindLeadsListByKey(key)
        ElseIf (e.Parameters.StartsWith("MarkColor")) Then
            Dim BBLE = e.Parameters.Split("|")(1)
            Dim Color = CInt(e.Parameters.Split("|")(2))
            Using Context As New Entities
                Dim leads = Context.Leads.Where(Function(l) l.BBLE = BBLE).FirstOrDefault
                leads.MarkColor = Color
                Context.SaveChanges()
                BindLeadsColor()
            End Using

        Else
        End If
    End Sub
    Public Function GetMarkColor(markColor As Integer)
        If (markColor <= 0 Or markColor = 1000) Then
            Return "gray"
        End If
        Dim colors As New Dictionary(Of Integer, String)
        colors.Add(1, "#a820e1")
        colors.Add(2, "#ec471b")
        colors.Add(3, "#7bb71b")
        Dim color = colors.Item(markColor)
        If (color Is Nothing) Then
            Throw New Exception("Can't find color " & markColor & "In GetMarkColor")
        End If
        Return color
    End Function
    Protected Sub gridLeads_AfterPerformCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewAfterPerformCallbackEventArgs) Handles gridLeads.AfterPerformCallback
        'If gridLeads.DataSource Is Nothing Then
        '    BindLeadsList(lblLeadCategory.Text)
        'End If
    End Sub

    Protected Sub gridLeads_DataBinding(sender As Object, e As EventArgs)
        If gridLeads.DataSource Is Nothing Then

            If Not String.IsNullOrEmpty(Request.QueryString("o")) Then
                LeadsListView = ControlView.OfficeView
                OfficeName = Request.QueryString("o")
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
                LeadsListView = ControlView.TeamView
                TeamMgr = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("team")) Then
                LeadsListView = ControlView.TeamView2
                TeamId = CInt(Request.QueryString("team"))
            End If

            BindLeadsList(lblLeadCategory.Text)
        End If
    End Sub

    Protected Sub gridLeads_CustomGroupDisplayText(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewColumnDisplayTextEventArgs)

    End Sub

    Protected Sub gridLeads_SummaryDisplayText(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewSummaryDisplayTextEventArgs)
        If e.Item.FieldName = "LeadsName" Then
            e.Text = e.Value
        End If
    End Sub

    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        popContentRequestUpdate.Visible = True
        If e.Parameter = "SendRequest" Then
            Dim bble = hfRequestUpdateBBLE.Value

            If Not String.IsNullOrEmpty(bble) Then
                SendRequest(bble)

                'Cancel Edit, Notify User
                'gridLeads.CancelEdit()
            End If
        Else
            Dim bble = e.Parameter
            hfRequestUpdateBBLE.Value = bble

            Using Context As New Entities
                Dim lead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

                TryCast(requestUpdateFormlayout.FindControl("txtRequestUpdateLeadsName"), ASPxTextBox).Text = lead.LeadsName
                TryCast(requestUpdateFormlayout.FindControl("txtRequestUpdateCreateby"), ASPxTextBox).Text = lead.EmployeeName
                TryCast(requestUpdateFormlayout.FindControl("txtRequestUpdateManager"), ASPxTextBox).Text = Employee.GetReportToManger(Page.User.Identity.Name).Name

            End Using
        End If
    End Sub

    Protected Sub MarkColorCallBack_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim BBLE = e.Parameter.Split("|")(1)
        Dim Color = CInt(e.Parameter.Split("|")(2))
        Using Context As New Entities
            Dim leads = Context.Leads.Where(Function(l) l.BBLE = BBLE).FirstOrDefault
            leads.MarkColor = Color
            Context.SaveChanges()

        End Using
    End Sub
End Class

Public Enum ControlView
    UserView
    ManagerView
    OfficeView
    TeamView
    TeamView2
End Enum
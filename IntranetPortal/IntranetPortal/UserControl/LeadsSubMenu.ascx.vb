Imports DevExpress.Web.ASPxMenu
Imports System.ComponentModel
Imports DevExpress.Web.ASPxEditors

Public Class LeadsSubMenu
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        MenuControl()

        If Not IsPostBack Then

        End If
    End Sub

    Sub MenuControl()
        If Employee.IsManager(Page.User.Identity.Name) Then
            popupMenuLeads.Items.FindByName("Reassign").Visible = True
        End If
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities

            If Page.User.IsInRole("Admin") Then
                listboxEmployee.DataSource = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
                listboxEmployee.DataBind()
                Return
            End If

            Dim mgr = Employee.GetInstance(Page.User.Identity.Name)
            Dim emps = Employee.GetSubOrdinate(mgr.EmployeeID)
            emps.Add(mgr)
            listboxEmployee.DataSource = emps
            listboxEmployee.DataBind()
        End Using
    End Sub

    Public ReadOnly Property PopupMenu As ASPxPopupMenu
        Get
            Return popupMenuLeads
        End Get
    End Property

    Protected Sub reassignCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If e.Parameter.Split("|").Length > 0 Then
            Dim bble = e.Parameter.Split("|")(0)
            Dim empId = CInt(e.Parameter.Split("|")(1))
            Dim name = e.Parameter.Split("|")(2)


            Using Context As New Entities
                Dim lead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

                Dim oldOwner = lead.EmployeeName
                lead.EmployeeID = empId
                lead.EmployeeName = name
                lead.Status = LeadStatus.NewLead
                Context.SaveChanges()
                LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} reassign this lead from {1} to {2}.", Page.User.Identity.Name, oldOwner, name), bble, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)
            End Using
        End If
    End Sub

    Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Using Context As New Entities
            Dim lead = Context.LeadsInfoes.Where(Function(ld) ld.BBLE = e.Parameter).SingleOrDefault
            e.Result = lead.PropertyAddress + "|Block:" + lead.Block + " Lot:" + lead.Lot
        End Using
    End Sub

    Protected Sub leadStatusCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If e.Parameter.Length > 0 Then

            If e.Parameter.StartsWith("Tomorrow") Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Callback, DateTime.Now.AddDays(1))
                End If
            End If

            If e.Parameter.StartsWith("nextWeek") Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Callback, DateTime.Now.AddDays(7))
                End If
            End If

            If e.Parameter.StartsWith("thirtyDays") Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Callback, DateTime.Now.AddDays(30))
                End If
            End If

            If e.Parameter.StartsWith("sixtyDays") Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Callback, DateTime.Now.AddDays(60))
                End If
            End If

            If e.Parameter.StartsWith("customDays") Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    Dim tmpdate = If(e.Parameter.Split("|").Count > 2, DateTime.Parse(e.Parameter.Split("|")(2)), DateTime.Now)
                    UpdateLeadStatus(bble, LeadStatus.Callback, tmpdate)
                End If
            End If

            If e.Parameter.StartsWith(4) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.DoorKnocks, Nothing)
                End If
            End If

            If e.Parameter.StartsWith(5) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Priority, Nothing)
                End If
            End If

            If e.Parameter.StartsWith(6) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.DeadEnd, Nothing)
                End If
            End If

            If e.Parameter.StartsWith(7) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.InProcess, Nothing)

                    If Not String.IsNullOrEmpty(lbSelectionMode.Value) AndAlso lbSelectionMode.Value = 0 Then
                        'Add leads to short sale section
                        ShortSaleManage.MoveLeadsToShortSale(hfBBLE.Value, Page.User.Identity.Name)
                    End If
                End If
            End If

            If e.Parameter.StartsWith(8) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Closed, Nothing)
                End If
            End If

            'Delete Lead
            If e.Parameter.StartsWith(11) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Deleted, Nothing)
                End If
            End If
        End If
    End Sub

    Sub UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime)
        Lead.UpdateLeadStatus(bble, status, callbackDate)
    End Sub

    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        PopupContentReAssign.Visible = True
        BindEmployeeList()
    End Sub

    'Dead Leads Popup
    Protected Sub ASPxPopupControl5_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        popupContentDeadLeads.Visible = True
        If (e.Parameter.StartsWith("Show")) Then
            Dim bble = e.Parameter.Split("|")(1)
            hfBBLE.Value = bble

            cbDeadReasons.DataSource = GetType(Lead.DeadReasonEnum).GetEnumValues().OfType(Of Lead.DeadReasonEnum).ToDictionary(
              Function(key)
                  Return CInt(key).ToString
              End Function,
              Function(val)
                  Dim type = val.GetType()
                  Dim fi = type.GetField(val.ToString)
                  Dim attrs = fi.GetCustomAttributes(GetType(DescriptionAttribute), False)
                  If attrs.Length > 0 Then
                      Dim att = CType(attrs(0), DescriptionAttribute)
                      Return att.Description
                  End If
                  Return ""
              End Function
              )

            cbDeadReasons.TextField = "Value"
            cbDeadReasons.ValueField = "Key"
            cbDeadReasons.DataBind()
        End If

        If e.Parameter.StartsWith("Save") Then
            Dim reason = cbDeadReasons.Text
            Dim description = txtDeadLeadDescription.Text

            Lead.SetDeadLeadsStatus(hfBBLE.Value, cbDeadReasons.Value, description)
            'UpdateLeadStatus(hfBBLE.Value, LeadStatus.DeadEnd, Nothing)

            Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td style=""width:100px;"">Dead Reason:</td>" &
                            "<td>{0}</td></tr>" &
                            "<tr><td>Description:</td><td>{1}</td></tr>" &
                          "</table>", reason, description)
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.DeadLead)

            cbDeadReasons.Text = ""
            txtDeadLeadDescription.Text = ""
        End If
    End Sub

    'In Process Popup
    Protected Sub ASPxPopupControl4_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        popupContentInProcess.Visible = True
        If (e.Parameter.StartsWith("Show")) Then
            Dim bble = e.Parameter.Split("|")(1)
            hfInProcessBBLE.Value = bble
            BindEvictionUsers()
        End If

        If e.Parameter.StartsWith("Save") Then
            Dim bble = hfInProcessBBLE.Value
            UpdateLeadStatus(bble, LeadStatus.InProcess, Nothing)

            If Not String.IsNullOrEmpty(lbSelectionMode.Value) Then
                If lbSelectionMode.SelectedValues.Contains("0") Then
                    'Add leads to short sale section
                    ShortSaleManage.MoveLeadsToShortSale(hfInProcessBBLE.Value, Page.User.Identity.Name)
                End If

                If lbSelectionMode.SelectedValues.Contains("1") Then
                    Dim name = cbEvictionUsers.Value
                    If String.IsNullOrEmpty(name) Then
                        Throw New Exception("Please select Eviction User")
                    End If
                    ShortSale.EvictionCas.AddEviction(bble, name, Page.User.Identity.Name)
                End If
            End If
        End If
    End Sub

    Private Sub BindEvictionUsers()
        cbEvictionUsers.DataSource = Roles.GetUsersInRole("Eviction-User")
        cbEvictionUsers.DataBind()
    End Sub

    Protected Sub ASPxPopupControl6_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        If e.Parameter.StartsWith("Show") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim ctr = CType(LoadControl("~/UserControl/DocumentsUI.ascx"), DocumentsUI)
            ctr.ID = popupWinViewFiles.ID & "FileControls"
            ctr.LeadsName = Lead.GetInstance(bble).LeadsName
            ctr.ViewMode = True
            ctr.BindFilesFromSharepoint(bble)
            e.Window.Controls.Add(ctr)
        End If
    End Sub

    Protected Sub popupRequestUpdate_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
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

    Sub SendRequest(bble)

        Dim employees = New List(Of String)
        employees.Add(Page.User.Identity.Name.ToLower)
        employees.Add(txtRequestUpdateCreateby.Text.ToLower)
        employees.Add(txtRequestUpdateManager.Text.ToLower)
        Dim emps = String.Join(";", employees.Distinct().ToArray)

        'Start new task
        Dim actlog As New ActivityLogs
        actlog.SetAsTask(emps, cbTaskImportant.Text, "Request Update", txtTaskDes.Text, bble, Page.User.Identity.Name)
    End Sub
End Class
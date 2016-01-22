Imports DevExpress.Web
Imports DevExpress.XtraPrintingLinks

Public Class LeadsManagement
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindData()
        End If
    End Sub

    Sub BindData()
        If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
            Dim mgrName = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            BindTeamList(mgrName)
            BindTeamEmployees(mgrName)
            AssignLeadsPopup.LeadsSource = mgrName
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("office")) Then
            Dim office = Request.QueryString("office").ToString
            BindOfficeLeads(office)
            BindOfficeEmployee(office)
            AssignLeadsPopup.LeadsSource = office & " Office"
        Else
            BindNewestLeads()
            'gridLeads.DataBind()
            BindEmployeeList()
        End If
    End Sub

    Sub BindLeads()
        If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
            Dim mgrName = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            BindTeamList(mgrName)
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("office")) Then
            Dim office = Request.QueryString("office").ToString
            BindOfficeLeads(office)
        Else
            BindNewestLeads()
        End If
    End Sub

    Sub BindNewestLeads()
        Using Context As New Entities
            If User.IsInRole("Admin") Then
                Dim lds = Context.LeadsAssignView2.Where(Function(la) String.IsNullOrEmpty(la.EmployeeName)).OrderByDescending(Function(la) la.CreateDate)
                gridLeads.DataSource = lds.ToList ' Context.LeadsInfoes.Where(Function(l) l.Lead Is Nothing).ToList
                gridLeads.DataBind()
            Else
                If Employee.IsManager(User.Identity.Name) Then
                    Dim name = User.Identity.Name

                    Dim lds = Context.LeadsAssignView2.Where(Function(la) la.EmployeeName = name And la.Status = LeadStatus.NewLead).OrderByDescending(Function(la) la.LastUpdate)
                    gridLeads.DataSource = lds.ToList
                    gridLeads.DataBind()

                    AssignLeadsPopup.LeadsSource = name
                End If
            End If
        End Using
    End Sub

    Sub BindTeamList(mgrName As String)
        Using Context As New Entities
            'gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = mgrName And li.Lead.Status = LeadStatus.NewLead).ToList         

            gridLeads.DataSource = Context.LeadsAssignView2.Where(Function(la) la.EmployeeName = mgrName And la.Status = LeadStatus.NewLead).OrderByDescending(Function(la) la.LastUpdate).ToList 'lds.ToList
            gridLeads.DataBind()
        End Using
    End Sub

    Sub BindOfficeLeads(office As String)
        Dim currentTeam = Team.GetTeam(office)
        gridLeads.DataSource = currentTeam.AssignLeadsView.ToList
        gridLeads.DataBind()
        Return
    End Sub

    Sub BindOfficeEmployee(office As String)
        If String.IsNullOrEmpty(Request.QueryString("team")) Then
            Dim emps = Employee.GetDeptUsersList(office).OrderBy(Function(e) e.Name).ToList
            listboxEmployee.DataSource = emps
            listboxEmployee.DataBind()

            AssignLeadsPopup.EmployeeSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)
        Else
            Dim teamId = CInt(Request.QueryString("team"))
            Dim emps = Team.GetTeam(teamId).ActiveUsers.Select(Function(u) Employee.GetInstance(u)).OrderBy(Function(e) e.Name).ToList
            listboxEmployee.DataSource = emps
            listboxEmployee.DataBind()

            AssignLeadsPopup.EmployeeSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)
        End If

        AddDeadLeadsFolderToEmpList()
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            If Page.User.IsInRole("Admin") Then
                Dim emps1 = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
                listboxEmployee.DataSource = emps1
                listboxEmployee.DataBind()

                AssignLeadsPopup.EmployeeSource = String.Join(",", emps1.Select(Function(em) em.Name).ToArray)
                Return
            End If

            If String.IsNullOrEmpty(Page.User.Identity.Name) Then
                Return
            End If

            Dim mgr = Employee.GetInstance(Page.User.Identity.Name)
            Dim emps = Employee.GetSubOrdinate(mgr.EmployeeID)
            emps.Add(mgr)

            listboxEmployee.DataSource = emps
            listboxEmployee.DataBind()
            AssignLeadsPopup.EmployeeSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)

            AddDeadLeadsFolderToEmpList()
        End Using
    End Sub

    Sub BindTeamEmployees(teamMgr As String)
        Dim mgr = Employee.GetInstance(teamMgr)
        Dim emps = Employee.GetSubOrdinate(mgr.EmployeeID)
        emps.Add(mgr)

        listboxEmployee.DataSource = emps
        listboxEmployee.DataBind()

        AssignLeadsPopup.EmployeeSource = String.Join(",", emps)

        AddDeadLeadsFolderToEmpList()
    End Sub

    Sub AddDeadLeadsFolderToEmpList()
        Dim dealleads = Employee.GetInstance("Dead Leads")
        listboxEmployee.Items.Add(New ListEditItem(dealleads.Name, dealleads.EmployeeID))
    End Sub

    'Protected Sub btnAssign_Click(sender As Object, e As EventArgs)
    '    If gridLeads.Selection.Count > 0 AndAlso listboxEmployee.SelectedItem IsNot Nothing Then
    '        Dim selectedLeads = gridLeads.GetSelectedFieldValues("BBLE", "LeadsName", "Neighborhood")

    '        Using Context As New Entities
    '            For Each lead In selectedLeads
    '                Dim bble = lead(0).ToString
    '                Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault
    '                If newlead Is Nothing Then
    '                    newlead = New Lead() With {
    '                                      .BBLE = lead(0).ToString,
    '                                      .LeadsName = lead(1).ToString,
    '                                      .Neighborhood = lead(2),
    '                                      .EmployeeID = CInt(listboxEmployee.SelectedItem.Value),
    '                                      .EmployeeName = listboxEmployee.SelectedItem.Text,
    '                                      .Status = LeadStatus.NewLead,
    '                                      .AssignDate = DateTime.Now,
    '                                    .AssignBy = User.Identity.Name
    '                                      }
    '                    Context.Leads.Add(newlead)
    '                Else
    '                    newlead.LeadsName = lead(1)
    '                    newlead.Neighborhood = lead(2)
    '                    newlead.EmployeeID = CInt(listboxEmployee.SelectedItem.Value)
    '                    newlead.EmployeeName = listboxEmployee.SelectedItem.Text
    '                    newlead.Status = LeadStatus.NewLead
    '                    newlead.AssignDate = DateTime.Now
    '                    newlead.AssignBy = User.Identity.Name
    '                End If
    '            Next
    '            If Context.GetValidationErrors().Count > 0 Then
    '                Throw New Exception("Exception Occured in Assign: " & Context.GetValidationErrors()(0).ValidationErrors(0).ErrorMessage)
    '            Else
    '                Context.SaveChanges()
    '            End If
    '        End Using

    '    End If
    '    'BindData()
    '    Dim script = "<script type=""text/javascript"">"
    '    script += "gridLeads.Refresh();"

    '    script += "</script>"

    '    If Not Page.ClientScript.IsStartupScriptRegistered("Refresh") Then
    '        Page.ClientScript.RegisterStartupScript(Me.GetType, "Refresh", script)
    '    End If
    'End Sub

    Protected Sub gridLeads_DataBinding(sender As Object, e As EventArgs)
        If gridLeads.DataSource Is Nothing Then
            BindLeads()
        End If
    End Sub

    Protected Sub gridLeads_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridViewTableRowEventArgs)
        If Not e.RowType = DevExpress.Web.GridViewRowType.Data Then
            Return
        End If

        Dim imgType = TryCast(gridLeads.FindRowCellTemplateControl(e.VisibleIndex, gridLeads.Columns("Type"), "imgType"), ASPxImage)
        imgType.ClientSideEvents.Click = String.Format("function(s,e){{tempBBLE='{0}';leadsTypeMenu.ShowAtElement(s.GetMainElement());}}", e.GetValue("BBLE"))

        If e.GetValue("Type") IsNot Nothing Then
            Dim type = CType(e.GetValue("Type"), LeadsInfo.LeadsType)
            imgType.ToolTip = type.ToString
            imgType.Visible = True
            imgType.ImageUrl = TypeImages(e.GetValue("Type"))
        End If
    End Sub

    Protected Sub updateLeadsType_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        If Not String.IsNullOrEmpty(e.Parameter) AndAlso e.Parameter.Split("|").Length > 1 Then
            Dim bble = e.Parameter.Split("|")(0)
            Dim type = e.Parameter.Split("|")(1)

            Using Context As New Entities
                Dim ld = Context.LeadsInfoes.Find(bble)
                If ld IsNot Nothing Then
                    ld.Type = ld.GetLeadsType(type)
                    Context.SaveChanges()
                End If
            End Using
        End If
    End Sub

    Private _typeImages As StringDictionary
    Public ReadOnly Property TypeImages As StringDictionary
        Get
            If _typeImages Is Nothing Then
                _typeImages = New StringDictionary
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.DevelopmentOpportunity, "~/images/lr_dev_opportunity.png")
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.Foreclosure, "~/images/lr_forecosure.png")
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.HasEquity, "~/images/lr_has_equity.png")
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.TaxLien, "~/images/lr_tax_lien.png")
            End If

            Return _typeImages
        End Get
    End Property

    Protected Sub gridLeads_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters.StartsWith("AssignLeads") Then
            If gridLeads.Selection.Count > 0 AndAlso listboxEmployee.SelectedItem IsNot Nothing Then
                Dim selectedLeads = gridLeads.GetSelectedFieldValues("BBLE").Select(Function(l) l.ToString).ToArray

                Lead.BatchAssignLeads(selectedLeads.ToArray, listboxEmployee.SelectedItem.Text, CInt(listboxEmployee.SelectedItem.Value), User.Identity.Name, cbArchived.Checked)

                gridLeads.DataBind()
            End If
        End If
    End Sub

    Protected Sub btnExport_Click(sender As Object, e As EventArgs)
        gridExport.WriteXlsxToResponse()
    End Sub

    Protected Sub gridExport_RenderBrick(sender As Object, e As DevExpress.Web.ASPxGridViewExportRenderingEventArgs)
        If e.Column.Caption = "Recycle" Then
            If e.GetValue("Comments") IsNot Nothing Then
                e.TextValue = Utility.RemoveHtmlTags(e.GetValue("Comments")) 'String.Format("{0}@{1} {2}", e.GetValue("UpdateUser"), e.GetValue("ActivityDate"), e.GetValue("Comments"))                
            End If
        End If
    End Sub


End Class

Partial Class LeadsAssignView
    Public ReadOnly Property IsRecycled As Boolean
        Get
            Return Me.Recycle > 0
        End Get
    End Property

    Public ReadOnly Property MortgageCombo As Decimal
        Get
            Return If(C1stMotgrAmt.HasValue, C1stMotgrAmt, 0) + If(C2ndMotgrAmt.HasValue, C2ndMotgrAmt, 0) + If(C3rdMortgrAmt.HasValue, C3rdMortgrAmt, 0)
        End Get
    End Property

    Public ReadOnly Property TaxLiensAmount As String
        Get
            Return If(Amount = 0, "Not Avaiable", "")
        End Get
    End Property

    Public ReadOnly Property Neighborhood As String
        Get
            Return NeighName
        End Get
    End Property

    Public ReadOnly Property Street As String
        Get
            Return StreetName
        End Get
    End Property

    Public ReadOnly Property TypeText As String
        Get
            If Type.HasValue Then
                Return CType(Type, LeadsInfo.LeadsType).ToString
            End If

            Return ""
        End Get
    End Property
End Class

Partial Class LeadsAssignView2
    Public ReadOnly Property IsRecycled As Boolean
        Get
            Return Not String.IsNullOrEmpty(Me.Comments)
        End Get
    End Property

    Public ReadOnly Property MortgageCombo As Decimal
        Get
            Return If(C1stMotgrAmt.HasValue, C1stMotgrAmt, 0) + If(C2ndMotgrAmt.HasValue, C2ndMotgrAmt, 0) + If(C3rdMortgrAmt.HasValue, C3rdMortgrAmt, 0)
        End Get
    End Property

    Public ReadOnly Property TaxLiensAmount As String
        Get
            Return If(Amount = 0, "Not Avaiable", "")
        End Get
    End Property

    Public ReadOnly Property Neighborhood As String
        Get
            Return NeighName
        End Get
    End Property

    Public ReadOnly Property Street As String
        Get
            Return StreetName
        End Get
    End Property

    Public ReadOnly Property TypeText As String
        Get
            If Type.HasValue Then
                Return CType(Type, LeadsInfo.LeadsType).ToString
            End If

            Return ""
        End Get
    End Property
End Class
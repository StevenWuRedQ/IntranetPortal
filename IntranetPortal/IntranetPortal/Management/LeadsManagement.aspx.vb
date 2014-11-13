Imports DevExpress.Web.ASPxEditors

Public Class LeadsManagement
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub page_init(ByVal sender As Object, e As EventArgs) Handles Me.Init
        'If (Not IsPostBack) Then
        BindData()
        'End If
    End Sub

    Sub BindData()
        If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
            Dim mgrName = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            BindTeamList(mgrName)
            BindTeamEmployees(mgrName)
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("office")) Then
            Dim office = Request.QueryString("office").ToString
            BindOfficeLeads(office)
            BindOfficeEmployee(office)
        Else
            BindNewestLeads()
            'gridLeads.DataBind()
            BindEmployeeList()
        End If
    End Sub

    Function GetDataSource() As List(Of LeadsInfo)
        Using Context As New Entities
            If User.IsInRole("Admin") Then
                Return Context.LeadsInfoes.Where(Function(li) li.Lead Is Nothing).ToList
            Else
                If Employee.IsManager(User.Identity.Name) Then
                    Dim name = User.Identity.Name
                    Return Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = name And li.Lead.Status = LeadStatus.NewLead).ToList
                End If
            End If

            Return New List(Of LeadsInfo)
        End Using
    End Function

    Sub BindNewestLeads()
        Using Context As New Entities
            If User.IsInRole("Admin") Then
                gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead Is Nothing).ToList
                gridLeads.DataBind()

            Else
                If Employee.IsManager(User.Identity.Name) Then
                    Dim name = User.Identity.Name
                    gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = name And li.Lead.Status = LeadStatus.NewLead).ToList
                    gridLeads.DataBind()
                End If
            End If
        End Using
    End Sub

    Sub BindTeamList(mgrName As String)
        Using Context As New Entities
            gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = mgrName And li.Lead.Status = LeadStatus.NewLead).ToList
            gridLeads.DataBind()
        End Using
    End Sub

    Sub BindOfficeLeads(office As String)
        Dim officeName = office & " Office"

        Dim unActiveUser = Employee.GetDeptUsersList(office, False).Select(Function(emp) emp.Name).ToArray

        Using Context As New Entities
            gridLeads.DataSource = (From li In Context.LeadsInfoes
                                   Join ld In Context.Leads On ld.BBLE Equals li.BBLE
                                   Where ld.EmployeeName = officeName Or (unActiveUser.Contains(ld.EmployeeName) And ld.Status <> LeadStatus.InProcess)
                                   Select li).ToList

            gridLeads.DataBind()
        End Using
    End Sub

    Sub BindOfficeEmployee(office As String)
        Using Context As New Entities
            If Page.User.IsInRole("Admin") Then
                listboxEmployee.DataSource = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
                listboxEmployee.DataBind()
                Return
            End If

            listboxEmployee.DataSource = Employee.GetDeptUsersList(office)
            listboxEmployee.DataBind()

            AddDeadLeadsFolderToEmpList()
        End Using
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            If Page.User.IsInRole("Admin") Then
                listboxEmployee.DataSource = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
                listboxEmployee.DataBind()
                AddDeadLeadsFolderToEmpList()

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

            AddDeadLeadsFolderToEmpList()
        End Using
    End Sub

    Sub BindTeamEmployees(teamMgr As String)
        Dim mgr = Employee.GetInstance(teamMgr)
        Dim emps = Employee.GetSubOrdinate(mgr.EmployeeID)
        emps.Add(mgr)

        listboxEmployee.DataSource = emps
        listboxEmployee.DataBind()

        AddDeadLeadsFolderToEmpList()
    End Sub

    Sub AddDeadLeadsFolderToEmpList()
        Dim dealleads = Employee.GetInstance("Dead Leads")
        listboxEmployee.Items.Add(New ListEditItem(dealleads.Name, dealleads.EmployeeID))
    End Sub

    Protected Sub btnAssign_Click(sender As Object, e As EventArgs) Handles btnAssign.Click
        If gridLeads.Selection.Count > 0 AndAlso listboxEmployee.SelectedItem IsNot Nothing Then
            Dim selectedLeads = gridLeads.GetSelectedFieldValues("BBLE", "LeadsName", "Neighborhood")

            Using Context As New Entities
                For Each lead In selectedLeads
                    Dim bble = lead(0).ToString
                    Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault
                    If newlead Is Nothing Then
                        newlead = New Lead() With {
                                          .BBLE = lead(0).ToString,
                                          .LeadsName = lead(1).ToString,
                                          .Neighborhood = lead(2),
                                          .EmployeeID = CInt(listboxEmployee.SelectedItem.Value),
                                          .EmployeeName = listboxEmployee.SelectedItem.Text,
                                          .Status = LeadStatus.NewLead,
                                          .AssignDate = DateTime.Now,
                                        .AssignBy = User.Identity.Name
                                          }
                        Context.Leads.Add(newlead)
                    Else
                        newlead.LeadsName = lead(1)
                        newlead.Neighborhood = lead(2)
                        newlead.EmployeeID = CInt(listboxEmployee.SelectedItem.Value)
                        newlead.EmployeeName = listboxEmployee.SelectedItem.Text
                        newlead.Status = LeadStatus.NewLead
                        newlead.AssignDate = DateTime.Now
                        newlead.AssignBy = User.Identity.Name
                    End If
                Next
                If Context.GetValidationErrors().Count > 0 Then
                    Throw New Exception("Exception Occured in Assign: " & Context.GetValidationErrors()(0).ValidationErrors(0).ErrorMessage)
                Else
                    Context.SaveChanges()
                End If
            End Using

            'BindNewestLeads()

            'gridLeads.DataBind()
        End If
        'BindData()
        Dim script = "<script type=""text/javascript"">"
        script += "gridLeads.Refresh();"

        script += "</script>"

        If Not Page.ClientScript.IsStartupScriptRegistered("Refresh") Then
            Page.ClientScript.RegisterStartupScript(Me.GetType, "Refresh", script)
        End If
    End Sub

    Protected Sub gridLeads_DataBinding(sender As Object, e As EventArgs)
        'gridLeads.DataSource = GetDataSource()
    End Sub

    Protected Sub gridLeads_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)
        If Not e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Data Then
            Return
        End If

        Dim imgType = TryCast(gridLeads.FindRowCellTemplateControl(e.VisibleIndex, gridLeads.Columns("Type"), "imgType"), ASPxImage)
        imgType.ClientSideEvents.Click = String.Format("function(s,e){{tempBBLE={0};leadsTypeMenu.ShowAtElement(s.GetMainElement());}}", e.GetValue("BBLE"))

        If e.GetValue("Type") IsNot Nothing Then
            Dim type = CType(e.GetValue("Type"), LeadsInfo.LeadsType)
            imgType.ToolTip = type.ToString
            imgType.Visible = True
            imgType.ImageUrl = TypeImages(e.GetValue("Type"))
        End If
    End Sub

    Protected Sub updateLeadsType_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If Not String.IsNullOrEmpty(e.Parameter) Then
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



End Class
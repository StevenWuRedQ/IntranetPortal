
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
                Return Context.LeadsInfoes.Where(Function(li) li.Lead Is Nothing Or (li.Lead.Employee.Active = False And li.Lead.Status <> LeadStatus.InProcess)).ToList
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
                gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead Is Nothing Or (li.Lead.Employee.Active = False And li.Lead.Status <> LeadStatus.InProcess)).ToList
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
            listboxEmployee.DataSource = Employee.GetDeptUsersList(office)
            listboxEmployee.DataBind()
        End Using
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            If Page.User.IsInRole("Admin") Then
                listboxEmployee.DataSource = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
                listboxEmployee.DataBind()
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
        End Using
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
                Context.SaveChanges()
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
End Class
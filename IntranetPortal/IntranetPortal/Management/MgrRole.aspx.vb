Public Class MgrRole
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            InitApplications()
            BindRoles()
            BindEmployeeList()
        End If
    End Sub

    Sub InitApplications()
        ddlApplications.DataSource = Core.Application.GetAll
        ddlApplications.DataTextField = "Name"
        ddlApplications.DataValueField = "ApplicationId"
        ddlApplications.DataBind()
    End Sub

    Sub BindRoles()
        Using Context = New Entities
            lbRoles.DataSource = Context.Roles.OrderBy(Function(r) r.Rolename).ToList
            lbRoles.TextField = "Rolename"
            lbRoles.ValueField = "Rolename"
            lbRoles.DataBind()
        End Using
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            Dim appId = ddlApplications.SelectedValue
            cbEmps.DataSource = Context.Employees.Where(Function(em) em.Active = True And em.AppId = appId).OrderBy(Function(em) em.Name).ToList
            cbEmps.TextField = "Name"
            cbEmps.ValueField = "EmployeeID"
            cbEmps.DataBind()
        End Using
    End Sub

    Protected Sub lbRoles_SelectedIndexChanged(sender As Object, e As EventArgs) Handles lbRoles.SelectedIndexChanged
        BindUserInRole()
    End Sub

    Protected Sub btnAddRole_Click(sender As Object, e As EventArgs) Handles btnAddRole.Click
        If Not String.IsNullOrEmpty(txtRoles.Text) Then
            Using Context As New Entities
                Dim role = New Role

                role.Rolename = txtRoles.Text
                role.ApplicationName = "IntranetPortal"

                Try
                    Context.Roles.Add(role)
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindRoles()
                    txtRoles.Text = ""
                End Try

            End Using
        End If
    End Sub

    Protected Sub btnRemoveRole_Click(sender As Object, e As EventArgs) Handles btnRemoveRole.Click

        If Not String.IsNullOrEmpty(lbRoles.Value.ToString) Then
            Using Context As New Entities
                Dim role = Context.Roles.Where(Function(r) r.Rolename = lbRoles.Value.ToString).SingleOrDefault

                Context.UsersInRoles.RemoveRange(role.UsersInRole)
                Context.Roles.Remove(role)
                Context.SaveChanges()

                BindRoles()
            End Using
        End If
    End Sub

    Sub BindUserInRole()
        If lbRoles.Value = Nothing Then
            lbEmployees.Items.Clear()
            Return
        End If

        Using Context As New Entities
            Dim roleName = lbRoles.Value.ToString
            Dim appId = ddlApplications.SelectedValue

            lbEmployees.DataSource = (From ui In Context.UsersInRoles
                                      Join emp In Context.Employees On ui.Username Equals emp.Name
                                      Where ui.Rolename = roleName And emp.AppId = appId
                                      Select ui.Username).ToArray
            'Context.UsersInRoles.Where(Function(ur) ur.Rolename = roleName).OrderBy(Function(r) r.Username).ToList

            'lbEmployees.ValueField = "Username"
            'lbEmployees.TextField = "Username"
            lbEmployees.DataBind()
        End Using
    End Sub

    Protected Sub btnAddEmp_Click(sender As Object, e As EventArgs) Handles btnAddEmp.Click
        If Not cbEmps.Value = Nothing AndAlso Not String.IsNullOrEmpty(cbEmps.Value) Then
            Using Context As New Entities
                Dim ur As New UsersInRole
                ur.Rolename = lbRoles.Value.ToString
                ur.ApplicationName = "IntranetPortal"
                ur.Username = cbEmps.Text.ToString

                Try
                    Context.UsersInRoles.Add(ur)
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindUserInRole()
                End Try
            End Using
        End If
    End Sub

    Protected Sub btnRemoveEmp_Click(sender As Object, e As EventArgs) Handles btnRemoveEmp.Click
        If Not lbEmployees.Value = Nothing AndAlso Not lbRoles.Value = Nothing Then
            Using Context As New Entities
                Dim ur = Context.UsersInRoles.Where(Function(tem) tem.Rolename = lbRoles.Value.ToString And tem.Username = lbEmployees.Value.ToString).SingleOrDefault
                Context.UsersInRoles.Remove(ur)
                Try
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindUserInRole()
                End Try

            End Using
        End If
    End Sub

    Protected Sub ddlApplications_SelectedIndexChanged(sender As Object, e As EventArgs)
        BindEmployeeList()
    End Sub
End Class
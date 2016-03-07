Public Class MgrTeamPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            BindEmployeeList()
            BindTeam()
        End If

    End Sub

    Sub BindTeam()
        Using Context = New Entities
            'lbRoles.DataSource = Context.Teams.OrderBy(Function(r) r.Name).ToList
            'lbRoles.TextField = "Name"
            'lbRoles.ValueField = "TeamId"
            'lbRoles.DataBind()

            gvTeams.DataSource = Team.GetAllTeams
            gvTeams.DataBind()
        End Using
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            cbEmps.DataSource = Context.Employees.Where(Function(em) em.Active = True).OrderBy(Function(em) em.Name).ToList
            cbEmps.TextField = "Name"
            cbEmps.ValueField = "EmployeeID"
            cbEmps.DataBind()
        End Using
    End Sub

    Protected Sub lbRoles_SelectedIndexChanged(sender As Object, e As EventArgs) Handles lbRoles.SelectedIndexChanged
        BindUserInTeam()
    End Sub

    Protected Sub btnAddRole_Click(sender As Object, e As EventArgs) Handles btnAddRole.Click
        If Not String.IsNullOrEmpty(txtRoles.Text) Then
            Using Context As New Entities
                Dim role = Context.Teams.Where(Function(t) t.Name = txtRoles.Text).SingleOrDefault
                If role Is Nothing Then
                    role = New Team
                    role.Name = txtRoles.Text

                    Try
                        Context.Teams.Add(role)
                        Context.SaveChanges()
                    Catch ex As Exception
                        lblError.Text = ex.Message
                    Finally
                        BindTeam()
                        txtRoles.Text = ""
                    End Try
                End If
            End Using
        End If
    End Sub

    Protected Sub btnRemoveRole_Click(sender As Object, e As EventArgs) Handles btnRemoveRole.Click

        If Not String.IsNullOrEmpty(lbRoles.Value.ToString) Then
            Using Context As New Entities
                Dim teamId = CInt(lbRoles.Value)
                Dim role = Context.Teams.Where(Function(r) r.TeamId = teamId).SingleOrDefault
                Dim users = Context.UserInTeams.Where(Function(ut) ut.TeamId = role.TeamId).ToList

                Context.UserInTeams.RemoveRange(users)
                Context.Teams.Remove(role)
                Context.SaveChanges()
                BindTeam()
            End Using
        End If
    End Sub

    Sub BindUserInTeam()
        If lbRoles.Value = Nothing Then
            lbEmployees.Items.Clear()
            Return
        End If

        Dim teamId = CInt(lbRoles.Value)
        lbEmployees.DataSource = Team.GetTeam(teamId).ActiveUsers
        lbEmployees.DataBind()
        Return

        Using Context As New Entities

            lbEmployees.DataSource = Context.UserInTeams.Where(Function(ur) ur.TeamId = teamId).OrderBy(Function(r) r.EmployeeName).ToList
            lbEmployees.ValueField = "EmployeeName"
            lbEmployees.TextField = "EmployeeName"
            lbEmployees.DataBind()
        End Using
    End Sub

    Protected Sub btnAddEmp_Click(sender As Object, e As EventArgs) Handles btnAddEmp.Click
        If Not cbEmps.Value = Nothing AndAlso Not String.IsNullOrEmpty(cbEmps.Value) Then
            Using Context As New Entities
                Dim teamId = CInt(lbRoles.Value)
                For Each name In cbEmps.Text.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)

                    Dim ur = Context.UserInTeams.Where(Function(u) u.TeamId = teamId And u.EmployeeName = name).FirstOrDefault
                    If ur Is Nothing Then
                        ur = New UserInTeam
                        ur.TeamId = teamId
                        ur.EmployeeName = name
                        Context.UserInTeams.Add(ur)
                    End If
                Next

                Try
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindUserInTeam()
                    cbEmps.Text = ""
                End Try
            End Using
        End If
    End Sub

    Protected Sub btnRemoveEmp_Click(sender As Object, e As EventArgs) Handles btnRemoveEmp.Click
        If Not lbEmployees.Value = Nothing AndAlso Not gvTeams.GetSelectedFieldValues("TeamId")(0) = Nothing Then
            Using Context As New Entities
                Dim teamId = CInt(gvTeams.GetSelectedFieldValues("TeamId")(0) = Nothing)
                Dim ur = Context.UserInTeams.Where(Function(tem) tem.TeamId = teamId And tem.EmployeeName = lbEmployees.Value.ToString).SingleOrDefault
                Context.UserInTeams.Remove(ur)

                Try
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindUserInTeam()
                End Try
            End Using
        End If
    End Sub

    Protected Sub lbEmployees_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If (e.Parameter.StartsWith("Load")) Then
            Dim teamId = CInt(e.Parameter.Split("|")(1))
            lbEmployees.DataSource = Team.GetTeam(teamId).ActiveUsers
            lbEmployees.DataBind()
        End If

        If (e.Parameter.StartsWith("Remove")) Then
            Dim teamId = CInt(e.Parameter.Split("|")(1))
            Dim empName = e.Parameter.Split("|")(2)
            Dim tm = Team.GetTeam(teamId)
            tm.RemoveUser(empName)

            lbEmployees.DataSource = tm.ActiveUsers
            lbEmployees.DataBind()
        End If

        If (e.Parameter.StartsWith("Add")) Then
            Dim teamId = CInt(e.Parameter.Split("|")(1))
            Dim names = e.Parameter.Split("|")(2)

            If Not String.IsNullOrEmpty(names) Then
                Using Context As New Entities
                    For Each name In names.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)

                        Dim ur = Context.UserInTeams.Where(Function(u) u.TeamId = teamId And u.EmployeeName = name).FirstOrDefault
                        If ur Is Nothing Then
                            ur = New UserInTeam
                            ur.TeamId = teamId
                            ur.EmployeeName = name
                            Context.UserInTeams.Add(ur)
                        End If
                    Next

                    Try
                        Context.SaveChanges()
                    Catch ex As Exception
                        lblError.Text = ex.Message
                    Finally
                        BindUserInTeam()
                        cbEmps.Text = ""
                    End Try
                End Using
            End If

            Dim tm = Team.GetTeam(teamId)
            lbEmployees.DataSource = tm.ActiveUsers
            lbEmployees.DataBind()
        End If
    End Sub

    Protected Sub gvTeams_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim tm As New Team
        tm.Name = e.NewValues("Name")
        tm.Manager = e.NewValues("Manager")
        tm.Assistant = e.NewValues("Assistant")
        tm.OfficeNo = e.NewValues("OfficeNo")
        tm.Address = e.NewValues("Address")
        tm.Description = e.NewValues("Description")
        tm.LeadsCreateLimit = e.NewValues("LeadsCreateLimit")
        tm.Active = e.NewValues("Active")

        tm.Save(Page.User.Identity.Name)

        e.Cancel = True
        gvTeams.CancelEdit()

    End Sub

    Protected Sub gvTeams_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        Dim teamId = CInt(e.Keys("TeamId"))
        Dim tm = Team.GetTeam(teamId)

        tm.Manager = e.NewValues("Manager")
        tm.Assistant = e.NewValues("Assistant")
        tm.OfficeNo = e.NewValues("OfficeNo")
        tm.Address = e.NewValues("Address")
        tm.Description = e.NewValues("Description")
        tm.LeadsCreateLimit = e.NewValues("LeadsCreateLimit")
        tm.Active = e.NewValues("Active")
        tm.Save(Page.User.Identity.Name)

        e.Cancel = True
        gvTeams.CancelEdit()
    End Sub

    Protected Sub gvTeams_DataBinding(sender As Object, e As EventArgs)
        If gvTeams.DataSource Is Nothing Then
            BindTeam()
        End If
    End Sub

    Protected Sub cbEmps_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        Dim teamId = e.Parameter.Split("|")(0)
        Dim names = e.Parameter.Split("|")(1)

        If Not String.IsNullOrEmpty(names) Then
            Using Context As New Entities
                For Each name In names.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)

                    Dim ur = Context.UserInTeams.Where(Function(u) u.TeamId = teamId And u.EmployeeName = name).FirstOrDefault
                    If ur Is Nothing Then
                        ur = New UserInTeam
                        ur.TeamId = teamId
                        ur.EmployeeName = name
                        Context.UserInTeams.Add(ur)
                    End If
                Next

                Try
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindUserInTeam()
                    cbEmps.Text = ""
                End Try
            End Using
        End If
    End Sub

End Class
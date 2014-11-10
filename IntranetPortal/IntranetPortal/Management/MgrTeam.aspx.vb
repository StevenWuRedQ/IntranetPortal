﻿Public Class MgrTeamPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindTeam()
            BindEmployeeList()
        End If
    End Sub

    Sub BindTeam()
        Using Context = New Entities
            lbRoles.DataSource = Context.Teams.OrderBy(Function(r) r.Name).ToList
            lbRoles.TextField = "Name"
            lbRoles.ValueField = "TeamId"
            lbRoles.DataBind()
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

        Using Context As New Entities
            Dim teamId = CInt(lbRoles.Value)
            lbEmployees.DataSource = Context.UserInTeams.Where(Function(ur) ur.TeamId = teamId).OrderBy(Function(r) r.EmployeeName).ToList
            lbEmployees.ValueField = "EmployeeName"
            lbEmployees.TextField = "EmployeeName"
            lbEmployees.DataBind()
        End Using
    End Sub

    Protected Sub btnAddEmp_Click(sender As Object, e As EventArgs) Handles btnAddEmp.Click
        If Not cbEmps.Value = Nothing AndAlso Not String.IsNullOrEmpty(cbEmps.Value) Then
            Using Context As New Entities
                Dim ur As New UserInTeam
                ur.TeamId = CInt(lbRoles.Value)
                ur.EmployeeName = cbEmps.Text.ToString

                Try
                    Context.UserInTeams.Add(ur)
                    Context.SaveChanges()
                Catch ex As Exception
                    lblError.Text = ex.Message
                Finally
                    BindUserInTeam()
                End Try
            End Using
        End If
    End Sub

    Protected Sub btnRemoveEmp_Click(sender As Object, e As EventArgs) Handles btnRemoveEmp.Click
        If Not lbEmployees.Value = Nothing AndAlso Not lbRoles.Value = Nothing Then
            Using Context As New Entities
                Dim teamId = CInt(lbRoles.Value)
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
End Class
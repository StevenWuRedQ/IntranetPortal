Imports DevExpress.Web

Public Class MgrTeamPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            BindEmployeeList()
            BindTeam()
        End If
    End Sub

    Sub BindTeam()
        gvTeams.DataSource = Team.GetAllTeams
        gvTeams.DataBind()
    End Sub

    Sub BindEmployeeList()
        cbEmps.DataSource = Employee.GetAllActiveEmps
        cbEmps.DataBind()
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
                        Throw New CallbackException(ex.Message)
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

    Protected Sub gvTeams_CellEditorInitialize(sender As Object, e As DevExpress.Web.ASPxGridViewEditorEventArgs)
        If e.Column.FieldName = "Manager" OrElse e.Column.FieldName = "Assistant" Then
            Dim cmb As ASPxComboBox = TryCast(e.Editor, ASPxComboBox)
            cmb.DataSource = Employee.GetAllActiveEmps
            cmb.DataBindItems()
        End If
    End Sub

End Class
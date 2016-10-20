Public Class MgrOffDays
    Inherits PortalPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gridOffDays.DataBind()
            BindAgent()

            Dim days = Core.SpecialDay.GetPublicOffDays
            gridPublicHoliday.DataSource = days
            gridPublicHoliday.DataBind()
        End If
    End Sub

    Private Sub BindAgent()
      
        Dim teamUsers = GetAgent()
        cbAgents.DataSource = teamUsers

        cbAgents.DataBind()
    End Sub
    Private Function GetAgent() As String()
        Return Employee.GetMyEmployees(Page.User.Identity.Name).Select(Function(e) e.Name).ToArray
    End Function

    Protected Sub gridOffDays_DataBinding(sender As Object, e As EventArgs)
        If gridOffDays.DataSource Is Nothing Then
            Dim agents = GetAgent()
            gridOffDays.DataSource = Core.SpecialDay.GetPersonalOffDays().Where(Function(d) agents.Contains(d.Employee))
        End If
    End Sub

    Protected Sub submitButton_Click(sender As Object, e As EventArgs)
        Core.SpecialDay.AddPersonalOff(cbAgents.Text, sDate.Date, endDate.Date, cbReason.Value.ToString, User.Identity.Name)
        gridOffDays.DataBind()
    End Sub
End Class
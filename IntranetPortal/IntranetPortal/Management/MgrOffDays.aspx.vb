Public Class MgrOffDays
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gridOffDays.DataBind()
            BindAgent()

            gridPublicHoliday.DataSource = Core.SpecialDay.GetPublicOffDays
            gridPublicHoliday.DataBind()
        End If
    End Sub

    Private Sub BindAgent()
        cbAgents.DataSource = Employee.GetAllActiveEmps()
        cbAgents.DataBind()
    End Sub
    
    Protected Sub gridOffDays_DataBinding(sender As Object, e As EventArgs)
        If gridOffDays.DataSource Is Nothing Then
            gridOffDays.DataSource = Core.SpecialDay.GetPersonalOffDays
        End If
    End Sub

    Protected Sub submitButton_Click(sender As Object, e As EventArgs)
        Core.SpecialDay.AddPersonalOff(cbAgents.Text, sDate.Date, endDate.Date, cbReason.Text, User.Identity.Name)
        gridOffDays.DataBind()
    End Sub
End Class
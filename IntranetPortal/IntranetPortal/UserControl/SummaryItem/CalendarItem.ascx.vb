Public Class CalendarItem
    Inherits SummaryItemBase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData()
        MyBase.BindData()
        BindCalendar()
    End Sub

    Sub BindCalendar()
        Using Context As New Entities
            Dim user = Page.User.Identity.Name
            Dim users = Employee.GetManagedEmployees(user)
            Dim appoints = (From appoint In Context.UserAppointments.Where(Function(ua) ua.Status = UserAppointment.AppointmentStatus.Accepted AndAlso (users.Contains(ua.Agent) Or ua.Manager = user)).ToList
                           Select New With {
                               .AppointmentId = appoint.LogID,
                               .Subject = appoint.Subject,
                               .Start = appoint.ScheduleDate,
                               .TitleLink = BuilerSubject(appoint),
                               .End = appoint.EndDate,
                               .Description = appoint.Description,
                               .Location = appoint.Location,
                               .Agent = appoint.Agent,
                               .Manager = appoint.Manager,
                               .Status = 0,
                               .Label = 0,
                               .Type = 0,
                               .AppointType = appoint.Type}).Distinct.ToList

            todayScheduler.AppointmentDataSource = appoints
            todayScheduler.DataBind()
        End Using
    End Sub

    Private Function BuilerSubject(appoint As UserAppointment) As String
        Dim ld = LeadsInfo.GetInstance(appoint.BBLE)
        Dim result = String.Format("Appointment of <a href='/viewleadsinfo.aspx?id={1}' target='_blank'>{0}</a>", ld.PropertyAddress, ld.BBLE)
        Return result
    End Function

    Protected Sub todayScheduler_PopupMenuShowing(sender As Object, e As DevExpress.Web.ASPxScheduler.PopupMenuShowingEventArgs)
        e.Menu.Items.Clear()
    End Sub
End Class
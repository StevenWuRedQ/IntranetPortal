Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxScheduler
Imports DevExpress.XtraScheduler
Imports DevExpress.Web.ASPxSplitter

Public Class Calendar
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindCalendar()

        'CType(Master, Main).LeftPanelSize = 310
    End Sub

    Sub BindCalendar()
        Using Context As New Entities
            Dim user = Page.User.Identity.Name
            Dim users = Employee.GetManagedEmployees(user)
            Dim appoints = (From appoint In Context.UserAppointments
                           Where appoint.Status = UserAppointment.AppointmentStatus.Accepted And (users.Contains(appoint.Agent) Or appoint.Manager = user)
                           Select New With {
                               .AppointmentId = appoint.LogID,
                               .Subject = appoint.Subject,
                               .Start = appoint.ScheduleDate,
                               .End = appoint.EndDate,
                               .Description = appoint.Description,
                               .Location = appoint.Location,
                               .Agent = appoint.Agent,
                               .Manager = appoint.Manager,
                               .Status = 0,
                               .Label = 0,
                               .Type = 0,
                               .AppointType = appoint.Type}).Distinct.ToList
            'From task In Context.UserTasks
            'Where task.EmployeeName.Contains(user)
            'Select New With {
            '    .AppointmentId = task.LogID,
            '    .Subject = task.Action,
            '    .Start = task.Schedule,
            '    .End = task.EndDate,
            '    .Description = task.Description,
            '    .Location = task.Location
            '    }).Distinct.ToList

            Scheduler.AppointmentDataSource = appoints
            Scheduler.DataBind()
        End Using
    End Sub

    Protected Sub Scheduler_AppointmentFormShowing(sender As Object, e As AppointmentFormEventArgs) Handles Scheduler.AppointmentFormShowing, officeScheduler.AppointmentFormShowing
        e.Container.Caption = e.Appointment.Subject
    End Sub

    Protected Sub calendarPages_ActiveTabChanged(source As Object, e As DevExpress.Web.ASPxTabControl.TabControlEventArgs) Handles calendarPages.ActiveTabChanged
        If e.Tab.Name = "tabOffice" Then
            BindOfficeCalandar()
        End If
    End Sub

    Sub BindOfficeCalandar()
        Using Context As New Entities
            Dim user = Page.User.Identity.Name
            Dim users = Employee.GetDeptUsers(Employee.GetInstance(user).Department)
            Dim appoints = (From appoint In Context.UserAppointments
                           Where appoint.Status = UserAppointment.AppointmentStatus.Accepted And (users.Contains(appoint.Agent))
                           Select New With {
                               .AppointmentId = appoint.LogID,
                               .Subject = appoint.Subject,
                               .Start = appoint.ScheduleDate,
                               .End = appoint.EndDate,
                               .Description = appoint.Description,
                               .Location = appoint.Location,
                               .Agent = appoint.Agent,
                               .Manager = appoint.Manager,
                               .Status = 0,
                               .Label = 0,
                               .Type = 0,
                               .AppointType = appoint.Type}).Distinct.ToList

            officeScheduler.AppointmentDataSource = appoints
            officeScheduler.DataBind()
        End Using
    End Sub
End Class
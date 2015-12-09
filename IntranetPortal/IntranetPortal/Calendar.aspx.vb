Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxScheduler
Imports DevExpress.XtraScheduler
Imports DevExpress.Web

Public Class Calendar
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindCalendar()
        End If

        'CType(Master, Main).LeftPanelSize = 310
    End Sub

    Sub BindCalendar()
        Using Context As New Entities
            Dim user = Page.User.Identity.Name
            Dim userslist = New List(Of String)
            userslist.AddRange(Employee.GetControledDeptEmployees(user))
            userslist.AddRange(Employee.GetManagedEmployees(user))
            Dim users = userslist.ToArray
            Dim appoints = (From appoint In Context.UserAppointments.Where(Function(ua) ua.Status = UserAppointment.AppointmentStatus.Accepted And (users.Contains(ua.Agent) Or ua.Manager = user)).ToList
                            Select New With {
                               .AppointmentId = appoint.LogID,
                               .Subject = appoint.Subject,
                               .TitleLink = BuilerSubject(appoint),
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

            Scheduler.AppointmentDataSource = appoints
            Scheduler.DataBind()
        End Using
    End Sub

    Private Function BuilerSubject(appoint As UserAppointment) As String
        Dim ld = LeadsInfo.GetInstance(appoint.BBLE)
        Dim result = String.Format("Appointment of <a href='/viewleadsinfo.aspx?id={1}' target='_blank'>{0}</a>", ld.PropertyAddress, ld.BBLE)
        Return result
    End Function

    Protected Sub Scheduler_AppointmentFormShowing(sender As Object, e As AppointmentFormEventArgs) Handles Scheduler.AppointmentFormShowing, officeScheduler.AppointmentFormShowing
        e.Container.Caption = e.Appointment.Subject
    End Sub

    Protected Sub calendarPages_ActiveTabChanged(source As Object, e As DevExpress.Web.TabControlEventArgs) Handles calendarPages.ActiveTabChanged
        If e.Tab.Name = "tabOffice" Then
            BindOfficeCalandar()
        End If
    End Sub

    Sub BindOfficeCalandar()
        Using Context As New Entities
            Dim user = Page.User.Identity.Name
            Dim users = Employee.GetDeptUsers(Employee.GetInstance(user).Department)
            Dim appoints = (From appoint In Context.UserAppointments.Where(Function(ua) ua.Status = UserAppointment.AppointmentStatus.Accepted AndAlso users.Contains(ua.Agent)).ToList
                           Select New With {
                               .AppointmentId = appoint.LogID,
                               .Subject = appoint.Subject,
                               .TitleLink = BuilerSubject(appoint),
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

    Protected Sub officeScheduler_AppointmentChanging(sender As Object, e As PersistentObjectCancelEventArgs)
        Dim appoint = CType(e.Object, DevExpress.XtraScheduler.Appointment)
        Dim apt = UserAppointment.GetAppointmentBylogID(CInt(appoint.Id))
        apt.ScheduleDate = appoint.Start
        apt.EndDate = appoint.End
        apt.Save()

        e.Cancel = True

        BindOfficeCalandar()
    End Sub

    Protected Sub Scheduler_AppointmentChanging(sender As Object, e As PersistentObjectCancelEventArgs)
        Dim appoint = CType(e.Object, DevExpress.XtraScheduler.Appointment)
        Dim apt = UserAppointment.GetAppointmentBylogID(CInt(appoint.Id))
        apt.ScheduleDate = appoint.Start
        apt.EndDate = appoint.End
        apt.Save()

        e.Cancel = True

        BindCalendar()
    End Sub

    Protected Sub officeScheduler_DataBinding(sender As Object, e As EventArgs)
        If officeScheduler.AppointmentDataSource Is Nothing Then
            BindOfficeCalandar()
        End If
    End Sub

    Protected Sub Scheduler_DataBinding(sender As Object, e As EventArgs)
        If Scheduler.AppointmentDataSource Is Nothing Then
            BindCalendar()
        End If
    End Sub
End Class
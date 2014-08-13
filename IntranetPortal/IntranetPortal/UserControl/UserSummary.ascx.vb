Imports DevExpress.Web.ASPxGridView

Public Class UserSummary
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindData()
        BindCalendar()
    End Sub

    Public ReadOnly Property Quote As String
        Get
            Using Context As New Entities
                Dim id = New Random().Next(3, 200)
                Dim qu = Context.PortalQuotes.Where(Function(q) q.QuoteID = id).SingleOrDefault

                If qu Is Nothing Then
                    Return ""
                Else
                    Return qu.Quote
                End If
            End Using
        End Get
    End Property

    Sub BindData()
        Using Context As New Entities
            'Bind Appointment
            Dim leads = (From al In Context.Leads
                                         Join appoint In Context.UserAppointments On appoint.BBLE Equals al.BBLE
                                        Where appoint.Status = UserAppointment.AppointmentStatus.Accepted And (appoint.Agent = Page.User.Identity.Name Or appoint.Manager = Page.User.Identity.Name)
                                          Select New With {
                                              .BBLE = al.BBLE,
                                              .LeadsName = al.LeadsName,
                                              .ScheduleDate = appoint.ScheduleDate
                                              }).Distinct.ToList.OrderByDescending(Function(li) li.ScheduleDate)

            gridAppointment.DataSource = leads
            gridAppointment.DataBind()
            gridAppointment.GroupBy(gridAppointment.Columns("ScheduleDate"))

            Dim emps = Employee.GetSubOrdinateWithoutMgr(Page.User.Identity.Name)
            'BindTask
            leads = (From lead In Context.Leads
                                                   Join task In Context.UserTasks On task.BBLE Equals lead.BBLE
                                                   Where task.Status = UserTask.TaskStatus.Active And task.EmployeeName.Contains(Page.User.Identity.Name)
                                                   Select New With {
                                                                    .BBLE = lead.BBLE,
                                                                    .LeadsName = lead.LeadsName,
                                                                    .ScheduleDate = task.Schedule
                                                                   }).Union(
                    From al In Context.Leads
                                       Join appoint In Context.UserAppointments On appoint.BBLE Equals al.BBLE
                                       Where appoint.Status = UserAppointment.AppointmentStatus.NewAppointment And (appoint.Agent = Page.User.Identity.Name Or appoint.Manager = Page.User.Identity.Name)
                                        Select New With {
                                                                    .BBLE = al.BBLE,
                                                                    .LeadsName = al.LeadsName,
                                                                    .ScheduleDate = appoint.ScheduleDate
                                                                   }).Union(
                                       From lead In Context.Leads.Where(Function(ld) ld.Status = LeadStatus.MgrApproval And emps.Contains(ld.EmployeeID))
                                        Select New With {
                                                                    .BBLE = lead.BBLE,
                                                                    .LeadsName = lead.LeadsName,
                                                                    .ScheduleDate = lead.AssignDate
                                                                   }
                                       ).Distinct.ToList.OrderByDescending(Function(li) li.ScheduleDate)
            gridTask.DataSource = leads
            gridTask.DataBind()

            gridTask.GroupBy(gridTask.Columns("ScheduleDate"))

            'Bind Priority Data
            Dim priorityData = Context.Leads.Where(Function(ld) ld.Status = LeadStatus.Priority And ld.EmployeeName = Page.User.Identity.Name).ToList.OrderByDescending(Function(e) e.LastUpdate2)
            gridPriority.DataSource = priorityData
            gridPriority.DataBind()

            'Bind Callback data
            Dim callbackleads = Context.Leads.Where(Function(ld) ld.Status = LeadStatus.Callback And ld.EmployeeName = Page.User.Identity.Name).ToList.OrderByDescending(Function(e) e.LastUpdate2)
            gridCallback.DataSource = callbackleads
            gridCallback.DataBind()
            CType(gridCallback.Columns("CallbackDate"), GridViewDataColumn).GroupBy()
            'gridCallback.GroupBy(gridCallback.Columns("CallbackDate"))

        End Using
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

            todayScheduler.AppointmentDataSource = appoints
            todayScheduler.DataBind()
        End Using
    End Sub

    'change the quote to the UI by steven
    Public Function HtmlBlackQuote(quote As String) As String
        Dim spliteSymble As String = "-"
        If (quote.IndexOf("~") <> 0) Then
            spliteSymble = "~"
        End If
        Dim strArry As String() = quote.Split(New Char() {spliteSymble})
        If strArry Is Nothing Or strArry.Length < 2 Then
            Return quote
        End If
        Dim FontStr As String = ""
        Dim EndStr As String = ""

        FontStr = strArry(0)

        EndStr = strArry(1)

        Return String.Format("{0}<br>-<span style=""font-weight:700;"">{1}</span>", FontStr, EndStr)
        'Return "<span style=""font-weight: 900;""> 720 QUINCY ST</span> - " & leadData
    End Function

    'Change to span let it show the blod font by steven <span style="font-weight: 900;"> 720 QUINCY ST</span> by steven
    Public Function HtmlBlackInfo(leadData As String) As String
        Dim strArry As String() = leadData.Split(New Char() {"-"c})
        If strArry Is Nothing Or strArry.Length < 2 Then
            Return leadData
        End If
        Dim FontStr As String = ""
        Dim EndStr As String = ""

        FontStr = strArry(0)

        EndStr = strArry(1)

        If strArry.Length > 2 Then
            FontStr = FontStr + "-" + EndStr
            EndStr = strArry(2)
        End If

        Return String.Format("<span style=""font-weight: 900;"">{0}</span>-{1}", FontStr, EndStr)
        'Return "<span style=""font-weight: 900;""> 720 QUINCY ST</span> - " & leadData
    End Function

    'Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
    '    Using Context As New Entities
    '        Dim lead = Context.LeadsInfoes.Where(Function(ld) ld.BBLE = e.Parameter).SingleOrDefault
    '        e.Result = lead.PropertyAddress
    '    End Using
    'End Sub

    'Protected Sub leadStatusCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
    '    If e.Parameter.Length > 0 Then

    '        If e.Parameter.StartsWith("Tomorrow") Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.Callback, DateTime.Now.AddDays(1))
    '            End If
    '        End If


    '        If e.Parameter.StartsWith(4) Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.DoorKnocks, Nothing)
    '            End If
    '        End If

    '        If e.Parameter.StartsWith(5) Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.Priority, Nothing)
    '            End If
    '        End If

    '        If e.Parameter.StartsWith(6) Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.DeadEnd, Nothing)
    '            End If
    '        End If

    '        If e.Parameter.StartsWith(7) Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.InProcess, Nothing)
    '            End If
    '        End If

    '        If e.Parameter.StartsWith(8) Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.Closed, Nothing)
    '            End If
    '        End If

    '        'Delete Lead
    '        If e.Parameter.StartsWith(11) Then
    '            If e.Parameter.Contains("|") Then
    '                Dim bble = e.Parameter.Split("|")(1)
    '                UpdateLeadStatus(bble, LeadStatus.Deleted, Nothing)
    '            End If
    '        End If

    '    End If
    'End Sub

    'Sub UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime)
    '    Lead.UpdateLeadStatus(bble, status, callbackDate)
    'End Sub

    Public Function GroupText(groupDateText As String) As String
        Dim today = DateTime.Now.Date
        Dim groupDate = Date.Parse(groupDateText).Date
        If today >= groupDate Then
            Return "Today"
        Else
            If today.AddDays(1).Equals(groupDate) Then
                Return "Tomorrow"
            Else
                Return "Future"
            End If
        End If
    End Function


    Protected Sub gridAppointment_CustomColumnGroup(sender As Object, e As CustomColumnSortEventArgs) Handles gridAppointment.CustomColumnGroup, gridTask.CustomColumnGroup, gridCallback.CustomColumnGroup
        If e.Column.FieldName = "ScheduleDate" Or e.Column.FieldName = "CallbackDate" Then
            Dim today = DateTime.Now.Date
            Dim day1 = CDate(e.Value1).Date
            Dim day2 = CDate(e.Value2).Date

            If day1 <= today Then
                day1 = today
            Else
                If day1 >= today.AddDays(2) Then
                    day1 = today.AddDays(2)
                End If
            End If

            If day2 <= today Then
                day2 = today
            Else
                If day2 >= today.AddDays(2) Then
                    day2 = today.AddDays(2)
                End If
            End If

            Dim res As Integer
            If day1 = day2 Then
                res = 0
            End If

            If day1 < day2 Then
                res = 1
            End If

            If day1 > day2 Then
                res = -1
            End If

            e.Result = res
            e.Handled = True

        End If
    End Sub

    Protected Sub gridAppointment_CustomColumnDisplayText(sender As Object, e As ASPxGridViewColumnDisplayTextEventArgs) Handles gridAppointment.CustomColumnDisplayText, gridTask.CustomColumnDisplayText, gridCallback.CustomColumnDisplayText
        If e.Column.FieldName = "ScheduleDate" Or e.Column.FieldName = "CallbackDate" Then
            e.DisplayText = GroupText(e.Value)
        End If
    End Sub
End Class
Imports DevExpress.Web.ASPxGridView

Public Class AppointmentItem
    Inherits SummaryItemBase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData()
        MyBase.BindData()

        gridAppointment.DataBind()

        If Not Page.IsPostBack Then
            gridAppointment.GroupBy(gridAppointment.Columns("ScheduleDate"))
        End If
    End Sub

    Protected Sub gridAppointment_DataBinding(sender As Object, e As EventArgs)
        If gridAppointment.DataSource Is Nothing Then
            Dim Context As New Entities
            'Bind Appointment
            Dim leads = (From al In Context.Leads
                                         Join appoint In Context.UserAppointments On appoint.BBLE Equals al.BBLE
                                        Where appoint.Status = UserAppointment.AppointmentStatus.Accepted And (appoint.Agent = Page.User.Identity.Name Or appoint.Manager = Page.User.Identity.Name) And appoint.ScheduleDate >= Today
                                          Select New With {
                                              .BBLE = al.BBLE,
                                              .LeadsName = al.LeadsName,
                                              .ScheduleDate = appoint.ScheduleDate
                                              }).Distinct.ToList.OrderByDescending(Function(li) li.ScheduleDate)

            gridAppointment.DataSource = leads
        End If
    End Sub

    Public Function HtmlBlackInfo(leadData As String) As String
        Dim symble = "-"

        Dim strArry As String() = leadData.Split(New Char() {symble})
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


    Protected Sub gridAppointment_CustomColumnGroup(sender As Object, e As CustomColumnSortEventArgs) Handles gridAppointment.CustomColumnGroup
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

    Protected Sub gridAppointment_CustomColumnDisplayText(sender As Object, e As ASPxGridViewColumnDisplayTextEventArgs) Handles gridAppointment.CustomColumnDisplayText
        If e.Column.FieldName = "ScheduleDate" Or e.Column.FieldName = "CallbackDate" Then
            e.DisplayText = GroupText(e.Value)
        End If
    End Sub

    Public Function GroupText(groupDateText As String) As String
        Dim today = DateTime.Now.Date

        If String.IsNullOrEmpty(groupDateText) Then
            Return "Today"
        End If

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

End Class
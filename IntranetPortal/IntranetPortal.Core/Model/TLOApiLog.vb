Partial Public Class TLOApiLog
    Public Shared Sub Log(bble As String, name As String, address1 As String, address2 As String, city As String, state As String, zip As String, country As String, successed As Boolean, createBy As String)
        Using ctx As New CoreEntities
            Dim log As New TLOApiLog With
                {
                    .BBLE = bble,
                    .Name = name,
                    .Address1 = address1,
                    .address2 = address2,
                    .City = city,
                    .State = state,
                    .Zip = zip,
                    .Country = country,
                    .Successed = successed,
                    .CreateBy = createBy,
                    .CreateDate = DateTime.Now
                    }

            ctx.TLOApiLogs.Add(log)
            ctx.SaveChanges()

            log.CheckApiLimit()
        End Using
    End Sub

    Public Shared Function LimiteIsExceed() As Boolean
        Return GetCount() >= PortalSettings.GetValue("TLOMonthLimit")
    End Function

    Private Function CheckApiLimit() As Boolean
        Dim count = GetCount()
        Dim MonthLimit = CInt(PortalSettings.GetValue("TLOMonthLimit"))
        Dim warningPoint = PortalSettings.GetValue("TLOWarningPoint")
        Dim left = MonthLimit - count

        If warningPoint.Contains(left) Then
            NotifyUserLimited(left, count)
        End If

        Return True
    End Function

    Public Shared ReadOnly Property IsServiceOn As Boolean
        Get
            Return CBool(PortalSettings.GetValue("TLOSwitchOn"))
        End Get
    End Property

    Public Shared Function GetCount() As Integer
        Using ctx As New CoreEntities
            Dim firstOfMonth = New Date(DateTime.Today.Year, DateTime.Today.Month, 1)
            Dim count = ctx.TLOApiLogs.Where(Function(a) a.CreateDate > firstOfMonth And a.Successed = True).Count
            Return count
        End Using
    End Function

    Private Sub NotifyUserLimited(countLeft As Integer, count As Integer)
        Dim users = PortalSettings.GetValue("TLOWarningUsers")
        Dim maildata As New Dictionary(Of String, String)
        maildata.Add("Left", countLeft)
        maildata.Add("Count", count)

        EmailService.SendMail(users, "", "TLOCallLimitedWarning", maildata)
    End Sub
End Class

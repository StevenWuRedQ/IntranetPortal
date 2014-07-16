Partial Public Class LeadsActivityLog
    Public Shared Sub AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, empid As Integer, empName As String)
        Using Context As New Entities
            Dim log As New LeadsActivityLog
            log.BBLE = bble
            log.EmployeeID = empid
            log.EmployeeName = empName
            log.Category = category
            log.ActivityDate = logDate
            log.Comments = comments

            Context.LeadsActivityLogs.Add(log)
            Context.SaveChanges()
        End Using

    End Sub

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String) As LeadsActivityLog
        Using Context As New Entities
            Dim log As New LeadsActivityLog
            log.BBLE = bble
            log.EmployeeID = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            log.EmployeeName = HttpContext.Current.User.Identity.Name
            log.Category = category
            log.ActivityDate = logDate
            log.Comments = comments

            Context.LeadsActivityLogs.Add(log)
            Context.SaveChanges()

            Return log
        End Using

    End Function

    Enum LogCategory
        SalesAgent
        Finder
        Manager
        Task
        Appointment
        Status
        Approval
        Approved
        Declined
    End Enum

End Class

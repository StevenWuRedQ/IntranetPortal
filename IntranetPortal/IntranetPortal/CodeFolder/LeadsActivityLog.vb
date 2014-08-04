Partial Public Class LeadsActivityLog
    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, empid As Integer, empName As String) As LeadsActivityLog
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

            Return log
        End Using
    End Function

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, empid As Integer, empName As String, actionType As EnumActionType) As LeadsActivityLog
        Using Context As New Entities
            Dim log As New LeadsActivityLog
            log.BBLE = bble
            log.EmployeeID = empid
            log.EmployeeName = empName
            log.Category = category
            log.ActionType = actionType
            log.ActivityDate = logDate
            log.Comments = comments

            Context.LeadsActivityLogs.Add(log)
            Context.SaveChanges()

            Return log
        End Using
    End Function

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, actionType As EnumActionType) As LeadsActivityLog
        Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
        Dim empName = HttpContext.Current.User.Identity.Name
        Return AddActivityLog(logDate, comments, bble, category, empId, empName, actionType)
    End Function

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String) As LeadsActivityLog
        Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
        Dim empName = HttpContext.Current.User.Identity.Name
        Return AddActivityLog(logDate, comments, bble, category, empId, empName)
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

    Enum EnumActionType
        CallOwner = 0
        DoorKnock = 1
    End Enum

End Class

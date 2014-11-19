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
        Dim empId As Integer
        Dim empName As String

        If HttpContext.Current Is Nothing Then
            empId = Nothing
            empName = "System"
        Else
            empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            empName = HttpContext.Current.User.Identity.Name
        End If

        Return AddActivityLog(logDate, comments, bble, category, empId, empName, actionType)
    End Function

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String) As LeadsActivityLog
        Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
        Dim empName = HttpContext.Current.User.Identity.Name
        Return AddActivityLog(logDate, comments, bble, category, empId, empName)
    End Function

    Public Shared Function GetLastComments(bble As String) As String
        Using Context As New Entities
            Dim log = Context.LeadsActivityLogs.Where(Function(lg) lg.BBLE = bble).OrderByDescending(Function(lg) lg.ActivityDate).FirstOrDefault
            If log IsNot Nothing Then
                Return log.Comments
            End If

            Return ""
        End Using
    End Function

    Enum LogCategory
        SalesAgent
        Finder
        Manager
        Task
        DoorknockTask
        Appointment
        Status
        Approval
        Approved
        Declined
    End Enum

    Enum EnumActionType
        CallOwner = 0
        DoorKnock = 1
        FollowUp = 2
        Appointment = 3
        Email = 4
        Comments = 5
        SetAsTask = 6
        UpdateInfo = 7
        DealClosed = 8
        HotLeads = 9
        Print = 10
        Approval = 11
        Approved = 12
        Declined = 13
        Reassign = 14
        DeadLead = 15
    End Enum

End Class

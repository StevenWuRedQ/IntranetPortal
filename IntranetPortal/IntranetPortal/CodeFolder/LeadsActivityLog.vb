Partial Public Class LeadsActivityLog
    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, empid As Integer, empName As String) As LeadsActivityLog

        Return AddActivityLog(logDate, comments, bble, category, empid, empName, EnumActionType.DefaultAction)

        'Using Context As New Entities
        '    Dim log As New LeadsActivityLog
        '    log.BBLE = bble
        '    log.EmployeeID = empid
        '    log.EmployeeName = empName
        '    log.Category = category
        '    log.ActivityDate = logDate
        '    log.Comments = comments

        '    Context.LeadsActivityLogs.Add(log)
        '    Context.SaveChanges()

        '    Return log
        'End Using
    End Function

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, empid As Integer, empName As String, actionType As EnumActionType) As LeadsActivityLog
        Using Context As New Entities
            Dim log = AddActivityLogEntity(logDate, comments, bble, category, empid, empName, actionType, Context)

            'Dim log As New LeadsActivityLog
            'log.BBLE = bble
            'log.EmployeeID = empid
            'log.EmployeeName = empName
            'log.Category = category
            'log.ActionType = actionType
            'log.ActivityDate = logDate
            'log.Comments = comments

            'Context.LeadsActivityLogs.Add(log)

            Select Case category
                Case LogCategory.ShortSale.ToString
                    ShortSaleManage.UpdateDate(bble, empName)

                Case Else
                    Dim ld = Context.Leads.Find(bble)
                    If ld IsNot Nothing Then
                        ld.LastUpdate = DateTime.Now
                        ld.UpdateBy = empName
                    End If
            End Select

            Context.SaveChanges()

            Return log
        End Using
    End Function

    Public Shared Function AddActivityLogEntity(logDate As DateTime, comments As String, bble As String, category As String, empid As Integer, empName As String, actionType As EnumActionType, ctx As Entities) As LeadsActivityLog
        Dim log As New LeadsActivityLog
        log.BBLE = bble
        log.EmployeeID = empid
        log.EmployeeName = empName
        log.Category = category
        log.ActionType = actionType
        log.ActivityDate = logDate
        log.Comments = comments

        ctx.LeadsActivityLogs.Add(log)

        Return log
    End Function

    Public Property AppId As Integer

    Public Shared Function AddActivityLog(logDate As DateTime, comments As String, bble As String, category As String, actionType As EnumActionType) As LeadsActivityLog
        Dim empId As Integer
        Dim empName As String

        If HttpContext.Current Is Nothing Then
            empId = Nothing
            empName = "Portal"
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

                Return Utility.RemoveHtmlTags(log.Comments)
            End If

            Return ""
        End Using
    End Function

    Public Shared Function GetLastAgentAction(bble As String) As LeadsActivityLog
        Using ctx As New Entities
            Dim agentLog = ctx.LeadsActivityLogs.Where(Function(l) l.BBLE = bble And l.EmployeeID = l.Lead.EmployeeID).OrderByDescending(Function(l) l.ActivityDate).FirstOrDefault

            Return agentLog
        End Using
    End Function

    Public Shared Function GetLeadsActivityLogs(bble As String, categories As String()) As List(Of LeadsActivityLog)
        Using ctx As New Entities
            If categories Is Nothing Then
                Return ctx.LeadsActivityLogs.Where(Function(l) l.BBLE = bble).OrderByDescending(Function(l) l.ActivityDate).ToList
            End If

            Dim logs = (From log In ctx.LeadsActivityLogs.Where(Function(l) l.BBLE = bble AndAlso categories.Contains(l.Category))
                        Join emp In ctx.Employees On log.EmployeeID Equals emp.EmployeeID
                        Select log, emp.AppId).ToList.Select(Function(item)
                                                                 item.log.AppId = item.AppId
                                                                 Return item.log
                                                             End Function).OrderByDescending(Function(l) l.ActivityDate).ToList

            Return logs
        End Using
    End Function

    Public Shared Function GetLeadsActivityLogWithArchieved(bble As String) As List(Of LeadsActivityLog)

        Using ctx As New Entities

            Dim logs = ctx.LeadsActivityLogs.Where(Function(l) l.BBLE = bble).OrderByDescending(Function(l) l.ActivityDate).ToList

            Dim archived = ctx.LeadsActivityLogArchiveds.Where(Function(l) l.BBLE = bble).ToList

            logs.AddRange(archived.Select(Function(r)
                                              Dim log As New LeadsActivityLog
                                              Core.Utility.CopyTo(r, log)
                                              Return log
                                          End Function).ToList)

            Return logs.OrderByDescending(Function(l) l.ActivityDate).ToList
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
        Email
        RecycleTask
        ShortSale
        Legal
        Eviction
        Construction
        PublicUpdate
        Title
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
        ExtendRecycle = 16
        DefaultAction = 17
        RefreshLeads = 18
        AcceptAppoitment = 19
        DeclineAppointment = 20
        Reschedule = 21
        InProcess = 22
        SharedLeads = 23
    End Enum

End Class

Public Class PortalReport

    Public Shared Function LoadLegalActivityReport(startDate As DateTime, endDate As DateTime) As List(Of CaseActivityData)
        Dim users = LegalCaseManage.LegalUsers

        Using ctx As New Entities
            Dim actionTypes = {LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.Email}
            Dim category = LeadsActivityLog.LogCategory.Legal.ToString
            Dim logs = ctx.LeadsActivityLogs.Where(Function(al) al.Category.Contains(category) And al.ActivityDate < endDate And al.ActivityDate > startDate And actionTypes.Contains(al.ActionType)).ToList

            Return BuildCaseActivityReport(CaseActivityData.ActivityType.Legal, logs, users, Core.SystemLog.GetLogs(LegalCaseManage.LogTitleOpen, startDate, endDate), Core.SystemLog.GetLogs(LegalCaseManage.LogTitleSave, startDate, endDate))
        End Using
    End Function

    Public Shared Function LoadShortSaleActivityReport(startDate As DateTime, endDate As DateTime) As List(Of CaseActivityData)
        Dim ssRoles = Roles.GetAllRoles().Where(Function(r) r.StartsWith("ShortSale-") OrElse r.StartsWith("Title-")).ToList
        Dim ssUsers As New List(Of String)

        For Each rl In ssRoles
            ssUsers.AddRange(Roles.GetUsersInRole(rl))
        Next

        Using ctx As New Entities
            Dim actionTypes = {LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.Email}
            Dim category = LeadsActivityLog.LogCategory.ShortSale.ToString
            Dim logs = ctx.LeadsActivityLogs.Where(Function(al) (al.Category.Contains(category) Or al.Category.Contains(12)) And al.ActivityDate < endDate And al.ActivityDate > startDate And actionTypes.Contains(al.ActionType)).ToList

            Return BuildCaseActivityReport(CaseActivityData.ActivityType.ShortSale, logs, ssUsers.Distinct.ToArray, ShortSaleManage.GetSSOpenCaseLogs(startDate, endDate), ShortSaleManage.GetSSSaveCaseLogs(startDate, endDate))

            'Dim report = BuildAgentActivityData(logs, ssUsers.Distinct.ToArray)

            'Dim openCaseLogs = ShortSaleManage.GetSSOpenCaseLogs(startDate, endDate)

            'Return report.Select(Function(r)
            '                         Dim useLogs = openCaseLogs.Where(Function(l) l.CreateBy = r.Name).ToList
            '                         r.AmountofViewCase = useLogs.Count
            '                         r.UniqueBBLE = useLogs.Select(Function(l) l.BBLE).Distinct.Count
            '                         Return r
            '                     End Function).ToList

        End Using
    End Function

    Private Shared Function BuildCaseActivityReport(type As CaseActivityData.ActivityType, commentslogs As List(Of LeadsActivityLog), users As String(), openLogs As List(Of Core.SystemLog), saveLogs As List(Of Core.SystemLog)) As List(Of CaseActivityData)
        Dim result As New List(Of CaseActivityData)

        For Each user In users
            Dim actData As New CaseActivityData
            actData.Type = type

            Dim clogsBBLE = commentslogs.Where(Function(c) c.EmployeeName = user).Select(Function(c) c.BBLE).ToList
            Dim oLogsBBLE = openLogs.Where(Function(o) o.CreateBy = user).Select(Function(o) o.BBLE).ToList
            Dim sLogsBBLE = saveLogs.Where(Function(s) s.CreateBy = user).Select(Function(s) s.BBLE).ToList
            actData.Name = user

            actData.TotalFileOpened = Data.ShortSaleCase.GetCaseByBBLEs(oLogsBBLE)
            actData.FilesWorkedWithComments = Data.ShortSaleCase.GetCaseByBBLEs(oLogsBBLE.Where(Function(b) clogsBBLE.Contains(b)).ToList)
            actData.FilesWorkedWithoutComments = Data.ShortSaleCase.GetCaseByBBLEs(oLogsBBLE.Where(Function(s) sLogsBBLE.Contains(s) And Not clogsBBLE.Contains(s)).ToList)
            actData.FilesViewedOnly = Data.ShortSaleCase.GetCaseByBBLEs(oLogsBBLE.Where(Function(o) Not clogsBBLE.Contains(o) And Not sLogsBBLE.Contains(o)).ToList)

            result.Add(actData)
        Next

        Return result
    End Function

    Public Shared Function LoadTeamAgentActivityReport(teamName As String, startDate As DateTime, endDate As DateTime) As List(Of AgentActivityData)
        Dim users = UserInTeam.GetTeamFinders(teamName)
        Return LoadActivityReport(users, startDate, endDate)
    End Function

    Public Shared Function LoadAgentActivityReport(agentName As String, startDate As DateTime, endDate As DateTime) As AgentActivityData
        Return LoadActivityReport({agentName}, startDate, endDate).FirstOrDefault
    End Function

    Private Shared Function LoadActivityReport(users As String(), startDate As DateTime, endDate As DateTime) As List(Of AgentActivityData)
        Using ctx As New Entities
            Dim actionTypes = {LeadsActivityLog.EnumActionType.CallOwner,
                               LeadsActivityLog.EnumActionType.Comments,
                               LeadsActivityLog.EnumActionType.DoorKnock,
                               LeadsActivityLog.EnumActionType.FollowUp,
                               LeadsActivityLog.EnumActionType.SetAsTask,
                               LeadsActivityLog.EnumActionType.Appointment}

            Dim logSql = ctx.LeadsActivityLogs.Where(Function(al) users.Contains(al.EmployeeName) And al.ActivityDate < endDate And al.ActivityDate > startDate AndAlso actionTypes.Contains(al.ActionType))
            Dim logs = logSql.ToList

            'Dim result As New List(Of AgentActivityData)
            'For Each user In users
            '    'Dim actionTypes = {LeadsActivityLog.EnumActionType.CallOwner, LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.DoorKnock,
            '    '                   LeadsActivityLog.EnumActionType.FollowUp, LeadsActivityLog.EnumActionType.SetAsTask, LeadsActivityLog.EnumActionType.Appointment}
            '    Dim userLogs = logs.Where(Function(l) l.EmployeeName = user)

            '    result.Add(New AgentActivityData With {
            '               .Name = user,
            '               .CallOwner = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.CallOwner).Count,
            '               .Comments = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Comments).Count,
            '               .DoorKnock = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.DoorKnock).Count,
            '               .FollowUp = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.FollowUp).Count,
            '               .SetAsTask = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.SetAsTask).Count,
            '               .Appointment = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Appointment).Count,
            '               .UniqueBBLE = userLogs.Select(Function(l) l.BBLE).Distinct.Count
            '               })
            'Next

            Return BuildAgentActivityData(logs, users)
        End Using
    End Function

    Private Shared Function BuildAgentActivityData(logs As List(Of LeadsActivityLog), users As String()) As List(Of AgentActivityData)
        Dim result As New List(Of AgentActivityData)
        For Each user In users
            'Dim actionTypes = {LeadsActivityLog.EnumActionType.CallOwner, LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.DoorKnock,
            '                   LeadsActivityLog.EnumActionType.FollowUp, LeadsActivityLog.EnumActionType.SetAsTask, LeadsActivityLog.EnumActionType.Appointment}
            Dim userLogs = logs.Where(Function(l) l.EmployeeName = user)

            result.Add(New AgentActivityData With {
                       .Name = user,
                       .CallOwner = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.CallOwner).Count,
                       .Comments = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Comments).Count,
                       .DoorKnock = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.DoorKnock).Count,
                       .FollowUp = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.FollowUp).Count,
                       .SetAsTask = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.SetAsTask).Count,
                       .Appointment = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Appointment).Count,
                       .Email = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Email).Count,
                       .UniqueBBLE = userLogs.Select(Function(l) l.BBLE).Distinct.Count
                       })
        Next

        Return result


    End Function

    Public Class AgentActivityData
        Public Property Name As String
        Public Property CallOwner As Integer
        Public Property Comments As Integer
        Public Property DoorKnock As Integer
        Public Property FollowUp As Integer
        Public Property SetAsTask As Integer
        Public Property Appointment As Integer
        Public Property Email As Integer
        Public Property UniqueBBLE As Integer
        Public Property AmountofViewCase As Integer
    End Class

    Public Class CaseActivityData
        Inherits AgentActivityData

        Public Property Type As ActivityType
        Public Property FilesWorkedWithComments As List(Of Data.ShortSaleCase)
        Public Property FilesWorkedWithoutComments As List(Of Data.ShortSaleCase)
        Public Property FilesViewedOnly As List(Of Data.ShortSaleCase)
        Public Property TotalFileOpened As List(Of Data.ShortSaleCase)

        Public ReadOnly Property FilesWithCmtCount As Integer
            Get
                Return FilesWorkedWithComments.Count
            End Get
        End Property

        Public ReadOnly Property FilesWithoutCmtCount As Integer
            Get
                Return FilesWorkedWithoutComments.Count
            End Get
        End Property

        Public ReadOnly Property FilesViewedCount As Integer
            Get
                Return FilesViewedOnly.Count
            End Get
        End Property


        Public Function GetViewLink(bble As String) As String
            Select Case Type
                Case ActivityType.Legal
                    Return "LegalUI/LegalUI.aspx?bble=" & bble
                Case Else
                    Return "ShortSale/ShortSale.aspx?bble=" & bble
            End Select
        End Function

        Public Enum ActivityType
            ShortSale
            Legal
        End Enum

    End Class
End Class

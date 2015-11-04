Public Class PortalReport

    Public Shared Function LoadLegalActivityReport(startDate As DateTime, endDate As DateTime) As List(Of CaseActivityData)
        Dim users = LegalCaseManage.LegalUsers

        Using ctx As New Entities
            Dim actionTypes = {LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.Email}
            Dim category = LeadsActivityLog.LogCategory.Legal.ToString
            Dim logs = ctx.LeadsActivityLogs.Where(Function(al) al.Category.Contains(category) And al.ActivityDate < endDate And al.ActivityDate > startDate And actionTypes.Contains(al.ActionType)).ToList

            Return BuildCaseActivityReport(CaseActivityData.ActivityType.Legal, logs, users, Core.SystemLog.GetLogs(LegalCaseManage.LogTitleOpen, startDate, endDate), Core.SystemLog.GetLogs(LegalCaseManage.LogTitleSave, startDate, endDate), endDate)
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

            Return BuildCaseActivityReport(CaseActivityData.ActivityType.ShortSale, logs, ssUsers.Distinct.ToArray, ShortSaleManage.GetSSOpenCaseLogs(startDate, endDate), ShortSaleManage.GetSSSaveCaseLogs(startDate, endDate), endDate)


        End Using
    End Function

    Private Shared Function BuildCaseActivityReport(type As CaseActivityData.ActivityType, commentslogs As List(Of LeadsActivityLog), users As String(), openLogs As List(Of Core.SystemLog), saveLogs As List(Of Core.SystemLog), endDate As DateTime) As List(Of CaseActivityData)
        Dim result As New List(Of CaseActivityData)

        For Each user In users
            Dim actData As New CaseActivityData
            actData.Type = type

            Dim clogsBBLE = commentslogs.Where(Function(c) c.EmployeeName = user).Select(Function(c) c.BBLE).ToArray
            Dim oLogsBBLE = openLogs.Where(Function(o) o.CreateBy = user).Select(Function(o) o.BBLE).ToArray
            Dim sLogsBBLE = saveLogs.Where(Function(s) s.CreateBy = user).Select(Function(s) s.BBLE).ToArray
            actData.Name = user

            actData.TotalFileOpened = LeadsInfo.GetLeadsByBBLEs(oLogsBBLE)
            actData.FilesWorkedWithComments = LeadsInfo.GetLeadsByBBLEs(oLogsBBLE.Where(Function(b) clogsBBLE.Contains(b)).ToArray)
            actData.FilesWorkedWithoutComments = LeadsInfo.GetLeadsByBBLEs(oLogsBBLE.Where(Function(s) sLogsBBLE.Contains(s) And Not clogsBBLE.Contains(s)).ToArray)
            actData.FilesViewedOnly = LeadsInfo.GetLeadsByBBLEs(oLogsBBLE.Where(Function(o) Not clogsBBLE.Contains(o) And Not sLogsBBLE.Contains(o)).ToArray)

            BuildMissedFollowUpData(actData, endDate)

            result.Add(actData)
        Next

        Return result
    End Function

    Public Shared Sub BuildMissedFollowUpData(actData As CaseActivityData, missedDate As String)
        Select Case actData.Type
            Case CaseActivityData.ActivityType.ShortSale
                Dim sCases = ShortSaleManage.GetSSMissedFollowUp(actData.Name, missedDate)
                actData.FollowUpMissed = sCases.Select(Function(a)
                                                           Return New FollowUpItem With {
                                                           .BBLE = a.BBLE,
                                                           .CaseName = a.CaseName,
                                                           .FollowUpDate = a.CallbackDate
                                                           }
                                                       End Function).ToArray
            Case CaseActivityData.ActivityType.Legal
                'Dim lCases = LegalCaseManage.GetMissedFollowUp(actData.Name, missedDate)
                'actData.FollowUpMissed = lCases.Select(Function(a)
                '                                           Return New FollowUpItem With {
                '                                           .BBLE = a.BBLE,
                '                                           .CaseName = a.CaseName,
                '                                           .FollowUpDate = a.FollowUp
                '                                           }
                '                                       End Function).ToArray

            Case Else

        End Select
    End Sub

    Public Shared Function LoadDeadLeadsReport(startDate As DateTime, endDate As DateTime) As List(Of AgentActivityData)

        Using ctx As New Entities

            Dim deadLogs = ctx.LeadsStatusLogs.Where(Function(l) l.CreateDate > startDate And l.CreateDate < endDate And l.Type = LeadsStatusLog.LogType.DeadLeads).ToList

            Dim result As New List(Of AgentActivityData)
            For Each emp In deadLogs.Select(Function(d) d.Employee).Distinct.ToArray
                Dim act As New AgentActivityData
                act.Name = emp
                act.TeamName = UserInTeam.GetUserTeam(emp)
                Dim bbles = deadLogs.Where(Function(d) d.Employee = emp).Select(Function(d) d.BBLE).ToArray
                act.DeadLeads = ctx.Leads.Where(Function(ld) bbles.Contains(ld.BBLE)).ToArray

                result.Add(act)
            Next

            Return result
        End Using
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

        Public Property TeamName As String
        Public ReadOnly Property DeadLeadsAmount As Integer
            Get
                Return DeadLeads.Length
            End Get
        End Property
        Public Property DeadLeads As Lead()
    End Class

    Public Class CaseActivityData
        Inherits AgentActivityData

        Public Property Type As ActivityType
        Public Property FilesWorkedWithComments As LeadsInfo()
        Public Property FilesWorkedWithoutComments As LeadsInfo()
        Public Property FilesViewedOnly As LeadsInfo()
        Public Property TotalFileOpened As LeadsInfo()

        Public Property FollowUpMissed As FollowUpItem()

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

        Public ReadOnly Property FollowUpMissedCount As Integer
            Get
                If FollowUpMissed IsNot Nothing Then
                    Return FollowUpMissed.Count
                End If

                Return 0
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

    Public Class FollowUpItem
        Public Property BBLE As String
        Public Property CaseName As String
        Public Property FollowUpDate As DateTime

    End Class
End Class

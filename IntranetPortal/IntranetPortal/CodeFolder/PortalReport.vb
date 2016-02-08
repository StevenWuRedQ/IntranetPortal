
''' <summary>
''' Generate the portal report data
''' </summary>
Public Class PortalReport

    ''' <summary>
    ''' Return all the teams leads count imported by system
    ''' </summary>
    ''' <param name="startDate">Start Date</param>
    ''' <param name="endDate">End Date</param>
    ''' <returns></returns>
    Public Shared Function LeadsImportReport(startDate As DateTime, endDate As DateTime) As Object
        Dim teams = Team.GetAllTeams.Select(Function(t)
                                                Return New With {
                                                    .Name = t.Name,
                                                    .ImportCount = 0,
                                                    .DeadCount = 0}
                                            End Function).ToList

        Using ctx As New Entities

            Dim logs = ctx.LeadsStatusLogs.Where(Function(l) l.CreateDate >= startDate AndAlso l.CreateDate < endDate AndAlso l.CreateBy = "System" AndAlso l.Type = 0).ToList
            Dim result = logs.GroupBy(Function(l) l.Employee).Select(Function(l) New With {.Key = l.Key.Replace(" Office", ""), .ImportCount = l.Select(Function(d) d.BBLE).Distinct.Count}).ToList
            Dim deadslogs = LoadDeadLeadsReport(startDate, endDate)
            Dim deadLeadsCounts = deadslogs.Where(Function(l) l.TeamName IsNot Nothing).GroupBy(Function(ad) ad.TeamName).Select(Function(ag) New With {.Key = ag.Key, .Amount = ag.Sum(Function(l) l.UniqueBBLE)}).ToList

            For Each tm In teams
                tm.ImportCount = result.Where(Function(r) r.Key.ToLower = tm.Name.ToLower).Select(Function(r) r.ImportCount).SingleOrDefault
                tm.DeadCount = deadLeadsCounts.Where(Function(a) a.Key.ToLower = tm.Name.ToLower).Select(Function(r) r.Amount).SingleOrDefault
            Next

            Return teams
        End Using
    End Function


    Public Shared Function WeeklyTeamImportReport(teamName As String) As Object
        Using ctx As New Entities
            teamName = teamName & " Office"
            Dim endDate = DateTime.Now
            Dim startDate = endDate.AddDays(-endDate.DayOfWeek - 7 * 4)

            Dim logs = ctx.LeadsStatusLogs.Where(Function(l) l.CreateDate >= startDate AndAlso l.CreateDate < endDate AndAlso l.Employee = teamName AndAlso l.CreateBy = "System" AndAlso l.Type = 0).ToList

            Dim result = logs.GroupBy(Function(a) DateAndTime.DatePart(DateInterval.WeekOfYear, a.CreateDate.Value)).Select(Function(g) New With {.WeekofYear = g.Key, .Count = g.Count}).ToList

            Return result
        End Using
        Return Nothing
    End Function


    ''' <summary>
    ''' Return lega users' activity data betweeen start date and end date
    ''' </summary>
    ''' <param name="startDate">Start Date</param>
    ''' <param name="endDate">End Date</param>
    ''' <returns></returns>
    Public Shared Function LoadLegalActivityReport(startDate As DateTime, endDate As DateTime) As List(Of CaseActivityData)
        Dim users = LegalCaseManage.LegalUsers

        Using ctx As New Entities
            Dim actionTypes = {LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.Email}
            Dim category = LeadsActivityLog.LogCategory.Legal.ToString
            Dim logs = ctx.LeadsActivityLogs.Where(Function(al) al.Category.Contains(category) And al.ActivityDate < endDate And al.ActivityDate > startDate And actionTypes.Contains(al.ActionType)).ToList

            Return BuildCaseActivityReport(CaseActivityData.ActivityType.Legal, logs, users, Core.SystemLog.GetLogs(LegalCaseManage.LogTitleOpen, startDate, endDate), Core.SystemLog.GetLogs(LegalCaseManage.LogTitleSave, startDate, endDate), endDate)
        End Using
    End Function

    ''' <summary>
    ''' Return title users' activity from start date to end
    ''' </summary>
    ''' <param name="startDate">Start Date</param>
    ''' <param name="endDate">End Date</param>
    ''' <returns></returns>
    Public Shared Function LoadTitleActivityReport(startDate As DateTime, endDate As DateTime) As List(Of CaseActivityData)
        Dim users = TitleManage.TitleUsers

        Using ctx As New Entities
            Dim actionTypes = {LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.Email}
            Dim category = LeadsActivityLog.LogCategory.Title.ToString
            Dim logs = ctx.LeadsActivityLogs.Where(Function(al) al.Category.Contains(category) And al.ActivityDate < endDate And al.ActivityDate > startDate And actionTypes.Contains(al.ActionType)).ToList

            Return BuildCaseActivityReport(CaseActivityData.ActivityType.Title, logs, users, Core.SystemLog.GetLogs(TitleManage.FormName, startDate, endDate, Core.SystemLog.LogCategory.OpenData.ToString), Core.SystemLog.GetLogs(TitleManage.FormName, startDate, endDate, Core.SystemLog.LogCategory.SaveData.ToString), endDate)
        End Using
    End Function

    ''' <summary>
    ''' Load ShortSale Activity Data
    ''' </summary>
    ''' <param name="startDate">Start Date</param>
    ''' <param name="endDate">End Date</param>
    ''' <returns>User Activity Data</returns>
    Public Shared Function LoadShortSaleActivityReport(startDate As DateTime, endDate As DateTime, Optional ssUsers As List(Of String) = Nothing) As List(Of CaseActivityData)
        If ssUsers Is Nothing Then
            ssUsers = New List(Of String)

            Dim ssRoles = Roles.GetAllRoles().Where(Function(r) r.StartsWith("ShortSale-") OrElse r.StartsWith("Title-")).ToList
            For Each rl In ssRoles
                ssUsers.AddRange(Roles.GetUsersInRole(rl))
            Next
        End If

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

    ''' <summary>
    ''' Load the user missed followup data
    ''' </summary>
    ''' <param name="actData">User's activity data</param>
    ''' <param name="missedDate">End Date</param>
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
            Case CaseActivityData.ActivityType.Title
                Dim fps = UserFollowUpManage.GetMissedFollowUp(actData.Name, missedDate)
                actData.FollowUpMissed = fps.Select(Function(a)
                                                        Return New FollowUpItem With {
                                                           .BBLE = a.BBLE,
                                                           .CaseName = a.CaseName,
                                                           .FollowUpDate = a.FollowUpDate,
                                                           .ViewUrl = a.URL
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

    ''' <summary>
    ''' Return list of Agent activity data of Dead Leads in specific date range
    ''' </summary>
    ''' <param name="startDate">Start Date</param>
    ''' <param name="endDate">End Date</param>
    ''' <returns></returns>
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
                act.UniqueBBLE = bbles.Distinct.Count
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
                If DeadLeads IsNot Nothing Then
                    Return DeadLeads.Length
                End If

                Return 0
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

        ''' <summary>
        ''' Return case view links
        ''' </summary>
        ''' <param name="bble">the property bble</param>
        ''' <returns></returns>
        Public Function GetViewLink(bble As String) As String
            Select Case Type
                Case ActivityType.Legal
                    Return "LegalUI/LegalUI.aspx?bble=" & bble
                Case ActivityType.Title
                    Return "BusinessForm/Default.aspx?tag=" & bble
                Case Else
                    Return "ShortSale/ShortSale.aspx?bble=" & bble
            End Select
        End Function

        Public Enum ActivityType
            ShortSale
            Legal
            Title
        End Enum

    End Class

    Public Class FollowUpItem
        Public Property BBLE As String
        Public Property CaseName As String
        Public Property FollowUpDate As DateTime
        Public Property ViewUrl As String
    End Class
End Class

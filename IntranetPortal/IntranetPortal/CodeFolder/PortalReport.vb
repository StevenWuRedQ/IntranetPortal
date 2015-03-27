Public Class PortalReport

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
                           .UniqueBBLE = userLogs.Select(Function(l) l.BBLE).Distinct.Count
                           })
            Next

            Return result
        End Using
    End Function

    Public Class AgentActivityData
        Public Property Name As String
        Public Property CallOwner As Integer
        Public Property Comments As Integer
        Public Property DoorKnock As Integer
        Public Property FollowUp As Integer
        Public Property SetAsTask As Integer
        Public Property Appointment As Integer
        Public Property UniqueBBLE As Integer
    End Class
End Class

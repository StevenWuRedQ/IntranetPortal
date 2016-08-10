Imports Newtonsoft.Json

''' <summary>
''' The team object and related actions
''' </summary>
Partial Public Class Team
    Public Shared Function GetAllTeams() As List(Of Team)
        Using ctx As New Entities
            Return ctx.Teams.ToList
        End Using
    End Function

    Public Shared Function GetActiveTeams() As List(Of Team)
        Using ctx As New Entities
            Return ctx.Teams.Where(Function(a) a.Active).ToList
        End Using
    End Function

    Public Shared Function GetTeam(teamName As String) As Team
        Using ctx As New Entities
            Return ctx.Teams.Where(Function(t) t.Name = teamName).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetTeam(teamId As Integer) As Team
        Using ctx As New Entities
            Return ctx.Teams.Find(teamId)
        End Using
    End Function

    Public Sub RemoveUser(userName As String)
        Using ctx As New Entities
            If ctx.UserInTeams.Any(Function(s) s.TeamId = TeamId AndAlso s.EmployeeName = userName) Then
                Dim ur = ctx.UserInTeams.Where(Function(tem) tem.TeamId = TeamId And tem.EmployeeName = userName).SingleOrDefault
                ctx.UserInTeams.Remove(ur)
                ctx.SaveChanges()
            End If
        End Using

    End Sub

    Public Sub Save(saveBy As String)
        Using ctx As New Entities
            If ctx.Teams.Any(Function(t) t.TeamId = TeamId) Then
                Me.UpdateBy = saveBy
                Me.UpdateTime = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Added
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    <JsonIgnoreAttribute>
    Public ReadOnly Property AllUsers As String()
        Get
            Return UserInTeam.GetTeamUsersArray(Name)
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property ActiveUsers As String()
        Get
            Return UserInTeam.GetTeamActiveUser(Name)
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property UnActiveUsers As String()
        Get
            Return UserInTeam.GetTeamUnActiveUser(Name)
        End Get
    End Property

    Private Function GetUnActiveUser(teamName As String) As List(Of String)
        Dim unActiveUser = Employee.GetDeptUnActiveUserList(teamName).Select(Function(emp) emp.Name).ToList
        'Add team non-active users
        unActiveUser.AddRange(UnActiveUsers)
        unActiveUser = unActiveUser.Distinct.ToList

        Return unActiveUser
    End Function

    ''' <summary>
    ''' Return if daily creation limit of team is reached. 
    ''' The limitation was set in portal settings.
    ''' </summary>
    ''' <returns></returns>
    Public Function OverLimitation() As Boolean
        If Not LeadsCreateLimit.HasValue OrElse LeadsCreateLimit = 0 Then
            LeadsCreateLimit = CInt(IntranetPortal.Core.PortalSettings.GetValue("LeadsCreatedLimit"))
        End If

        Return OverLimitation(LeadsCreateLimit)
    End Function

    ''' <summary>
    ''' Return if given daily limit of team is reached.
    ''' </summary>
    ''' <param name="limit">The daily limitation</param>
    ''' <returns></returns>
    Public Function OverLimitation(limit As Integer) As Boolean
        Dim today = DateTime.Today
        Dim count = GetTeamCreateLeadsCount(today, today.AddDays(1))

        Return count >= limit
    End Function

    ''' <summary>
    ''' Return the amount of leads that team created in the given time period. 
    ''' </summary>
    ''' <param name="startDate">the start date</param>
    ''' <param name="endDate">the end date</param>
    ''' <returns></returns>
    Public Function GetTeamCreateLeadsCount(startDate As DateTime, endDate As DateTime) As Integer

        Return LeadsStatusLog.GetNewLeadsCreatedCount(AllUsers, startDate, endDate)

    End Function

    <JsonIgnoreAttribute>
    Public ReadOnly Property AssignLeadsView() As IEnumerable(Of LeadsAssignView2)
        Get
            Dim ctx As New Entities
            Dim officeName = Name & " Office"

            'check the old non active users
            Dim unActiveUser = GetUnActiveUser(Name)

            Return ctx.LeadsAssignView2.Where(Function(la) la.EmployeeName = officeName Or (unActiveUser.Contains(la.EmployeeName) And la.Status <> LeadStatus.InProcess)).OrderByDescending(Function(la) la.AssignDate)
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property AssignLeadsCount As Integer
        Get
            Dim ctx As New Entities
            Dim officeName = Name & " Office"

            'check the old non active users
            Dim unActiveUser = GetUnActiveUser(Name)

            Return ctx.Leads.Where(Function(la) la.EmployeeName = officeName Or (unActiveUser.Contains(la.EmployeeName) And la.Status <> LeadStatus.InProcess)).Count

        End Get
    End Property

    Private _managers As String()
    <JsonIgnoreAttribute>
    Public ReadOnly Property TeamManagers As String()
        Get
            If _managers Is Nothing Then
                Dim roleName = String.Format("OfficeManager-{0}", Name)
                _managers = Roles.GetUsersInRole(roleName)
            End If
            Return _managers
        End Get
    End Property

    Public ReadOnly Property ManagerData As Employee
        Get
            Return Employee.GetInstance(Manager)
        End Get
    End Property

    Public ReadOnly Property AssistantData As Employee
        Get
            Return Employee.GetInstance(Assistant)
        End Get
    End Property

    Public Function GetLeadsByStatus(status As LeadStatus) As List(Of Lead)
        Return Lead.GetUserLeadsData(AllUsers, status)
    End Function
End Class

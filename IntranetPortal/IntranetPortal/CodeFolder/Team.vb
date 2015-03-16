Partial Public Class Team
    Public Shared Function GetAllTeams() As List(Of Team)
        Using ctx As New Entities
            Return ctx.Teams.ToList
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

    Public ReadOnly Property AllUsers As String()
        Get
            Return UserInTeam.GetTeamUsersArray(Name)
        End Get
    End Property

    Public ReadOnly Property ActiveUsers As String()
        Get
            Return UserInTeam.GetTeamActiveUser(Name)
        End Get
    End Property

    Public ReadOnly Property UnActiveUsers As String()
        Get
            Return UserInTeam.GetTeamUnActiveUser(Name)
        End Get
    End Property

    Public ReadOnly Property AssignLeadsView() As IEnumerable(Of LeadsAssignView2)
        Get
            Dim ctx As New Entities
            Dim officeName = Name & " Office"

            'check the old non active users
            Dim unActiveUser = Employee.GetDeptUsersList(Name, False).Select(Function(emp) emp.Name).ToList
            'Add team non-active users
            unActiveUser.AddRange(UnActiveUsers)
            unActiveUser = unActiveUser.Distinct.ToList

            Return ctx.LeadsAssignView2.Where(Function(la) la.EmployeeName = officeName Or (unActiveUser.Contains(la.EmployeeName) And la.Status <> LeadStatus.InProcess)).OrderBy(Function(la) la.BBLE)
        End Get
    End Property

    Public ReadOnly Property AssignLeadsCount As Integer
        Get
            Dim ctx As New Entities
            Dim officeName = Name & " Office"

            'check the old non active users
            Dim unActiveUser = Employee.GetDeptUsersList(Name, False).Select(Function(emp) emp.Name).ToList
            'Add team non-active users
            unActiveUser.AddRange(UnActiveUsers)
            unActiveUser = unActiveUser.Distinct.ToList

            Return ctx.Leads.Where(Function(la) la.EmployeeName = officeName Or (unActiveUser.Contains(la.EmployeeName) And la.Status <> LeadStatus.InProcess)).Count

        End Get
    End Property

End Class

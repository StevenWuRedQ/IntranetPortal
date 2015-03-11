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

    Public ReadOnly Property AllUsers As String()
        Get
            Return Employee.GetAllTeamUsers(TeamId)
        End Get
    End Property

    Public ReadOnly Property ActiveUsers As String()
        Get
            Return Employee.GetTeamUsers(TeamId)
        End Get
    End Property
End Class

Partial Public Class UserInTeam
    Public Property TeamName As String
    Public Property EmployeeId As Integer
    Public Property EmployeePosition As String

    Public Shared Function GetTeamUsers(teamNames As String) As List(Of UserInTeam)
        Using ctx As New Entities
            Dim items = From ut In ctx.UserInTeams
                           Join team In ctx.Teams On ut.TeamId Equals team.TeamId
                           Join Emp In ctx.Employees On ut.EmployeeName Equals Emp.Name
                           Where teamNames.Contains(team.Name) Or teamNames = "*"
                           Select New With {
                               .UserTeam = ut,
                               .TeamName = team.Name,
                               .EmployeeId = Emp.EmployeeID,
                               .Position = Emp.Position
                               }

            Dim result As New List(Of UserInTeam)
            For Each item In items
                item.UserTeam.TeamName = item.TeamName
                item.UserTeam.EmployeeId = item.EmployeeId
                item.UserTeam.EmployeePosition = item.Position
                result.Add(item.UserTeam)
            Next

            Return result.ToList
        End Using
    End Function

    Public Shared Function GetTeamUsersByNames(names As String()) As List(Of UserInTeam)
        Using ctx As New Entities
            Dim items = From ut In ctx.UserInTeams
                           Join team In ctx.Teams On ut.TeamId Equals team.TeamId
                           Join Emp In ctx.Employees On ut.EmployeeName Equals Emp.Name
                           Where names.Contains(ut.EmployeeName)
                           Select New With {
                               .UserTeam = ut,
                               .TeamName = team.Name,
                               .EmployeeId = Emp.EmployeeID,
             .Position = Emp.Position
                               }

            Dim result As New List(Of UserInTeam)
            For Each item In items
                item.UserTeam.TeamName = item.TeamName
                item.UserTeam.EmployeeId = item.EmployeeId
                item.UserTeam.EmployeePosition = item.Position
                result.Add(item.UserTeam)
            Next

            Return result.ToList
        End Using
    End Function

    Public Shared Function GetAllUsers() As List(Of UserInTeam)
        Return GetTeamUsers("*")
    End Function
End Class

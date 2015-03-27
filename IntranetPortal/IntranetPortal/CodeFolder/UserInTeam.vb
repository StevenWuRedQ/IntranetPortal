
Partial Public Class UserInTeam
    Public Property TeamName As String
    Public Property EmployeeId As Integer
    Public Property EmployeePosition As String
    Public Property EmployeeActive As Boolean

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
                               .Position = Emp.Position,
                               .Active = Emp.Active
                               }

            Dim result As New List(Of UserInTeam)
            For Each item In items
                item.UserTeam.TeamName = item.TeamName
                item.UserTeam.EmployeeId = item.EmployeeId
                item.UserTeam.EmployeePosition = item.Position
                item.UserTeam.EmployeeActive = item.Active
                result.Add(item.UserTeam)
            Next

            Return result.ToList
        End Using
    End Function

    Public Shared Function GetTeamUsersArray(teamNames As String) As String()
        Return GetTeamUsers(teamNames).Select(Function(u) u.EmployeeName).ToArray
    End Function

    Public Shared Function GetTeamFinders(teamNames As String) As String()
        Dim position = {"Finder"}
        Return GetTeamUsers(teamNames).Where(Function(t) position.Contains(t.EmployeePosition) And t.EmployeeActive).Select(Function(u) u.EmployeeName).ToArray
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
                               .Position = Emp.Position,
                                .Active = Emp.Active
                               }

            Dim result As New List(Of UserInTeam)
            For Each item In items
                item.UserTeam.TeamName = item.TeamName
                item.UserTeam.EmployeeId = item.EmployeeId
                item.UserTeam.EmployeePosition = item.Position
                item.UserTeam.EmployeeActive = item.Active
                result.Add(item.UserTeam)
            Next

            Return result.ToList
        End Using
    End Function

    Public Shared Function GetAllUsers() As List(Of UserInTeam)
        Return GetTeamUsers("*")
    End Function

    Public Shared Function GetTeamActiveUser(teamName As String) As String()
        Return SelectEmployeeArray(GetTeamUsers(teamName).Where(Function(emp) emp.EmployeeActive = True))
    End Function

    Public Shared Function GetTeamUnActiveUser(teamName As String) As String()
        Return SelectEmployeeArray(GetTeamUsers(teamName).Where(Function(emp) emp.EmployeeActive = False))
    End Function

    Private Shared Function SelectEmployeeArray(usersInTeam As IEnumerable(Of UserInTeam)) As String()
        Return usersInTeam.Select(Function(u) u.EmployeeName).ToArray
    End Function

    Public Shared Function GetUserTeam(userName As String) As String
        Dim ut = GetTeamUsersByNames({userName}).FirstOrDefault
        If ut IsNot Nothing Then
            Return ut.TeamName
        End If

        Return Nothing
    End Function
End Class

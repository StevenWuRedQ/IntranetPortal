Public Class PortalRoleProvider
    Inherits RoleProvider

    Public Overrides Sub AddUsersToRoles(usernames() As String, roleNames() As String)
        Throw New NotImplementedException()
    End Sub

    Public Overrides Property ApplicationName As String = ""

    Public Overrides Sub Initialize(name As String, config As NameValueCollection)
        If config Is Nothing Then _
            Throw New ArgumentNullException("config")

        If name Is Nothing OrElse name.Length = 0 Then _
            name = "PortalRoleProvider"


        If config("applicationName") Is Nothing OrElse config("applicationName").Trim() = "" Then
            ApplicationName = System.Web.Hosting.HostingEnvironment.ApplicationVirtualPath
        Else
            ApplicationName = config("applicationName")
        End If

        ' Initialize the abstract base class.
        MyBase.Initialize(name, config)

    End Sub

    Public Overrides Sub CreateRole(roleName As String)
        Using context As New Entities
            context.Roles.Add(New Role() With {
                              .Rolename = roleName,
                              .ApplicationName = ApplicationName
                              })
            context.SaveChanges()
        End Using
    End Sub

    Public Overrides Function DeleteRole(roleName As String, throwOnPopulatedRole As Boolean) As Boolean
        Try
            Using Context As New Entities
                Dim role = Context.Roles.Where(Function(r) r.Rolename = roleName And r.ApplicationName = ApplicationName).SingleOrDefault
                Context.Roles.Remove(role)

                Context.SaveChanges()
            End Using
        Catch ex As Exception
            Return False
        End Try
        Return True
    End Function

    Public Overrides Function FindUsersInRole(roleName As String, usernameToMatch As String) As String()
        Throw New NotImplementedException()
    End Function

    Public Overrides Function GetAllRoles() As String()
        Try
            Using ctx As New Entities
                Return ctx.Roles.Select(Function(r) r.Rolename).ToArray
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Overrides Function GetRolesForUser(username As String) As String()
        Using context As New Entities
            Dim roles = context.UsersInRoles.Where(Function(u) u.Username = username And u.ApplicationName = ApplicationName).Select(Function(u) u.Rolename).ToList

            Return roles.ToArray()
        End Using
    End Function

    Public Overrides Function GetUsersInRole(roleName As String) As String()
        Using context As New Entities
            Dim appid = Employee.CurrentAppId

            Dim result = From ui In context.UsersInRoles
                         Join emp In context.Employees On ui.Username Equals emp.Name
                         Where ui.ApplicationName = ApplicationName And ui.Rolename = roleName And emp.AppId = appid
                         Select ui.Username


            Return result.ToArray
        End Using
    End Function

    Public Overrides Function IsUserInRole(username As String, roleName As String) As Boolean

        Using context As New Entities
            If (roleName.IndexOf("*") > 0) Then
                Dim likeRole = roleName.Replace("*", "")
                Return context.UsersInRoles.Where(Function(r) r.ApplicationName = ApplicationName And r.Rolename.Contains(likeRole) And r.Username = username).Count > 0
            End If
            Return context.UsersInRoles.Where(Function(r) r.ApplicationName = ApplicationName And r.Rolename = roleName And r.Username = username).Count > 0
        End Using
    End Function

    Public Overrides Sub RemoveUsersFromRoles(usernames() As String, roleNames() As String)
        Throw New NotImplementedException()
    End Sub

    Public Overrides Function RoleExists(roleName As String) As Boolean
        Using context As New Entities
            Return context.Roles.Where(Function(r) r.ApplicationName = ApplicationName And r.Rolename = roleName).Count > 0
        End Using
    End Function
End Class

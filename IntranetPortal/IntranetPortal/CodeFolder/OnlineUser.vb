Imports System.Web.SessionState
Imports System.Web
Imports System.Web.HttpApplication
Imports System.Security

Public Class OnlineUser
    Public Property UserName As String
    Public Property IPAddress As String
    Public Property LoginTime As DateTime
    Public Property RefreshTime As DateTime
    Public Property SessionID As String

    Public Const LoginTimeout As Integer = 30
    Public Const RefreshTimeout As Integer = 10

    Public Shared ReadOnly Property OnlineUsers As List(Of OnlineUser)
        Get
            If HttpContext.Current.Application("Users") IsNot Nothing Then
                Return CType(HttpContext.Current.Application("Users"), List(Of OnlineUser))
            End If
            Return Nothing
        End Get
    End Property

    Public Shared ReadOnly Property IsActive(userName As String) As Boolean
        Get
            Dim user = OnlineUsers.Where(Function(a) a.UserName = userName).FirstOrDefault
            If user Is Nothing Then
                Return False
            Else
                Return user.RefreshTime.AddMinutes(LoginTimeout) > DateTime.Now
            End If
        End Get
    End Property

    Public Shared Function Refresh(context As HttpContext) As Boolean
        If context Is Nothing OrElse context.User Is Nothing OrElse context.User.Identity Is Nothing Then
            Return False
        End If

        If Not String.IsNullOrEmpty(context.User.Identity.Name) Then
            context.Application.Lock()
            Dim users = CType(context.Application("Users"), List(Of OnlineUser))

            If users Is Nothing Then
                context.Application.Lock()
                context.Application("Users") = New List(Of OnlineUser)
                context.Application.UnLock()
            End If

            Dim currentUser = users.Where(Function(u) u.UserName = context.User.Identity.Name).SingleOrDefault

            If currentUser IsNot Nothing Then
                If currentUser.RefreshTime.AddMinutes(LoginTimeout) < DateTime.Now Then
                    users.Remove(currentUser)
                    context.Application("Users") = users
                    context.Application.UnLock()
                    Return False
                End If

                If currentUser.RefreshTime.AddMinutes(RefreshTimeout) > DateTime.Now Then
                    context.Application.UnLock()
                    Return True
                End If

                currentUser.RefreshTime = DateTime.Now
            Else
                Dim newUser As New OnlineUser
                newUser.UserName = context.User.Identity.Name
                newUser.IPAddress = context.Request.ServerVariables("REMOTE_ADDR")
                newUser.LoginTime = DateTime.Now
                newUser.RefreshTime = DateTime.Now

                users.Add(AddLog(newUser))
            End If
            context.Application("Users") = users
            context.Application.UnLock()

            RefreshUserList()

            Return True
        End If
    End Function

    Public Shared LastRefreshTime As DateTime
    Public Shared Sub RefreshUserList()
        If LastRefreshTime.AddMinutes(10) < DateTime.Now Then
            HttpContext.Current.Application.Lock()
            Dim users = CType(HttpContext.Current.Application("Users"), List(Of OnlineUser))

            For Each item In users.Where(Function(u) u.RefreshTime.AddMinutes(10) < DateTime.Now)
                UpdateLog(item)

            Next

            users.RemoveAll(Function(u) u.RefreshTime.AddMinutes(10) < DateTime.Now)
            HttpContext.Current.Application("Users") = users
            HttpContext.Current.Application.UnLock()
        End If
    End Sub

    Public Shared Sub LogoutUserFromSystem()


    End Sub

    Public Shared Sub LogoutUser(name As String)
        HttpContext.Current.Application.Lock()
        Dim users = CType(HttpContext.Current.Application("Users"), List(Of OnlineUser))
        Dim currentUser = users.Where(Function(u) u.UserName = name).SingleOrDefault
        If currentUser IsNot Nothing Then
            UpdateLog(currentUser)
            users.Remove(currentUser)
        End If

        HttpContext.Current.Application("Users") = users
        HttpContext.Current.Application.UnLock()
    End Sub

    Shared Function AddLog(user As OnlineUser) As OnlineUser
        Using Context As New Entities
            Dim Log As New LoginLog
            Log.Employee = user.UserName
            Log.CreateDate = DateTime.Now
            Log.LogInTime = DateTime.Now
            Log.IPAddress = user.IPAddress

            Log = Context.LoginLogs.Add(Log)
            Context.SaveChanges()
            user.SessionID = Log.LogID

            Return user
        End Using
    End Function

    Shared Function UpdateLog(user As OnlineUser) As Boolean
        Using context As New Entities
            Dim log = context.LoginLogs.Where(Function(l) l.LogID = user.SessionID).SingleOrDefault
            If log IsNot Nothing Then
                log.LogoutTime = IIf(user.RefreshTime = DateTime.MinValue, DateTime.Now, user.RefreshTime)
                context.SaveChanges()
            End If

            Return True
        End Using
    End Function
End Class

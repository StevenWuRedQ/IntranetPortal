Imports Microsoft.AspNet.SignalR

Public Class ChatHub
    Inherits Hub

    Shared ConnectedUsers As New List(Of UserDetail)
    Shared CurrentMessage As New List(Of MessageDetail)

    Public Sub Send(name As String, message As String)
        name = HttpContext.Current.User.Identity.Name
        Clients.All.broadcastMessage(name, message)
    End Sub

    Public Sub Connect()
        Dim id = Context.ConnectionId
        Dim userName = HttpContext.Current.User.Identity.Name

        If ConnectedUsers.Any(Function(a) a.UserName = userName) Then
            Dim user = ConnectedUsers.First(Function(a) a.UserName = userName)
            user.ConnectionId = id
            Clients.Caller.onConnected(user.ConnectionId, user.UserName, ConnectedUsers, CurrentMessage)
            Return
        End If

        If Not ConnectedUsers.Any(Function(a) a.ConnectionId = id) Then
            ConnectedUsers.Add(New UserDetail() With {
                               .ConnectionId = id,
                               .UserName = HttpContext.Current.User.Identity.Name
                               })

            Clients.Caller.onConnected(id, userName, ConnectedUsers, CurrentMessage)

            Clients.AllExcept(id).onNewUserConnected(id, userName)
        End If
    End Sub

    Public Overrides Function OnDisconnected(stopCalled As Boolean) As Threading.Tasks.Task
        Dim user = ConnectedUsers.FirstOrDefault(Function(u) u.ConnectionId = Context.ConnectionId)

        If user IsNot Nothing Then
            ConnectedUsers.Remove(user)
            Dim id = Context.ConnectionId
            Clients.All.onUserDisconnected(id, user.UserName)
        End If

        Return MyBase.OnDisconnected(stopCalled)
    End Function

    Public Sub SendMessageToAll(userName As String, message As String)
        AddMessageinCache(userName, message)
        Clients.All.messageReceived(userName, message)
    End Sub

    Public Sub SendPrivateMessage(toUserName As String, message As String)
        Dim fromUser = ConnectedUsers.FirstOrDefault(Function(u) u.ConnectionId = Context.ConnectionId)
        Dim toUser = ConnectedUsers.FirstOrDefault(Function(u) u.UserName = toUserName)

        If toUser IsNot Nothing AndAlso fromUser IsNot Nothing Then
            Clients.Client(toUser.ConnectionId).sendPrivateMessage(fromUser.UserName, fromUser.ConnectionId, fromUser.UserName, message)
            Clients.Caller.sendPrivateMessage(toUser.UserName, toUser.ConnectionId, fromUser.UserName, message)
        End If
    End Sub

    Private Sub AddMessageinCache(userName As String, message As String)
        CurrentMessage.Add(New MessageDetail With {.UserName = userName, .Message = message, .CreateDate = DateTime.Now})

        If (CurrentMessage.Count > 100) Then
            CurrentMessage.RemoveAt(0)
        End If
    End Sub
End Class

Public Class UserDetail
    Public Property ConnectionId As String
    Public Property UserName As String
End Class

Public Class MessageDetail
    Public Property UserName As String
    Public Property Message As String
    Public Property CreateDate As DateTime
End Class
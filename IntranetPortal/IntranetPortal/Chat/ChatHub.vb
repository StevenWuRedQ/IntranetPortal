Imports Microsoft.AspNet.SignalR

Public Class ChatHub
    Inherits Hub

    Public Sub Hello()
        Clients.All.Hello()
    End Sub

    Public Sub Send(name As String, message As String)
        name = HttpContext.Current.User.Identity.Name
        Clients.All.broadcastMessage(name, message)
    End Sub

    Public Sub Connect()

    End Sub

End Class

Imports Microsoft.Owin
Imports Owin
Imports Microsoft.AspNet.SignalR

Public Class Startup
    Public Sub Configuration(app As IAppBuilder)
        app.MapSignalR()
    End Sub
End Class

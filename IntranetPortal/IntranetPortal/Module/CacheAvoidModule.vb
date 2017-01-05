Public Class CacheAvoidModule
    Implements IHttpModule

    Public Sub Dispose() Implements IHttpModule.Dispose
    End Sub

    Public Sub Init(context As HttpApplication) Implements IHttpModule.Init
        AddHandler context.EndRequest, AddressOf Me.OnEndRequest
    End Sub

    Public Sub OnEndRequest(sender As Object, e As EventArgs)
        Dim app = CType(sender, HttpApplication)

        If app.Context.Response.ContentType = "application/x-javascript" OrElse
           app.Context.Response.ContentType = "application/javascript" OrElse
           app.Context.Response.ContentType = "text/css" Then
            Dim Tomorrow12Am = Date.Today.AddDays(1)
            Dim MinDiff = (Tomorrow12Am - Date.Now).TotalMinutes
            app.Context.Response.Expires = MinDiff
        End If
    End Sub
End Class

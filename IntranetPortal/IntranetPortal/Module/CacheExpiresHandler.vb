Public Class CacheExpiresHandler
    Implements IHttpHandler

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim response = context.Response
        If response.ContentType = "application/x-javascript" OrElse response.ContentType = "application/javascript" OrElse response.ContentType = "text/css" Then
            Dim Tomorrow12Am = Date.Today.AddDays(1)
            Dim MinDiff = (Tomorrow12Am - Date.Now).TotalMinutes
            response.Expires = MinDiff
        End If
    End Sub
End Class

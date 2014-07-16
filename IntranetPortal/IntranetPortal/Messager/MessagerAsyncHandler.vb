Imports System.Web
Imports System.Web.Script.Serialization

Namespace Messager
    Public Class MessagerAsyncHandler
        Implements IHttpAsyncHandler

        Public Function BeginProcessRequest(context As HttpContext, cb As AsyncCallback, extraData As Object) As IAsyncResult Implements IHttpAsyncHandler.BeginProcessRequest
            'Refresh online user list
            OnlineUser.Refresh(HttpContext.Current)
            UserTask.UpdateNotify()
            Dim msg = UserMessage.GetNewMessage(context.User.Identity.Name)
            Dim result = New MessagerAsyncResult(context, msg)

            Return result
        End Function

        Public Sub EndProcessRequest(result As IAsyncResult) Implements IHttpAsyncHandler.EndProcessRequest
            Dim rslt = CType(result, MessagerAsyncResult)
            Dim user = rslt.context.User.Identity.Name

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(rslt.Message)

            If rslt.Message IsNot Nothing Then
                rslt.context.Response.Clear()
                rslt.context.Response.ContentType = "text/html"
                rslt.context.Response.Write(jsonString)
            End If
        End Sub

        Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
            Get
                Return True
            End Get
        End Property

        Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
            Throw New NotImplementedException()
        End Sub

    End Class
End Namespace


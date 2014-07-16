Imports System.Web

Namespace Messager
    Public Class MessagerHandler
        Implements IHttpHandler

        ''' <summary>
        '''  You will need to configure this handler in the Web.config file of your 
        '''  web and register it with IIS before being able to use it. For more information
        '''  see the following link: http://go.microsoft.com/?linkid=8101007
        ''' </summary>
#Region "IHttpHandler Members"

        Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
            Get
                ' Return false in case your Managed Handler cannot be reused for another request.
                ' Usually this would be false in case you have some state information preserved per request.
                Return True
            End Get
        End Property

        Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
            Dim userName = context.User.Identity.Name
            Dim msgId = context.Request("msgId")
            If msgId IsNot Nothing Then
                msgId = CInt(msgId)
                UserMessage.ReadMsg(userName, msgId)
            End If
        End Sub

#End Region

    End Class
End Namespace
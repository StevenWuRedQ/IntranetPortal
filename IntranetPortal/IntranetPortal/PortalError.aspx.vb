Public Class PortalError
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim generalErrorMsg = "A problem has occurred on this web site. Please try again. " &
          "If this error continues, please contact support."
        Dim unhandledErrorMsg = "The error was unhandled by application code."

        If Request.QueryString("errorId") IsNot Nothing Then
            generalErrorMsg = generalErrorMsg & " Error Id: " & Request.QueryString("errorId")
        End If

        FriendlyErrorMsg.Text = generalErrorMsg

        Dim errorCode = Request.QueryString("code")
        If Not String.IsNullOrEmpty(errorCode) Then
            Dim msg = ErrorMessages.Where(Function(m) m.Code = errorCode).SingleOrDefault

            IntranetPortal.Core.SystemLog.Log(msg.Description, Request.RawUrl, Core.SystemLog.LogCategory.Operation, Nothing, Page.User.Identity.Name)
            If msg IsNot Nothing Then
                FriendlyErrorMsg.Text = msg.Message
            End If
        End If

        Dim ex = Server.GetLastError()

        If ex Is Nothing Then
            ex = New Exception(unhandledErrorMsg)
        End If

        If Request.IsLocal Then
            ErrorDetailedMsg.Text = ex.Message
            DetailedErrorPanel.Visible = True

            If ex.InnerException IsNot Nothing Then
                InnerMessage.Text = ex.GetType().ToString & "<br />" & ex.InnerException.Message
                InnerTrace.Text = ex.InnerException.StackTrace
            Else
                InnerMessage.Text = ex.GetType().ToString
                If ex.StackTrace IsNot Nothing Then
                    InnerTrace.Text = ex.StackTrace.ToString.TrimStart
                End If
            End If
        End If

        Server.ClearError()
    End Sub

    Private Shared _messages As List(Of CustomErrorMsg)
    Private ReadOnly Property ErrorMessages As List(Of CustomErrorMsg)
        Get
            If _messages Is Nothing Then
                LoadMessages()
            End If

            Return _messages
        End Get
    End Property

    Private Sub LoadMessages()
        If _messages Is Nothing Then
            _messages = New List(Of CustomErrorMsg)
            _messages.Add(New CustomErrorMsg() With {.Code = 1001, .Description = "UnauthorizedAccess", .Message = "Sorry, you do not have permission to view this case. Thank you."})
            _messages.Add(New CustomErrorMsg() With {.Code = 1002, .Description = "Service Not Available", .Message = "We are sorry, but you cannot create an offer for this property. Please create a Pre-Deal. Thank you."})
            _messages.Add(New CustomErrorMsg() With {.Code = 1003, .Description = "Service Not Available", .Message = "We are sorry, but you cannot create an offer for this property. Please check if the Document Search is Complete. Thank you."})
        End If

    End Sub

End Class

Class CustomErrorMsg
    Public Property Code As String
    Public Property Description As String
    Public Property Message As String
End Class
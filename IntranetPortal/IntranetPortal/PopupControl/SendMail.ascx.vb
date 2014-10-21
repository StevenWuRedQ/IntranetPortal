Public Class SendMailControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub PopupSendMail_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        If Not PopupContentSendMail.Visible Then
            PopupContentSendMail.Visible = True
        End If

        If e.Parameter = "SendMail" Then
            Dim attachments = EmailAttachments.Text.Split(",")
            IntranetPortal.Core.EmailService.SendMail(EmailToIDs.Text, EmailCCIDs.Text, EmailSuject.Text, EmailBody.Html, attachments)

            EmailToIDs.Text = ""
            EmailCCIDs.Text = ""
            EmailSuject.Text = ""
            EmailBody.Html = ""
        End If
    End Sub
End Class
Public Class SendMailControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub PopupSendMail_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        If Not PopupContentSendMail.Visible Then
            PopupContentSendMail.Visible = True
        End If

        If e.Parameter.StartsWith("SendMail") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim attachments = EmailAttachments.Text.Split(",")
            Dim mailId = IntranetPortal.Core.EmailService.SendMail(EmailToIDs.Text, EmailCCIDs.Text, EmailSuject.Text, EmailBody.Html, attachments)
            'Dim comments = String.Format("{0} send an email.", Page.User.Identity.Name)
            LeadsActivityLog.AddActivityLog(DateTime.Now, mailId, bble, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Email)
            EmailToIDs.Text = ""
            EmailCCIDs.Text = ""
            EmailSuject.Text = ""
            EmailBody.Html = ""
        End If
    End Sub
End Class
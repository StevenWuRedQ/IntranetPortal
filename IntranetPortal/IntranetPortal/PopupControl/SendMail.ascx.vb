﻿Imports DevExpress.Web.ASPxHtmlEditor
Imports DevExpress.Web.ASPxEditors

Public Class SendMailControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EmailBody.Toolbars.Add(Utility.CreateCustomToolbar("Custom"))
        If (Not IsPostBack) Then
            'BindEmail()
        End If
    End Sub

    'Protected Function CreateDemoCustomToolbar(ByVal name As String) As HtmlEditorToolbar
    '    Return New HtmlEditorToolbar(name, New ToolbarFontSizeEdit(), New ToolbarJustifyLeftButton(True), New ToolbarJustifyCenterButton(), New ToolbarJustifyRightButton(), New ToolbarJustifyFullButton(), New ToolbarBoldButton(), New ToolbarItalicButton(), New ToolbarUnderlineButton()).CreateDefaultItems()
    'End Function

    Protected Sub PopupSendMail_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        If Not PopupContentSendMail.Visible Then
            PopupContentSendMail.Visible = True
            BindEmail()
        End If

        If e.Parameter.StartsWith("SendMail") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim attachments As New List(Of String)

            If Not String.IsNullOrEmpty(EmailAttachments.Text) Then
                attachments = EmailAttachments.Text.Split(",").ToList
            End If

            Dim mailId = IntranetPortal.Core.EmailService.SendMail(EmailToIDs.Text, EmailCCIDs.Text, EmailSuject.Text, EmailBody.Html, attachments)
            Dim comments = String.Format("{0} send an email.&nbsp;<a href='#' onclick='ShowMailmessage({1})'>Email Message</a>", Page.User.Identity.Name, mailId)
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Email.ToString, LeadsActivityLog.EnumActionType.Email)
            EmailToIDs.Text = ""
            EmailCCIDs.Text = ""
            EmailSuject.Text = ""
            EmailBody.Html = ""
        End If

        If e.Parameter.StartsWith("ShowMail") Then
            Dim mailId = e.Parameter.Split("|")(1)
            Dim msg = IntranetPortal.Core.EmailService.GetMailMessage(CInt(mailId))

            EmailToIDs.Text = msg.ToAddress
            EmailCCIDs.Text = msg.CcAddress
            EmailSuject.Text = msg.Subject
            EmailBody.Html = msg.Body
            EmailAttachments.Text = msg.Attachments
        End If

    End Sub
    Protected Sub BindEmail()

        'tabPageEmailSelect()
        Dim emilList = TryCast(EmailToIDs.FindControl("tabPageEmailSelect").FindControl("lbEmails"), ASPxListBox)
        Dim emailCClist = TryCast(EmailCCIDs.FindControl("tabPageEmailCCSelect").FindControl("lbEmailCCs"), ASPxListBox)
        Using Context As New Entities
            Dim emilListData = Context.Employees.Select(Function(e) e.Email).Where(Function(e) e IsNot Nothing And e.IndexOf("@") > 0).ToList
            emilListData.AddRange(ShortSale.PartyContact.getAllEmail())
            emilListData = emilListData.Distinct.ToList
            emilList.DataSource = emilListData
            emilList.DataBind()
            emailCClist.DataSource = emilListData
            emailCClist.DataBind()
        End Using
    End Sub
End Class
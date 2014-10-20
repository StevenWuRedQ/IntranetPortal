Imports System.Configuration
Imports System.Net.Mail
Imports System.Net

Public Class EmailService
    Public Shared Sub SendMail()

        'Dim utilisateur As String = System.Configuration.ConfigurationManager.AppSettings("StmpUtilisateur")
        'Dim pass As String = System.Configuration.ConfigurationManager.AppSettings("SmtpPassword")
        'Dim server As String = System.Configuration.ConfigurationManager.AppSettings("SmtpServer")

        Dim Message As New Mail.MailMessage()
        Message.To.Add(New MailAddress("chris@gvs4u.com"))
        Message.Subject = "test"
        Message.Body = "testing mail"
        Message.Attachments.Add(New Attachment("https://gvs4uinc.sharepoint.com/Shared%20Documents/4065270016/Financials/grid.pdf"))

        ' Replace SmtpMail.SmtpServer = server with the following:
        Dim client As New SmtpClient()

        Try
            client.Send(Message)
        Catch ex As Exception
            ' ...
        End Try

    End Sub

End Class

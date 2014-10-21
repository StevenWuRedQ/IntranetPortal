Imports System.Configuration
Imports System.Net.Mail
Imports System.Net
Imports System.IO

Public Class EmailService
    Public Shared Sub SendMail()

        'Dim utilisateur As String = System.Configuration.ConfigurationManager.AppSettings("StmpUtilisateur")
        'Dim pass As String = System.Configuration.ConfigurationManager.AppSettings("SmtpPassword")
        'Dim server As String = System.Configuration.ConfigurationManager.AppSettings("SmtpServer")

        Dim Message As New Mail.MailMessage()
        Message.To.Add(New MailAddress("chris@gvs4u.com"))
        Message.Subject = "test"
        Message.Body = "testing mail"
        Dim file = DocumentService.DownLoadFileStream("b70ddcff-8d22-4b65-8fc8-42b46f8b1380")

        Message.Attachments.Add(New Attachment(CType(file.Stream, IO.MemoryStream), file.Name.ToString))
        Dim client As New SmtpClient()
        Try
            client.Send(Message)
        Catch ex As Exception
            ' ...
        End Try
    End Sub

    Public Shared Sub SendMail(toAddress As String, ccAddress As String, subject As String, body As String, attchments As String())
        Dim Message As New Mail.MailMessage()
        If String.IsNullOrEmpty(toAddress) Then
            Throw New Exception("To address can't be empty.")
        End If

        Message.To.Add(New MailAddress(toAddress))
        If Not String.IsNullOrEmpty(ccAddress) Then
            Dim adds = ccAddress.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            For Each add In adds
                Message.CC.Add(add)
            Next
        End If

        Message.Subject = subject
        Message.Body = body
        Message.IsBodyHtml = True

        If attchments IsNot Nothing AndAlso attchments.Length > 0 Then
            For Each att In attchments
                Dim file = DocumentService.DownLoadFileStream(att)
                Message.Attachments.Add(New Attachment(CType(file.Stream, MemoryStream), file.Name.ToString))
            Next
        End If

        Dim client As New SmtpClient()

        Try
            client.Send(Message)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
End Class

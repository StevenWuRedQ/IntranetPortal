Imports System.Configuration
Imports System.Net.Mail
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient
Imports System.Data.Entity.Core.EntityClient
Imports System.Web.Script.Serialization

Public Class EmailService
    Public Shared Sub SendMail()

        'Dim utilisateur As String = System.Configuration.ConfigurationManager.AppSettings("StmpUtilisateur")
        'Dim pass As String = System.Configuration.ConfigurationManager.AppSettings("SmtpPassword")
        'Dim server As String = System.Configuration.ConfigurationManager.AppSettings("SmtpServer")

        'Dim Message As New Mail.MailMessage()
        'Message.To.Add(New MailAddress("chris@gvs4u.com"))
        'Message.Subject = "test"
        'Message.Body = "testing mail"
        'Dim file = DocumentService.DownLoadFileStream("b70ddcff-8d22-4b65-8fc8-42b46f8b1380")

        'Message.Attachments.Add(New Attachment(CType(file.Stream, IO.MemoryStream), file.Name.ToString))
        'Dim client As New SmtpClient()
        'Try
        '    client.Send(Message)
        'Catch ex As Exception
        '    ' ...
        'End Try
    End Sub

    Public Shared Sub SendMail(toAddress As String, ccAddress As String, templateName As String, mailData As Dictionary(Of String, String))
        Dim emailTemplate = GetEmailTemplate(templateName)
        If emailTemplate IsNot Nothing Then
            SendMail(toAddress, ccAddress, ProcessContent(emailTemplate.Subject, mailData), ProcessContent(emailTemplate.Body, mailData), Nothing)
        End If
    End Sub

    Public Shared Function SendMail(toAddress As String, ccAddress As String, subject As String, body As String, attachments As List(Of String)) As Integer
        Dim mailmsg As New EmailMessage
        mailmsg.ToAddress = toAddress
        mailmsg.CcAddress = ccAddress
        mailmsg.Subject = subject
        mailmsg.Body = body

        'mailmsg.Attachments = String.Join(";", attachments)
        Dim tmpAttachs As New Dictionary(Of String, String)

        Dim Message As New Mail.MailMessage()
        If String.IsNullOrEmpty(toAddress) Then
            Throw New Exception("To address can't be empty.")
        Else
            Dim adds = toAddress.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            For Each add In adds
                Message.To.Add(add)
            Next
        End If

        If Not String.IsNullOrEmpty(ccAddress) Then
            Dim adds = ccAddress.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            For Each add In adds
                Message.CC.Add(add)
            Next
        End If

        Message.Subject = subject
        Message.Body = body
        Message.IsBodyHtml = True

        If attachments IsNot Nothing AndAlso attachments.Count > 0 Then
            For Each att In attachments
                Dim file = DocumentService.DownLoadFileStream(att)
                Message.Attachments.Add(New Attachment(CType(file.Stream, MemoryStream), file.Name.ToString))
                tmpAttachs.Add(att, file.Name.ToString)
            Next

            If tmpAttachs.Count > 0 Then
                'Dim items = From kvp In tmpAttachs
                '            Select kvp.Key & "=" & kvp.Value

                mailmsg.Attachments = New JavaScriptSerializer().Serialize(tmpAttachs)
            End If
        End If

        Dim client As New SmtpClient()

        Try
            client.Send(Message)
            Return SaveEmail(mailmsg)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function GetMailMessage(mailId As Integer) As EmailMessage
        Using ctx As New CoreEntities
            Dim msg = ctx.EmailMessages.Find(mailId)
            Return msg
        End Using
    End Function

    Private Shared Function SaveEmail(msg As EmailMessage) As Integer
        Using ctx As New CoreEntities
            msg.SendDate = DateTime.Now
            msg.SendBy = "Portal"
            msg = ctx.EmailMessages.Add(msg)
            ctx.SaveChanges()
            Return msg.EmailId
        End Using
    End Function

    Private Shared Function GetEmailTemplate(templateName As String) As EmailTemplate
        Using ctx As New CoreEntities
            Return ctx.EmailTemplates.FirstOrDefault(Function(a) a.Name = templateName)
        End Using
    End Function

    Private Shared Function ProcessContent(content As String, emailData As Dictionary(Of String, String)) As String

        For Each item In emailData
            content = content.Replace("{{$" & item.Key & "}}", item.Value)
        Next

        Return content
    End Function
End Class

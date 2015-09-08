Imports System.Configuration
Imports System.Net.Mail
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient
Imports System.Data.Entity.Core.EntityClient
Imports System.Web.Script.Serialization
Imports System.Text.RegularExpressions
Imports System.Globalization
Imports System.Net.Configuration

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

    Public Shared Sub SendShortSaleMail(toAddress As String, ccAddress As String, templateName As String, mailData As Dictionary(Of String, String))
        SendMail(toAddress, ccAddress, templateName, mailData)
    End Sub

    Public Shared Sub SendMail(toAddress As String, ccAddress As String, templateName As String, mailData As Dictionary(Of String, String))
        Dim emailTemplate = GetEmailTemplate(templateName)
        If emailTemplate IsNot Nothing Then
            SendMail(toAddress, ccAddress, ProcessContent(emailTemplate.Subject, mailData), ProcessContent(emailTemplate.Body, mailData), Nothing)
        End If
    End Sub

    Public Shared Sub SendMail(toAddress As String, ccAddress As String, templateName As String, mailData As Dictionary(Of String, String), attachments As Attachment())
        Dim emailTemplate = GetEmailTemplate(templateName)
        If emailTemplate IsNot Nothing Then
            SendMail(toAddress, ccAddress, ProcessContent(emailTemplate.Subject, mailData), ProcessContent(emailTemplate.Body, mailData), Nothing, attachments)
        End If
    End Sub

    Public Shared Function SendGroupEmail(toAddes As List(Of String), subject As String, body As String, attachments As List(Of String)) As Boolean

        Dim util As New RegexUtilities()

        Dim tmpAttachs As New Dictionary(Of String, String)

        Dim Message As New Mail.MailMessage()
        If toAddes Is Nothing Or toAddes.Count = 0 Then
            Throw New Exception("Address can't be empty.")
        Else
            For Each add In toAddes
                If util.IsValidEmail(add) Then
                    Message.Bcc.Add(add)
                End If
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
        End If

        Dim client As New SmtpClient()

        Try
            'client.Send(Message)
            Dim mailmsg As New EmailMessage
            mailmsg.ToAddress = toAddes.Count
            mailmsg.Subject = subject
            mailmsg.Body = body
            mailmsg.Description = "Group Msg"

            SaveEmail(mailmsg)
            Return True
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function SendMail(toAddress As String, ccAddress As String, subject As String, body As String, attachments As List(Of String), Optional attachments2 As Attachment() = Nothing, Optional smtpSetting As String = "smtp") As Integer
        'Using ctx As New CoreEntities
        '    If ctx.EmailMessages.Any(Function(em) em.ToAddress = toAddress AndAlso em.Subject = subject AndAlso em.SendDate > DateTime.Today) Then
        '        Return 0
        '    End If
        'End Using
        Dim util As New RegexUtilities()

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
                If util.IsValidEmail(add) Then
                    Message.To.Add(add)
                End If
            Next
        End If

        If Not String.IsNullOrEmpty(ccAddress) Then
            Dim adds = ccAddress.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            For Each add In adds
                If util.IsValidEmail(add) Then
                    Message.CC.Add(add)
                End If
            Next
        End If

        Message.Subject = subject
        Message.Body = body
        Message.IsBodyHtml = True

        If attachments IsNot Nothing AndAlso attachments.Count > 0 Then
            For Each att In attachments
                Dim file As Object
                If att.ToLower.EndsWith("pdf") Then
                    
                    file = New With {.Stream = New System.IO.MemoryStream(DocumentService.GetPDFContent(att)), .Name = Regex.Match(att,
                     "\w+\.pdf$",
                     RegexOptions.IgnoreCase)}
                Else
                    file = DocumentService.DownLoadFileStream(att)
                End If

                Message.Attachments.Add(New Attachment(CType(file.Stream, MemoryStream), file.Name.ToString))
                tmpAttachs.Add(att, file.Name.ToString)
            Next

            If tmpAttachs.Count > 0 Then
                'Dim items = From kvp In tmpAttachs
                '            Select kvp.Key & "=" & kvp.Value

                mailmsg.Attachments = New JavaScriptSerializer().Serialize(tmpAttachs)
            End If
        End If

        If attachments2 IsNot Nothing AndAlso attachments2.Count > 0 Then
            For Each att In attachments2
                Message.Attachments.Add(att)
            Next
        End If

        Dim client As New CustomSmtpClient(smtpSetting)

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

Public Class CustomSmtpClient
    Private ReadOnly _smtpClient As SmtpClient
    Private fromAddress As String

    Public Sub New(Optional sectionName As String = "smtp")
        Dim section As SmtpSection = DirectCast(ConfigurationManager.GetSection(Convert.ToString("mailSettings/") & sectionName), SmtpSection)

        _smtpClient = New SmtpClient()

        If section IsNot Nothing Then
            If section.Network IsNot Nothing Then
                fromAddress = section.From
                _smtpClient.Host = section.Network.Host
                _smtpClient.Port = section.Network.Port
                _smtpClient.UseDefaultCredentials = section.Network.DefaultCredentials

                _smtpClient.Credentials = New NetworkCredential(section.Network.UserName, section.Network.Password, section.Network.ClientDomain)
                _smtpClient.EnableSsl = section.Network.EnableSsl

                If section.Network.TargetName IsNot Nothing Then
                    _smtpClient.TargetName = section.Network.TargetName
                End If
            End If

            _smtpClient.DeliveryMethod = section.DeliveryMethod
            If section.SpecifiedPickupDirectory IsNot Nothing AndAlso section.SpecifiedPickupDirectory.PickupDirectoryLocation IsNot Nothing Then
                _smtpClient.PickupDirectoryLocation = section.SpecifiedPickupDirectory.PickupDirectoryLocation
            End If
        End If
    End Sub

    Public Sub Send(message As MailMessage)
        message.From = New MailAddress(fromAddress)
        _smtpClient.Send(message)
    End Sub
End Class



Public Class RegexUtilities
    Dim invalid As Boolean = False

    Public Function IsValidEmail(strIn As String) As Boolean
        strIn = strIn.Trim
        invalid = False
        If String.IsNullOrEmpty(strIn) Then Return False

        ' Use IdnMapping class to convert Unicode domain names. 
        Try
            strIn = Regex.Replace(strIn, "(@)(.+)$", AddressOf Me.DomainMapper,
                                  RegexOptions.None, TimeSpan.FromMilliseconds(200))
        Catch e As RegexMatchTimeoutException
            Return False
        End Try

        If invalid Then Return False

        ' Return true if strIn is in valid e-mail format. 
        Try
            Return Regex.IsMatch(strIn,
                   "^(?("")("".+?(?<!\\)""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" +
                   "(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9][\-a-z0-9]{0,22}[a-z0-9]))$",
                   RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250))
        Catch e As RegexMatchTimeoutException
            Return False
        End Try
    End Function

    Private Function DomainMapper(match As Match) As String
        ' IdnMapping class with default property values. 
        Dim idn As New IdnMapping()

        Dim domainName As String = match.Groups(2).Value
        Try
            domainName = idn.GetAscii(domainName)
        Catch e As ArgumentException
            invalid = True
        End Try
        Return match.Groups(1).Value + domainName
    End Function

    Public Shared Function ValidEmail(email As String) As Boolean
        Dim rgx As New RegexUtilities
        Return rgx.IsValidEmail(email)
    End Function
End Class

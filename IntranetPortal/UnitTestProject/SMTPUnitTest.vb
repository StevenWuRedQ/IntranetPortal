Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System.Net.Mail
Imports System.Net

<TestClass()> Public Class SMTPUnitTest

    <TestMethod()> Public Sub smtp_test()
        Try
            Dim Smtp_Server As New SmtpClient
            Dim e_mail As New MailMessage()
            Smtp_Server.UseDefaultCredentials = False
            Smtp_Server.Credentials = New Net.NetworkCredential("portal@myidealprop.com", "Chris123")
            Smtp_Server.Port = 25
            Smtp_Server.EnableSsl = True
            Smtp_Server.Host = "myidealprop-com.mail.protection.outlook.com" ' "smtp.office365.com" 

            e_mail = New MailMessage()
            e_mail.From = New MailAddress("portal@myidealprop.com")
            e_mail.To.Add("chrisy@redq.com")
            e_mail.Subject = "Email Sending"
            e_mail.IsBodyHtml = False
            e_mail.Body = "Test"
            Smtp_Server.Send(e_mail)
            Assert.IsTrue(True)
        Catch error_t As Exception
            Throw error_t
        End Try
    End Sub

    <TestMethod()> Public Sub smtpsubmission_test()
        Try
            Dim Smtp_Server As New SmtpClient
            Dim e_mail As New MailMessage()
            Smtp_Server.UseDefaultCredentials = False
            Smtp_Server.Credentials = New Net.NetworkCredential("portal@myidealprop.com", "Chris123")
            Smtp_Server.Port = 587
            Smtp_Server.EnableSsl = True
            Smtp_Server.Host = "smtp.office365.com"

            e_mail = New MailMessage()
            e_mail.From = New MailAddress("portal@myidealprop.com")
            e_mail.To.Add("chrisy@redq.com")
            e_mail.Subject = "Email Sending"
            e_mail.IsBodyHtml = False
            e_mail.Body = "Test"
            Smtp_Server.Send(e_mail)
            Assert.IsTrue(True)
        Catch error_t As Exception
            Throw error_t
        End Try
    End Sub

    <TestMethod()> Public Sub smtp2_test()
        Try
            Dim Smtp_Server As New SmtpClient
            Dim e_mail As New MailMessage()
            Smtp_Server.UseDefaultCredentials = False
            Smtp_Server.Credentials = New Net.NetworkCredential("portal@myidealprop.com", "ColorBlue206!")
            Smtp_Server.Port = 587
            Smtp_Server.EnableSsl = False
            Smtp_Server.Host = "smtp.myidealprop.com" ' "smtp.office365.com" 

            e_mail = New MailMessage()
            e_mail.From = New MailAddress("portal@myidealprop.com")
            e_mail.To.Add("chrisy@myidealprop.com")
            e_mail.Subject = "Email Sending"
            e_mail.IsBodyHtml = False
            e_mail.Body = "Test"
            Smtp_Server.Send(e_mail)
            Assert.IsTrue(True)
        Catch error_t As Exception
            Throw error_t
        End Try
    End Sub

End Class
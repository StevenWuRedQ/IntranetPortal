Imports System.IO

Public Class WebForm3
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.IsInRole("Admin") Then
            Response.Redirect("/Account/Login.aspx")
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("UserName")) Then
            Me.ComplaintsNotify.BindData(Request.QueryString("UserName"))
        End If

        Me.DeadleadsReport.BindData(Nothing)
        Dim params As New Dictionary(Of String, String)
        params.Add("IsWeekly", False)
        Me.AuctionDailyReport.BindData(params)
    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)

        Dim sb As New StringBuilder
        Using tw As New StringWriter(sb)
            Using hw As New HtmlTextWriter(tw)
                Me.ComplaintsNotify.RenderControl(hw)
            End Using
        End Using


        Dim emailData As New Dictionary(Of String, String)
        emailData.Add("Body", sb.ToString)
        emailData.Add("Date", DateTime.Today.ToString("m"))
        'IntranetPortal.Core.EmailService.SendMail("Chris@gvs4u.com", "", "Task Summary on " & DateTime.Now, LoadSummaryEmail(userName), Nothing)
        Core.EmailService.SendMail("chrisy@myidealprop.com", "chrisy@myidealprop.com", "ComplaintsNotifySummary", emailData)
    End Sub

    Protected Sub Button2_Click(sender As Object, e As EventArgs)

        Dim complaint = IntranetPortal.Data.CheckingComplain.Instance(Request.QueryString("bble").ToString)
        Dim mailData As New Dictionary(Of String, String)
        mailData.Add("UserName", "All")
        mailData.Add("Address", complaint.Address)
        mailData.Add("BBLE", complaint.BBLE)

        Dim svr As New CommonService
        svr.SendEmailByControl("chrisy@myidealprop.com", "DOB Complaint Update for: " & complaint.Address, "ComplaintsDetailNotify", mailData)

    End Sub

    Protected Sub Button3_Click(sender As Object, e As EventArgs)
        Dim svr As New CommonService
        svr.SendEmailByControl("chrisy@myidealprop.com", "Deadleads Report - " & DateTime.Today.ToShortDateString, "DeadleadsReport", Nothing)
    End Sub

    Protected Sub Button4_Click(sender As Object, e As EventArgs)
        Dim svr As New CommonService
        svr.SendEmailByControl("chrisy@myidealprop.com", "The coming Auction Properties - " & DateTime.Today.ToShortDateString, "AuctionDailyReport", Nothing)
    End Sub

End Class
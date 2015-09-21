Imports System.IO

Public Class WebForm3
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("UserName")) Then
            Me.ComplaintsNotify.BindData(Request.QueryString("UserName"))
        End If
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
        Core.EmailService.SendMail("Georgev@myidealprop.com", "chrisy@myidealprop.com", "ComplaintsNotifySummary", emailData)


    End Sub
End Class
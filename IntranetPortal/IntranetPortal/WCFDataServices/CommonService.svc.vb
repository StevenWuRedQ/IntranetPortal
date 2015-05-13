Imports System.IO
Imports Spire.Pdf
Imports DevExpress.XtraReports.UI
Imports System.Net
Imports System.ServiceModel

' NOTE: You can use the "Rename" command on the context menu to change the class name "CommonService" in code, svc and config file together.
' NOTE: In order to launch WCF Test Client for testing this service, please select CommonService.svc or CommonService.svc.vb at the Solution Explorer and start debugging.
Public Class CommonService
    Implements ICommonService

    Public Sub SendEmail(userName As String, subject As String, body As String) Implements ICommonService.SendEmail
        Dim emp = Employee.GetInstance(userName)
        IntranetPortal.Core.EmailService.SendMail(emp.Email, "", subject, body, Nothing)
    End Sub

    Public Sub SendMessage(userName As String, title As String, msg As String, bble As String, notifyTime As Date, createBy As String) Implements ICommonService.SendMessage
        UserMessage.AddNewMessage(userName, title, msg, bble, notifyTime, createBy)
    End Sub

    Public Sub SendEmailByTemplate(userName As String, templateName As String, emailData As Dictionary(Of String, String)) Implements ICommonService.SendEmailByTemplate
        Dim names = userName.Split(";")
        Dim toAdds = New List(Of String)
        For Each name In names
            Dim tmpEmp = Employee.GetInstance(name)
            If tmpEmp IsNot Nothing AndAlso Not String.IsNullOrEmpty(tmpEmp.Email) Then
                toAdds.Add(tmpEmp.Email)
            End If
        Next
        'Dim emp = Employee.GetInstance(userName)

        If toAdds IsNot Nothing AndAlso toAdds.Count > 0 Then
            IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), "", templateName, emailData)
        End If
    End Sub

    Public Sub UpdateLeadsSearchStatus(leadsSearchId As Integer, status As Integer) Implements ICommonService.UpdateLeadsSearchStatus
        Using ctx As New Entities
            Dim ls = ctx.LeadsSearchTasks.Find(leadsSearchId)
            ls.Status = status
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub SendTaskSummaryEmail(userName As String) Implements ICommonService.SendTaskSummaryEmail
        Dim emp = Employee.GetInstance(userName)

        Dim emailData As New Dictionary(Of String, String)
        emailData.Add("Body", LoadSummaryEmail(userName))
        emailData.Add("Date", DateTime.Today.ToString("m"))
        'IntranetPortal.Core.EmailService.SendMail("Chris@gvs4u.com", "", "Task Summary on " & DateTime.Now, LoadSummaryEmail(userName), Nothing)
        IntranetPortal.Core.EmailService.SendMail(emp.Email, "", "UserTaskSummary", emailData)
    End Sub

    Public Sub SendTeamActivityEmail(teamName As String) Implements ICommonService.SendTeamActivityEmail
        Dim objTeam = Team.GetTeam(teamName)
        Dim toAdds = New List(Of String)

        For Each mgr In objTeam.TeamManagers
            Dim emp = Employee.GetInstance(mgr)
            If emp IsNot Nothing AndAlso emp.Active AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                toAdds.Add(emp.Email)
            End If
        Next

        'toAdds.Add("ron@myidealprop.com")
        'toAdds.Add("chris@gvs4u.com")

        Dim emailData As New Dictionary(Of String, String)
        'emailData.Add("Body", LoadTeamActivityEmail(objTeam))
        emailData.Add("Date", DateTime.Today.ToString("m"))

        Dim name = String.Format("{1}-ActivityReport-{0:m}.pdf", DateTime.Today, teamName)
        Dim attachment As New System.Net.Mail.Attachment(GetPDf(teamName), name)

        IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), "", "TeamActivitySummary", emailData, {attachment})
    End Sub

    Public Sub SendShortSaleActivityEmail() Implements ICommonService.SendShortSaleActivityEmail
        Dim ssMgrs = Roles.GetUsersInRole("ShortSale-Manager")

        Dim toAdds = New List(Of String)

        For Each mgr In ssMgrs.Distinct
            Dim emp = Employee.GetInstance(mgr)
            If emp IsNot Nothing AndAlso emp.Active AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                toAdds.Add(emp.Email)
            End If
        Next

        'toAdds.Add("ron@myidealprop.com")
        'toAdds.Add("chris@gvs4u.com")

        Dim emailData As New Dictionary(Of String, String)
        'emailData.Add("Body", LoadTeamActivityEmail(objTeam))
        emailData.Add("Date", DateTime.Today.ToString("m"))

        Dim name = String.Format("{1}-ActivityReport-{0:m}.pdf", DateTime.Today, "ShortSale Team")
        Dim attachment As New System.Net.Mail.Attachment(GetPDf("ShortSale"), name)

        IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), "", "TeamActivitySummary", emailData, {attachment})

    End Sub

    Private Function GetPDf(name As String) As MemoryStream
        'Using stream As New MemoryStream()
        '    'DemoRichEdit.ExportToPdf(stream)
        '    'HttpUtils.WriteFileToResponse(Me.Page, stream, "ExportedDocument", True, "pdf")
        'End Using

        Dim report As New XtraReport
        report.Margins = New Drawing.Printing.Margins(50, 50, 50, 50)
        Dim richText As New XRRichText
        Dim db As New DetailBand
        report.Bands.Add(db)
        richText.SizeF = New System.Drawing.SizeF(700, 20)
        richText.LocationF = New System.Drawing.PointF(0, 0)
        report.Bands(BandKind.Detail).Controls.Add(richText)

        Dim ms As New MemoryStream
        richText.Html = LoadEmailTemplateThroughWeb(name)  'LoadTeamActivityEmail(Team.GetTeam("RonTeam"))
        report.ExportToPdf(ms)
        ms.Position = 0
        Return ms
    End Function

    Private Function LoadEmailTemplateThroughWeb(name As String) As String
        Dim url = OperationContext.Current.RequestContext.RequestMessage.Headers.To.GetLeftPart(UriPartial.Authority)
        Dim pageLink = String.Format("{0}/EmailTemplate/TeamActivityReport.aspx?name={1}", url, name)

        If name = "ShortSale" Then
            pageLink = String.Format("{0}/EmailTemplate/ShortSaleActivityReport.aspx", url)
        End If

        Dim myRequest As WebRequest = WebRequest.Create(pageLink)
        Dim response As HttpWebResponse = CType(myRequest.GetResponse(), HttpWebResponse)
        Dim receiveStream As Stream = response.GetResponseStream()
        ' Pipes the stream to a higher level stream reader with the required encoding format.  
        Dim readStream As New StreamReader(receiveStream, Encoding.UTF8)
        Dim result = readStream.ReadToEnd()
        response.Close()
        readStream.Close()

        Return result
    End Function

    Private Function LoadTeamActivityEmail(objTeam As Team) As String
        Dim ts As ActivitySummary
        Using Page As New Page
            ts = Page.LoadControl("~/EmailTemplate/ActivitySummary.ascx")
            ts.team = objTeam

            Dim sb As New StringBuilder
            Using tw As New StringWriter(sb)
                Using hw As New HtmlTextWriter(tw)
                    ts.RenderControl(hw)
                End Using
            End Using

            Return sb.ToString
        End Using
    End Function

    Private Function LoadSummaryEmail(userName As String) As String
        Dim ts As TaskSummary
        Using Page As New Page
            ts = Page.LoadControl("~/EmailTemplate/TaskSummary.ascx")
            ts.DestinationUser = userName
            ts.BindData()

            Dim sb As New StringBuilder
            Using tw As New StringWriter(sb)
                Using hw As New HtmlTextWriter(tw)
                    ts.RenderControl(hw)
                End Using
            End Using

            Return sb.ToString
        End Using
    End Function
End Class

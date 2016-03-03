Imports System.IO
Imports DevExpress.XtraReports.UI
Imports System.Net
Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports IntranetPortal.PortalReport
Imports IntranetPortal

' NOTE: You can use the "Rename" command on the context menu to change the class name "CommonService" in code, svc and config file together.
' NOTE: In order to launch WCF Test Client for testing this service, please select CommonService.svc or CommonService.svc.vb at the Solution Explorer and start debugging.
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class CommonService
    Implements ICommonService

    Public Sub SendEmailByAddress(toAddress As String, ccAddress As String, subject As String, body As String) Implements ICommonService.SendEmailByAddress
        IntranetPortal.Core.EmailService.SendMail(toAddress, ccAddress, subject, body, Nothing)
    End Sub

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
            Dim taskId = 0
            If emailData.ContainsKey("TaskComments") AndAlso Integer.TryParse(emailData("TaskComments"), taskId) Then
                If taskId > 0 Then
                    Dim task = UserTask.GetTaskById(taskId)
                    If task IsNot Nothing Then
                        emailData("TaskComments") = task.Description
                    End If
                End If
            End If

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

        If toAdds.Count > 0 Then
            IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), "", "TeamActivitySummary", emailData, {attachment})
        End If

    End Sub

    ''' <summary>
    ''' Send ShortSale users report to short sale team manager and short sale manager
    ''' </summary>
    Public Sub SendShortSaleActivityEmail() Implements ICommonService.SendShortSaleActivityEmail

        'SendShortAllActivityReport()
        SendShortSaleTeamMgrReport()
        SendTitleTeamReport()
    End Sub

    ''' <summary>
    ''' Send all shortsale user report to Short Sale Manager
    ''' </summary>
    Private Sub SendShortAllActivityReport()
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

    ''' <summary>
    ''' Send Title User report to Title Manager and ShortSale Manager
    ''' </summary>
    Private Sub SendTitleTeamReport()
        Dim ssMgrs = Roles.GetUsersInRole("Title-Manager")

        Dim ccAdds = New List(Of String)
        For Each mgr In Roles.GetUsersInRole("ShortSale-Manager")
            Dim emp = Employee.GetInstance(mgr)
            If emp IsNot Nothing AndAlso emp.Active AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                ccAdds.Add(emp.Email)
            End If
        Next

        Dim toAdds = New List(Of String)
        For Each mgr In ssMgrs.Distinct
            Dim emp = Employee.GetInstance(mgr)
            If emp IsNot Nothing AndAlso emp.Active AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                toAdds.Add(emp.Email)
            End If
        Next

        Dim emailData As New Dictionary(Of String, String)
        'emailData.Add("Body", LoadTeamActivityEmail(objTeam))
        emailData.Add("Date", DateTime.Today.ToString("m"))

        Dim name = String.Format("{1}-ActivityReport-{0:m}.pdf", DateTime.Today, "Title Team")
        Dim attachment As New System.Net.Mail.Attachment(GetPDf("Title"), name)

        If toAdds.Count > 0 Then
            IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), String.Join(";", ccAdds.ToArray), "TeamActivitySummary", emailData, {attachment})
        End If

    End Sub

    ''' <summary>
    ''' Send short sale user report to related team manager
    ''' </summary>
    Private Sub SendShortSaleTeamMgrReport()
        Dim ssMgrs = Roles.GetUsersInRole("ShortSale-TeamManager")

        Dim ccAdds = New List(Of String)
        For Each mgr In Roles.GetUsersInRole("ShortSale-Manager")
            Dim emp = Employee.GetInstance(mgr)
            If emp IsNot Nothing AndAlso emp.Active AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                ccAdds.Add(emp.Email)
            End If
        Next

        For Each mgr In ssMgrs.Distinct

            Dim toAdds = New List(Of String)

            Dim emp = Employee.GetInstance(mgr)
            If emp IsNot Nothing AndAlso emp.Active AndAlso Not String.IsNullOrEmpty(emp.Email) Then
                toAdds.Add(emp.Email)

                Dim emailData As New Dictionary(Of String, String)
                'emailData.Add("Body", LoadTeamActivityEmail(objTeam))
                emailData.Add("Date", DateTime.Today.ToString("m"))

                Dim params As New StringDictionary
                params.Add("teamMgr", mgr)

                Dim name = String.Format("{1}-ActivityReport-{0:m}.pdf", DateTime.Today, "ShortSale Team")
                Dim attachment As New System.Net.Mail.Attachment(GetPDf("ShortSale", params), name)

                IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), String.Join(";", ccAdds.ToArray), "TeamActivitySummary", emailData, {attachment})
            End If
        Next
    End Sub

    Public Sub SendLegalActivityEmail() Implements ICommonService.SendLegalActivityEmail
        Dim ssMgrs = Roles.GetUsersInRole("Legal-Manager")

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

        Dim name = String.Format("{1}-ActivityReport-{0:m}.pdf", DateTime.Today, "Legal Team")
        Dim attachment As New System.Net.Mail.Attachment(GetPDf("Legal"), name)

        If toAdds.Count > 0 Then
            IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), If(Employee.CEO IsNot Nothing, Employee.CEO.Email, ""), "TeamActivitySummary", emailData, {attachment})
        End If
    End Sub

    Public Sub LegalFollowUp() Implements ICommonService.LegalFollowUp
        Dim startDateTime = DateTime.Today
        Dim endDateTime = DateTime.Today.AddDays(1).AddTicks(-1)

        Dim followUps = Data.LegalCase.GetFollowUpCases().Where(Function(l) l.FollowUp >= startDateTime AndAlso l.FollowUp <= endDateTime).ToList

        For Each lc In followUps
            Try
                IntranetPortal.LegalCaseManage.ReminderFollowUp(lc)
            Catch ex As Exception
                Throw ex
            End Try
        Next
    End Sub

    Public Sub SendUserActivitySummayEmail(type As String, startDate As DateTime, endDate As DateTime) Implements ICommonService.SendUserActivitySummayEmail
        Select Case type
            Case "Legal"
                SendActivityDataEmail(PortalReport.LoadLegalActivityReport(startDate, endDate))
            Case Else

        End Select
    End Sub

    Public Sub SendShortSaleUserSummayEmail() Implements ICommonService.SendShortSaleUserSummayEmail
        Dim TeamActivityData = PortalReport.LoadShortSaleActivityReport(DateTime.Today, DateTime.Today.AddDays(1))

        For Each actData In TeamActivityData
            Dim emailData As New Dictionary(Of String, String)
            emailData.Add("Body", LoadSSUserSummaryEmail(actData))
            emailData.Add("Date", DateTime.Today.ToString("m"))
            'IntranetPortal.Core.EmailService.SendMail("Chris@gvs4u.com", "", "Task Summary on " & DateTime.Now, LoadSummaryEmail(userName), Nothing)
            Me.SendEmailByTemplate(actData.Name, "SSUserSummary", emailData)
        Next
    End Sub

    Private Sub SendActivityDataEmail(TeamActivityData As List(Of CaseActivityData))
        For Each actData In TeamActivityData
            Try
                Dim emailData As New Dictionary(Of String, String)
                emailData.Add("Body", LoadSSUserSummaryEmail(actData))
                emailData.Add("Date", DateTime.Today.ToString("m"))
                'IntranetPortal.Core.EmailService.SendMail("Chris@gvs4u.com", "", "Task Summary on " & DateTime.Now, LoadSummaryEmail(userName), Nothing)
                Me.SendEmailByTemplate(actData.Name, "SSUserSummary", emailData)
            Catch ex As Exception
                Core.SystemLog.LogError("Error in SendActivityDataEmail", ex, actData.Name, "WCFServices", "")
            End Try
        Next
    End Sub

    Private Function GetPDf(name As String, Optional params As StringDictionary = Nothing) As MemoryStream
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
        richText.Html = LoadEmailTemplateThroughWeb(name, params)  'LoadTeamActivityEmail(Team.GetTeam("RonTeam"))
        report.ExportToPdf(ms)
        ms.Position = 0
        Return ms
    End Function

    Private Function LoadEmailTemplateThroughWeb(name As String, params As StringDictionary) As String
        Dim url = OperationContext.Current.RequestContext.RequestMessage.Headers.To.GetLeftPart(UriPartial.Authority)
        Dim pageLink = String.Format("{0}/EmailTemplate/TeamActivityReport.aspx?name={1}", url, name)

        If name = "ShortSale" Then
            pageLink = String.Format("{0}/EmailTemplate/ShortSaleActivityReport.aspx?", url)
        End If

        If name = "Title" Then
            pageLink = String.Format("{0}/EmailTemplate/ShortSaleActivityReport.aspx?t=Title", url)
        End If

        If name = "Legal" Then
            pageLink = String.Format("{0}/EmailTemplate/ShortSaleActivityReport.aspx?t=Legal", url)
        End If

        If params IsNot Nothing AndAlso params.Count > 0 Then
            For Each param As DictionaryEntry In params
                If Not pageLink.Contains("?") Then
                    pageLink = pageLink & "?"
                End If

                pageLink = pageLink + String.Format("&{0}={1}", param.Key, param.Value)
            Next
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

    Private Function LoadSSUserSummaryEmail(actData As PortalReport.CaseActivityData) As String
        Dim ts As ShortSaleUserReport
        Using Page As New Page
            ts = Page.LoadControl("~/EmailTemplate/ShortSaleUserReport.ascx")
            ts.BindData(actData)

            Return RenderUserControl(ts)
        End Using
    End Function

    Private Function RenderUserControl(ctr As UserControl) As String
        Dim sb As New StringBuilder
        Using tw As New StringWriter(sb)
            Using hw As New HtmlTextWriter(tw)
                ctr.RenderControl(hw)
            End Using
        End Using

        Return sb.ToString
    End Function

    Public Sub SendEmailByControl(toAddresses As String, subject As String, controlName As String, params As Dictionary(Of String, String)) Implements ICommonService.SendEmailByControl
        Dim ts As EmailTemplateControl
        Using page As New Page
            ts = CType(page.LoadControl("~/EmailTemplate/" & controlName & ".ascx"), EmailTemplateControl)
            ts.BindData(params)

            Dim body = RenderUserControl(ts)

            Dim emailData As New Dictionary(Of String, String)
            emailData.Add("Body", body)
            emailData.Add("Subject", subject)

            Core.EmailService.SendMail(toAddresses, Nothing, "EmailControlTemplate", emailData)
        End Using
    End Sub

End Class

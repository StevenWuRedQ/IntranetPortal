Imports System.IO
Imports System.Threading
Imports DevExpress.Web.Internal
Imports DevExpress.XtraReports.UI
Imports System.Net

Public Class PdfCreator
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Clear()
        Response.ClearHeaders()
        Response.AddHeader("Content-Disposition", "attachment; filename=" & "test.pdf")
        Response.BinaryWrite(GetPDf().ToArray)
        Response.[End]()
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        'MyBase.VerifyRenderingInServerForm(control)
    End Sub

    Private Function GetPDf() As MemoryStream
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

        Using ms As New MemoryStream
            richText.Html = LoadEmailTemplateThroughWeb()  'LoadTeamActivityEmail(Team.GetTeam("RonTeam"))
            report.ExportToPdf(ms)

            Return ms
        End Using

        'Dim ms As New MemoryStream
        'Dim pdfDoc As PdfDocument = New PdfDocument()
        'Dim url As String = Request.Url.GetLeftPart(UriPartial.Authority) & "/Test.aspx?team=ronTeam"
        'Dim thread As Thread = New Thread(Sub()
        '                                      pdfDoc.LoadFromHTML(url, False, True, True)
        '                                  End Sub)
        'thread.SetApartmentState(ApartmentState.STA)
        'thread.Start()
        'thread.Join()
        'pdfDoc.SaveToStream(ms)
        'pdfDoc.Close()
        'pdfDoc.Dispose()

        ' Return ms
    End Function

    Private Function LoadEmailTemplateThroughWeb() As String
        Dim myRequest As WebRequest = WebRequest.Create("http://localhost:61504/EmailTemplate/TeamActivityReport.aspx?name=ronteam")
        Dim response As HttpWebResponse = CType(myRequest.GetResponse(), HttpWebResponse)
        Dim receiveStream As Stream = response.GetResponseStream()
        ' Pipes the stream to a higher level stream reader with the required encoding format.  
        Dim readStream As New StreamReader(receiveStream, Encoding.UTF8)
        Dim result = readStream.ReadToEnd()
        Response.Close()
        readStream.Close()

        Return result
    End Function

    Private Function LoadTeamActivityEmail(objTeam As Team) As String
        Dim ts As ActivitySummary
        Using Page As New Page
            ts = Page.LoadControl("~/EmailTemplate/ActivitySummary.ascx")
            ts.team = objTeam
            ts.DataBind()
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
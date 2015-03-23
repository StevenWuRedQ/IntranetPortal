Imports System.IO
Imports Spire.Pdf
Imports System.Threading
Imports DevExpress.Web.ASPxClasses.Internal
Imports DevExpress.XtraReports.UI

Public Class PdfCreator
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Clear()
        Response.ClearHeaders()
        Response.AddHeader("Content-Disposition", "attachment; filename=" & "test.pdf")
        Response.BinaryWrite(GetPDf().ToArray)
        Response.[End]()
    End Sub

    Private Function GetPDf() As MemoryStream
        'Using stream As New MemoryStream()
        '    'DemoRichEdit.ExportToPdf(stream)
        '    'HttpUtils.WriteFileToResponse(Me.Page, stream, "ExportedDocument", True, "pdf")
        'End Using

        Dim report As New XtraReport
        Dim richText As New XRRichText
        Dim db As New DetailBand
        report.Bands.Add(db)
        richText.SizeF = New System.Drawing.SizeF(600, 20)
        richText.LocationF = New System.Drawing.PointF(0, 0)
        report.Bands(BandKind.Detail).Controls.Add(richText)

        Using ms As New MemoryStream
            richText.Text = "testing"
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

End Class
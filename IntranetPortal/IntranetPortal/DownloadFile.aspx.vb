Imports Microsoft.SharePoint.Client
Imports System.Security
Imports Microsoft.SharePoint.Client.Sharing

Public Class DownloadFile
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("spFile")) Then
            Dim link = DocumentService.GetPreviewContentLink(Request.QueryString("spFile"))
            If Not String.IsNullOrEmpty(link) Then
                Response.Redirect(link)
            End If
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("pdfUrl")) Then
            Dim data = DocumentService.GetPDFContent(Request.QueryString("pdfUrl"))
            Response.Clear()
            Response.ClearHeaders()
            Response.ContentType = "application/pdf"
            Response.AddHeader("Content-Disposition", "attachment; filename=file.pdf")
            'Response.AddHeader("Content-Disposition", String.Format("inline; filename=""{0}""", File.Name))
            'Response.AddHeader("Content-Length", File.Size)
            Response.BinaryWrite(data)
            Response.[End]()
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
            ' Get the file id from the query string
            Dim id As Integer = Convert.ToInt16(Request.QueryString("id"))

            ' Get the file from the database
            Dim file = GetFile(id)

            ' Send the file to the browser
            Response.Clear()
            Response.ClearHeaders()
            Response.ContentType = file.ContentType
            'Response.AddHeader("Content-Disposition", "attachment; filename=" & file.Name)
            Response.AddHeader("Content-Disposition", String.Format("inline; filename=""{0}""", file.Name))
            Response.AddHeader("Content-Length", file.Size)
            Response.BinaryWrite(file.Data)
            Response.[End]()
        End If
    End Sub

    Function GetFile(fileId As String) As FileAttachment
        Using Context As New Entities
            Return Context.FileAttachments.Where(Function(f) f.FileID = fileId).SingleOrDefault
        End Using
    End Function
End Class
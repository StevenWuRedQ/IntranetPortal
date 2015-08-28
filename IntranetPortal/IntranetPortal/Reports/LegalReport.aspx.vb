
Imports DocumentFormat.OpenXml.Packaging
Imports DocumentFormat.OpenXml.Wordprocessing
Imports System.IO

Public Class LegalReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)

        AddHeaderFromTo(Server.MapPath("/App_Data/OSCTemplate.docx"))
    End Sub
    Public Sub AddHeaderFromTo(document As String)
        ' Replace header in target document with header of source document.
        Dim wordDoc As WordprocessingDocument = WordprocessingDocument.Open(document, True)
        Dim reslutDoc As WordprocessingDocument = WordprocessingDocument.Open(Server.MapPath("/App_Data/reslut.docx"), True)
        Using (wordDoc)
            Dim docText As String = Nothing
            Dim sr As StreamReader = New StreamReader(wordDoc.MainDocumentPart.GetStream)

            Using (sr)
                docText = sr.ReadToEnd
            End Using

            Dim regexText As Regex = New Regex("\[\[[^\]]*\]\]")
            Dim NotTag As Regex = New Regex("<[^>]*>")
            Dim reportDatas = regexText.Matches(docText)

            For Each feild As Match In reportDatas
                If (Not String.IsNullOrEmpty(feild.Value)) Then
                    Dim filedStr = NotTag.Replace(feild.Value, "").Replace("[[", "").Replace("]]", "").Replace(" ", "")
                    docText = docText.Replace(feild.Value, "Hi Test")
                End If

            Next


            Using (reslutDoc)
                Dim sw As StreamWriter = New StreamWriter(reslutDoc.MainDocumentPart.GetStream(FileMode.Create))

                Using (sw)
                    sw.Write(docText)
                End Using
                Response.Clear()
                Response.AppendHeader("Content-Disposition", "Attachment; Filename=OSCTemplate.docx")
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                Dim outMenery = New System.IO.MemoryStream
                reslutDoc.MainDocumentPart.GetStream.CopyTo(outMenery)
                Response.BinaryWrite(outMenery.ToArray)
            End Using


        End Using
    End Sub
End Class
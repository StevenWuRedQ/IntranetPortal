Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services
Imports IntranetPortal.Core
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports DocumentFormat.OpenXml.Packaging
Imports System.IO

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class Documents


    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function getFolderItems(bble As String, folderPath As String) As String
        Dim info = DocumentService.GetCateByBBLEAndFolder(bble, folderPath)
        Return JsonConvert.SerializeObject(info)
    End Function

    <WebInvoke(Method:="POST", ResponseFormat:=WebMessageFormat.Json)>
    <OperationContract()>
    Public Function DocGenrate(tplName As String, data As String) As Channels.Message
        Dim jData = JObject.Parse(data)
        GenerateDoc(tplName, jData) '"OSCTemplate.docx"
        Return "/TempDataFile/reslut.docx".ToJson
    End Function
    Public Sub GenerateDoc(tplName As String, data As JObject)
        ' Replace header in target document with header of source document.

        Dim wordDoc As WordprocessingDocument = WordprocessingDocument.Open(HttpContext.Current.Server.MapPath("/App_Data/" & tplName), True)

        Dim reslutDoc As WordprocessingDocument = WordprocessingDocument.Open(HttpContext.Current.Server.MapPath("/TempDataFile/reslut.docx"), True)
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

                    If (data.Item(filedStr) IsNot Nothing AndAlso Not String.IsNullOrEmpty(data.Item(filedStr).ToString)) Then
                        docText = docText.Replace(feild.Value, data.Item(filedStr).ToString)
                    End If
                End If

            Next


            Using (reslutDoc)
                Dim sw As StreamWriter = New StreamWriter(reslutDoc.MainDocumentPart.GetStream(FileMode.Create))

                Using (sw)
                    sw.Write(docText)
                End Using
                'Response.Clear()
                'Response.AppendHeader("Content-Disposition", "Attachment; Filename=OSCTemplate.docx")
                'Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                'Dim outMenery = New System.IO.MemoryStream
                'reslutDoc.MainDocumentPart.GetStream.CopyTo(outMenery)
                'Response.BinaryWrite(outMenery.ToArray)
            End Using


        End Using
    End Sub
End Class

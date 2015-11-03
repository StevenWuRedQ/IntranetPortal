Imports System.IO
Imports System.Net
Imports System.Net.Http
Imports System.Net.Http.Headers
Imports System.Web.Http
Imports System.Web.Http.Description
Imports Newtonsoft.Json.Linq

Namespace Controllers
    Public Class TitleController
        Inherits ApiController

        <Route("api/Title/UpdateStatus")>
        Public Function PostUpdateStatus(bble As String, <FromBody> status As Data.TitleCase.DataStatus) As IHttpActionResult
            Try
                TitleManage.UpdateStatus(bble, status, HttpContext.Current.User.Identity.Name)
                Return Ok()
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <Route("api/Title/Completed")>
        Public Function PostCompleteTitle(<FromBody> bble As String) As IHttpActionResult

            Try
                TitleManage.CompleteCase(bble, HttpContext.Current.User.Identity.Name)
                Return Ok()
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <Route("api/Title/UnCompleted")>
        Public Function UnCompleted(<FromBody> bble As String) As IHttpActionResult
            Try
                TitleManage.UnCompleteCase(bble, HttpContext.Current.User.Identity.Name)
                Return Ok()
            Catch ex As Exception
                Throw ex
            End Try
        End Function


        <Route("api/Title/GetCaseStatus")>
        Public Function GetCaseStatus(bble As String) As IHttpActionResult
            Try
                Dim status = Data.TitleCase.GetCaseStatus(bble)
                Return Ok(status)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <ResponseType(GetType(String()))>
        <Route("api/Title/UploadFiles")>
        Public Function uploadTitleFiles() As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim results = New List(Of String)
            Dim bble = HttpContext.Current.Request.QueryString("bble")
            Dim fileName = HttpContext.Current.Request.QueryString("fileName")
            Dim fileFoler = HttpContext.Current.Request.QueryString("folder")

            If HttpContext.Current.Request.Files.Count > 0 Then
                For i = 0 To HttpContext.Current.Request.Files.Count - 1
                    Dim file As HttpPostedFile = HttpContext.Current.Request.Files(i)
                    Dim ms = New MemoryStream()
                    file.InputStream.CopyTo(ms)

                    Dim folderPath = String.Format("{0}/{1}", bble, "Title")
                    If Not String.IsNullOrEmpty(fileFoler) Then
                        fileFoler = IIf(fileFoler.Last() = "/", fileFoler.Substring(0, fileFoler.Length - 1), fileFoler)
                        folderPath = folderPath & "/" & fileFoler
                    End If

                    If String.IsNullOrEmpty(fileName) Then
                        Dim fileNameParts = file.FileName.Split("\")
                        fileName = fileNameParts(fileNameParts.Length - 1)
                    End If

                    results.Add(Core.DocumentService.UploadFile(folderPath, ms.ToArray, fileName, User.Identity.Name))
                Next
                Return Ok(results.ToArray)
            End If

            Return BadRequest("Can't find File")
        End Function

        <Route("api/Title/GenerateExcel")>
        Function GenerateExcel(<FromBody> queryString As JObject) As IHttpActionResult

            Dim bytes = Core.ExcelBuilder.BuildTitleReport(queryString)
            If bytes.Length > 0 Then
                Using fs = File.Open(HttpContext.Current.Server.MapPath("~/TempDataFile/checkrequest.xlsx"), FileMode.OpenOrCreate, FileAccess.ReadWrite)
                    fs.Write(bytes, 0, bytes.Length)
                End Using
            End If
            Return Ok()
        End Function

        <Route("api/ConstructionCases/GetGeneratedExcel")>
        Function GetGeneratedExcel() As HttpResponseMessage
            Dim response = New HttpResponseMessage(HttpStatusCode.OK)
            Dim fs = New FileStream(HttpContext.Current.Server.MapPath("~/TempDataFile/checkrequest.xlsx"), FileMode.Open)
            Dim bfs = New BinaryReader(fs).ReadBytes(fs.Length)
            response.Content = New ByteArrayContent(bfs)
            response.Content.Headers.Add("Content-Disposition", "inline; filename=titlereport.xlsx")
            response.Content.Headers.ContentType = New MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.Content.Headers.ContentLength = bfs.Length
            Return response
        End Function

    End Class
End Namespace

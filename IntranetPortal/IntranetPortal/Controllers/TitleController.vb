Imports System.IO
Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description

Namespace Controllers
    Public Class TitleController
        Inherits ApiController


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
    End Class
End Namespace
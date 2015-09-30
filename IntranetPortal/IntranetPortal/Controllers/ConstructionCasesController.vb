﻿Imports System.Data.Entity.Infrastructure
Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data
Imports System.IO
Imports System.Drawing
Imports ClosedXML
Imports System.Net.Http
Imports System.Net.Http.Headers

Namespace Controllers
    Public Class ConstructionCasesController
        Inherits System.Web.Http.ApiController

        ' GET: api/ConstructionCases
        Function GetConstructionCases() As IQueryable(Of ConstructionCase)
            Return ConstructionManage.GetMyCases(User.Identity.Name).AsQueryable
        End Function

        ' GET: api/ConstructionCases/5
        <ResponseType(GetType(ConstructionCase))>
        Function GetConstructionCase(ByVal id As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionManage.GetCase(id, CurrentUser)

            If IsNothing(constructionCase) Then
                Return NotFound()
            End If

            Return Ok(constructionCase)
        End Function

        ' PUT: api/ConstructionCases/5
        <ResponseType(GetType(Void))>
        Function PutConstructionCase(ByVal id As String, ByVal constructionCase As ConstructionCase) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = constructionCase.BBLE.Trim Then
                Return BadRequest()
            End If

            Try
                constructionCase.Save(CurrentUser)
            Catch ex As DbUpdateConcurrencyException
                If Not (ConstructionCaseExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/ConstructionCases
        <ResponseType(GetType(ConstructionCase))>
        Function PostConstructionCase(ByVal constructionCase As ConstructionCase) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                constructionCase.Save(CurrentUser)
            Catch ex As DbUpdateException
                If (ConstructionCaseExists(constructionCase.BBLE)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = constructionCase.BBLE}, constructionCase)
        End Function

        <ResponseType(GetType(Void))>
        <Route("api/ConstructionCases/ChangeStatus/{bble}")>
        Function PostChangeStatus(bble As String, <FromBody> status As ConstructionCase.CaseStatus) As IHttpActionResult
            ConstructionManage.ChnageStatus(bble, status, HttpContext.Current.User.Identity.Name)
            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/ConstructionCases
        <ResponseType(GetType(String()))>
        <Route("api/ConstructionCases/UploadFiles")>
        Function PostConstructionFiles() As IHttpActionResult
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
                    Using ms = New MemoryStream()
                        file.InputStream.CopyTo(ms)

                        Dim folderPath = String.Format("{0}/{1}", bble, "Construction")
                        If Not String.IsNullOrEmpty(fileFoler) Then
                            fileFoler = IIf(fileFoler.Last() = "/", fileFoler.Substring(0, fileFoler.Length - 1), fileFoler)
                            folderPath = folderPath & "/" & fileFoler
                        End If

                        If String.IsNullOrEmpty(fileName) Then
                            Dim fileNameParts = file.FileName.Split("\")
                            fileName = HttpUtility.UrlEncode(fileNameParts(fileNameParts.Length - 1))
                        End If

                        results.Add(Core.DocumentService.UploadFile(folderPath, ms.ToArray, fileName, User.Identity.Name))

                        If (Core.Thumbnail.IsImageFile(file.FileName)) Then
                            Dim image = System.Drawing.Image.FromStream(ms)
                            Dim thumbImg = Core.Thumbnail.FixedSize(image, 50, 50)
                            Using thumbms = New MemoryStream
                                thumbImg.Save(thumbms, image.RawFormat)
                                Dim thumbId = Core.Thumbnail.SaveThumb(Path.GetExtension(file.FileName).ToLower, thumbms.ToArray)
                                results.Add(thumbId)
                            End Using
                        End If
                    End Using

                Next
                Return Ok(results.ToArray)
            End If

            Return BadRequest("Can't find File")
        End Function

        ' DELETE: api/ConstructionCases/5
        <ResponseType(GetType(ConstructionCase))>
        Function DeleteConstructionCase(ByVal id As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionCase.GetCase(id)
            If IsNothing(constructionCase) Then
                Return NotFound()
            End If

            constructionCase.Delete()

            Return Ok(constructionCase)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then

            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function ConstructionCaseExists(ByVal id As String) As Boolean
            Return ConstructionCase.Exists(id)
        End Function

        Private Function CurrentUser() As String
            Return RequestContext.Principal.Identity.Name
        End Function

        <Route("api/ConstructionCases/LastLastUpdate/{bble}")>
        <ResponseType(GetType(Void))>
        Function GetLastLastUpdate(bble As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionCase.GetCase(bble)

            If IsNothing(constructionCase) Then
                Return NotFound()
            End If
            Return Ok(constructionCase.LastUpdate)
        End Function

        <Route("api/ConstructionCases/LastModifyUser/{bble}")>
        <ResponseType(GetType(Void))>
        Function GetLastModifyUser(bble As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionCase.GetCase(bble)

            If IsNothing(constructionCase) Then
                Return NotFound()
            End If
            If (constructionCase.UpdateBy = HttpContext.Current.User.Identity.Name) Then
                Return Ok("")
            End If
            Return Ok(constructionCase.UpdateBy)
        End Function

        <Route("api/ConstructionCases/GenerateExcel")>
        Function GetGenerateExcel() As HttpResponseMessage
            Dim response = New HttpResponseMessage(HttpStatusCode.OK)

            Dim wb As New Excel.XLWorkbook
            Dim ws = wb.Worksheets.Add("sheet1")
            ws.Cell("B2").Value = "Contacts"

            ws.Cell("B3").Value = "FName"
            ws.Cell("B4").Value = "John"
            ws.Cell("B5").Value = "Hank"
            ws.Cell("B6").Value = "Dagny"


            ws.Cell("C3").Value = "LName"
            ws.Cell("C4").Value = "Galt"
            ws.Cell("C5").Value = "Rearden"
            ws.Cell("C6").Value = "Taggart"
            Dim stream = New MemoryStream
            wb.SaveAs(stream)

            response.Content = New StreamContent(stream)
            response.Content.Headers.ContentType = New MediaTypeHeaderValue("application/octet-stream")
            Return response
        End Function
    End Class
End Namespace

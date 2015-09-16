Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data
Imports System.ServiceModel.Channels
Imports System.IO
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
                    Dim ms = New MemoryStream()
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
                Next
                Return Ok(results.ToArray)
            End If

            Return BadRequest("Can't find File")
        End Function

        ' DELETE: api/ConstructionCases/5
        <ResponseType(GetType(ConstructionCase))>
        Function DeleteConstructionCase(ByVal id As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = constructionCase.GetCase(id)
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
    End Class
End Namespace

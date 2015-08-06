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
            Return ConstructionCase.GetAllCases.AsQueryable
        End Function

        ' GET: api/ConstructionCases/5
        <ResponseType(GetType(ConstructionCase))>
        Function GetConstructionCase(ByVal id As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = constructionCase.GetCase(id)
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
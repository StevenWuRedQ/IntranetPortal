Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class LeadInfoDocumentSearchesController
        Inherits System.Web.Http.ApiController

        Private db As New IntranetPortalEntities

        ' GET: api/LeadInfoDocumentSearches
        Function GetLeadInfoDocumentSearches() As IQueryable(Of LeadInfoDocumentSearch)
            Return db.LeadInfoDocumentSearches
        End Function

        ' GET: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function GetLeadInfoDocumentSearch(ByVal id As String) As IHttpActionResult
            Dim leadInfoDocumentSearch As LeadInfoDocumentSearch = db.LeadInfoDocumentSearches.Find(id)
            If IsNothing(leadInfoDocumentSearch) Then
                Return NotFound()
            End If

            Return Ok(leadInfoDocumentSearch)
        End Function

        ' PUT: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(Void))>
        Function PutLeadInfoDocumentSearch(ByVal id As String, ByVal leadInfoDocumentSearch As LeadInfoDocumentSearch) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = leadInfoDocumentSearch.BBLE Then
                Return BadRequest()
            End If

            db.Entry(leadInfoDocumentSearch).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (LeadInfoDocumentSearchExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/LeadInfoDocumentSearches
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function PostLeadInfoDocumentSearch(ByVal leadInfoDocumentSearch As LeadInfoDocumentSearch) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            db.LeadInfoDocumentSearches.Add(leadInfoDocumentSearch)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (LeadInfoDocumentSearchExists(leadInfoDocumentSearch.BBLE)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = leadInfoDocumentSearch.BBLE}, leadInfoDocumentSearch)
        End Function

        ' DELETE: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function DeleteLeadInfoDocumentSearch(ByVal id As String) As IHttpActionResult
            Dim leadInfoDocumentSearch As LeadInfoDocumentSearch = db.LeadInfoDocumentSearches.Find(id)
            If IsNothing(leadInfoDocumentSearch) Then
                Return NotFound()
            End If

            db.LeadInfoDocumentSearches.Remove(leadInfoDocumentSearch)
            db.SaveChanges()

            Return Ok(leadInfoDocumentSearch)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function LeadInfoDocumentSearchExists(ByVal id As String) As Boolean
            Return db.LeadInfoDocumentSearches.Count(Function(e) e.BBLE = id) > 0
        End Function
    End Class
End Namespace
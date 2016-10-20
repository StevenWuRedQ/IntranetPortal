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
    Public Class UnderwritingRequestsController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/UnderwritingRequests
        Function GetUnderwritingRequests() As IQueryable(Of UnderwritingRequest)
            Return db.UnderwritingRequests
        End Function

        ' GET: api/UnderwritingRequests/5
        <ResponseType(GetType(UnderwritingRequest))>
        Function GetUnderwritingRequest(ByVal id As Integer) As IHttpActionResult
            Dim underwritingRequest As UnderwritingRequest = db.UnderwritingRequests.Find(id)
            If IsNothing(underwritingRequest) Then
                Return NotFound()
            End If

            Return Ok(underwritingRequest)
        End Function

        ' PUT: api/UnderwritingRequests/5
        <ResponseType(GetType(Void))>
        Function PutUnderwritingRequest(ByVal id As Integer, ByVal underwritingRequest As UnderwritingRequest) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = underwritingRequest.Id Then
                Return BadRequest()
            End If

            db.Entry(underwritingRequest).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (UnderwritingRequestExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/UnderwritingRequests
        <ResponseType(GetType(UnderwritingRequest))>
        Function PostUnderwritingRequest(ByVal underwritingRequest As UnderwritingRequest) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            db.UnderwritingRequests.Add(underwritingRequest)
            db.SaveChanges()

            Return CreatedAtRoute("DefaultApi", New With {.id = underwritingRequest.Id}, underwritingRequest)
        End Function

        ' DELETE: api/UnderwritingRequests/5
        <ResponseType(GetType(UnderwritingRequest))>
        Function DeleteUnderwritingRequest(ByVal id As Integer) As IHttpActionResult
            Dim underwritingRequest As UnderwritingRequest = db.UnderwritingRequests.Find(id)
            If IsNothing(underwritingRequest) Then
                Return NotFound()
            End If

            db.UnderwritingRequests.Remove(underwritingRequest)
            db.SaveChanges()

            Return Ok(underwritingRequest)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function UnderwritingRequestExists(ByVal id As Integer) As Boolean
            Return db.UnderwritingRequests.Count(Function(e) e.Id = id) > 0
        End Function
    End Class
End Namespace
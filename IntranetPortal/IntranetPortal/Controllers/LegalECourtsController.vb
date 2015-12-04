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
    Public Class LegalECourtsController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/LegalECourts
        Function GetLegalECourts() As IQueryable(Of LegalECourt)
            Return db.LegalECourts
        End Function

        ' GET: api/LegalECourts/5
        <ResponseType(GetType(LegalECourt))>
        Function GetLegalECourt(ByVal id As Integer) As IHttpActionResult
            Dim legalECourt As LegalECourt = db.LegalECourts.Find(id)
            If IsNothing(legalECourt) Then
                Return NotFound()
            End If

            Return Ok(legalECourt)
        End Function

        <ResponseType(GetType(LegalECourt))>
        <Route("api/LegalECourtByBBLE/{bble}")>
        Function GetLegalECourtByBBLE(ByVal BBLE As String) As IHttpActionResult
            Dim legalECourt As LegalECourt = Data.LegalECourt.GetLegalEcourt(BBLE)
            If IsNothing(legalECourt) Then
                Return NotFound()
            End If

            Return Ok(legalECourt)
        End Function
        ' PUT: api/LegalECourts/5
        <ResponseType(GetType(Void))>
        Function PutLegalECourt(ByVal id As Integer, ByVal legalECourt As LegalECourt) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = legalECourt.Id Then
                Return BadRequest()
            End If

            db.Entry(legalECourt).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (LegalECourtExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/LegalECourts
        <ResponseType(GetType(LegalECourt))>
        Function PostLegalECourt(ByVal legalECourt As LegalECourt) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            db.LegalECourts.Add(legalECourt)
            db.SaveChanges()

            Return CreatedAtRoute("DefaultApi", New With {.id = legalECourt.Id}, legalECourt)
        End Function

        ' DELETE: api/LegalECourts/5
        <ResponseType(GetType(LegalECourt))>
        Function DeleteLegalECourt(ByVal id As Integer) As IHttpActionResult
            Dim legalECourt As LegalECourt = db.LegalECourts.Find(id)
            If IsNothing(legalECourt) Then
                Return NotFound()
            End If

            db.LegalECourts.Remove(legalECourt)
            db.SaveChanges()

            Return Ok(legalECourt)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function LegalECourtExists(ByVal id As Integer) As Boolean
            Return db.LegalECourts.Count(Function(e) e.Id = id) > 0
        End Function
    End Class
End Namespace
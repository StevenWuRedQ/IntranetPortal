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
    Public Class AuctionPropertiesController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/Auction
        Function GetAuctionProperties() As IQueryable(Of AuctionProperty)
            Return db.AuctionProperties
        End Function

        ' GET: api/Auction/5
        <ResponseType(GetType(AuctionProperty))>
        Function GetAuctionProperty(ByVal id As Integer) As IHttpActionResult
            Dim auctionProperty As AuctionProperty = db.AuctionProperties.Find(id)
            If IsNothing(auctionProperty) Then
                Return NotFound()
            End If

            Return Ok(auctionProperty)
        End Function

        ' PUT: api/Auction/5
        <ResponseType(GetType(Void))>
        Function PutAuctionProperty(ByVal id As Integer, ByVal auctionProperty As AuctionProperty) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = auctionProperty.AuctionId Then
                Return BadRequest()
            End If

            db.Entry(auctionProperty).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (AuctionPropertyExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/Auction
        <ResponseType(GetType(AuctionProperty))>
        Function PostAuctionProperty(ByVal auctionProperty As AuctionProperty) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            db.AuctionProperties.Add(auctionProperty)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (AuctionPropertyExists(auctionProperty.AuctionId)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = auctionProperty.AuctionId}, auctionProperty)
        End Function

        ' DELETE: api/Auction/5
        <ResponseType(GetType(AuctionProperty))>
        Function DeleteAuctionProperty(ByVal id As Integer) As IHttpActionResult
            Dim auctionProperty As AuctionProperty = db.AuctionProperties.Find(id)
            If IsNothing(auctionProperty) Then
                Return NotFound()
            End If

            db.AuctionProperties.Remove(auctionProperty)
            db.SaveChanges()

            Return Ok(auctionProperty)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function AuctionPropertyExists(ByVal id As Integer) As Boolean
            Return db.AuctionProperties.Count(Function(e) e.AuctionId = id) > 0
        End Function
    End Class
End Namespace
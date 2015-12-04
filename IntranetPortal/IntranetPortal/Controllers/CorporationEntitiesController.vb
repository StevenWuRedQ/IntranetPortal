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
    Public Class CorporationEntitiesController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/CorporationEntities
        Function GetCorporationEntities() As IQueryable(Of CorporationEntity)
            Return db.CorporationEntities.Where(Function(c) c.AppId = Employee.CurrentAppId)
        End Function
        ' GET /api/CorporationEntities/ByBBLE?BBLE=3041250022
        <ResponseType(GetType(CorporationEntity))>
        <Route("api/CorporationEntities/ByBBLE")>
        Function GetCorporationEntityByBBLE(ByVal BBLE As String) As IHttpActionResult
            Dim corporationentity As CorporationEntity = db.CorporationEntities.Where(Function(c) c.BBLE = BBLE).FirstOrDefault
            If IsNothing(corporationentity) Then
                Return NotFound()
            End If
            Return Ok(corporationentity)
        End Function
        ' GET: api/CorporationEntities/5
        <ResponseType(GetType(CorporationEntity))>
        Function GetCorporationEntity(ByVal id As Integer) As IHttpActionResult
            Dim corporationEntity As CorporationEntity = db.CorporationEntities.Find(id)
            If IsNothing(corporationEntity) Then
                Return NotFound()
            End If

            Return Ok(corporationEntity)
        End Function

        ' PUT: api/CorporationEntities/5
        <ResponseType(GetType(Void))>
        Function PutCorporationEntity(ByVal id As Integer, ByVal corporationEntity As CorporationEntity) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = corporationEntity.EntityId Then
                Return BadRequest()
            End If

            db.Entry(corporationEntity).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (CorporationEntityExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/CorporationEntities
        <ResponseType(GetType(CorporationEntity))>
        Function PostCorporationEntity(ByVal corporationEntity As CorporationEntity) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If
            corporationEntity.AppId = Employee.CurrentAppId
            db.CorporationEntities.Add(corporationEntity)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (CorporationEntityExists(corporationEntity.EntityId)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = corporationEntity.EntityId}, corporationEntity)
        End Function

        ' DELETE: api/CorporationEntities/5
        <ResponseType(GetType(CorporationEntity))>
        Function DeleteCorporationEntity(ByVal id As Integer) As IHttpActionResult
            Dim corporationEntity As CorporationEntity = db.CorporationEntities.Find(id)
            If IsNothing(corporationEntity) Then
                Return NotFound()
            End If

            db.CorporationEntities.Remove(corporationEntity)
            db.SaveChanges()

            Return Ok(corporationEntity)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function CorporationEntityExists(ByVal id As Integer) As Boolean
            Return db.CorporationEntities.Count(Function(e) e.EntityId = id) > 0
        End Function
    End Class
End Namespace
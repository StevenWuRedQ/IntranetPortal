Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal

Namespace Controllers
    Public Class BuildingCodes1Controller
        Inherits System.Web.Http.ApiController

        Private db As New Entities

        ' GET: api/BuildingCodes1
        Function GetBuildingCodes() As IQueryable(Of BuildingCode)
            Return db.BuildingCodes
        End Function

        ' GET: api/BuildingCodes1/5
        <ResponseType(GetType(BuildingCode))>
        Function GetBuildingCode(ByVal id As String) As IHttpActionResult
            Dim buildingCode As BuildingCode = db.BuildingCodes.Find(id)
            If IsNothing(buildingCode) Then
                Return NotFound()
            End If

            Return Ok(buildingCode)
        End Function

        ' PUT: api/BuildingCodes1/5
        <ResponseType(GetType(Void))>
        Function PutBuildingCode(ByVal id As String, ByVal buildingCode As BuildingCode) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = buildingCode.Code Then
                Return BadRequest()
            End If

            db.Entry(buildingCode).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (BuildingCodeExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/BuildingCodes1
        <ResponseType(GetType(BuildingCode))>
        Function PostBuildingCode(ByVal buildingCode As BuildingCode) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            db.BuildingCodes.Add(buildingCode)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (BuildingCodeExists(buildingCode.Code)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = buildingCode.Code}, buildingCode)
        End Function

        ' DELETE: api/BuildingCodes1/5
        <ResponseType(GetType(BuildingCode))>
        Function DeleteBuildingCode(ByVal id As String) As IHttpActionResult
            Dim buildingCode As BuildingCode = db.BuildingCodes.Find(id)
            If IsNothing(buildingCode) Then
                Return NotFound()
            End If

            db.BuildingCodes.Remove(buildingCode)
            db.SaveChanges()

            Return Ok(buildingCode)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function BuildingCodeExists(ByVal id As String) As Boolean
            Return db.BuildingCodes.Count(Function(e) e.Code = id) > 0
        End Function
    End Class
End Namespace
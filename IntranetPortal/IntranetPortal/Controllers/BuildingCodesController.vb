Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.ModelBinding
Imports System.Web.Http.OData
Imports System.Web.Http.OData.Routing
Imports IntranetPortal

Namespace Controllers

    'The WebApiConfig class may require additional changes to add a route for this controller. Merge these statements into the Register method of the WebApiConfig class as applicable. Note that OData URLs are case sensitive.

    'Imports System.Web.Http.OData.Builder
    'Dim builder As New ODataConventionModelBuilder
    'builder.EntitySet(Of BuildingCode)("BuildingCodes")
    'config.Routes.MapODataRoute("odata", "odata", builder.GetEdmModel())

    Public Class BuildingCodesController
        Inherits ODataController

        Private db As New Entities

        ' GET: odata/BuildingCodes
        <Queryable>
        Function GetBuildingCodes() As IQueryable(Of BuildingCode)
            Return db.BuildingCodes
        End Function

        ' GET: odata/BuildingCodes(5)
        <Queryable>
        Function GetBuildingCode(<FromODataUri> key As String) As SingleResult(Of BuildingCode)
            Return SingleResult.Create(db.BuildingCodes.Where(Function(buildingCode) buildingCode.Code = key))
        End Function

        ' PUT: odata/BuildingCodes(5)
        Function Put(<FromODataUri> ByVal key As String, ByVal buildingCode As BuildingCode) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not key = buildingCode.Code Then
                Return BadRequest()
            End If

            db.Entry(buildingCode).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (BuildingCodeExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(buildingCode)
        End Function

        ' POST: odata/BuildingCodes
        Function Post(ByVal buildingCode As BuildingCode) As IHttpActionResult
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

            Return Created(buildingCode)
        End Function

        ' PATCH: odata/BuildingCodes(5)
        <AcceptVerbs("PATCH", "MERGE")>
        Function Patch(<FromODataUri> ByVal key As String, ByVal patchValue As Delta(Of BuildingCode)) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim buildingCode As BuildingCode = db.BuildingCodes.Find(key)
            If IsNothing(buildingCode) Then
                Return NotFound()
            End If

            patchValue.Patch(buildingCode)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (BuildingCodeExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(buildingCode)
        End Function

        ' DELETE: odata/BuildingCodes(5)
        Function Delete(<FromODataUri> ByVal key As String) As IHttpActionResult
            Dim buildingCode As BuildingCode = db.BuildingCodes.Find(key)
            If IsNothing(buildingCode) Then
                Return NotFound()
            End If

            db.BuildingCodes.Remove(buildingCode)
            db.SaveChanges()

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function BuildingCodeExists(ByVal key As String) As Boolean
            Return db.BuildingCodes.Count(Function(e) e.Code = key) > 0
        End Function
    End Class
End Namespace

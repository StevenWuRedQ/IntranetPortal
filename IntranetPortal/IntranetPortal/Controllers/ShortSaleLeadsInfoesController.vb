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
Imports IntranetPortal.Data

Namespace Controllers

    'The WebApiConfig class may require additional changes to add a route for this controller. Merge these statements into the Register method of the WebApiConfig class as applicable. Note that OData URLs are case sensitive.

    'Imports System.Web.Http.OData.Builder
    'Dim builder As New ODataConventionModelBuilder
    'builder.EntitySet(Of ShortSaleLeadsInfo)("ShortSaleLeadsInfoes")
    'config.Routes.MapODataRoute("odata", "odata", builder.GetEdmModel())

    Public Class ShortSaleLeadsInfoesController
        Inherits ODataController

        Private db As New ShortSaleEntities

        ' GET: odata/ShortSaleLeadsInfoes
        Function GetShortSaleLeadsInfoes() As IQueryable(Of ShortSaleLeadsInfo)
            Return db.ShortSaleLeadsInfoes
        End Function

        ' GET: odata/ShortSaleLeadsInfoes(5)
        Function GetShortSaleLeadsInfo(<FromODataUri> key As String) As SingleResult(Of ShortSaleLeadsInfo)
            Return SingleResult.Create(db.ShortSaleLeadsInfoes.Where(Function(shortSaleLeadsInfo) shortSaleLeadsInfo.BBLE = key))
        End Function

        ' PUT: odata/ShortSaleLeadsInfoes(5)
        Function Put(<FromODataUri> ByVal key As String, ByVal shortSaleLeadsInfo As ShortSaleLeadsInfo) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not key = shortSaleLeadsInfo.BBLE Then
                Return BadRequest()
            End If

            db.Entry(shortSaleLeadsInfo).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (ShortSaleLeadsInfoExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(shortSaleLeadsInfo)
        End Function

        ' POST: odata/ShortSaleLeadsInfoes
        Function Post(ByVal shortSaleLeadsInfo As ShortSaleLeadsInfo) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If
                            
            db.ShortSaleLeadsInfoes.Add(shortSaleLeadsInfo)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (ShortSaleLeadsInfoExists(shortSaleLeadsInfo.BBLE)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return Created(shortSaleLeadsInfo)
        End Function

        ' PATCH: odata/ShortSaleLeadsInfoes(5)
        <AcceptVerbs("PATCH", "MERGE")>
        Function Patch(<FromODataUri> ByVal key As String, ByVal patchValue As Delta(Of ShortSaleLeadsInfo)) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim shortSaleLeadsInfo As ShortSaleLeadsInfo = db.ShortSaleLeadsInfoes.Find(key)
            If IsNothing(shortSaleLeadsInfo) Then
                Return NotFound()
            End If

            patchValue.Patch(shortSaleLeadsInfo)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (ShortSaleLeadsInfoExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(shortSaleLeadsInfo)
        End Function

        ' DELETE: odata/ShortSaleLeadsInfoes(5)
        Function Delete(<FromODataUri> ByVal key As String) As IHttpActionResult
            Dim shortSaleLeadsInfo As ShortSaleLeadsInfo = db.ShortSaleLeadsInfoes.Find(key)
            If IsNothing(shortSaleLeadsInfo) Then
                Return NotFound()
            End If

            db.ShortSaleLeadsInfoes.Remove(shortSaleLeadsInfo)
            db.SaveChanges()

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function ShortSaleLeadsInfoExists(ByVal key As String) As Boolean
            Return db.ShortSaleLeadsInfoes.Count(Function(e) e.BBLE = key) > 0
        End Function
    End Class
End Namespace

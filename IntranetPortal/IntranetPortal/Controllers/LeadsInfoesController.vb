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
    'builder.EntitySet(Of LeadsInfo)("LeadsInfoes")
    'builder.EntitySet(Of Lead)("Leads")
    'config.Routes.MapODataRoute("odata", "odata", builder.GetEdmModel())

    Public Class LeadsInfoesController
        Inherits ODataController

        Private db As New Entities

        ' GET: odata/LeadsInfoes
        <Queryable>
        Function GetLeadsInfoes() As IQueryable(Of LeadsInfo)
            Return db.LeadsInfoes
        End Function

        ' GET: odata/LeadsInfoes(5)
        <Queryable>
        Function GetLeadsInfo(<FromODataUri> key As String) As SingleResult(Of LeadsInfo)
            Return SingleResult.Create(db.LeadsInfoes.Where(Function(leadsInfo) leadsInfo.BBLE = key))
        End Function

        ' PUT: odata/LeadsInfoes(5)
        Function Put(<FromODataUri> ByVal key As String, ByVal leadsInfo As LeadsInfo) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not key = leadsInfo.BBLE Then
                Return BadRequest()
            End If

            db.Entry(leadsInfo).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (LeadsInfoExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(leadsInfo)
        End Function

        ' POST: odata/LeadsInfoes
        Function Post(ByVal leadsInfo As LeadsInfo) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If
                            
            db.LeadsInfoes.Add(leadsInfo)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (LeadsInfoExists(leadsInfo.BBLE)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return Created(leadsInfo)
        End Function

        ' PATCH: odata/LeadsInfoes(5)
        <AcceptVerbs("PATCH", "MERGE")>
        Function Patch(<FromODataUri> ByVal key As String, ByVal patchValue As Delta(Of LeadsInfo)) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim leadsInfo As LeadsInfo = db.LeadsInfoes.Find(key)
            If IsNothing(leadsInfo) Then
                Return NotFound()
            End If

            patchValue.Patch(leadsInfo)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (LeadsInfoExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(leadsInfo)
        End Function

        ' DELETE: odata/LeadsInfoes(5)
        Function Delete(<FromODataUri> ByVal key As String) As IHttpActionResult
            Dim leadsInfo As LeadsInfo = db.LeadsInfoes.Find(key)
            If IsNothing(leadsInfo) Then
                Return NotFound()
            End If

            db.LeadsInfoes.Remove(leadsInfo)
            db.SaveChanges()

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' GET: odata/LeadsInfoes(5)/Lead
        <Queryable>
        Function GetLead(<FromODataUri> ByVal key As String) As SingleResult(Of Lead)
            Return SingleResult.Create(db.LeadsInfoes.Where(Function(m) m.BBLE = key).Select(Function(m) m.Lead))
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function LeadsInfoExists(ByVal key As String) As Boolean
            Return db.LeadsInfoes.Count(Function(e) e.BBLE = key) > 0
        End Function
    End Class
End Namespace

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
    'builder.EntitySet(Of NYC_Scan_TaxLiens_Per_Year)("TaxLiensOData")
    'config.Routes.MapODataRoute("odata", "odata", builder.GetEdmModel())

    Public Class TaxLiensODataController
        Inherits ODataController

        Private db As New Entities

        ' GET: odata/TaxLiensOData
        <EnableQuery>
        Function GetTaxLiensOData() As IQueryable(Of NYC_Scan_TaxLiens_Per_Year)
            Return db.NYC_Scan_TaxLiens_Per_Year
        End Function

        ' GET: odata/TaxLiensOData(5)
        <EnableQuery>
        Function GetNYC_Scan_TaxLiens_Per_Year(<FromODataUri> key As String) As SingleResult(Of NYC_Scan_TaxLiens_Per_Year)
            Return SingleResult.Create(db.NYC_Scan_TaxLiens_Per_Year.Where(Function(nYC_Scan_TaxLiens_Per_Year) nYC_Scan_TaxLiens_Per_Year.BBLE = key))
        End Function

        ' PUT: odata/TaxLiensOData(5)
        Function Put(<FromODataUri> ByVal key As String, ByVal nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not key = nYC_Scan_TaxLiens_Per_Year.BBLE Then
                Return BadRequest()
            End If

            db.Entry(nYC_Scan_TaxLiens_Per_Year).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (NYC_Scan_TaxLiens_Per_YearExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(nYC_Scan_TaxLiens_Per_Year)
        End Function

        ' POST: odata/TaxLiensOData
        Function Post(ByVal nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If
                            
            db.NYC_Scan_TaxLiens_Per_Year.Add(nYC_Scan_TaxLiens_Per_Year)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (NYC_Scan_TaxLiens_Per_YearExists(nYC_Scan_TaxLiens_Per_Year.BBLE)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return Created(nYC_Scan_TaxLiens_Per_Year)
        End Function

        ' PATCH: odata/TaxLiensOData(5)
        <AcceptVerbs("PATCH", "MERGE")>
        Function Patch(<FromODataUri> ByVal key As String, ByVal patchValue As Delta(Of NYC_Scan_TaxLiens_Per_Year)) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year = db.NYC_Scan_TaxLiens_Per_Year.Find(key)
            If IsNothing(nYC_Scan_TaxLiens_Per_Year) Then
                Return NotFound()
            End If

            patchValue.Patch(nYC_Scan_TaxLiens_Per_Year)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (NYC_Scan_TaxLiens_Per_YearExists(key)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return Updated(nYC_Scan_TaxLiens_Per_Year)
        End Function

        ' DELETE: odata/TaxLiensOData(5)
        Function Delete(<FromODataUri> ByVal key As String) As IHttpActionResult
            Dim nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year = db.NYC_Scan_TaxLiens_Per_Year.Find(key)
            If IsNothing(nYC_Scan_TaxLiens_Per_Year) Then
                Return NotFound()
            End If

            db.NYC_Scan_TaxLiens_Per_Year.Remove(nYC_Scan_TaxLiens_Per_Year)
            db.SaveChanges()

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function NYC_Scan_TaxLiens_Per_YearExists(ByVal key As String) As Boolean
            Return db.NYC_Scan_TaxLiens_Per_Year.Count(Function(e) e.BBLE = key) > 0
        End Function
    End Class
End Namespace

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
    Public Class TaxLiensController
        Inherits System.Web.Http.ApiController

        Private db As New Entities

        ' GET: api/TaxLiens
        Function GetNYC_Scan_TaxLiens_Per_Year() As IQueryable(Of NYC_Scan_TaxLiens_Per_Year)
            Return db.NYC_Scan_TaxLiens_Per_Year
        End Function

        ' GET: api/TaxLiens/5
        <ResponseType(GetType(NYC_Scan_TaxLiens_Per_Year))>
        Function GetNYC_Scan_TaxLiens_Per_Year(ByVal id As String) As IHttpActionResult
            Dim nYC_Scan_TaxLiens_Per_Year = db.NYC_Scan_TaxLiens_Per_Year.Where(Function(t) t.BBLE = id)
            If IsNothing(nYC_Scan_TaxLiens_Per_Year) Then
                Return NotFound()
            End If

            Return Ok(nYC_Scan_TaxLiens_Per_Year)
        End Function

        ' PUT: api/TaxLiens/5
        <ResponseType(GetType(Void))>
        Function PutNYC_Scan_TaxLiens_Per_Year(ByVal id As String, ByVal nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = nYC_Scan_TaxLiens_Per_Year.BBLE Then
                Return BadRequest()
            End If

            db.Entry(nYC_Scan_TaxLiens_Per_Year).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (NYC_Scan_TaxLiens_Per_YearExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/TaxLiens
        <ResponseType(GetType(NYC_Scan_TaxLiens_Per_Year))>
        Function PostNYC_Scan_TaxLiens_Per_Year(ByVal nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year) As IHttpActionResult
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

            Return CreatedAtRoute("DefaultApi", New With {.id = nYC_Scan_TaxLiens_Per_Year.BBLE}, nYC_Scan_TaxLiens_Per_Year)
        End Function

        ' DELETE: api/TaxLiens/5
        <ResponseType(GetType(NYC_Scan_TaxLiens_Per_Year))>
        Function DeleteNYC_Scan_TaxLiens_Per_Year(ByVal id As String) As IHttpActionResult
            Dim nYC_Scan_TaxLiens_Per_Year As NYC_Scan_TaxLiens_Per_Year = db.NYC_Scan_TaxLiens_Per_Year.Find(id)
            If IsNothing(nYC_Scan_TaxLiens_Per_Year) Then
                Return NotFound()
            End If

            db.NYC_Scan_TaxLiens_Per_Year.Remove(nYC_Scan_TaxLiens_Per_Year)
            db.SaveChanges()

            Return Ok(nYC_Scan_TaxLiens_Per_Year)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function NYC_Scan_TaxLiens_Per_YearExists(ByVal id As String) As Boolean
            Return db.NYC_Scan_TaxLiens_Per_Year.Count(Function(e) e.BBLE = id) > 0
        End Function
    End Class
End Namespace
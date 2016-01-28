Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.IO
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    <Authorize(Roles:="Admin,Auction-Manager")>
    Public Class AuctionPropertiesController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/AuctionProperties
        Function GetAuctionProperties() As IQueryable(Of AuctionPropertyView)
            Dim today = DateTime.Today
            Return db.AuctionPropertyViews.Where(Function(a) a.AuctionDate > today)
        End Function

        Function GetAuctionProperties(showAll As Boolean?, unassigned As Boolean?) As IQueryable(Of AuctionPropertyView)
            Dim result = GetAuctionProperties()
            If showAll Then
                result = db.AuctionPropertyViews
            End If

            If unassigned Then
                result = result.Where(Function(a) a.EmployeeName Is Nothing)
            End If

            Return result
        End Function

        ' GET: api/AuctionProperties/5
        <ResponseType(GetType(AuctionPropertyView))>
        Function GetAuctionProperty(ByVal id As Integer) As IHttpActionResult
            'Dim message = String.Format("Product with id = {0} not found", id)
            'Throw New HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.NotFound, message))
            Dim prop As AuctionPropertyView = AuctionProperty.GetAuctionProperty(id)
            If IsNothing(prop) Then
                Return NotFound()
            End If

            Return Ok(prop)
        End Function

        ' PUT: api/AuctionProperties/5
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

        'POST: api/AuctionProperties/Import
        <Route("api/AuctionProperties/Import")>
        Function PostImportAuctionPropeties() As IQueryable(Of AuctionPropertyView)
            If HttpContext.Current.Request.Files.Count <= 0 Then
                Return NotFound()
            End If

            Try
                Dim file = HttpContext.Current.Request.Files(0)
                Dim FileName As String = Path.GetFileName(file.FileName)
                Dim Extension As String = Path.GetExtension(file.FileName)
                Dim FolderPath As String = "/TempDataFile/AuctionFiles/"

                Dim FilePath As String = HttpContext.Current.Server.MapPath(FolderPath + FileName)
                file.SaveAs(FilePath)

                Dim result = AuctionProperty.Import(FilePath, HttpContext.Current.User.Identity.Name)

                Core.SystemLog.Log("ImportAuctionFiles", "ImportAuctionFiles, Result: " & result, Core.SystemLog.LogCategory.Operation, Nothing, HttpContext.Current.User.Identity.Name)

                Return GetAuctionProperties()
            Catch ex As Exception
                Throw ex
            End Try
        End Function


        '' POST: api/AuctionProperties
        '<ResponseType(GetType(AuctionProperty))>
        'Function PostAuctionProperty(ByVal auctionProperty As AuctionProperty) As IHttpActionResult
        '    Throw New Exception("Not Implement")

        '    If Not ModelState.IsValid Then
        '        Return BadRequest(ModelState)
        '    End If

        '    db.AuctionProperties.Add(auctionProperty)

        '    Try
        '        db.SaveChanges()
        '    Catch ex As DbUpdateException
        '        If (AuctionPropertyExists(auctionProperty.AuctionId)) Then
        '            Return Conflict()
        '        Else
        '            Throw
        '        End If
        '    End Try

        '    Return CreatedAtRoute("DefaultApi", New With {.id = auctionProperty.AuctionId}, auctionProperty)
        'End Function

        '' DELETE: api/AuctionProperties/5
        '<ResponseType(GetType(AuctionProperty))>
        'Function DeleteAuctionProperty(ByVal id As Integer) As IHttpActionResult
        '    Dim auctionProperty As AuctionProperty = db.AuctionProperties.Find(id)
        '    If IsNothing(auctionProperty) Then
        '        Return NotFound()
        '    End If

        '    db.AuctionProperties.Remove(auctionProperty)
        '    db.SaveChanges()

        '    Return Ok(auctionProperty)
        'End Function

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
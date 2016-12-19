Imports System.IO
Imports System.Net
Imports System.Net.Http
Imports System.Net.Http.Headers
Imports System.Web.Http
Imports IntranetPortal.Data
Imports Newtonsoft.Json.Linq

Namespace Controllers
    Public Class UnderwritingController
        Inherits ApiController

        <Route("api/underwriter/{bble}")>
        Public Function GetUnderwritingByBBLE(bble As String) As IHttpActionResult
            'Return Ok()
            Dim uw = UnderwritingManage.GetUnderwritingByBBLE(bble)
            Return Ok(uw)
        End Function

        <Route("api/underwriter")>
        <HttpPost>
        Public Function PostUnderwriting(<FromBody> uw As Underwriting) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                Dim u = UnderwritingManage.SaveOrUpdate(uw, HttpContext.Current.User.Identity.Name)
                Return Ok(u)
            Catch ex As Exception

            End Try

            Return Ok()
        End Function

        <Route("api/underwriter/archive")>
        <HttpPost>
        Public Function PostArchive(<FromBody> data As Object()) As IHttpActionResult
            Dim underwriting = data(0).ToObject(GetType(Underwriting))
            Dim archiveNote = CStr(data(1))
            Dim currentUser = HttpContext.Current.User.Identity.Name
            UnderwritingManage.SaveOrUpdate(underwriting, currentUser)
            Dim isSaved = UnderwritingManage.archive(underwriting.BBLE, currentUser, archiveNote)
            If isSaved Then
                Return Ok()
            Else
                Return BadRequest()
            End If
        End Function

        <Route("api/underwriter/archived/{bble}")>
        <HttpGet>
        Public Function GetArchivedListByBBLE(bble As String) As IHttpActionResult
            Return Ok(UnderwritingManage.loadArchivedList(bble).AsEnumerable)
        End Function

        <Route("api/underwriter/archived/id/{id}")>
        <HttpGet>
        Public Function GetArchivedByID(id As String) As IHttpActionResult
            Return Ok(UnderwritingManage.getArchived(id))
        End Function

        <Route("api/underwriter/generatexml/{bble}")>
        <HttpGet>
        Function GenerateExcel(bble As String) As IHttpActionResult
            If Not String.IsNullOrEmpty(bble) Then
                Dim ms As New MemoryStream
                Using _
                    fs =
                        File.Open(HttpContext.Current.Server.MapPath("~/App_Data/underwriter.xlsx"),
                                  FileMode.OpenOrCreate, FileAccess.ReadWrite)
                    fs.CopyTo(ms)
                End Using
                Dim leadinfo As LeadsInfo
                Dim docsearch As LeadInfoDocumentSearch
                leadinfo = LeadsInfo.GetInstance(bble)
                Using ctx As New PortalEntities
                    docsearch = ctx.LeadInfoDocumentSearches.Find(bble)
                End Using
                If Not ms Is Nothing AndAlso Not leadinfo Is Nothing AndAlso Not docsearch Is Nothing Then
                    Dim excelbytes = ExcelBuilder.fillUpUnderWriterSheet(ms, leadinfo, docsearch)
                    Using _
                        tempFile =
                            New FileStream(HttpContext.Current.Server.MapPath("~/TempDataFile/underwriter.xlsx"),
                                           FileMode.OpenOrCreate, FileAccess.ReadWrite)
                        tempFile.Write(excelbytes, 0, excelbytes.Length)
                        Return Ok()
                    End Using
                    ms.Close()
                End If
            End If


            Return Ok()
        End Function

        <Route("api/underwriter/getgeneratedxml/{bble}")>
        Function GetGeneratedExcel(bble As String, <FromBody> queryString As JToken) As HttpResponseMessage
            Dim response = New HttpResponseMessage(HttpStatusCode.OK)
            Dim fs = New FileStream(HttpContext.Current.Server.MapPath("~/TempDataFile/underwriter.xlsx"), FileMode.Open)
            Dim bfs = New BinaryReader(fs).ReadBytes(fs.Length)
            response.Content = New ByteArrayContent(bfs)
            response.Content.Headers.Add("Content-Disposition", "inline; filename=underwriter-" & bble & ".xlsx")
            response.Content.Headers.ContentType =
                New MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.Content.Headers.ContentLength = bfs.Length
            Return response
        End Function
    End Class
End Namespace
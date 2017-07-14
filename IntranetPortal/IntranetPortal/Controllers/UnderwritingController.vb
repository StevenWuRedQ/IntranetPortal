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

        <Route("api/underwriting/list"), HttpGet>
        Public Function GetProperties() As IHttpActionResult
            ' the original version
            'Dim list = UnderwritingService.GetPropertiesList()
            'Dim jArrayList = JArray.FromObject(list).ToList
            'jArrayList.ForEach(Sub(s) s("Team") = Employee.GetEmpTeam(s("EmployeeName").ToString()))
            'Return Ok(jArrayList)

            ' changed by chris - 7/14/2017
            Dim list = UnderwritingService.GetPropertiesList2()
            Return Ok(list)
        End Function

        <Route("api/underwriting/status/{status}"), HttpGet>
        Public Function GetUnderwritingByStatus(status As Integer) As IHttpActionResult
            Dim list = UnderwritingService.GetUnderwritingByStatus(status)
            Dim jArrayList = JArray.FromObject(list).ToList
            jArrayList.ForEach(Sub(s) s("CaseName") = LeadsInfo.GetPropertyAddress(s("BBLE").ToString.Trim))
            Dim Result = New With {
                .data = jArrayList
            }
            Return Ok(Result)
        End Function

        <Route("api/underwriting/sync"), HttpPost>
        Public Function SyncToUnderwritingService() As IHttpActionResult
            Dim Errors = UnderwritingService.SyncToUnderwritingService()
            Return Ok(Errors)
        End Function
    End Class
End Namespace
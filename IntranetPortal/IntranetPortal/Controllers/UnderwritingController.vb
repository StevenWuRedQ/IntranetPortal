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
        Dim list = LeadInfoDocumentSearch.GetPropertiesList().ToList()
            Dim jArrayList = JArray.FromObject(list).ToList()
            jArrayList.ForEach(Function(s) s.item("Team") = Employee.GetEmpTeam(s("Owner").ToString()))
            Return Ok(jArrayList)
        End Function
    End Class
End Namespace
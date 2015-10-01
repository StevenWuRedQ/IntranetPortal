Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Core
Imports Newtonsoft.Json.Linq

Namespace Controllers
    Public Class ReportController
        Inherits ApiController


        <ResponseType(GetType(String))>
        <Route("api/Report/Query")>
        Function PostQuery(<FromBody> queryString As JToken) As IHttpActionResult
            If queryString Is Nothing Then
                Return BadRequest()
            End If

            Try
                Dim qb As New Core.QueryBuilder
                Dim sql = qb.BuildSelectQuery(queryString, "ShortSaleCases")
                Return Ok(sql)
            Catch ex As Exception
                Throw
            End Try
        End Function

        <ResponseType(GetType(DataTable))>
        <Route("api/Report/QueryData")>
        Function PostQueryData(<FromBody> queryString As JToken) As IHttpActionResult
            If queryString Is Nothing Then
                Return BadRequest()
            End If

            Try
                Dim qb As New Core.QueryBuilder
                Dim dt = qb.LoadReportData(queryString, "ShortSaleCases")
                Return Ok(dt)
            Catch ex As Exception
                Throw
            End Try
        End Function

        <ResponseType(GetType(CustomReport))>
        <Route("api/Report/Load/{reportId}")>
        Function GetLoadReport(reportId As Integer) As IHttpActionResult
            Try
                Dim report = CustomReport.Instance(reportId)
                If report Is Nothing Then
                    Return NotFound()
                End If

                Return Ok(report)
            Catch ex As Exception
                Throw
            End Try
        End Function

        <ResponseType(GetType(Void))>
        <Route("api/Report/Save")>
        Function PostSaveReport(report As CustomReport) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                report.Save(CurrentUser)
            Catch ex As Exception
                If Not CustomReport.Exists(report.ReportId) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        <ResponseType(GetType(CustomReport))>
        <Route("api/Report/Delete/{reportId}")>
        Function DeleteReport(reportId As Integer) As IHttpActionResult
            Dim report = CustomReport.Instance(reportId)

            If IsNothing(report) Then
                Return NotFound()
            End If

            report.Delete()

            Return Ok(report)
        End Function

        Private Function CurrentUser() As String
            Return RequestContext.Principal.Identity.Name
        End Function

    End Class
End Namespace
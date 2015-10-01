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

    End Class
End Namespace
Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data
Imports Newtonsoft.Json.Linq

Namespace Controllers
    Public Class ExternalDataController
        Inherits ApiController

        Public Function GetExternalData(api As String, source As String) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest()
            End If

            Dim service = New GradingService()

            If service Is Nothing Then
                Return BadRequest("Unknown Service Type.")
            End If

            Try
                Dim result = service.GetData(api)
                Return Ok(result)
            Catch ex As Exception
                Throw
            End Try
        End Function



        Public Function PostExternalData(api As String, source As String, json As JObject) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest()
            End If

            Dim service = New GradingService()
            If service Is Nothing Then
                Return BadRequest("unknow service type")
            End If

            Try
                Dim result As String = service.PostData(api, json)
                Return Ok(result)
            Catch
                ' return Ok();
                Throw
            End Try
        End Function


    End Class


End Namespace
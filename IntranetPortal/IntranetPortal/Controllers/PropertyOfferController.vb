Imports System.Net
Imports System.Web.Http
Imports Newtonsoft.Json.Linq

Namespace Controllers
    Public Class PropertyOfferController
        Inherits ApiController

        <Route("api/PropertyOffer/GeneratePackage/{bble}")>
        Public Function PostGeneratePackage(bble As String, <FromBody> data As JObject) As IHttpActionResult

            Try
                Dim link = PropertyOfferManage.GeneratePackage(bble, data)
                Return Ok(link)
            Catch ex As Exception
                Return BadRequest(ex.Message)
            End Try

        End Function

    End Class
End Namespace
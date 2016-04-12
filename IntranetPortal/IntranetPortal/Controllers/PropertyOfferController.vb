Imports System.Net
Imports System.Web.Http
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data

Namespace Controllers

    ''' <summary>
    ''' The web controller for PropertyOffer
    ''' </summary>
    Public Class PropertyOfferController
        Inherits ApiController

        ''' <summary>
        ''' Generate the document package
        ''' </summary>
        ''' <param name="bble">The property bble</param>
        ''' <param name="data">The form data</param>
        ''' <returns>The generated file link</returns>
        <Route("api/PropertyOffer/GeneratePackage/{bble}")>
        Public Function PostGeneratePackage(bble As String, <FromBody> data As JObject) As IHttpActionResult

            Try
                Dim path = HttpContext.Current.Server.MapPath("~/App_Data/OfferDoc")
                Dim destPath = HttpContext.Current.Server.MapPath("/TempDataFile/OfferDoc/")
                Dim fileName = PropertyOfferManage.GeneratePackage(bble, data, path, destPath)
                Return Ok(destPath & fileName)
            Catch ex As Exception
                Return BadRequest(ex.Message)
            End Try

        End Function

        <Route("api/PropertyOffer/")>
        Public Function GetPropertyOffers() As IHttpActionResult

            Dim name = HttpContext.Current.User.Identity.Name

            If Employee.IsAdmin(name) Then
                name = "*"
            End If

            Dim records = PropertyOffer.GetOffers(name)
            Return Ok(records)

        End Function

    End Class
End Namespace
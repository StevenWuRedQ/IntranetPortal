Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class ShortSaleController
        Inherits ApiController

        <Route("api/ShortSale/GetBuyerTitle")>
        Public Function GetBuyerTitle(bble As String) As IHttpActionResult
            Dim Title = Data.PropertyTitle.GetBuyerTitle(bble)
            Return Ok(Title)
        End Function


        <Route("api/ShortSale/UpdateBuyerTitle")>
        Public Function UpdateBuyerTitle(<FromBody> titleInfo As Data.PropertyTitle) As IHttpActionResult
            Dim result = Data.PropertyTitle.UpdateBuyerTitle(titleInfo, HttpContext.Current.User.Identity.Name)
            Return Ok(result)
        End Function

    End Class
End Namespace
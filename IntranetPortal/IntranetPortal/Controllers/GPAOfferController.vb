Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class GPAOfferController
        Inherits ApiController

        Public Function GetOffers(view As Integer) As List(Of GPAOffer)
            Return GPAOffer.GetOffers(view)
        End Function

        <Route("api/gpaoffer/{bble}/enabletitle")>
        Public Function PostEnableTitle(bble As String, offer As GPAOffer) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            offer.UpdateStatus(GPAOffer.OfferStatus.InTitle)
            'TitleManage.StartTitle(offer.BBLE, offer.Address, HttpContext.Current.User.Identity.Name)
            Return Ok()
        End Function
    End Class
End Namespace
Public Class MapsPopup
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        'Dim propInfo = ShortSale.PropertyBaseInfo.GetInstance(e.Parameter)
        'e.Result = propInfo.PropertyAddress + "|Block:" + propInfo.Block + " Lot:" + propInfo.Lot
    End Sub
End Class
Public Class MapsPopup
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Using ctx As New Entities
            Dim r = ctx.SearchResults.Where(Function(l) l.BBLE = e.Parameter).FirstOrDefault
            If (r IsNot Nothing) Then
                If (Not String.IsNullOrEmpty(r.PropertyAddress)) Then
                    e.Result = r.PropertyAddress + "|Block:" + r.BLOCK + " Lot:" + r.LOT
                End If
            End If
        End Using
        'Dim propInfo = ShortSale.PropertyBaseInfo.GetInstance(e.Parameter)
        'e.Result = propInfo.PropertyAddress + "|Block:" + propInfo.Block + " Lot:" + propInfo.Lot
    End Sub
End Class
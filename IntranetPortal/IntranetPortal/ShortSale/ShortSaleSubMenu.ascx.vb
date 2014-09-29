Public Class ShortSaleSubMenu
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim propInfo = ShortSale.PropertyBaseInfo.GetInstance(e.Parameter)
        e.Result = propInfo.PropertyAddress + "|Block:" + propInfo.Block + " Lot:" + propInfo.Lot
    End Sub

    Protected Sub statusCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim status As ShortSale.CaseStatus
        If [Enum].TryParse(Of ShortSale.CaseStatus)(e.Parameter.Split("|")(0), status) Then
            'Dim status = [Enum].Parse(GetType(ShortSale.CaseStatus), e.Parameter.Split("|")(0))
            Dim caseId = CInt(e.Parameter.Split("|")(1))
            ShortSale.ShortSaleCase.GetCase(caseId).SaveStatus(status)
        End If
    End Sub
End Class
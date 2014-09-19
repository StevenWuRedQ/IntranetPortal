Imports IntranetPortal.ShortSale
Public Class ShortSaleOverVew
    Inherits System.Web.UI.UserControl

    Public Property shortSaleCaseData As ShortSaleCase
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub


    Protected Sub overviewCallbackPanel_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)

    End Sub
    Public Sub BindData(shortSale As ShortSaleCase)
        shortSaleCaseData = shortSale
    End Sub
End Class
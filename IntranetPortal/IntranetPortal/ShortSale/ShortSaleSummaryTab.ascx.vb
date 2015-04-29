Imports IntranetPortal.ShortSale

Public Class ShortSaleSummaryTab
    Inherits System.Web.UI.UserControl
    Public Property summaryCase As New ShortSaleCase
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub summary_call_back_panel_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        summaryCase = ShortSaleCase.GetCase(CInt(e.Parameter))

    End Sub
End Class
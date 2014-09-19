Imports IntranetPortal.ShortSale

Public Class ShortSalePage
    Inherits System.Web.UI.Page

    Public Property ShortSaleCaseData As ShortSaleCase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ASPxSplitter1.ClientVisible = True
            Dim leadPanel = ASPxSplitter1.GetPaneByName("leadPanel")
            leadPanel.Collapsed = False
            ShortSaleCaseList.BindCaseList()
        End If
    End Sub

    Protected Sub ASPxCallbackPanel2_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        ShortSaleCaseData = ShortSaleCase.GetCase(e.Parameter)
        ShortSaleOverVew.BindData(ShortSaleCaseData)
    End Sub
End Class
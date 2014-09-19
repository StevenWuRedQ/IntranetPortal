Imports IntranetPortal.ShortSale

Public Class ShortSaleCaseList
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()
    End Sub

    Public Sub BindCaseList()
        gridCase.DataSource = IntranetPortal.ShortSale.ShortSaleCase.GetAllCase()
        gridCase.DataBind()
    End Sub
End Class
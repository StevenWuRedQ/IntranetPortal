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

    Public Sub BindCaseList(status As CaseStatus)
        hfCaseStatus.Value = status
        gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status)
        gridCase.DataBind()
    End Sub

    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing Then
            If Not String.IsNullOrEmpty(hfCaseStatus.Value) Then
                BindCaseList(hfCaseStatus.Value)
            End If
        End If
    End Sub
End Class
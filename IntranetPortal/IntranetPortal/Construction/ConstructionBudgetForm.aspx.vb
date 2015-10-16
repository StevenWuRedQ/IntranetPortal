Public Class ConstructionBudgetForm
    Inherits System.Web.UI.Page
    Public BBLE = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Not String.IsNullOrEmpty(Page.Request.QueryString("BBLE")) Then
                BBLE = Page.Request.QueryString("BBLE")
            End If
        End If
    End Sub

End Class
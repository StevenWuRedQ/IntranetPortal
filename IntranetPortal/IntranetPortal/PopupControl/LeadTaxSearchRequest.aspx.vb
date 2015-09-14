Public Class LeadTaxSearchRequest
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            SearchRecodingPopupCtrl1.BBLE = Request.QueryString("BBLE")
        End If
    End Sub

End Class
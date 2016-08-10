Public Class LeadTaxSearchRequest
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Not IsPostBack) Then
            Me.DocSearchOldVersion.SearchRecodingPopupCtrl1.BBLE = Request.QueryString("BBLE")

            If (Me.DocSearchOldVersion.SearchRecodingPopupCtrl1.BBLE IsNot Nothing) Then
                ASPxSplitter1.GetPaneByName("listPanel").Visible = False
                ASPxSplitter1.GetPaneByName("dataPane").Visible = False
            End If

        End If

    End Sub

End Class
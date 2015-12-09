Public Class SearchRecodingPopupCtrl
    Inherits System.Web.UI.UserControl

    Public Property BBLE As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RecodingPopup1.ContentUrl = "/popupControl/SearchRecordingPopup.aspx?BBLE=" & Request.QueryString("BBLE")
    End Sub

End Class
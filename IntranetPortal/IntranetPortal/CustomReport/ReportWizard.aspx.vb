Public Class ReportWizard
    Inherits System.Web.UI.Page

    Public Template = "shortsale"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("t")) Then
            Template = Request.QueryString("t").ToString
        End If
    End Sub

End Class
Public Class ReportWizard
    Inherits System.Web.UI.Page

    Public Template = "shortsale"
    Public ReportId = 0
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("t")) Then
            Template = Request.QueryString("t").ToString
        End If
        Dim ReportIdStr = Request.QueryString("ReportId")
        If (Not String.IsNullOrEmpty(ReportIdStr)) Then
            ReportId = CInt(ReportIdStr)
        End If
    End Sub

End Class
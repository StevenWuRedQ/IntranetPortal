Public Class TitleSummaryView
    Inherits System.Web.UI.UserControl

    Public Property CategoryId As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not String.IsNullOrEmpty(Request.QueryString("c")) Then
            CategoryId = CInt(Request.QueryString("c"))
        End If

    End Sub

End Class
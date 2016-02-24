Public Class TitleSummaryView
    Inherits System.Web.UI.UserControl

    Public Property CategoryId As String
    Public Property Category As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not String.IsNullOrEmpty(Request.QueryString("c")) Then
            CategoryId = CInt(Request.QueryString("c"))
            Category = TitleManage.TitleCategories(CategoryId)
        Else
            Category = "All Cases"
        End If

    End Sub

End Class
Public Class MyTask
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            If Not String.IsNullOrEmpty(Request.QueryString("page")) Then

                Dim page = Request.QueryString("page")

                ASPxSplitter1.GetPaneByName("contentPanel").ContentUrl = page

            End If

        End If

    End Sub

End Class
Public Class ShortSalePage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ASPxSplitter1.ClientVisible = True
            Dim leadPanel = ASPxSplitter1.GetPaneByName("leadPanel")
            leadPanel.Collapsed = False
            ShortSaleCaseList.BindCaseList()
        End If
    End Sub
End Class
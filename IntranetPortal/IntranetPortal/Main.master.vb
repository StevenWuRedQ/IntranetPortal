Public Class Main
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.User.IsInRole("Admin") Then
            Dim item = MenuCorner.Items.FindByName("manageNode")
            item.Visible = True

        End If
    End Sub

    Public Property LeftPanelSize As Double
        Get
            Return ASPxSplitter1.Panes("LeftPane").Size.Value
        End Get
        Set(value As Double)
            ASPxSplitter1.Panes("LeftPane").Size = value
        End Set
    End Property

End Class
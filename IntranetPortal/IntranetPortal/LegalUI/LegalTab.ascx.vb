Public Class LegalTab
    Inherits System.Web.UI.UserControl
    
    Public SecondaryAction As Boolean = False
    Public Agent As Boolean = False
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Sub Page_init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        SecondaryAction = Request.QueryString("Attorney") IsNot Nothing
        Agent = Request.QueryString("Agent") IsNot Nothing

    End Sub


End Class
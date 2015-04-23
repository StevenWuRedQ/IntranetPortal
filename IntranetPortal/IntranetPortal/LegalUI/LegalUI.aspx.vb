Public Class LegalUI
    Inherits System.Web.UI.Page
    Public SecondaryAction As Boolean = False
    Public Agent As Boolean = False
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            
            SecondaryAction = Request.QueryString("Attorney") IsNot Nothing
            Agent = Request.QueryString("Agent") IsNot Nothing
        End If
    End Sub

End Class
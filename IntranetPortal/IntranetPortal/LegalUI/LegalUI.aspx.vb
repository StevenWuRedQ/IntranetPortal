Public Class LegalUI
    Inherits System.Web.UI.Page
    Public SecondaryAction As Boolean = False
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            
            SecondaryAction = Request.QueryString("SecondaryAction") IsNot Nothing

        End If
    End Sub

End Class
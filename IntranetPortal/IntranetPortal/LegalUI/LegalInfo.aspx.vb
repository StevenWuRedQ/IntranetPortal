Public Class LegalInfo
    Inherits System.Web.UI.Page
    Public Property logid As Integer = 0
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("logid")) Then
                logid = Request.QueryString("logid")
            End If
        End If
    End Sub

End Class
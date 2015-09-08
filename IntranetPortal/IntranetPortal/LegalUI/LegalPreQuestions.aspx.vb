Public Class LegalPreQuestions
    Inherits System.Web.UI.Page
    Public Property BBLE As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("bble").ToString) Then
            BBLE = Request.QueryString("bble").ToString
        End If

    End Sub

End Class
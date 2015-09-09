Public Class LegalPreQuestions
    Inherits System.Web.UI.Page
    Public Property BBLE As String = ""
    Public Property IsReview As Boolean = False


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
            BBLE = Request.QueryString("bble").ToString
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("r")) Then
            IsReview = True
        End If

    End Sub

End Class
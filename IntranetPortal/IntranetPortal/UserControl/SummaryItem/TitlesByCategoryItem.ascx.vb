Public Class TitlesByCategoryItem
    Inherits SummaryItemBase

    Public Property CategoryId As Integer

    Public Property Category As String

    Public Property IsTitleStatus As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData()

        If Parameters IsNot Nothing Then
            CategoryId = CInt(Parameters("CategoryId"))
            Category = TitleManage.TitleCategories(CategoryId)

            If Parameters.ContainsKey("IsTitleStatus") Then
                IsTitleStatus = True
                Category = CType(CategoryId, IntranetPortal.Data.TitleCase.DataStatus).ToString
            End If
        End If

    End Sub

End Class
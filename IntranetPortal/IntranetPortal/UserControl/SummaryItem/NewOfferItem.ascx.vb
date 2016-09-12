Public Class NewOfferItem
    Inherits SummaryItemBase

    Public Property ManagerView As PropertyOfferManage.ManagerView

    Public Property ViewName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData()
        If Parameters IsNot Nothing Then
            ManagerView = CType(Parameters("mgrView"), PropertyOfferManage.ManagerView)
        End If

    End Sub

End Class
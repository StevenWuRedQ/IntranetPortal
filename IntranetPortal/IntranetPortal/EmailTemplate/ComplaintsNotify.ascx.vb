Public Class ComplaintsNotify1
    Inherits System.Web.UI.UserControl

    Public Property UserName As String
    Public Property Complaints As New List(Of Data.CheckingComplain)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub BindData(name As String)

        UserName = name
        Complaints = Data.CheckingComplain.GetAllComplains("", If(ComplaintsManage.IsComplaintsManager(UserName), "", UserName))

    End Sub

End Class
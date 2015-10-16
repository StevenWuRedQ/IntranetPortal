Public Class ComplaintsNotify1
    Inherits System.Web.UI.UserControl

    Public Property UserName As String
    Public Property Complaints As New List(Of Data.CheckingComplain)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub BindData(name As String)

        UserName = name
        Complaints = Data.CheckingComplain.GetAllComplains("", If(ComplaintsManage.IsComplaintsManager(UserName), "", UserName))
        rptProperties.DataSource = Complaints
        rptProperties.DataBind()
    End Sub

    Protected Sub rptProperties_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim complaints = CType(e.Item.DataItem, Data.CheckingComplain)

            Dim rptComplaints = CType(e.Item.FindControl("rptComplaints"), Repeater)
            rptComplaints.DataSource = complaints.ComplaintsResult.Where(Function(r) r.Status = "ACT").ToArray
            rptComplaints.DataBind()
        End If
    End Sub

    Protected Sub rptComplaints_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)

    End Sub
End Class
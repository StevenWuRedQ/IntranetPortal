Public Class ComplaintsView1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString("bble") IsNot Nothing Then
            BindData(Request.QueryString("bble"))
        End If
    End Sub

    Public Sub BindData(bble As String)

        Dim checking = Data.CheckingComplain.Instance(bble)
        rptComplaints.DataSource = checking.ComplaintsResult
        rptComplaints.DataBind()
    End Sub


End Class
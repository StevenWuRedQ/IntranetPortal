Public Class ViewHomeOwner
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnLoad_Click(sender As Object, e As EventArgs)
        Dim bble = txtBBLE.Text
        cbOwners.DataSource = HomeOwner.GetHomeOwenrs(bble).ToArray
        cbOwners.TextField = "Name"
        cbOwners.ValueField = "OwnerID"
        cbOwners.DataBind()
    End Sub

    Protected Sub btnView_Click(sender As Object, e As EventArgs)
        Dim ownerId = CInt(cbOwners.Value)
        txtOwnerData.Text = HomeOwner.LoadOwner(ownerId).TLOLocateReport.ToJsonString
    End Sub
End Class
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

    Protected Sub btnLoadOwnerInfo_Click(sender As Object, e As EventArgs)
        Dim ownerId = CInt(cbOwners.Value)
        Using ctx As New Entities
            Dim owner = ctx.HomeOwners.Find(ownerId)
            Dim result = DataWCFService.GetLocateReport(New Random().Next(1, 10000), owner.BBLE, owner)
            If result IsNot Nothing Then
                owner.TLOLocateReport = result
                owner.UserModified = False
                owner.LastUpdate = DateTime.Now
            End If

            ctx.SaveChanges()

            txtOwnerData.Text = result.ToJsonString
        End Using
    End Sub
End Class
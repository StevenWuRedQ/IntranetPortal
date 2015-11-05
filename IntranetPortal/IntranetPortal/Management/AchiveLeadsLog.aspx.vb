Public Class AchiveLeadsLog
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btArchive_Click(sender As Object, e As EventArgs)
        For Each b In txtBBLEs.Text.Split(",")
            Lead.ArchivedLogs(b)
            Status.InnerText = "Archive finsihed!"
        Next
    End Sub
End Class
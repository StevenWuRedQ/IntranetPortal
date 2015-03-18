Public Class _Default1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Using ctx As New Entities
            Dim result = ctx.HomeOwners.Where(Function(h) h.LocateReport IsNot Nothing AndAlso h.ReportToken IsNot Nothing).Take(500).ToList
            gridHomeOwner.DataSource = result.Where(Function(h) h.PhoneCount > 7).Take(30).ToList
            gridHomeOwner.DataBind()
        End Using
    End Sub

    Protected Sub gridExport_RenderBrick(sender As Object, e As DevExpress.Web.ASPxGridView.Export.ASPxGridViewExportRenderingEventArgs)

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)
        gridExport.WriteXlsxToResponse()
    End Sub
End Class
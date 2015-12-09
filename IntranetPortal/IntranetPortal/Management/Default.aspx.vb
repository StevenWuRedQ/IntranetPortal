Public Class _Default1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Using ctx As New Entities
            Dim result = ctx.HomeOwners.Where(Function(h) h.LocateReport IsNot Nothing AndAlso h.ReportToken IsNot Nothing AndAlso h.BBLE.StartsWith(7)).ToList
            gridHomeOwner.DataSource = result.ToList
            gridHomeOwner.DataBind()
        End Using
    End Sub

    Protected Sub gridExport_RenderBrick(sender As Object, e As DevExpress.Web.ASPxGridViewExportRenderingEventArgs)

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)
        gridExport.WriteXlsxToResponse()
    End Sub
End Class
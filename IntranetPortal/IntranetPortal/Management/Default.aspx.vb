Public Class _Default1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub gridExport_RenderBrick(sender As Object, e As DevExpress.Web.ASPxGridViewExportRenderingEventArgs)

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)
        loadData()
        gridExport.WriteXlsxToResponse()
    End Sub

    Protected Sub btnLoadData_Click(sender As Object, e As EventArgs)
        loadData()
    End Sub

    Private Sub loadData()
        Dim BBLEs = txtbbles.Text

        Dim BBLEArr = BBLEs.Split(";")
        Using ctx As New Entities
            Dim result = ctx.HomeOwners.Where(Function(h) h.ReportToken IsNot Nothing AndAlso BBLEArr.Contains(h.BBLE)).ToList
            gridHomeOwner.DataSource = result.ToList
            gridHomeOwner.DataBind()
        End Using
    End Sub
End Class
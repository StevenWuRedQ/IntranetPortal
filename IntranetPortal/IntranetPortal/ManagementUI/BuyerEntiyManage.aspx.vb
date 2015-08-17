Imports IntranetPortal.Data

Public Class BuyerEntiyManage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindEntity()
    End Sub

    Protected Sub entityGrid_DataBinding(sender As Object, e As EventArgs)
        BindEntity()
    End Sub
    Sub BindEntity()
        If (entitiesGrid.DataSource Is Nothing) Then
            entitiesGrid.DataSource = CorporationEntity.GetAllEntities().OrderBy(Function(c) c.CorpName)
            entitiesGrid.DataBind()
        End If
    End Sub

    Protected Sub lbExportExcel_Click(sender As Object, e As EventArgs)
        CaseExporter.WriteXlsToResponse()
    End Sub
End Class
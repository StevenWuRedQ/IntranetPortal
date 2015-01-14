Imports DevExpress.Web.ASPxGridView

Public Class ProcessReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindData()
    End Sub

    Sub BindData()
        gridProcInst.DataSource = MyIdealProp.Workflow.DBPersistence.ProcessInstance.GetAllProcessInstances()
        gridProcInst.DataBind()

        gridProcInst.GroupBy(gridProcInst.Columns("ProcessName"))
    End Sub

    Protected Sub gridProcInst_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)
        If e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Detail Then
            Dim gridActInst = CType(gridProcInst.FindDetailRowTemplateControl(e.VisibleIndex, "gridActInst"), ASPxGridView)
            gridActInst.DataSource = MyIdealProp.Workflow.DBPersistence.ActivityInstance.GetProcessActivityInstances(e.KeyValue)
            gridActInst.DataBind()
        End If
    End Sub
End Class
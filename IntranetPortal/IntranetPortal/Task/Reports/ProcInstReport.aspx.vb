Imports DevExpress.Web

Public Class ProcInstReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gridProcInst.DataBind()
        End If
    End Sub

    Sub BindData()
        If String.IsNullOrEmpty(Request.QueryString("p")) Then
            gridProcInst.DataSource = MyIdealProp.Workflow.DBPersistence.ProcessInstance.GetAllProcessInstances()
            gridProcInst.GroupBy(gridProcInst.Columns("ProcessName"))
        Else
            Dim procName = Request.QueryString("p").ToString
            lblProcName.Text = "Process Name: " & procName

            gridProcInst.DataSource = MyIdealProp.Workflow.DBPersistence.ProcessInstance.GetAllProcessInstances.Where(Function(a) a.ProcessSchemeDisplayName = procName).ToList
            gridProcInst.Columns("ProcessName").Visible = False
        End If
    End Sub

    Protected Sub gridProcInst_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridViewTableRowEventArgs)
        If e.RowType = DevExpress.Web.GridViewRowType.Detail Then
            Dim gridActInst = CType(gridProcInst.FindDetailRowTemplateControl(e.VisibleIndex, "gridActInst"), ASPxGridView)
            gridActInst.DataSource = MyIdealProp.Workflow.DBPersistence.ActivityInstance.GetProcessActivityInstances(e.KeyValue)
            gridActInst.DataBind()
        End If
    End Sub

    Protected Sub gridProcInst_DataBinding(sender As Object, e As EventArgs)
        If gridProcInst.DataSource Is Nothing Then
            BindData()
        End If
    End Sub
End Class
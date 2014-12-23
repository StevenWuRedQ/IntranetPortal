Imports MyIdealProp.Workflow.Client

Public Class TasklistControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindTask()
    End Sub

    Public Sub BindTask()
        gridTasks.DataSource = WorkflowService.GetMyWorklist()
        gridTasks.DataBind()

        If Not Page.IsPostBack Then
            gridTasks.GroupBy(gridTasks.Columns("ProcessName"))
        End If
    End Sub
End Class
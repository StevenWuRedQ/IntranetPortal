Public Class TaskItem
    Inherits SummaryItemBase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gridTask.GroupBy(gridTask.Columns("ProcSchemeDisplayName"))
        End If
    End Sub

    Public Overrides Sub BindData()
        MyBase.BindData()
        gridTask.DataBind()
    End Sub

    Protected Sub gridTask_DataBinding(sender As Object, e As EventArgs)
        If gridTask.DataSource Is Nothing Then
            gridTask.DataSource = WorkflowService.GetMyWorklist()
        End If
    End Sub

End Class
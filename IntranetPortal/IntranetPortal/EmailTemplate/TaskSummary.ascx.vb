Public Class TaskSummary
    Inherits System.Web.UI.UserControl

    Public Property DestinationUser As String
    Public Property TaskCount As Integer
    Protected Property Worklist As List(Of MyIdealProp.Workflow.Client.WorklistItem)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindData()
    End Sub

    Sub BindData()
        Dim wls = WorkflowService.GetUserWorklist(DestinationUser)
        TaskCount = wls.Count
        Dim procList = (From proc In wls
                       Group proc By proc.ProcSchemeDisplayName Into Data = Group).ToList
        'Worklist(0).ProcessInstance.
        rptWorklist.DataSource = procList
        rptWorklist.DataBind()
    End Sub

    Protected Sub rptWorklist_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim rptItems = CType(e.Item.FindControl("rptWorklistItem"), Repeater)

            rptItems.DataSource = DataBinder.Eval(e.Item.DataItem, "Data")
            rptItems.DataBind()
        End If
    End Sub

    Private Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        'BindData()
    End Sub

End Class
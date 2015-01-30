Imports MyIdealProp.Workflow.Client

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
            Dim wls = CType(DataBinder.Eval(e.Item.DataItem, "Data"), WorklistItem())

            Dim tasks As New List(Of TaskItem)
            For Each wl In wls
                Dim item As New TaskItem With
                    {
                           .DisplayName = wl.DisplayName,
                           .ItemData = wl.ItemData,
                           .Originator = wl.Originator,
                           .StartDate = wl.StartDate
                        }
                Try
                    Dim pInst = WorkflowService.LoadProcInstById(wl.ProcInstId)
                    If pInst.ProcessName = "TaskProcess" Then
                        Dim t = UserTask.GetTaskById(CInt(pInst.GetDataFieldValue("TaskId")))
                        item.Description = t.Description
                        If t.Important = "Urgent" Then
                            item.ShowPortalMsg = True
                            item.PortalMsg = "This is urgent task. Please complete it in 2 hours."
                        End If
                    End If
                Catch ex As Exception
                    item.Description = "Error"
                End Try

                tasks.Add(item)
            Next

            rptItems.DataSource = tasks
            rptItems.DataBind()
        End If
    End Sub

    Private Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        'BindData()
    End Sub

    Public Class TaskItem
        Public Property DisplayName As String
        Public Property ItemData As String
        Public Property Originator As String
        Public Property StartDate As DateTime
        Public Property Description As String
        Public Property PortalMsg As String
        Public Property ShowPortalMsg As Boolean
    End Class

End Class
Imports MyIdealProp.Workflow.Client

Public Class TaskSummary
    Inherits System.Web.UI.UserControl

    Public Property DestinationUser As String
    Public Property TaskCount As Integer
    Public Property followUpCount As Integer = 0
    Public Property hotCount As Integer = 0
    Public Property loanModCount As Integer = 0
    Public Property IsFinder As Boolean
    Protected Property Worklist As List(Of MyIdealProp.Workflow.Client.WorklistItem)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        DestinationUser = Page.User.Identity.Name

        If Page.Request.QueryString("dest") IsNot Nothing Then
            DestinationUser = Request.QueryString("dest").ToString
        End If

        BindData()
    End Sub

    Sub BindData()
        Dim wls = WorkflowService.GetUserWorklist(DestinationUser)
        TaskCount = wls.Count
        Dim procList = (From proc In wls
                        Group proc By proc.ProcSchemeDisplayName Into Data = Group
                        Select New With {
                           .ProcSchemeDisplayName = ProcSchemeDisplayName,
                           .Data = Data,
                           .Count = Data.Count
                           }).ToList
        'Worklist(0).ProcessInstance.
        rptWorklist.DataSource = procList
        rptWorklist.DataBind()

        'bind appointments
        rptAppointments.DataSource = UserAppointment.GetMyTodayAppointments(DestinationUser)
        rptAppointments.DataBind()

        'bind followup
        Dim followUps = Lead.GetUserTodayFollowUps(DestinationUser)
        followUpCount = followUps.Count
        If followUpCount = 0 Then
            rptFollowUp.Visible = False
            lblNoFollowUp.Visible = True
        Else
            rptFollowUp.DataSource = followUps.Take(10).ToList
            rptFollowUp.DataBind()
        End If

        bindHot()
        bindLoanMod()
        BindRecycleLeads()

        Me.DataBind()
    End Sub

    Public Sub bindHot()
        Dim hots = Lead.GetHotLeadsDue(DestinationUser)
        hotCount = hots.Count
        HotLeadsReapter.DataSource = hots
        HotLeadsReapter.DataBind()
    End Sub

    Public Sub BindRecycleLeads()
        Dim emps = Team.GetActiveTeamFinders()
        If emps.Contains(DestinationUser) Then
            IsFinder = True
            Dim status = {LeadStatus.NewLead, LeadStatus.Priority, LeadStatus.Warm}
            rptRecycled.DataSource = status
            rptRecycled.DataBind()
        Else
            IsFinder = False
        End If
    End Sub

    Public Sub bindLoanMod()
        Dim loanMods = Lead.GetLoanModDue(DestinationUser)
        loanModCount = loanMods.Count
        LoanModReapter.DataSource = loanMods
        LoanModReapter.DataBind()
    End Sub


    Protected Sub rptWorklist_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim rptItems = CType(e.Item.FindControl("rptWorklistItem"), Repeater)
            Dim wls = CType(DataBinder.Eval(e.Item.DataItem, "Data"), WorklistItem())

            Dim tasks As New List(Of TaskItem)
            For Each wl In wls.Take(5)
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
                        Dim taskId = CInt(pInst.GetDataFieldValue("TaskId"))
                        Dim t = UserTask.GetTaskById(CInt(pInst.GetDataFieldValue("TaskId")))
                        If t IsNot Nothing Then
                            item.Description = t.Description
                            If t.Important = "Urgent" Then
                                item.ShowPortalMsg = True
                                item.PortalMsg = "This is urgent task. Please complete it in 2 hours."
                            End If
                        Else
                            item.Description = ""
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

    Protected Sub rptAppointments_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Footer Then
            If rptAppointments IsNot Nothing AndAlso rptAppointments.Items.Count < 1 Then
                Dim lbl = e.Item.FindControl("lblErrorMsg")

                If lbl IsNot Nothing Then
                    lbl.Visible = True
                End If
            End If
        End If
    End Sub

    Protected Sub rptFollowUp_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Footer Then

        End If
    End Sub

    Protected Sub rptRecycled_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim status = CType(e.Item.DataItem, LeadStatus)
            Dim spanTitle = CType(e.Item.FindControl("spanTitle"), HtmlGenericControl)
            spanTitle.InnerText = status.ToString
            Dim spanAmount = CType(e.Item.FindControl("spanAmount"), HtmlGenericControl)
            Dim lds = Lead.GetRecycledLeads(DestinationUser, status)
            spanAmount.InnerText = String.Format("({0})", lds.Count)
            Dim rptItems = CType(e.Item.FindControl("rptLeadsRecycled"), Repeater)
            rptItems.DataSource = lds
            rptItems.DataBind()
        End If
    End Sub
End Class
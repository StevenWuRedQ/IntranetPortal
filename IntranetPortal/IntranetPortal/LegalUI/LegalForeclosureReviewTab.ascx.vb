Public Class LegalForeclosureReviewTab
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Public SecondaryAction As Boolean = False
    Public Agent As Boolean = False
    Sub Page_init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        SecondaryAction = Request.QueryString("Attorney") IsNot Nothing
        Agent = Request.QueryString("Agent") IsNot Nothing
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then

            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            Select Case wli.ActivityName
                Case "LegalResearch"
                    btnCompleteResearch.Visible = True
                Case "ManagerAssign"
                    lbEmployee.Visible = True
                    btnAssign.Visible = True
            End Select
        End If
    End Sub

    Protected Sub btnAssign_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
            wli.ProcessInstance.DataFields("Attorney") = lbEmployee.Value
            wli.Finish()

            'update legal case status
            Dim lc = Legal.LegalCase.GetCase(bble)
            lc.Status = Legal.LegalCaseStatus.AttorneyHandle
            lc.SaveData()

            Response.Clear()
            Response.Write("The case is move to " & lbEmployee.Value)
            Response.End()
        End If
    End Sub
    Protected Sub btnCompleteResearch_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
            wli.Finish()

            'update legal case status
            Dim lc = Legal.LegalCase.GetCase(bble)
            lc.Status = Legal.LegalCaseStatus.ManagerAssign
            lc.SaveData()

            Response.Clear()
            Response.Write("The case is move back to manager.")
            Response.End()
        End If
    End Sub
End Class
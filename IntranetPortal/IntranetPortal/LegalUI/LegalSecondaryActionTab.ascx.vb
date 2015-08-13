Public Class LegalSecondaryActionTab
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Sub btnComplete_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
            wli.Finish()

            'update legal case status
            Dim lc = IntranetPortal.Data.LegalCase.GetCase(bble)
            lc.Status = IntranetPortal.Data.LegalCaseStatus.Closed
            lc.SaveData(Page.User.Identity.Name)

            Response.Clear()
            Response.Write("The case is finished.")
            Response.End()
        End If
    End Sub

End Class
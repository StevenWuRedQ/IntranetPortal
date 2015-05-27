Public Class LegalCaseManage

    Public Shared Sub StartLegalRequest(bble As String, caseData As String, createBy As String)
        Dim ld = Lead.GetInstance(bble)

        Dim lc As New Legal.LegalCase
        lc.BBLE = bble
        lc.CaseName = ld.LeadsName
        lc.CaseData = caseData
        lc.Status = Legal.LegalCaseStatus.ManagerPreview
        lc.CreateBy = createBy
        lc.SaveData()

        WorkflowService.StartLegalRequest(ld.LeadsName, bble, String.Join(";", Roles.GetUsersInRole("Legal-Manager")))

    End Sub

End Class

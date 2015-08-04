Imports Newtonsoft.Json.Linq

Public Class LegalCaseManage

    Public Shared Sub StartLegalRequest(bble As String, caseData As String, createBy As String)
        Dim ld = Lead.GetInstance(bble)

        Dim lc As New Legal.LegalCase
        lc.BBLE = bble
        lc.CaseName = ld.LeadsName
        'lc.CaseData = caseData

        Dim data = JObject.Parse(caseData)
        Dim propInfo As JObject = data("PropertyInfo")
        'propInfo.Add("Address", li.PropertyAddress)
        'propInfo.Add("Block", li.Block)
        'propInfo.Add("Lot", li.Lot)

        data("PropertyInfo") = JObject.Parse(LeadsInfo.GetData(bble).ToJsonString)
        data.Add("CreateDate", DateTime.Now)
        data.Add("CreateBy", createBy)
        data.Add("UpdateDate", DateTime.Now)
        data.Add("UpdateBy", createBy)
        data.Add("CaseName", lc.CaseName)
        'data.PropertyInfo.Lot = li.Lot
        lc.CaseData = data.ToString
        lc.Status = Legal.LegalCaseStatus.ManagerPreview
        lc.CreateBy = createBy
        lc.SaveData()

        WorkflowService.StartLegalRequest(ld.LeadsName, bble, String.Join(";", Roles.GetUsersInRole("Legal-Manager")))
    End Sub

    Public Shared Sub AssignToResearch(sn As String, bble As String, searchUser As String, assignBy As String)
        Dim wli = Nothing

        If String.IsNullOrEmpty(sn) Then
            wli = WorkflowService.GetLegalWorklistItem(sn, bble, Legal.LegalCaseStatus.ManagerPreview, assignBy)
        Else
            wli = WorkflowService.LoadTaskProcess(sn)
            bble = wli.ProcessInstance.DataFields("BBLE").ToString
        End If

        If wli IsNot Nothing Then
            wli.ProcessInstance.DataFields("ResearchUser") = searchUser
            wli.Finish()
        End If

        Dim lc = Legal.LegalCase.GetCase(bble)
        lc.Status = Legal.LegalCaseStatus.LegalResearch
        lc.ResearchBy = searchUser
        lc.SaveData()
    End Sub

    Public Shared Sub AssignToAttorney(sn As String, bble As String, attorney As String, assignBy As String)
        Dim wli = Nothing

        If String.IsNullOrEmpty(sn) Then
            wli = WorkflowService.GetLegalWorklistItem(sn, bble, Legal.LegalCaseStatus.ManagerAssign, assignBy)
        Else
            wli = WorkflowService.LoadTaskProcess(sn)
            bble = wli.ProcessInstance.DataFields("BBLE").ToString
        End If

        If wli IsNot Nothing Then
            wli.ProcessInstance.DataFields("Attorney") = attorney
            wli.Finish()
        End If

        Dim lc = Legal.LegalCase.GetCase(bble)
        lc.Status = Legal.LegalCaseStatus.AttorneyHandle
        lc.Attorney = attorney
        lc.SaveData()
    End Sub

    Public Shared Sub NotifyLegalWhenClosedinSS(bble As String)
        Dim lCase = Legal.LegalCase.GetCase(bble)

        Dim NotifyUpdate = Sub()
                               Try
                                   Dim users = Roles.GetUsersInRole("Legal-Manager")

                                   Dim notifyEmails = String.Join(";", users.Select(Function(name)
                                                                                        Return Employee.GetInstance(name).Email
                                                                                    End Function).ToArray)

                                   Dim maildata As New Dictionary(Of String, String)
                                   maildata.Add("CaseName", lCase.CaseName)
                                   maildata.Add("BBLE", bble)

                                   Core.EmailService.SendShortSaleMail(notifyEmails, "", "SSClosedNotifyforLegal", maildata)
                               Catch ex As Exception
                                   Core.SystemLog.LogError("Notify legal when ShortSale case is closed", ex, "", "Portal", bble)
                               End Try
                           End Sub
    End Sub
End Class

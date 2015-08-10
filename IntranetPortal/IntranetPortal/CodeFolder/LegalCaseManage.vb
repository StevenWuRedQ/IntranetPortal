Imports Newtonsoft.Json.Linq
Imports Legal = IntranetPortal.Data
Imports IntranetPortal.Data

Public Class LegalCaseManage
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Legal-Manager"

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
            wli.ProcessInstance.DataFields("Result") = "Complete"
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

    Public Shared Sub SetFollowUpDate(bble As String, type As String, dateSelected As DateTime)
        Dim lCase = Legal.LegalCase.GetCase(bble)
        lCase.FollowUp = dateSelected
        lCase.UpdateDate = DateTime.Now
        lCase.UpdateBy = HttpContext.Current.User.Identity.Name
        lCase.SaveData()

        LeadsActivityLog.AddActivityLog(DateTime.Now, "New Legal follow up date: " & dateSelected.ToString("d"), bble, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.EnumActionType.FollowUp)
    End Sub

    Public Shared Sub ClearFollowUp(bble As String)
        Dim lCase = Legal.LegalCase.GetCase(bble)
        lCase.FollowUp = Nothing
        lCase.UpdateDate = DateTime.Now
        lCase.UpdateBy = HttpContext.Current.User.Identity.Name
        lCase.SaveData()

        LeadsActivityLog.AddActivityLog(DateTime.Now, "Legal follow up date was Cleared", bble, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.EnumActionType.FollowUp)
    End Sub

    Public Shared Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") Then
            Return True
        End If

        Return False
    End Function

#Region "Share data from other project"

    Public Shared Function GetPropertyAddress(bble As String)
        Dim l = Lead.GetInstance(bble)
        If (l IsNot Nothing) Then
            Return l.LeadsInfo.PropertyAddress
        End If
        Return Nothing
    End Function

    Public Shared Function GetSaleDate(bble As String) As DateTime?
        Dim c = ShortSaleCase.GetCaseByBBLE(bble)
        If (c IsNot Nothing) Then
            Return c.SaleDate
        End If
        Return Nothing
    End Function

#End Region

    Public Function GetAmount(menu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount

        Select Case menu.Name
            Case "Legal-FollowUps"
                Return LegalCase.GetFollowUpCases.Count
            Case "Legal-LawReferences"
                Return LawReference.GetAllReference().Count
        End Select

        Return 0
    End Function

End Class

Imports Newtonsoft.Json.Linq
Imports Legal = IntranetPortal.Data
Imports IntranetPortal.Data

Public Class LegalCaseManage
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Legal-Manager"
    Public Const LogTitleOpen As String = "LegalOpen"
    Public Const LogTitleSave As String = "LegalSave"
    Private Const FollowupEmailTemplate As String = "LegalFollowUpNotify"



    Public Shared Function IsInLegal(bble As String) As Boolean

        Return LegalCase.InLegal(bble)

    End Function

    Public Shared Function GetCaseData(bble As String, userName As String) As String
        Dim lcase = Legal.LegalCase.GetCase(bble)
        If lcase IsNot Nothing Then
            Core.SystemLog.Log(LogTitleOpen, lcase.CaseData, Core.SystemLog.LogCategory.Operation, lcase.BBLE, userName)
            Return lcase.CaseData
        End If
        Return "{}"
    End Function

    Public Shared Function GetLegalCaseList(userName As String, status As Legal.LegalCaseStatus) As List(Of LegalCase)
        If Roles.IsUserInRole(userName, "Legal-Manager") OrElse Roles.IsUserInRole(userName, "Admin") OrElse LegalCaseManage.IsViewable(userName) Then
            Return LegalCase.GetCaseList(status)
        Else
            Return LegalCase.GetCaseList(status, userName)
        End If
    End Function

    Public Shared Function GetLegalLightCaseList(userName As String, status As Legal.LegalCaseStatus) As List(Of LegalCase)
        If Roles.IsUserInRole(userName, "Legal-Manager") OrElse Roles.IsUserInRole(userName, "Admin") OrElse LegalCaseManage.IsViewable(userName) Then
            Return LegalCase.GetLightCaseList(status)
        Else
            Return LegalCase.GetLightCaseList(status, userName)
        End If
    End Function

    Public Shared Sub StartLegalRequest(bble As String, caseData As String, createBy As String)

        If Not Legal.LegalCase.InLegal(bble) Then
            Dim ld = Lead.GetInstance(bble)

            Dim lc As New Legal.LegalCase
            lc.BBLE = bble
            lc.CaseName = ld.LeadsName
            'lc.CaseData = caseData

            Dim data = JObject.Parse(caseData)
            Dim propInfo As JObject = data("PropertyInfo")

            data("PropertyInfo") = JObject.Parse(LeadsInfo.GetData(bble).ToJsonString)
            data("CreateDate") = DateTime.Now
            data("CreateBy") = createBy
            data("UpdateDate") = DateTime.Now
            data("UpdateBy") = createBy
            data("CaseName") = lc.CaseName
            'data.PropertyInfo.Lot = li.Lot
            lc.CaseData = data.ToString
            lc.Status = Legal.LegalCaseStatus.ManagerPreview
            lc.CreateBy = createBy
            lc.SaveData(createBy)

            WorkflowService.StartLegalRequest(ld.LeadsName, bble, String.Join(";", Roles.GetUsersInRole("Legal-Manager")))
        Else
            Dim data = JObject.Parse(caseData)
            Dim questionData = data.Item("PreQuestions")
            If questionData IsNot Nothing Then
                Dim lcase = LegalCase.GetCase(bble)
                Dim lcaseData = JObject.Parse(lcase.CaseData)
                If lcaseData IsNot Nothing Then
                    lcaseData.Item("PreQuestions") = questionData
                    lcase.CaseData = lcaseData.ToString
                    lcase.SaveData(createBy)
                End If
            End If
        End If
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
        lc.SaveData(assignBy)
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
        lc.SaveData(assignBy)
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

        Threading.ThreadPool.QueueUserWorkItem(NotifyUpdate)
    End Sub

    Public Shared Sub SetFollowUpDate(bble As String, type As String, dateSelected As DateTime)
        Dim lCase = Legal.LegalCase.GetCase(bble)
        lCase.FollowUp = dateSelected
        lCase.UpdateDate = DateTime.Now
        lCase.UpdateBy = HttpContext.Current.User.Identity.Name
        lCase.SaveData(lCase.UpdateBy)

        LeadsActivityLog.AddActivityLog(DateTime.Now, "New Legal follow up date: " & dateSelected.ToString("d"), bble, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.EnumActionType.FollowUp)
    End Sub

    Public Shared Sub ClearFollowUp(bble As String)
        Dim lCase = Legal.LegalCase.GetCase(bble)
        lCase.FollowUp = Nothing
        lCase.UpdateDate = DateTime.Now
        lCase.UpdateBy = HttpContext.Current.User.Identity.Name
        lCase.SaveData(HttpContext.Current.User.Identity.Name)

        LeadsActivityLog.AddActivityLog(DateTime.Now, "Legal follow up date was Cleared", bble, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.EnumActionType.FollowUp)
    End Sub

    Public Shared Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") Then
            Return True
        End If

        Return False
    End Function
    Public Shared Function GetLegalManger() As Employee
        Using ctx As New Entities
            Dim LegalManger = ctx.UsersInRoles.Where(Function(u) u.Rolename = MgrRoleName).FirstOrDefault
            If (LegalManger IsNot Nothing AndAlso (Not String.IsNullOrEmpty(LegalManger.Username))) Then
                Return Employee.GetInstance(LegalManger.Username)
            End If
        End Using
        Return Nothing
    End Function
    Public Shared Function IsViewable(userName As String) As Boolean

        Dim roleNames = Core.PortalSettings.GetValue("LegalViewableRoles").Split(";")
        Dim rols = ""
        Dim b = Roles.GetRolesForUser(userName).Select(Function(r) r.Contains(rols)) IsNot Nothing

        Dim myRoles = Roles.GetRolesForUser(userName)

        If myRoles.Any(Function(r) roleNames.Contains(r)) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Sub ReminderFollowUp(lCase As Legal.LegalCase)

        Try
            Dim users = Roles.GetUsersInRole("Legal-Manager").ToList

            If Not String.IsNullOrEmpty(lCase.ResearchBy) Then
                users.Add(lCase.ResearchBy)
            End If

            If Not String.IsNullOrEmpty(lCase.Attorney) Then
                users.Add(lCase.Attorney)
            End If

            Dim notifyEmails = String.Join(";", users.Distinct.Select(Function(name)
                                                                          Return Employee.GetInstance(name).Email
                                                                      End Function).ToArray)

            Dim emailData As New Dictionary(Of String, String)
            emailData.Add("CaseName", lCase.CaseName)
            emailData.Add("BBLE", lCase.BBLE)

            Core.EmailService.SendMail(notifyEmails, "", FollowupEmailTemplate, emailData)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Shared Function LegalUsers() As String()
        Dim ssRoles = Roles.GetAllRoles().Where(Function(r) r.StartsWith("Legal-")).ToList
        Dim ssUsers As New List(Of String)

        For Each rl In ssRoles
            ssUsers.AddRange(Roles.GetUsersInRole(rl))
        Next

        Return ssUsers.Distinct.ToArray
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

Imports IntranetPortal.Data
Imports ShortSale = IntranetPortal.Data
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json

''' <summary>
''' To handle the short sale managment function
''' </summary>
Public Class ShortSaleManage

    Public Const SSLogTitleSave As String = "ShortSaleSave"

    Public Shared ReadOnly Property OpenCaseLogTitle
        Get
            Return "OpenSSCaseLog"
        End Get
    End Property

    ''' <summary>
    ''' Return a boolean value indicating if the employee is short sale manager or short sale team manager
    ''' </summary>
    ''' <param name="userName">Employee name</param>
    ''' <returns></returns>
    Public Shared Function IsShortSaleManager(userName As String) As Boolean
        Return Roles.IsUserInRole(userName, "ShortSale-Manager") OrElse Roles.IsUserInRole(userName, "ShortSale-TeamManager")
    End Function

    ''' <summary>
    ''' Return if user can view this shortsale case
    ''' </summary>
    ''' <param name="bble">ShortSale case bble</param>
    ''' <param name="userName">User Name</param>
    ''' <returns></returns>
    Public Shared Function IsViewable(bble As String, userName As String) As Boolean
        Dim _viewable = False
        Dim userRoles = Roles.GetRolesForUser(userName)
        Dim viewableRoles = Core.PortalSettings.GetValue("ShortSaleViewableRoles").Split(";")

        If userRoles.Any(Function(a) viewableRoles.Any(Function(r) a.StartsWith(r.Replace("*", "")))) Then
            _viewable = True
        End If

        Return _viewable
    End Function

    Public Shared Function IsInShortSale(bble As String) As Boolean
        Return ShortSaleCase.IsExist(bble)
    End Function

    Public Shared Function IsOriginalCase(changedCase As ShortSaleCase) As Boolean
        Dim oCase = ShortSaleCase.GetCase(changedCase.CaseId)

        If oCase.UpdateDate.HasValue AndAlso changedCase.UpdateDate.HasValue Then
            Return oCase.UpdateDate = changedCase.UpdateDate
        End If

        Return True
    End Function

    Public Shared Function SaveCase(caseData As String, saveBy As String) As ShortSaleCase
        Dim res = JsonConvert.DeserializeObject(Of ShortSaleCase)(caseData)

        'If Not IsOriginalCase(res) Then
        '    Throw New Exception("Case Data was changed. Please load the latest data and try again.")
        'End If

        Try
            res.Save(HttpContext.Current.User.Identity.Name)
            Core.SystemLog.Log(SSLogTitleSave, caseData, Core.SystemLog.LogCategory.SaveData, res.BBLE, HttpContext.Current.User.Identity.Name)

            Return ShortSaleCase.GetCase(res.CaseId)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function GetSSMissedFollowUp(userName As String, missedDate As DateTime) As List(Of ShortSaleCase)
        Return ShortSaleCase.MissedFollowUpReport(userName, missedDate)
    End Function

    Public Shared Function GetSSOpenCaseLogs(startDate As DateTime, endDate As DateTime) As List(Of Core.SystemLog)
        Return Core.SystemLog.GetLogs(OpenCaseLogTitle, startDate, endDate)
    End Function

    Public Shared Function GetSSSaveCaseLogs(startDate As DateTime, endDate As DateTime) As List(Of Core.SystemLog)
        Return Core.SystemLog.GetLogs(SSLogTitleSave, startDate, endDate)
    End Function

    Public Shared Function GetDocumentRequestDetail(bble As String) As String
        Dim tasks = UserTask.GetDocumentRequestTask(bble)
        If tasks.Count > 0 Then
            Return tasks(0).Description
        End If

        Return ""
    End Function

    ''' <summary>
    ''' Add log to short sale activity 
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="userName">Employee Name</param>
    ''' <param name="typeOfUpdate">Update type</param>
    ''' <param name="category">Category</param>
    ''' <param name="statusOfUpdate">Status</param>
    ''' <param name="comments">Additional Comments</param>
    Public Shared Sub AddActivityLog(bble As String, userName As String, typeOfUpdate As String, category As String, statusOfUpdate As String, comments As String)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        ShortSale.ShortSaleActivityLog.AddLog(bble, userName, typeOfUpdate, category & " - " & statusOfUpdate, comments, ssCase.AppId)

        Dim NotifyUpdate = Sub()
                               Try
                                   Dim notifyEmails = Core.PortalSettings.GetValue("SSUpdateNotifyEmails")

                                   Dim emp = Employee.GetInstance(userName)
                                   If emp IsNot Nothing AndAlso emp.Manager IsNot Nothing AndAlso IsShortSaleManager(emp.Manager) Then
                                       Dim mgr = Employee.GetInstance(emp.Manager)
                                       If mgr IsNot Nothing AndAlso Not String.IsNullOrEmpty(mgr.Email) Then
                                           notifyEmails = mgr.Email
                                       End If
                                   End If

                                   ssCase = ShortSaleCase.GetCaseByBBLE(bble)

                                   Dim maildata As New Dictionary(Of String, String)
                                   maildata.Add("UserName", userName)
                                   maildata.Add("CaseName", ssCase.CaseName)
                                   maildata.Add("Referral", ssCase.ReferralContact.Name)
                                   maildata.Add("Address", ssCase.PropertyInfo.PropertyAddress)
                                   maildata.Add("TypeofUpdate", typeOfUpdate)
                                   maildata.Add("Category", category)
                                   maildata.Add("StatusOfUpdate", statusOfUpdate)
                                   maildata.Add("Comments", comments)
                                   If ssCase.AppId = 1 Then
                                       Core.EmailService.SendShortSaleMail(notifyEmails, "", "SSUpdateNotifyEmail", maildata)
                                   End If
                               Catch ex As Exception
                                   Core.SystemLog.LogError("ShortSaleUpdateNotifyEmail", ex, "", "Portal", bble)
                               End Try
                           End Sub

        If Not IsShortSaleManager(userName) Then
            System.Threading.ThreadPool.QueueUserWorkItem(NotifyUpdate)
        End If
    End Sub

    Public Shared Sub MoveLeadsToShortSale(bble As String, createBy As String, appid As Integer)
        Dim li = LeadsInfo.GetInstance(bble)

        If li Is Nothing Then
            Lead.CreateLeads(bble, LeadStatus.InProcess, createBy)
            li = LeadsInfo.GetInstance(bble)
        End If

        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        If ssCase Is Nothing OrElse ssCase.Status = ShortSale.CaseStatus.NewFile Then

            If li IsNot Nothing Then
                Dim propBase = SaveProp(li, createBy)

                ssCase = New ShortSaleCase(propBase)
                ssCase.BBLE = bble
                ssCase.CaseName = li.LeadsName
                ssCase.Status = ShortSale.CaseStatus.NewFile
                ssCase.AppId = appid
                ssCase.Owner = GetIntaker()
                ssCase = SetReferral(ssCase)
                ssCase.CreateBy = createBy
                ssCase.Save(createBy)

                If IsShortSaleManager(createBy) Then
                    NewCaseApproved(bble, createBy)
                    Dim emp = Employee.GetInstance(createBy)
                    LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("The case was created and assigned to {0}.", ssCase.Owner), bble, LeadsActivityLog.LogCategory.ShortSale.ToString, emp.EmployeeID, createBy, LeadsActivityLog.EnumActionType.UpdateInfo)
                Else
                    NewCaseProcess.ProcessStart(bble, bble, createBy, String.Format("{0} want to move this case to ShortSale. Please approval.", createBy))
                End If

                'NewCaseWithWF(bble, createBy)
            End If
        Else
            Throw New CallbackException("This address alread in system. please check.")
        End If
    End Sub

    Public Shared Function GetShortSaleUsers() As String()
        Dim ssRoles = Roles.GetAllRoles().Where(Function(r) r.StartsWith("ShortSale-"))

        Dim users As New List(Of String)
        For Each r In ssRoles
            users.AddRange(Roles.GetUsersInRole(r))
        Next

        Return users.Distinct.ToArray
    End Function

    Public Shared Sub StartConstruction(bble As String, userName As String)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        ConstructionManage.StartConstruction(bble, ssCase.CaseName, userName)

        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("Start Construction progress."), bble, LeadsActivityLog.LogCategory.PublicUpdate.ToString, LeadsActivityLog.EnumActionType.InProcess)
    End Sub

    Public Shared Sub StartTitle(bble As String, userName As String, Optional titleUser As String = Nothing)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        If ssCase IsNot Nothing Then
            TitleManage.StartTitle(bble, ssCase.CaseName, userName, titleUser)
        Else
            Throw New Exception("Address can't found in ShortSale. BBLE: " & bble)
        End If
    End Sub

    Public Shared Sub NewCaseApproved(bble As String, approvedBy As String)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        ssCase.Status = ShortSale.CaseStatus.Active
        ssCase.Owner = GetIntaker()
        Dim processor = PartyContact.GetContactByName(ssCase.Owner)
        If processor IsNot Nothing Then
            ssCase.Processor = processor.ContactId
        End If

        ssCase.Save()

        If ssCase.CaseId > 0 Then
            Dim mort = ssCase.FirstMortgage
            mort.CaseId = ssCase.CaseId
            mort.Category = "Assign"
            mort.Status = "Intake - New File"
            mort.Save(approvedBy)
        End If

        If approvedBy = "David" Then
            Return
        End If

        'Send user email 
        Try
            Dim intaker = Employee.GetInstance(ssCase.Owner)
            If intaker IsNot Nothing Then
                Dim ref = Employee.GetInstance(ssCase.ReferralContact.Name)
                Dim ccEmail = ""
                If ref IsNot Nothing Then
                    ccEmail = ref.Email
                End If

                Dim maildata As New Dictionary(Of String, String)
                maildata.Add("CaseName", ssCase.CaseName)
                maildata.Add("UserName", intaker.Name)
                maildata.Add("Referral", ref.Name)
                maildata.Add("ItemLink", HttpContext.Current.Request.Url.Authority & "/ShortSale/ShortSale.aspx?CaseId=" & ssCase.CaseId)

                Core.EmailService.SendMail(Employee.GetInstance(ssCase.Owner).Email, ccEmail, "ShortSaleNewCaseNotification", maildata)
            End If
        Catch ex As Exception
            Core.SystemLog.LogError("New SS Case email notification", ex, Nothing, HttpContext.Current.User.Identity.Name, bble)
        End Try
    End Sub

    Public Shared Function UpdateCaseStatus(caseId As Integer, status As ShortSale.CaseStatus, createBy As String, objData As String) As Boolean
        Dim ssCase = ShortSaleCase.GetCase(caseId)

        Select Case status
            Case CaseStatus.FollowUp
                Dim dt As DateTime
                'Dim objData = e.Parameter.Split("|")(2)
                Select Case objData
                    Case "Tomorrow"
                        dt = DateTime.Now.AddDays(1)
                    Case "NextWeek"
                        dt = DateTime.Now.AddDays(7)
                    Case "ThirtyDays"
                        dt = DateTime.Now.AddDays(30)
                    Case "SixtyDays"
                        dt = DateTime.Now.AddDays(60)
                    Case Else
                        If Not DateTime.TryParse(objData, dt) Then
                            dt = DateTime.Now.AddDays(7)
                        End If
                End Select
                ssCase.SaveFollowUp(dt)
                LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} set followup on {1}.", createBy, dt.ToShortDateString), ssCase.BBLE, LeadsActivityLog.LogCategory.ShortSale.ToString, LeadsActivityLog.EnumActionType.UpdateInfo)
                Return True
            Case CaseStatus.Archived
                If Not IsShortSaleManager(createBy) Then
                    Dim comments = String.Format("{0} want to archive this case. Please approval.", createBy)
                    Dim emp = Employee.GetInstance(createBy)
                    ArchivedProcess.ProcessStart(ssCase.BBLE, ssCase.BBLE, createBy, comments, If(emp IsNot Nothing, emp.Manager, Nothing))
                    Return False
                Else
                    ssCase.SaveStatus(status)
                    Return True
                End If
            Case CaseStatus.Closed
                ssCase.SaveStatus(status)
                LegalCaseManage.NotifyLegalWhenClosedinSS(ssCase.BBLE)
                Return True
            Case Else
                ssCase.SaveStatus(status)
                Return True
        End Select
    End Function

    'Public Shared Sub NewCaseApprovalAction(task As UserTask)
    '    Select Case task.Status
    '        Case UserTask.TaskStatus.Approved
    '            NewCaseApproved(task.TaskData)
    '        Case UserTask.TaskStatus.Declined

    '    End Select
    'End Sub

    Public Shared Sub UpdateDate(bble As String, Optional updateBy As String = Nothing)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        ssCase.UpdateDate = DateTime.Now

        If Not String.IsNullOrEmpty(updateBy) Then
            ssCase.UpdateBy = updateBy
        End If

        ssCase.Save()
    End Sub

    Public Shared Sub UpdateReferral()
        Dim ssCases = ShortSaleCase.GetAllCase().Where(Function(ss) ss.Referral Is Nothing).ToList

        For Each ss In ssCases
            If ss.Referral Is Nothing Then
                ss = SetReferral(ss)
                ss.Save()
            End If
        Next
    End Sub

    Public Shared Function UpdateCheckList() As Integer
        Dim ssCases = ShortSaleCase.GetAllCase.Where(Function(ss) Not String.IsNullOrEmpty(ss.ApprovalChecklist)).ToList

        Dim count = 0

        For Each ss In ssCases
            If ss.UpdateCheckList(ss.ApprovalChecklist, "System") Then
                count += count
            End If
        Next

    End Function

    Private Shared Function SetReferral(ssCase As ShortSaleCase)
        Dim ld = Lead.GetInstance(ssCase.BBLE)
        If ld IsNot Nothing Then
            Dim referral = ShortSale.PartyContact.GetContactByName(ld.EmployeeName)
            If referral IsNot Nothing Then
                ssCase.Referral = referral.ContactId
            End If
        End If

        Return ssCase
    End Function

    Public Shared Function GetShortSaleCasesByUsers(users As String()) As List(Of ShortSaleCase)
        Using ctx As New Entities
            Dim bbles = ctx.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso users.Contains(l.EmployeeName)).Select(Function(l) l.BBLE).ToList
            If Utility.IsAny(bbles) Then
                Return ShortSale.ShortSaleCase.GetCaseByBBLEs(bbles).Where(Function(ss) ss.Status <> ShortSale.CaseStatus.NewFile).ToList
            End If
        End Using

        Return New List(Of ShortSaleCase)
    End Function

    Public Shared Function GetEvictionCasesByUsers(users As String()) As List(Of EvictionCas)
        Using ctx As New Entities
            Dim bbles = ctx.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso users.Contains(l.EmployeeName)).Select(Function(l) l.BBLE).ToList

            If Utility.IsAny(bbles) Then
                Return ShortSale.EvictionCas.GetCaseByBBLEs(bbles)
            End If
        End Using

        Return New List(Of EvictionCas)
    End Function

    Public Shared Function SaveProp(li As LeadsInfo, createBy As String) As IntranetPortal.Data.PropertyBaseInfo
        Dim propBase = IntranetPortal.Data.PropertyBaseInfo.GetInstance(li.BBLE)

        If propBase Is Nothing Then
            propBase = New IntranetPortal.Data.PropertyBaseInfo
            propBase.BBLE = li.BBLE
            propBase.Borough = li.Borough
            propBase.Block = li.Block
            propBase.Lot = li.Lot
            propBase.Number = li.Number
            propBase.StreetName = li.StreetName
            propBase.City = li.NeighName
            propBase.State = li.State
            propBase.Zipcode = li.ZipCode
            propBase.TaxClass = li.TaxClass
            propBase.NumOfStories = li.NumFloors
            propBase.CreateDate = DateTime.Now
            propBase.CreateBy = createBy
            propBase.Save()
        End If

        Return propBase
    End Function

    Private Shared Function GetIntaker() As String
        Dim users = Roles.GetUsersInRole("ShortSale-Intake")
        If users.Length > 0 Then
            Return users(0)
        End If

        Return ""
        'Return System.Configuration.ConfigurationManager.AppSettings("ShortSaleIntake").ToString
    End Function

    Public Shared Sub NewCaseWithWF(bble As String, createBy As String)
        Dim comments = String.Format("{0} want to move this case to ShortSale. Please approval.", createBy)
        Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Task.ToString, Nothing, createBy, LeadsActivityLog.EnumActionType.SetAsTask)
        'For testing purpose, need change to ShortSale-Manager
        Dim names = String.Join(",", Roles.GetUsersInRole("TestRole"))
        Dim task = UserTask.AddUserTask(bble, names, "New Case", "Normal", "In Office", DateTime.Now, comments, log.LogID, createBy, UserTask.UserTaskMode.Approval, bble)

        Dim ld = LeadsInfo.GetInstance(bble)
        WorkflowService.StartTaskProcess("ShortSaleTask", "New Case - " & ld.StreetNameWithNo, task.TaskID, bble, names, "Normal")
    End Sub

    Public Shared Sub AssignCaseWithWF(bble As String, userName As String, createBy As String)
        If Not IsShortSaleManager(createBy) Then
            Dim emp = Employee.GetInstance(createBy)
            ReassignProcess.ProcessStart(bble, userName, createBy, String.Format("{0} want to reassign this case to {1}. Please approval.", createBy, userName), If(emp IsNot Nothing, emp.Manager, Nothing))

            'Dim comments = String.Format("{0} want to reassign this case to {1}. Please approval.", createBy, userName)
            'Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Task.ToString, Nothing, createBy, LeadsActivityLog.EnumActionType.SetAsTask)
            ''For testing purpose, need change to ShortSale-Manager
            'Dim names = String.Join(",", Roles.GetUsersInRole("TestRole"))
            'Dim task = UserTask.AddUserTask(bble, names, "Reassign Case Approval", "Normal", "In Office", DateTime.Now, comments, log.LogID, createBy, UserTask.UserTaskMode.Approval, userName)

            'Dim ld = LeadsInfo.GetInstance(bble)
            'WorkflowService.StartTaskProcess("ShortSaleTask", "Reassign - " & ld.StreetNameWithNo, task.TaskID, bble, names, "Normal")
        Else
            AssignCase(bble, userName, createBy)
        End If
    End Sub

    Public Shared Sub AssignCase(bble As String, userName As String, createBy As String)
        ShortSaleCase.ReassignOwner(bble, userName)
        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} reassign this case to {1}.", createBy, userName), bble, LeadsActivityLog.LogCategory.ShortSale.ToString, LeadsActivityLog.EnumActionType.Reassign)
    End Sub

    Public Shared Sub ReassignApproval(task As UserTask)
        Select Case task.Status
            Case UserTask.TaskStatus.Approved
                AssignCase(task.BBLE, task.TaskData, task.CreateBy)
                'ShortSaleCase.ReassignOwner(task.BBLE, task.TaskData)
            Case UserTask.TaskStatus.Declined

        End Select
    End Sub

    ''' <summary>
    ''' Approval process when agent move the leads to short sale
    ''' </summary>
    ''' <returns>Custom short sale new case process instance</returns>
    Public Shared Property NewCaseProcess As ShortSaleProcess = ShortSaleProcess.NewInstance("New Case", "ShortSale-AssignReviewer", Nothing,
                                                      Nothing,
                                                      Sub(task As UserTask)
                                                          NewCaseApproved(task.TaskData, task.CompleteBy)
                                                      End Sub,
                                                      Nothing)

    Public Shared Property ReassignProcess As ShortSaleProcess = ShortSaleProcess.NewInstance("Reassign Case Approval", "ShortSale-Manager", Nothing, Nothing,
                                                                                              Sub(task)
                                                                                                  AssignCase(task.BBLE, task.TaskData, task.CreateBy)
                                                                                              End Sub, Nothing)

    Public Shared Property AssignProcess As ShortSaleProcess = ShortSaleProcess.NewInstance("Assign Case Approval", "ShortSale-Manager", Nothing, Nothing,
                                                                                            Sub(task As UserTask)
                                                                                                Dim objData = JObject.Parse(task.TaskData)
                                                                                                Dim typeofUpdate = objData("TypeofUpdate").ToString
                                                                                                Dim category = objData("Category").ToString
                                                                                                Dim statusofUpdate = objData("StatusUpdate").ToString

                                                                                                Dim ssPage As New NGShortSale
                                                                                                ssPage.MortgageStatusUpdate(typeofUpdate, statusofUpdate, category, task.BBLE)

                                                                                                'Dim comments = String.Format("Mortgage Status Update: <br />Type of Update: {0}", typeofUpdate)
                                                                                                'If Not String.IsNullOrEmpty(category) AndAlso Not String.IsNullOrEmpty(statusofUpdate) Then
                                                                                                '    comments = comments & String.Format("<br />Status Update: {0} - {1}", category, statusofUpdate)
                                                                                                'End If

                                                                                                'LeadsActivityLog.AddActivityLog(DateTime.Now, comments, task.BBLE, LeadsActivityLog.LogCategory.ShortSale.ToString, LeadsActivityLog.EnumActionType.Comments)
                                                                                                Dim ssCase = ShortSaleCase.GetCaseByBBLE(task.BBLE)
                                                                                                ShortSale.ShortSaleActivityLog.AddLog(task.BBLE, task.CreateBy, typeofUpdate, category & " - " & statusofUpdate, "", ssCase.AppId)

                                                                                                If objData("Reviewer") IsNot Nothing AndAlso Not String.IsNullOrEmpty(objData("Reviewer")) Then
                                                                                                    ShortSaleCase.ReassignOwner(task.BBLE, objData("Reviewer").ToString)
                                                                                                Else
                                                                                                    Dim users = Roles.GetUsersInRole("ShortSale-AssignReviewer")
                                                                                                    If users IsNot Nothing AndAlso users.Count > 0 Then
                                                                                                        ShortSaleCase.ReassignOwner(task.BBLE, users(0))
                                                                                                    End If
                                                                                                End If
                                                                                            End Sub,
                                                                                            Nothing)

    Public Shared Property ArchivedProcess As ShortSaleProcess = ShortSaleProcess.NewInstance("Case Archive Approval", "ShortSale-Manager", Nothing, Nothing,
                                                                                              Sub(task As UserTask)
                                                                                                  Dim ssCase = ShortSaleCase.GetCaseByBBLE(task.TaskData)
                                                                                                  ssCase.SaveStatus(CaseStatus.Archived)
                                                                                              End Sub, Nothing)
End Class

''' <summary>
''' Custom shortsale Process, only one step approval
''' </summary>
Public Class ShortSaleProcess
    Public Delegate Sub StartProcess(bble As String, taskData As String, createBy As String)
    Public Delegate Sub Approved(task As UserTask)
    Public Delegate Sub Declined(task As UserTask)

    ''' <summary>
    ''' The Process Name
    ''' </summary>
    ''' <returns>Process Name</returns>
    Public Property TaskName As String

    ''' <summary>
    ''' Process approval role property
    ''' </summary>
    ''' <returns>Approval roles</returns>
    Public Property RoleName As String

    ''' <summary>
    ''' Process Approver property
    ''' </summary>
    ''' <returns>Approver</returns>
    Public Property UserNames As String

    Public StartProcessAction As StartProcess
    Public ApprovedAction As Approved
    Public DeclinedAction As Declined


    Private Shared ProcessTable As New List(Of ShortSaleProcess)
    Private Sub New()
    End Sub

    Public Shared Sub ExecuteAction(task As UserTask)
        Dim proc = ProcessTable.FirstOrDefault(Function(p) p.TaskName = task.Action)

        If proc IsNot Nothing Then
            proc.ProcessApproval(task)
        End If
    End Sub

    ''' <summary>
    ''' Get process instance
    ''' </summary>
    ''' <param name="name">Process Name</param>
    ''' <param name="roles">Approval Roles</param>
    ''' <param name="approvers">Approver</param>
    ''' <param name="startAction">the custom function on Process Starting</param>
    ''' <param name="approvedAction">custom function on process approved</param>
    ''' <param name="declinedAction">custom function on process declined</param>
    ''' <returns>Process Instance</returns>
    Public Shared Function NewInstance(name As String, roles As String, approvers As String, startAction As StartProcess, approvedAction As Approved, declinedAction As Declined)
        Dim proc = ProcessTable.FirstOrDefault(Function(p) p.TaskName = name)
        If proc Is Nothing Then
            proc = New ShortSaleProcess
            proc.TaskName = name
            proc.RoleName = roles
            proc.UserNames = approvers
            proc.StartProcessAction = startAction
            proc.ApprovedAction = approvedAction
            proc.DeclinedAction = declinedAction

            ProcessTable.Add(proc)
        End If

        Return proc
    End Function

    Public Sub ProcessApproval(task As UserTask)
        Select Case task.Status
            Case UserTask.TaskStatus.Approved
                If Me.ApprovedAction IsNot Nothing Then
                    Me.ApprovedAction(task)
                End If

                Dim ld = LeadsInfo.GetInstance(task.BBLE)
                Dim msg = String.Format("Your {0}-{1} is approved by {2}.", task.Action, ld.StreetNameWithNo, task.CompleteBy)
                UserMessage.AddNewMessage(task.CreateBy, "Approved", msg, task.BBLE, DateTime.Now, "Portal", "/ShortSale/ShortSale.aspx?bble=" & task.BBLE)
            Case UserTask.TaskStatus.Declined
                If DeclinedAction IsNot Nothing Then
                    DeclinedAction(task)
                End If

                Dim ld = LeadsInfo.GetInstance(task.BBLE)
                Dim msg = String.Format("Your {0}-{1} is declined by {2}. Comments: {3}", task.Action, ld.StreetNameWithNo, task.CompleteBy, task.Comments)
                UserMessage.AddNewMessage(task.CreateBy, "Declined", msg, task.BBLE, DateTime.Now, "Portal", "/ShortSale/ShortSale.aspx?bble=" & task.BBLE)
        End Select
    End Sub

    Public Sub ProcessStart(bble As String, taskData As String, createBy As String, comments As String, Optional approvers As String = Nothing)
        If StartProcessAction IsNot Nothing Then
            StartProcessAction(bble, taskData, createBy)
        End If

        'Dim comments = String.Format("{0} want to move this case to ShortSale. Please approval.", createBy)
        Dim emp = Employee.GetInstance(createBy)
        Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.ShortSale.ToString, emp.EmployeeID, createBy, LeadsActivityLog.EnumActionType.SetAsTask)
        'For testing purpose, need change to ShortSale-Manager

        Dim names = If(Not String.IsNullOrEmpty(RoleName), String.Join(";", Roles.GetUsersInRole(RoleName)), UserNames)

        If Not String.IsNullOrEmpty(approvers) Then
            names = approvers
        End If

        Dim task = UserTask.AddUserTask(bble, names, TaskName, "Normal", "In Office", DateTime.Now, comments, log.LogID, createBy, UserTask.UserTaskMode.Approval, taskData)

        Dim ld = LeadsInfo.GetInstance(bble)
        WorkflowService.StartTaskProcess("ShortSaleTask", TaskName & " " & ld.StreetNameWithNo, task.TaskID, bble, names, "Normal")
    End Sub
End Class
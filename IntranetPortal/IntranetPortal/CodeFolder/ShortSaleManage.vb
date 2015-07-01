Imports IntranetPortal.ShortSale

Public Class ShortSaleManage

    Public Shared Sub MoveLeadsToShortSale(bble As String, createBy As String)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        If ssCase Is Nothing OrElse ssCase.Status = ShortSale.CaseStatus.NewFile Then
            Dim li = LeadsInfo.GetInstance(bble)

            If li IsNot Nothing Then
                Dim propBase = SaveProp(li, createBy)

                ssCase = New ShortSaleCase(propBase)
                ssCase.BBLE = bble
                ssCase.CaseName = li.LeadsName
                ssCase.Status = ShortSale.CaseStatus.NewFile
                ssCase.Owner = GetIntaker()
                ssCase = SetReferral(ssCase)
                ssCase.Save()

                NewCaseProcess.ProcessStart(bble, bble, createBy, String.Format("{0} want to move this case to ShortSale. Please approval.", createBy))
                'NewCaseWithWF(bble, createBy)
            End If
        End If
    End Sub

    Public Shared Sub NewCaseApproved(bble As String)
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        ssCase.Status = ShortSale.CaseStatus.Active
        ssCase.Owner = GetIntaker()
        Dim processor = PartyContact.GetContactByName(ssCase.Owner)
        If processor IsNot Nothing Then
            ssCase.Processor = processor.ContactId
        End If

        ssCase.Save()

        If ssCase.CaseId > 0 Then
            If ssCase.Mortgages.Count = 0 Then
                Dim mort As New PropertyMortgage
                mort.CaseId = ssCase.CaseId
                mort.Category = "Assign"
                mort.Status = "Intake - New File"
                mort.Save()
            End If
        End If
    End Sub

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
        If String.IsNullOrEmpty(updateBy) Then
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
                Return ShortSale.ShortSaleCase.GetCaseByBBLEs(bbles)
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

    Public Shared Function SaveProp(li As LeadsInfo, createBy As String) As IntranetPortal.ShortSale.PropertyBaseInfo
        Dim propBase = IntranetPortal.ShortSale.PropertyBaseInfo.GetInstance(li.BBLE)

        If propBase Is Nothing Then
            propBase = New IntranetPortal.ShortSale.PropertyBaseInfo
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
        If Not Roles.IsUserInRole(createBy, "ShortSale-Manager") Then
            ReassignProcess.ProcessStart(bble, userName, createBy, String.Format("{0} want to reassign this case to {1}. Please approval.", createBy, userName))

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
        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} reassign this case to {1}.", createBy, userName), bble, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)
    End Sub

    Public Shared Sub ReassignApproval(task As UserTask)
        Select Case task.Status
            Case UserTask.TaskStatus.Approved
                AssignCase(task.BBLE, task.TaskData, task.CreateBy)
                'ShortSaleCase.ReassignOwner(task.BBLE, task.TaskData)
            Case UserTask.TaskStatus.Declined

        End Select
    End Sub

    Public Shared Property NewCaseProcess As ShortSaleProcess = ShortSaleProcess.NewInstance("New Case", "TestRole", Nothing,
                                                      Nothing,
                                                      Sub(task)
                                                          NewCaseApproved(task.TaskData)
                                                      End Sub,
                                                      Nothing)

    Public Shared Property ReassignProcess As ShortSaleProcess = ShortSaleProcess.NewInstance("Reassign Case Approval", "TestRole", Nothing, Nothing,
                                                                                              Sub(task)
                                                                                                  AssignCase(task.BBLE, task.TaskData, task.CreateBy)
                                                                                              End Sub, Nothing)

End Class

Public Class ShortSaleProcess
    Public Delegate Sub StartProcess(bble As String, taskData As String, createBy As String)
    Public Delegate Sub Approved(task As UserTask)
    Public Delegate Sub Declined(task As UserTask)

    Public Property TaskName As String
    Public Property RoleName As String
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
            Case UserTask.TaskStatus.Declined
                If DeclinedAction IsNot Nothing Then
                    DeclinedAction(task)
                End If
        End Select
    End Sub

    Public Sub ProcessStart(bble As String, taskData As String, createBy As String, comments As String)
        If StartProcessAction IsNot Nothing Then
            StartProcessAction(bble, taskData, createBy)
        End If

        'Dim comments = String.Format("{0} want to move this case to ShortSale. Please approval.", createBy)
        Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Task.ToString, Nothing, createBy, LeadsActivityLog.EnumActionType.SetAsTask)
        'For testing purpose, need change to ShortSale-Manager

        Dim names = If(Not String.IsNullOrEmpty(RoleName), String.Join(",", Roles.GetUsersInRole("TestRole")), UserNames)
        Dim task = UserTask.AddUserTask(bble, names, TaskName, "Normal", "In Office", DateTime.Now, comments, log.LogID, createBy, UserTask.UserTaskMode.Approval, taskData)

        Dim ld = LeadsInfo.GetInstance(bble)
        WorkflowService.StartTaskProcess("ShortSaleTask", TaskName & " " & ld.StreetNameWithNo, task.TaskID, bble, names, "Normal")
    End Sub
End Class
Imports IntranetPortal
Imports Newtonsoft.Json.Linq


''' <summary>
''' Handle lead related action
''' </summary>
Public Class LeadManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

    ''' <summary>
    ''' Return if the leads creation limiation of user's team was reached. 
    ''' The daily limitation is team based.
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns></returns>
    Public Shared Function OverUserCreateLimit(userName As String) As Boolean
        Dim roleNames = Core.PortalSettings.GetValue("LeadsCreatedLimitExcept").Split(";")

        Dim myRoles = Roles.GetRolesForUser(userName)

        If myRoles.Any(Function(r) roleNames.Contains(r)) Then
            Return False
        End If

        Dim teamName = UserInTeam.GetUserTeam(userName)
        If Not String.IsNullOrEmpty(teamName) Then
            Dim tm = Team.GetTeam(teamName)
            Return tm.OverLimitation()
        End If

        Return False
    End Function


    ''' <summary>
    ''' Return the leads which is in process
    ''' </summary>
    ''' <param name="type">The type of in Process</param>
    ''' <param name="userNames">the array of agents</param>
    ''' <returns></returns>
    Public Shared Function GetLeadsInProcess(type As String, userNames As String()) As List(Of Lead)
        Using context As New Entities
            Dim leads = (From ld In context.Leads.Where(Function(e) userNames.Contains(e.EmployeeName) And e.Status = LeadStatus.InProcess)
                         Join ss In context.InProcessBBLEs.Where(Function(ip) ip.Type = type) On ld.BBLE Equals ss.BBLE
                         Select ld).Distinct.ToList.OrderByDescending(Function(e) e.LastUpdate).ToList

            Return leads
        End Using
    End Function

    'Public Function GetLeadsInProcess(type As String, role As String, userName As String) As List(Of Lead)
    '    If role = "Manager" Then
    '        Dim subOridates = Employee.GetManagedEmployees(userName, False)
    '        Return GetLeadsInProcess(type, subOridates)
    '    ElseIf role = "Team"
    '        Dim subOridates = Employee.GetAllTeamUsers(userName)
    '        Return GetLeadsInProcess(type, subOridates)
    '    Else
    '        Return GetLeadsInProcess(type, {userName})
    '    End If

    'End Function

    ''' <summary>
    ''' The amount that show on the left menu
    ''' </summary>
    ''' <param name="navMenu"></param>
    ''' <param name="userName"></param>
    ''' <returns></returns>
    Public Function GetAmount(navMenu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount
        If navMenu.Name.Contains("InProcess") Then
            Dim tmpStr = navMenu.Name.Split("-")
            If tmpStr.Length > 2 Then
                Dim role = tmpStr(0)
                Select Case role
                    Case "Manager"
                        Dim type = tmpStr(2)
                        Dim subOridates = Employee.GetManagedEmployees(userName, False)
                        Return GetLeadsInProcess(type, subOridates).Count
                    Case "Agent"
                        Dim type = tmpStr(2)
                        Return GetLeadsInProcess(type, {userName}).Count
                    Case "Team"
                        Dim teamId = CInt(tmpStr(1))
                        Dim type = tmpStr(3)
                        Dim subOridates = Employee.GetAllTeamUsers(teamId)
                        Return GetLeadsInProcess(type, subOridates).Count
                    Case Else
                        Return 0
                End Select
            End If
        End If

        Return 0
    End Function


#Region "Activitylog Manage"

    Public Sub New()

    End Sub

    Public Sub New(actityLog As Boolean)
        Me.LogCategory = LeadsActivityLog.LogCategory.SalesAgent
        Me.LogCategoryFilter = {LeadsActivityLog.LogCategory.SalesAgent, LeadsActivityLog.LogCategory.Status}
    End Sub

    Public Overrides Function LogDataSource(bble As String) As List(Of LeadsActivityLog)
        Dim categories = Me.LogCategoryFilter.ToList
        Dim subCategories = {LeadsActivityLog.LogCategory.Approval, LeadsActivityLog.LogCategory.Approved, LeadsActivityLog.LogCategory.Appointment,
                             LeadsActivityLog.LogCategory.Declined, LeadsActivityLog.LogCategory.DoorknockTask, LeadsActivityLog.LogCategory.PublicUpdate}
        categories.AddRange(subCategories)

        Return LeadsActivityLog.GetLeadsActivityLogs(bble, categories.Select(Function(a) a.ToString).ToArray)
    End Function

#End Region

    Public Shared ReadOnly Property DeadLeadProcess As ShortSaleProcess
        Get
            Dim proc = ShortSaleProcess.NewInstance("Dead Lead Request", Nothing, Nothing,
                                                                                              Nothing, Sub(task)
                                                                                                           Dim objData = JObject.Parse(task.TaskData)
                                                                                                           Dim reason = CInt(objData("Reason"))
                                                                                                           Dim description = objData("Description").ToString
                                                                                                           Lead.SetDeadLeadsStatus(task.BBLE, reason, description)
                                                                                                       End Sub, Nothing)
            proc.ProcessName = "TaskProcess"
            proc.Category = LeadsActivityLog.LogCategory.SalesAgent
            proc.ApprovalUrl = "/ViewLeadsInfo.aspx"
            proc.TaskUrlTemplate = "/ViewLeadsInfo.aspx?id={0}"
            Return proc
        End Get
    End Property

    Public Shared ReadOnly Property DumpLeadProcess As ShortSaleProcess
        Get
            Dim proc = ShortSaleProcess.NewInstance("Dump Dead Lead Request", Nothing, Nothing,
                                                                                              Nothing, Sub(task)
                                                                                                           Dim objData = JObject.Parse(task.TaskData)
                                                                                                           Dim reason = CInt(objData("Reason"))
                                                                                                           Dim description = objData("Description").ToString
                                                                                                           Dim l = Lead.GetInstance(task.BBLE)
                                                                                                           l.ReAssignLeads("Dead Leads", task.CreateBy)
                                                                                                           Lead.SetDeadLeadsStatus(task.BBLE, reason, description)
                                                                                                       End Sub, Nothing)
            proc.ProcessName = "TaskProcess"
            proc.Category = LeadsActivityLog.LogCategory.SalesAgent
            proc.ApprovalUrl = "/ViewLeadsInfo.aspx"
            proc.TaskUrlTemplate = "/ViewLeadsInfo.aspx?id={0}"
            Return proc
        End Get
    End Property

End Class

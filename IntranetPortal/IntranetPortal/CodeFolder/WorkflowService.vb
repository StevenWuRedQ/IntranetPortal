Imports MyIdealProp.Workflow.Client
Imports MyIdealProp.Workflow

Public Class WorkflowService

#Region "Task"
    Public Shared Sub StartTaskProcess(procName As String, displayName As String, taskId As Integer, bble As String, approver As String, priority As String, createUser As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Dim conn = GetConnection(createUser)
        Dim procInst = conn.CreateProcessInstance(procName)
        procInst.DisplayName = displayName
        Dim tmpPriority As ProcessPriority
        If [Enum].TryParse(Of ProcessPriority)(priority, tmpPriority) Then
            procInst.Priority = tmpPriority
        End If

        procInst.DataFields.Add("TaskId", taskId)
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
        conn.Close()
    End Sub

    Public Shared Sub StartTaskProcess(procName As String, displayName As String, taskId As Integer, bble As String, approver As String, priority As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Dim conn = GetConnection()
        Dim procInst = conn.CreateProcessInstance(procName)
        procInst.DisplayName = displayName

        Dim tmpPriority As ProcessPriority
        If [Enum].TryParse(Of ProcessPriority)(priority, tmpPriority) Then
            procInst.Priority = tmpPriority
        End If

        procInst.DataFields.Add("TaskId", taskId)
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
        conn.Close()
    End Sub

    Public Shared Sub ExpiredLeadsProcess(bble As String)
        ExpireTaskProcess(bble)
        ExpiredLeadsReminder(bble)
        ExpiredRecycleProcess(bble)
    End Sub

    Public Shared Sub ExpireTaskProcess(bble As String)
        Using conn = GetConnection()
            Dim pInsts = conn.GetProcessInstancesByDataFields("TaskProcess", "BBLE", bble)
            For Each pInstId In pInsts
                conn.ExpiredProcessInstance(pInstId)
            Next
        End Using
    End Sub

    Public Shared Sub ExpiredLeadsReminder(bble As String)
        Using conn = GetConnection()
            Dim pInsts = conn.GetProcessInstancesByDataFields("ReminderProcess", "BBLE", bble)
            For Each pInstId In pInsts
                conn.ExpiredProcessInstance(pInstId)
            Next
        End Using
    End Sub

    Public Shared Sub ExpiredRecycleProcess(bble As String)
        Using conn = GetConnection()
            Dim pInsts = conn.GetProcessInstancesByDataFields("RecycleProcess", "BBLE", bble)
            For Each pInstId In pInsts
                conn.ExpiredProcessInstance(pInstId)
            Next
        End Using
    End Sub

    Public Shared Sub ExpiredReminderProcess(pInstId As Integer)
        Using conn = GetConnection()
            conn.ExpiredProcessInstance(pInstId)
        End Using
    End Sub

    Public Shared Function GetUserTaskWorklist(taskId As Integer, destUser As String) As DBPersistence.Worklist
        Using conn = GetConnection()
            Dim pInstIds = conn.GetProcessInstancesByDataFields("TaskProcess", "TaskId", taskId)
            If pInstIds.Count > 0 Then

                Dim wls = MyIdealProp.Workflow.DBPersistence.Worklist.GetProcInstWorkList(pInstIds(0))
                If wls IsNot Nothing Then
                    Return wls.SingleOrDefault(Function(wl) wl.DestinationUser.ToLower = destUser.ToLower)
                End If
            End If

            Return Nothing
        End Using
    End Function

    Public Shared Function GetUserTaskApprovalLink(taskId As Integer, destUser As String) As String
        Dim wl = GetUserTaskWorklist(taskId, destUser)
        Dim siteUrl = System.Configuration.ConfigurationManager.AppSettings("PortalUrl")
        If wl IsNot Nothing Then
            Return siteUrl & wl.ItemData
        Else
            Return siteUrl
        End If

    End Function

#End Region

#Region "New Leads"
    Public Shared Sub StartNewLeadsRequest(displayName As String, bble As String, approver As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Using conn = GetConnection()
            Dim procInst = conn.CreateProcessInstance("NewLeadsRequest")
            procInst.DisplayName = displayName
            procInst.DataFields.Add("BBLE", bble)
            procInst.DataFields.Add("Mgr", approver)
            conn.StartProcessInstance(procInst)
        End Using
    End Sub
#End Region

#Region "Appointment"
    Public Shared Sub StartNewAppointmentProcess(displayName As String, bble As String, appointId As Integer, approver As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Using conn = GetConnection()
            Dim procInst = conn.CreateProcessInstance("NewAppointmentRequest")
            procInst.DisplayName = displayName
            procInst.DataFields.Add("BBLE", bble)
            procInst.DataFields.Add("Mgr", approver)
            procInst.DataFields.Add("AppointmentId", appointId)
            conn.StartProcessInstance(procInst)
        End Using
    End Sub

    Public Shared Function IsAppointmentProcess(sn As String, appointId As Integer) As Boolean
        If Not IntegratedWithWorkflow() Then
            Return True
        End If

        Dim wli = LoadTaskProcess(sn)
        If wli IsNot Nothing AndAlso wli.ProcessName = "NewAppointmentRequest" Then
            Return CInt(wli.ProcessInstance.DataFields("AppointmentId")) = appointId
        End If

        Return False
    End Function
#End Region

#Region "Leads Search"
    Public Shared Sub StartLeadsSearchProcess(displayName As String, searchName As String, searchData As String, searchId As Integer)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Using conn = GetConnection()
            Dim procInst = conn.CreateProcessInstance("LeadsSearchRequest")
            procInst.DisplayName = displayName
            procInst.DataFields.Add("SearchName", searchName)
            procInst.DataFields.Add("SearchData", searchData)
            procInst.DataFields.Add("SearchId", searchId)
            conn.StartProcessInstance(procInst)
        End Using
    End Sub



#End Region

#Region "Worklist"
    Public Shared Function LoadTaskProcess(sn As String) As WorklistItem
        If Not IntegratedWithWorkflow() Then
            Return Nothing
        End If

        Try
            Dim conn = GetConnection()
            Dim wli = conn.OpenWorklistItem(sn)
            Return wli
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Shared Function LoadTaskProcess(sn As String, impersonateUser As String) As WorklistItem
        If Not IntegratedWithWorkflow() Then
            Return Nothing
        End If

        Try
            Dim conn = GetConnection(impersonateUser)
            Dim wli = conn.OpenWorklistItem(sn)
            Return wli
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Shared Function GetMyWorklist() As List(Of WorklistItem)
        If Not IntegratedWithWorkflow() Then
            Return New List(Of WorklistItem)
        End If

        Using conn = GetConnection()
            Return conn.OpenMyWorklist()
        End Using
    End Function

    Public Shared Function GetUserWorklist(destUser As String) As List(Of WorklistItem)
        If Not IntegratedWithWorkflow() Then
            Return New List(Of WorklistItem)
        End If

        Using conn = GetConnection(destUser)
            Return conn.OpenMyWorklist
        End Using
    End Function

    Public Shared ReadOnly Property ConnectionName As String
        Get
            If HttpContext.Current Is Nothing Then
                Return "Portal"
            Else
                Return HttpContext.Current.User.Identity.Name
            End If
        End Get
    End Property

#End Region

#Region "Workflow Log"
    Public Shared Function GetMyOriginated(userName As String) As List(Of DBPersistence.ProcessInstance)
        Return DBPersistence.ProcessInstance.GetMyApplication(userName)
    End Function

    Public Shared Function GetMyCompleted(userName As String) As List(Of DBPersistence.ProcessInstance)
        Return DBPersistence.ProcessInstance.GetMyProcessed(userName)
    End Function

    Public Shared Sub ArchivedProcInst(procInstId As Integer)
        DBPersistence.ProcessInstance.Archive(procInstId)
    End Sub

    Public Shared Function LoadProcInstById(procInstId As Integer) As DBPersistence.ProcessInstance
        Dim procInst = DBPersistence.ProcessInstance.LoadProcInstById(procInstId)
        Return procInst
    End Function
#End Region

#Region "Private Methods"
    Private Shared Function GetConnection() As Connection
        Dim conn As New Connection(wfServer)
        conn.Integrated = True
        conn.UserName = ConnectionName

        conn.Open()
        Return conn
    End Function

    Private Shared Function GetConnection(impersonateUser As String) As Connection
        Dim conn As New Connection(wfServer)
        conn.Integrated = True
        conn.UserName = impersonateUser

        conn.Open()
        Return conn
    End Function

    Private Shared Function IntegratedWithWorkflow() As Boolean
        Return True
    End Function

    Private Shared wfServer As String = System.Configuration.ConfigurationManager.AppSettings("WorkflowServer")
#End Region


End Class

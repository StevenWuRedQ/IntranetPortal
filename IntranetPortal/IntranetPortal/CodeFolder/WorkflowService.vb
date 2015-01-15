Imports MyIdealProp.Workflow.Client
Imports MyIdealProp.Workflow

Public Class WorkflowService
    Public Shared Sub StartTaskProcess(procName As String, displayName As String, taskId As Integer, bble As String, approver As String, priority As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Dim conn = GetConnection()
        Dim procInst = conn.CreateProcessInstance(procName)
        procInst.DisplayName = displayName
        procInst.Priority = [Enum].Parse(GetType(ProcessPriority), priority)
        procInst.DataFields.Add("TaskId", taskId)
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
        conn.Close()
    End Sub

    Public Shared Sub ExpireTaskProcess(bble As String)
        Using conn = GetConnection()
            Dim pInsts = conn.GetProcessInstancesByDataFields("TaskProcess", "BBLE", bble)
            For Each pInstId In pInsts
                conn.ExpiredProcessInstance(pInstId)
            Next
        End Using
    End Sub

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

    Public Shared Function GetMyWorklist() As List(Of WorklistItem)
        If Not IntegratedWithWorkflow() Then
            Return New List(Of WorklistItem)
        End If

        Using conn = GetConnection()
            Return conn.OpenMyWorklist()
        End Using
    End Function

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

    Private Shared Function GetConnection() As Connection
        Dim conn As New Connection(wfServer)
        conn.Integrated = True
        If HttpContext.Current Is Nothing Then
            conn.UserName = "Portal"
        Else
            conn.UserName = HttpContext.Current.User.Identity.Name
        End If

        conn.Open()
        Return conn
    End Function

    Private Shared Function IntegratedWithWorkflow() As Boolean
        Return True
    End Function

    Private Shared wfServer As String = System.Configuration.ConfigurationManager.AppSettings("WorkflowServer")
End Class

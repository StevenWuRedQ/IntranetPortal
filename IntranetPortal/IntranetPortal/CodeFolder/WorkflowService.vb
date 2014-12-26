Imports MyIdealProp.Workflow.Client
Imports MyIdealProp.Workflow

Public Class WorkflowService
    Public Shared Sub StartTaskProcess(procName As String, displayName As String, taskId As Integer, bble As String, approver As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Dim conn = GetConnection()
        Dim procInst = conn.CreateProcessInstance(procName)
        procInst.DisplayName = displayName
        procInst.DataFields.Add("TaskId", taskId)
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
    End Sub

    Public Shared Sub StartNewLeadsRequest(displayName As String, bble As String, approver As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Dim conn = GetConnection()
        Dim procInst = conn.CreateProcessInstance("NewLeadsRequest")
        procInst.DisplayName = displayName
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
    End Sub

    Public Shared Sub StartNewAppointmentProcess(displayName As String, bble As String, approver As String)
        If Not IntegratedWithWorkflow() Then
            Return
        End If

        Dim conn = GetConnection()
        Dim procInst = conn.CreateProcessInstance("NewAppointmentRequest")
        procInst.DisplayName = displayName
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
    End Sub

    Public Shared Function LoadTaskProcess(sn As String) As WorklistItem
        If Not IntegratedWithWorkflow() Then
            Return Nothing
        End If

        Dim conn = GetConnection()
        Dim wli = conn.OpenWorklistItem(sn)
        Return wli
    End Function

    Public Shared Function GetMyWorklist() As List(Of WorklistItem)
        If Not IntegratedWithWorkflow() Then
            Return New List(Of WorklistItem)
        End If


        Dim conn = GetConnection()
        Return conn.OpenMyWorklist()
    End Function

    Public Shared Function GetMyOriginated(userName As String) As List(Of DBPersistence.ProcessInstance)
        Return DBPersistence.ProcessInstance.GetMyApplication(userName)
    End Function

    Public Shared Function GetMyCompleted(userName As String) As List(Of DBPersistence.ProcessInstance)
        Return DBPersistence.ProcessInstance.getmyProcessed(userName)
    End Function

    Public Shared Function LoadProcInstById(procInstId As Integer) As DBPersistence.ProcessInstance
        Dim procInst = DBPersistence.ProcessInstance.LoadProcInstById(procInstId)
        Return procInst
    End Function

    Private Shared Function GetConnection() As Connection
        Dim conn As New Connection("Chrispc")
        conn.Integrated = True
        conn.UserName = HttpContext.Current.User.Identity.Name
        conn.Open()
        Return conn
    End Function

    Private Shared Function IntegratedWithWorkflow() As Boolean
        Return False
    End Function
End Class

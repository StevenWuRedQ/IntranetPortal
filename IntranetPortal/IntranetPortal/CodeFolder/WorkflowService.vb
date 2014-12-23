Imports MyIdealProp.Workflow.Client
Imports MyIdealProp.Workflow


Public Class WorkflowService
    Public Shared Sub StartTaskProcess(procName As String, displayName As String, taskId As Integer, bble As String, approver As String)
        Dim conn = GetConnection()

        Dim procInst = conn.CreateProcessInstance(procName)
        procInst.DisplayName = displayName
        procInst.DataFields.Add("TaskId", taskId)
        procInst.DataFields.Add("BBLE", bble)
        procInst.DataFields.Add("Mgr", approver)
        conn.StartProcessInstance(procInst)
    End Sub

    Public Shared Function LoadTaskProcess(sn As String) As WorklistItem
        Dim conn = GetConnection()
        Dim wli = conn.OpenWorklistItem(sn)
        Return wli
    End Function

    Public Shared Function GetMyWorklist() As List(Of WorklistItem)
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
        Dim conn As New Connection("localhost")
        conn.Integrated = True
        conn.UserName = HttpContext.Current.User.Identity.Name
        conn.Open()
        Return conn
    End Function
End Class

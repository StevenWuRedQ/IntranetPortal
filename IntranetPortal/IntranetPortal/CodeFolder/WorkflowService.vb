Imports MyIdealProp.Workflow.Client

Public Class WorkflowService
    Public Shared Sub StartTaskProcess(displayName As String, taskId As Integer, bble As String, approver As String)
        Dim conn As New Connection("localhost")
        conn.Integrated = True
        conn.UserName = HttpContext.Current.User.Identity.Name
        conn.Open()

        Dim procInst = conn.CreateProcessInstance("TaskProcess")
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

    Private Shared Function GetConnection() As Connection
        Dim conn As New Connection("localhost")
        conn.Integrated = True
        conn.UserName = HttpContext.Current.User.Identity.Name
        conn.Open()
        Return conn
    End Function
End Class

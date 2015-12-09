Public Class WorkflowMng
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub Unnamed1_Click(sender As Object, e As EventArgs)
        Dim taskId = CInt(txtTaskId.Text)

        Dim task = UserTask.GetTaskById(taskId)

        If task.Status = UserTask.TaskStatus.Active Then
            Try
                Dim ld = LeadsInfo.GetInstance(task.BBLE)
                Dim taskName = String.Format("{0} {1}", task.Action, ld.StreetNameWithNo)
                WorkflowService.StartTaskProcess("TaskProcess", taskName, task.TaskID, task.BBLE, task.EmployeeName, task.Important, task.CreateBy)
                lblResult.Text = "Task Created."
            Catch ex As Exception
                lblResult.Text = "Exception: " & ex.Message
            End Try
        Else
            lblResult.Text = "Task is not valid."
        End If
    End Sub
End Class
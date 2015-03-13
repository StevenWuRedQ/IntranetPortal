Imports MyIdealProp.Workflow.Client

Public Class RecycleManage
    Public Shared Sub PostponeRecyle(sn As String, days As Integer, postPoneBy As String)
        Dim wli = WorkflowService.LoadTaskProcess(sn, postPoneBy)

        If wli IsNot Nothing Then
            PostponeRecyle(wli, days, postPoneBy)
        End If
    End Sub

    Public Shared Sub PostponeRecyle(wli As WorklistItem, days As Integer, postponeBy As String)
        Dim recyleId = CInt(wli.ProcessInstance.DataFields("TaskId"))
        Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
        wli.ProcessInstance.DataFields("Result") = "Completed"
        wli.Finish()

        Dim recycle = Core.RecycleLead.GetInstance(recyleId)
        Dim rDate = recycle.PostponeDays(days)

        Try
            Dim emp = Employee.GetInstance(postponeBy)
            If emp Is Nothing Then
                emp = New Employee With
                      {
                          .EmployeeID = Nothing,
                          .Name = "Portal"
                          }
            End If

            LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("Recycle action is postponed to {0} by {1} ", rDate.ToShortDateString, postponeBy), bble, LeadsActivityLog.LogCategory.Status.ToString, emp.EmployeeID, emp.Name, LeadsActivityLog.EnumActionType.ExtendRecycle)
        Catch ex As Exception
            Throw New Exception("Add activity log, ex: " & ex.Message)
        End Try
    End Sub

    Public Shared Sub BatchPostponeRecycle(userName As String, days As Integer)
        Dim wlis = WorkflowService.GetUserWorklist(userName).Where(Function(wl) wl.ProcessName = "RecycleProcess").ToList

        For Each wli In wlis
            PostponeRecyle(wli.SeriesNumber, days, userName)
        Next
    End Sub
End Class

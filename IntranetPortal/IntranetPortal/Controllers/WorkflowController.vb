Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class WorkflowController
        Inherits ApiController

        Public Function GetTask()

            Dim wls = WorkflowService.GetMyWorklist()

            Dim result = From wl In wls
                         Select New With {
                                wl.SeriesNumber,
                                wl.ProcInstId,
                                wl.ItemData,
                                wl.Priority,
                                wl.ProcSchemeDisplayName,
                                wl.StartDate,
                                wl.Status,
                                wl.Originator,
                                wl.DisplayName,
                                .DueDate = Nothing
                             }

            Return result.Select(Function(s)
                                     s.DueDate = LoadDueDate(s.ProcInstId)
                                     Return s
                                 End Function).toarray
        End Function

        Private Function LoadDueDate(procInstId As Integer) As DateTime?
            Dim procInst = WorkflowService.LoadProcInstById(procInstId)

            If procInst Is Nothing Then
                Return Nothing
            End If

            If procInst IsNot Nothing Then
                Dim taskId = CInt(procInst.GetDataFieldValue("TaskId"))
                If taskId > 0 Then
                    Dim tk = UserTask.GetTaskById(taskId)

                    If tk Is Nothing Then
                        Return Nothing
                    End If

                    Return tk.Schedule
                End If
            End If

            Return Nothing
        End Function
    End Class
End Namespace
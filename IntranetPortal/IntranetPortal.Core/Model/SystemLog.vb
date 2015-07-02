Imports System.Threading

Partial Public Class SystemLog
    Public Shared Sub Log(title As String, description As String, category As String, bble As String, createBy As String)
        Using ctx As New CoreEntities
            Dim log As New SystemLog
            log.Title = title
            log.BBLE = bble
            log.Description = description
            log.Category = category
            log.CreateDate = DateTime.Now
            log.CreateBy = createBy

            ctx.SystemLogs.Add(log)
            ctx.SaveChanges()

        End Using
    End Sub

    Public Shared Sub LogError(title As String, ex As Exception, createby As String, bble As String)

        If TypeOf ex Is ThreadAbortException Then
            Return
        End If

        Log(title, String.Format("Error in Portal Application. Message:{0}, Stack: {1}", ex.Message, ex.StackTrace), "Error", bble, createby)
    End Sub
End Class

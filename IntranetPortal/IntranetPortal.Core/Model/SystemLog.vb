Imports System.Threading

Partial Public Class SystemLog

    Public Shared Sub Log(title As String, description As String, category As LogCategory, bble As String, createBy As String)
        Log(title, description, category.ToString, bble, createBy)
    End Sub

    Public Shared Sub Log(title As String, description As String, category As String, bble As String, createBy As String)
        Try
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
        Catch ex As Exception

        End Try
    End Sub

    Public Shared Function GetLogs(title As String, startDate As DateTime, endDate As DateTime) As List(Of SystemLog)

        Using ctx As New CoreEntities
            Return ctx.SystemLogs.Where(Function(l) l.Title = title And l.CreateDate > startDate And l.CreateDate < endDate).ToList
        End Using
    End Function

    Public Shared Sub LogError(title As String, ex As Exception, url As String, createby As String, bble As String)

        If TypeOf ex Is ThreadAbortException Then
            Return
        End If

        Try
            Log(title, String.Format("Error in Portal Application. Message:{0}, Request URL: {2}. Stack: {1}", ex.Message, ex.ToJsonString, url), LogCategory.Error, bble, createby)
        Catch exp As Exception

        End Try
    End Sub

    Public Enum LogCategory
        [Error]
        Operation
        SaveData
    End Enum
End Class

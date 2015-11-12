Imports System.Threading

Partial Public Class SystemLog

    Public Shared Sub Log(title As String, description As String, category As LogCategory, bble As String, createBy As String)
        Log(title, description, category.ToString, bble, createBy)
    End Sub

    ''' <summary>
    ''' Add the log to system
    ''' </summary>
    ''' <param name="title">Log Title</param>
    ''' <param name="description">Log Description</param>
    ''' <param name="category">Category</param>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="createBy">Create User</param>
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

    ''' <summary>
    ''' Return system log list by log title and datetime or category
    ''' </summary>
    ''' <param name="title">Log title</param>
    ''' <param name="startDate">Start Date</param>
    ''' <param name="endDate">End Date</param>
    ''' <param name="category">Log category, default is all category</param>
    ''' <returns></returns>
    Public Shared Function GetLogs(title As String, startDate As DateTime, endDate As DateTime, Optional category As String = Nothing) As List(Of SystemLog)

        Using ctx As New CoreEntities
            Dim noCategory = category Is Nothing
            Return ctx.SystemLogs.Where(Function(l) l.Title = title And l.CreateDate > startDate And l.CreateDate < endDate And (noCategory OrElse l.Category = category)).ToList
        End Using
    End Function

    Public Shared Function GetLatestLogs(startDate As DateTime?) As List(Of SystemLog)
        Using ctx As New CoreEntities
            If startDate.HasValue AndAlso startDate > DateTime.MinValue Then
                Return ctx.SystemLogs.Where(Function(l) l.CreateDate > startDate).ToList
            Else
                Return ctx.SystemLogs.OrderByDescending(Function(l) l.LogId).Take(100).OrderBy(Function(l) l.LogId).ToList
            End If
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
        OpenData
    End Enum
End Class

Imports System.Threading

Partial Public Class SystemLog

    Public Shared Function Log(title As String, description As String, category As LogCategory, bble As String, createBy As String) As Integer
        Return Log(title, description, category.ToString, bble, createBy)
    End Function

    ''' <summary>
    ''' Return system log object by log Id
    ''' </summary>
    ''' <param name="logId">Log Id</param>
    ''' <returns></returns>
    Public Shared Function GetLog(logId As Integer) As SystemLog
        Using ctx As New CoreEntities
            Return ctx.SystemLogs.Find(logId)
        End Using
    End Function

    ''' <summary>
    ''' Add the log to system
    ''' </summary>
    ''' <param name="title">Log Title</param>
    ''' <param name="description">Log Description</param>
    ''' <param name="category">Category</param>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="createBy">Create User</param>
    Public Shared Function Log(title As String, description As String, category As String, bble As String, createBy As String) As Integer
        Try
            Using ctx As New CoreEntities
                Dim lg As New SystemLog
                lg.Title = title
                lg.BBLE = bble
                lg.Description = description
                lg.Category = category
                lg.CreateDate = DateTime.Now
                lg.CreateBy = createBy

                ctx.SystemLogs.Add(lg)
                ctx.SaveChanges()

                Return lg.LogId
            End Using
        Catch ex As Exception

        End Try

        Return -1
    End Function

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

    ''' <summary>
    ''' Return system logs without description information
    ''' </summary>
    ''' <param name="title">Log title</param>
    ''' <param name="bble">property bble</param>
    ''' <returns></returns>
    Public Shared Function GetLightLogsByBBLE(title As String, bble As String) As SystemLog()

        Using ctx As New CoreEntities
            Dim result = (From log In ctx.SystemLogs.Where(Function(l) l.Title = title AndAlso l.BBLE = bble)
                          Select New With {log.BBLE, log.Category, log.CreateBy, log.CreateDate, log.LogId, log.Title}).ToList

            Return result.Select(Function(lg)
                                     Return New SystemLog With {
                                     .BBLE = lg.BBLE,
                                     .Category = lg.Category,
                                     .CreateBy = lg.CreateBy,
                                     .CreateDate = lg.CreateDate,
                                     .Title = lg.Title,
                                     .LogId = lg.LogId
                                     }
                                 End Function).ToArray
        End Using
    End Function



    Public Shared Function GetLastLogs(title As String, endDate As DateTime, bble As String) As SystemLog
        Using ctx As New CoreEntities
            Return ctx.SystemLogs.Where(Function(l) l.Title = title And l.CreateDate < endDate And l.BBLE = bble).OrderByDescending(Function(l) l.CreateDate).Take(1).FirstOrDefault
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

    Public Shared Function LogError(title As String, ex As Exception, url As String, createby As String, bble As String) As Integer

        If TypeOf ex Is ThreadAbortException Then
            Return -1
        End If

        Try
            Return Log(title, String.Format("Message:{0}, Request URL: {2}. Stack: {1}", ex.Message, ex.ToJsonString, url), LogCategory.Error, bble, createby)
        Catch exp As Exception

        End Try

        Return -1
    End Function

    Public Enum LogCategory
        [Error]
        Operation
        SaveData
        OpenData
    End Enum
End Class

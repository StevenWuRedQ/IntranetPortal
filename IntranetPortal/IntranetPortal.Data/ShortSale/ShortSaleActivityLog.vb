Partial Public Class ShortSaleActivityLog

    Public Shared Sub ClearLogs(bble As String)
        Using ctx As New ShortSaleEntities
            Dim logs = ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble).ToList
            ctx.ShortSaleActivityLogs.RemoveRange(logs)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Sub AddLog(bble As String, source As String, activityType As String, activityTitle As String, description As String)
        Dim log As New ShortSaleActivityLog
        log.BBLE = bble
        log.ActivityDate = DateTime.Now
        log.Source = source
        log.ActivityType = activityType
        log.ActivityTitle = activityTitle
        log.Description = description

        AddLogs({log})
    End Sub

    Public Shared Sub AddLogs(logs As ShortSaleActivityLog())
        Using ctx As New ShortSaleEntities
            ctx.ShortSaleActivityLogs.AddRange(logs)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetLogs(bble As String) As List(Of ShortSaleActivityLog)
        Using ctx As New ShortSaleEntities
            Return ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble).OrderByDescending(Function(l) l.ActivityDate).ToList
        End Using
    End Function

    Public Shared Function LastActivityLog(bble As String) As ShortSaleActivityLog
        Using ctx As New ShortSaleEntities
            Return ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble).OrderByDescending(Function(l) l.ActivityDate).LastOrDefault
        End Using
    End Function
End Class

Partial Public Class ShortSaleActivityLog

    Public Shared Sub ClearLogs(bble As String)
        Using ctx As New PortalEntities
            Dim logs = ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble).ToList
            ctx.ShortSaleActivityLogs.RemoveRange(logs)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Sub AddLog(bble As String, source As String, activityType As String, activityTitle As String, description As String, appId As Integer)
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
        Using ctx As New PortalEntities
            ctx.ShortSaleActivityLogs.AddRange(logs)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetLogs(bble As String, appId As Integer) As List(Of ShortSaleActivityLog)
        Using ctx As New PortalEntities
            Return ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble AndAlso l.AppId = appId).OrderByDescending(Function(l) l.ActivityDate).ToList
        End Using
    End Function

    Public Shared Function LastActivityLog(bble As String, appId As Integer) As ShortSaleActivityLog
        Using ctx As New PortalEntities
            Return ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble).OrderByDescending(Function(l) l.ActivityDate).FirstOrDefault
        End Using
    End Function
End Class

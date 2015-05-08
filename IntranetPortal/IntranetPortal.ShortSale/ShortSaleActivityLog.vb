Partial Public Class ShortSaleActivityLog

    Public Shared Sub ClearLogs(bble As String)
        Using ctx As New ShortSaleEntities
            Dim logs = ctx.ShortSaleActivityLogs.Where(Function(l) l.BBLE = bble).ToList
            ctx.ShortSaleActivityLogs.RemoveRange(logs)
            ctx.SaveChanges()
        End Using
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
End Class

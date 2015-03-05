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
End Class

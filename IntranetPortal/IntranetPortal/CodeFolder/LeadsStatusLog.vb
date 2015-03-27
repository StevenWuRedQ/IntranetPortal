Partial Public Class LeadsStatusLog
    Public Shared Function AddNew(bble As String, type As LogType, userName As String, createBy As String, description As String) As LeadsStatusLog
        Using ctx As New Entities
            'Dim log As New LeadsStatusLog
            'log.BBLE = bble
            'log.Type = type
            'log.Employee = userName
            'log.CreateDate = DateTime.Now
            'log.CreateBy = If(String.IsNullOrEmpty(createBy), "Portal", createBy)
            'ctx.LeadsStatusLogs.Add(log)

            Dim log = AddNewEntity(bble, type, userName, createBy, description, ctx)
            ctx.SaveChanges()

            Return log
        End Using
    End Function

    Public Shared Function AddNewEntity(bble As String, type As LogType, userName As String, createBy As String, description As String, ctx As Entities) As LeadsStatusLog
        Dim log As New LeadsStatusLog
        log.BBLE = bble
        log.Type = type
        log.Employee = userName
        log.Description = description
        log.CreateDate = DateTime.Now
        log.CreateBy = If(String.IsNullOrEmpty(createBy), "Portal", createBy)

        ctx.LeadsStatusLogs.Add(log)

        Return log
    End Function

    Public Enum LogType
        NewLeads = 0
        InProcess = 1
        Closed = 2
        Recycled = 3
        DeadLeads = 4
    End Enum
End Class

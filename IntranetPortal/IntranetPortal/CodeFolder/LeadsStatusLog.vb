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

    ''' <summary>
    ''' Return the amount the new leads logs in the given period and the group of user
    ''' </summary>
    ''' <param name="userNames">the list of user</param>
    ''' <param name="startDate">the start date</param>
    ''' <param name="endDate">the end date</param>
    ''' <returns></returns>
    Public Shared Function GetNewLeadsCreatedCount(userNames As String(), startDate As DateTime, endDate As DateTime) As Integer
        Using ctx As New Entities

            Dim result = ctx.LeadsStatusLogs.Where(Function(l) userNames.Contains(l.CreateBy) And l.Type = LogType.CreateNew And l.CreateDate > startDate AndAlso l.CreateDate < endDate)
            Return result.Count

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

    Public Sub Delete()
        Using ctx As New Entities

            ctx.Entry(Me).State = Entity.EntityState.Deleted
            ctx.SaveChanges()

        End Using
    End Sub

    Public Enum LogType
        NewLeads = 0
        InProcess = 1
        Closed = 2
        Recycled = 3
        DeadLeads = 4
        CreateNew = 5
    End Enum
End Class

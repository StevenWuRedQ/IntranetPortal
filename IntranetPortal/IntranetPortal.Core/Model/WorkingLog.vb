Public Class WorkingLog

    Public ReadOnly Property Duration As TimeSpan
        Get
            If Status = WorkingLogStatus.Closed Then
                Return EndTime - StartTime
            End If

            Return Nothing
        End Get
    End Property

    Public Shared Function Instance(logid As Integer) As WorkingLog
        Using ctx As New CoreEntities
            Return ctx.WorkingLogs.Find(logid)
        End Using
    End Function

    Public Shared Function GetLogs(bble As String, category As String) As WorkingLog()
        Using ctx As New CoreEntities
            Dim result = ctx.WorkingLogs.Where(Function(l) l.BBLE = bble AndAlso l.Category = category AndAlso l.Status = WorkingLogStatus.Closed).ToArray

            Return result
        End Using
    End Function

    Public Shared Function Instance(bble As String, category As String, pageUrl As String) As WorkingLog
        Using ctx As New CoreEntities
            Return ctx.WorkingLogs.FirstOrDefault(Function(l) l.BBLE = bble AndAlso l.Category = category AndAlso l.PageUrl = pageUrl AndAlso l.Status = WorkingLogStatus.Active)
        End Using
    End Function

    Public Sub Close()
        If Me.Status = WorkingLogStatus.Active Then
            Me.Status = WorkingLogStatus.Closed
            Me.EndTime = DateTime.Now
            Me.Save()
        End If
    End Sub

    Public Shared Function Exist(connectionId As String, bble As String, category As String, pageUrl As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.WorkingLogs.Any(Function(l) l.ConnectionId = connectionId AndAlso l.BBLE = bble AndAlso l.Category = category AndAlso l.PageUrl = pageUrl AndAlso l.Status = WorkingLogStatus.Active)
        End Using
    End Function

    Public Shared Function Exist(connectionId As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.WorkingLogs.Any(Function(l) l.ConnectionId = connectionId AndAlso l.Status = WorkingLogStatus.Active)
        End Using
    End Function

    Public Shared Function Exist(bble As String, category As String, pageUrl As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.WorkingLogs.Any(Function(l) l.BBLE = bble AndAlso l.Category = category AndAlso l.PageUrl = pageUrl AndAlso l.Status = WorkingLogStatus.Active)
        End Using
    End Function

    Public Shared Function Instance(connectionId As String) As WorkingLog
        Using ctx As New CoreEntities
            Return ctx.WorkingLogs.FirstOrDefault(Function(l) l.ConnectionId = connectionId AndAlso l.Status = WorkingLogStatus.Active)
        End Using
    End Function

    Public Shared Sub CloseAll()
        Using ctx As New CoreEntities
            Dim logs = ctx.WorkingLogs.Where(Function(l) l.Status = WorkingLogStatus.Active).ToList

            For Each log In logs
                log.EndTime = DateTime.Now
                log.Status = WorkingLogStatus.Closed

            Next

            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Save()
        Using db As New CoreEntities
            If db.WorkingLogs.Any(Function(l) l.LogId = LogId) Then
                db.Entry(Me).State = Entity.EntityState.Modified
            Else
                db.WorkingLogs.Add(Me)
            End If

            db.SaveChanges()
        End Using
    End Sub

    Public Enum WorkingLogStatus
        Active
        Closed
    End Enum
End Class

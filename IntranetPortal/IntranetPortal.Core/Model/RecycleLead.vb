

Partial Public Class RecycleLead

    Public Shared Function GetInstance(recycleId As Integer) As RecycleLead
        Using ctx As New CoreEntities
            Return ctx.RecycleLeads.Find(recycleId)
        End Using
    End Function

    Public Shared Function GetInstanceByLogId(logId As Integer) As RecycleLead
        Using ctx As New CoreEntities
            Return ctx.RecycleLeads.Where(Function(r) r.LogId = logId).FirstOrDefault
        End Using
    End Function

    Public Shared Function AddRecycle(rLeads As RecycleLead) As RecycleLead
        Using ctx As New CoreEntities
            ctx.RecycleLeads.Add(rLeads)
            ctx.SaveChanges()

            Return rLeads
        End Using
    End Function

    Public Shared Function InRecycle(bble As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.RecycleLeads.Any(Function(r) r.BBLE = bble And (r.Status = RecycleStatus.Active Or r.Status = RecycleStatus.Postponed))
        End Using
    End Function

    Public Shared Function GetActiveRecycleLeads() As List(Of RecycleLead)
        Using ctx As New CoreEntities
            Dim sDate = DateTime.Today.AddDays(1)
            Return ctx.RecycleLeads.Where(Function(r) (r.Status = RecycleStatus.Active Or r.Status = RecycleStatus.Postponed) And r.RecycleDate < sDate).ToList
        End Using
    End Function

    Public Shared Function AddRecycle(bble As String, recycleDate As DateTime, logId As Integer) As RecycleLead
        Using ctx As New CoreEntities
            Dim rLead = New Core.RecycleLead
            rLead.BBLE = bble
            rLead.CreateDate = DateTime.Now
            rLead.LogId = logId
            rLead.RecycleDate = recycleDate
            rLead.Status = RecycleStatus.Active

            ctx.RecycleLeads.Add(rLead)
            ctx.SaveChanges()

            Return rLead
        End Using
    End Function

    Public Function PostponeDays(days As Integer) As DateTime
        Using ctx As New CoreEntities
            Dim ld = ctx.RecycleLeads.Find(RecycleId)
            ld.RecycleDate = WorkingHours.AddWorkDays(RecycleDate.Value, days)
            ld.Status = RecycleStatus.Postponed
            ctx.SaveChanges()

            Return ld.RecycleDate
        End Using
    End Function

    Public Sub Recycle()
        Using ctx As New CoreEntities
            Dim ld = ctx.RecycleLeads.Find(RecycleId)
            ld.Status = RecycleStatus.Recycled
            ld.ActionDate = DateTime.Now
            ld.Recycled = True
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Expire()
        Using ctx As New CoreEntities
            Dim ld = ctx.RecycleLeads.Find(RecycleId)
            ld.Status = RecycleStatus.Expired
            ld.ActionDate = DateTime.Now
            ctx.SaveChanges()
        End Using
    End Sub

    Public Enum RecycleStatus
        Active
        Postponed
        Expired
        Recycled
    End Enum

End Class

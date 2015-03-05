Partial Public Class PendingAssignLead

    Public Shared Function GetAllPendingLeads() As List(Of PendingAssignLead)
        Using ctx As New Entities
            Return ctx.PendingAssignLeads.Where(Function(s) s.Status = PendingStatus.Active).ToList
        End Using
    End Function

    Public Shared Function GetInLoopLeads() As List(Of PendingAssignLead)
        Using ctx As New Entities
            Return ctx.PendingAssignLeads.Where(Function(s) s.Status = PendingStatus.InLoop).ToList
        End Using
    End Function

    'Public Sub Assign()
    '    'If ld Is Nothing Then
    '    '    ld = DataWCFService.UpdateAssessInfo(BBLE)
    '    'End If

    '    'DataWCFService.UpdateLeadInfo(BBLE, False, False, False, False, False, False, True)
    '    Dim ld = LeadsInfo.GetInstance(BBLE)
    '    ld.AssignTo(EmployeeName, CreateBy)
    '    Finish()
    'End Sub

    Public Sub Update(status As PendingStatus)
        Using ctx As New Entities
            Dim pLd = ctx.PendingAssignLeads.Find(BBLE)
            If pLd IsNot Nothing Then
                pLd.Status = status
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Public Sub Finish()
        Using ctx As New Entities
            Dim pLd = ctx.PendingAssignLeads.Find(BBLE)
            If pLd IsNot Nothing Then
                pLd.Status = PendingStatus.Complete
                pLd.FinishDate = DateTime.Now
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Enum PendingStatus
        Active
        InLoop
        Complete
    End Enum
End Class

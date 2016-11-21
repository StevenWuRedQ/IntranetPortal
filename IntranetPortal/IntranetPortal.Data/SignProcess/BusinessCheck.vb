
''' <summary>
''' The business check object
''' </summary>
Partial Public Class BusinessCheck

    ''' <summary>
    ''' Get business check instance
    ''' </summary>
    ''' <param name="checkId">The id of check instance</param>
    ''' <returns></returns>
    Public Shared Function GetInstance(checkId As Integer) As BusinessCheck
        Using ctx As New PortalEntities
            Return ctx.BusinessChecks.Find(checkId)
        End Using
    End Function

    ''' <summary>
    ''' Complete the check
    ''' </summary>
    ''' <param name="amount">The confirmed Amount</param>
    ''' <param name="checkNo">Check No.</param>
    ''' <param name="completeBy">The user who processed check</param>
    Public Sub Complete(amount As Decimal, checkNo As String, completeBy As String)
        Me.ConfirmedAmount = amount
        Me.ProcessedBy = completeBy
        Me.CheckNo = checkNo
        Me.ProcessedDate = DateTime.Now
        Me.Status = CheckStatus.Processed
        Me.Save(completeBy)
    End Sub

    ''' <summary>
    ''' Cancel the check
    ''' </summary>
    ''' <param name="comments">The comments to cancel</param>
    ''' <param name="cancelBy">The user who cancel the check</param>
    Public Sub Cancel(comments As String, cancelBy As String)
        Me.Comments = comments
        Me.CancelBy = cancelBy
        Me.CancelDate = DateTime.Now
        Me.Status = CheckStatus.Canceled
        Me.Save(cancelBy)
    End Sub

    Public Sub Save(saveby As String)
        Using ctx As New PortalEntities

            If Me.Date = DateTime.MinValue Then
                Me.Date = DateTime.Now
            End If

            If ctx.BusinessChecks.Any(Function(cr) cr.CheckId = Me.CheckId) Then
                Me.UpdateBy = saveby
                Me.UpdateDate = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.Entry(Me).OriginalValues.SetValues(ctx.Entry(Me).GetDatabaseValues)
            Else
                Me.Status = CheckStatus.Active
                Me.CreateBy = saveby
                Me.CreateDate = DateTime.Now
                ctx.BusinessChecks.Add(Me)
            End If

            ctx.SaveChanges(saveby)
        End Using
    End Sub

    Public Sub Delete()
        Using ctx As New PortalEntities
            If ctx.BusinessChecks.Any(Function(r) r.CheckId = CheckId) Then
                ctx.Entry(Me).State = Entity.EntityState.Deleted
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Public Enum CheckStatus
        Active = 0
        Canceled = 1
        Processed = 2
        Completed = 3
    End Enum

End Class

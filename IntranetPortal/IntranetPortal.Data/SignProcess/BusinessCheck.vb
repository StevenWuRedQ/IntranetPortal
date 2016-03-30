Partial Public Class BusinessCheck

    Public Shared Function GetInstance(checkId As Integer) As BusinessCheck
        Using ctx As New PortalEntities
            Return ctx.BusinessChecks.Find(checkId)
        End Using
    End Function

    Public Sub Save(saveby As String)
        Using ctx As New PortalEntities
            If ctx.BusinessChecks.Any(Function(cr) cr.CheckId = Me.CheckId) Then
                Me.UpdateBy = saveby
                Me.UpdateDate = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = saveby
                Me.CreateDate = DateTime.Now
                ctx.BusinessChecks.Add(Me)
            End If

            ctx.SaveChanges()
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

End Class

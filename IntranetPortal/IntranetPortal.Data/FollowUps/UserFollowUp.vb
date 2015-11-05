Public Class UserFollowUp

    Public Shared Function Instance(bble As String, userName As String, type As Integer) As UserFollowUp
        Using ctx As New ConstructionEntities
            Return ctx.UserFollowUps.Where(Function(u) u.BBLE = bble And u.Type = type And u.UserName = userName).FirstOrDefault
        End Using
    End Function

    Public Sub SaveData(saveBy As String)
        Using ctx As New ConstructionEntities
            If ctx.UserFollowUps.Any(Function(t) t.BBLE = BBLE And t.Type = Type And t.UserName = UserName) Then
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now

                ctx.UserFollowUps.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub
End Class

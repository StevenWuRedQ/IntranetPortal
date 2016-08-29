Public Class UserFollowUp

    Public Shared Function Instance(followUpId As Integer) As UserFollowUp
        Using ctx As New PortalEntities
            Return ctx.UserFollowUps.Find(followUpId)
        End Using
    End Function

    Public Shared Function Instance(bble As String, userName As String, type As Integer) As UserFollowUp
        Using ctx As New PortalEntities
            Dim followup = ctx.UserFollowUps.Where(Function(u) u.BBLE = bble And u.Type = type And u.UserName = userName And u.Status = FollowUpStatus.Active).FirstOrDefault
            If followup Is Nothing Then
                followup = New UserFollowUp
                followup.BBLE = bble
                followup.UserName = userName
                followup.Type = type
            End If

            Return followup
        End Using
    End Function

    Public Sub Clear(clearBy As String)
        Me.Status = FollowUpStatus.Cleared
        Me.UpdateBy = clearBy
        Me.UpdateTime = DateTime.Now
        Me.SaveData(clearBy)
    End Sub

    Public Sub Create(createBy As String)
        Complete(createBy)
        SaveData(createBy)
    End Sub

    Private Sub Complete(completeBy As String)
        Using ctx As New PortalEntities
            If ctx.UserFollowUps.Any(Function(t) t.BBLE = BBLE And t.Type = Type And t.UserName = UserName And (t.Status = FollowUpStatus.Active Or Not t.Status.HasValue)) Then
                For Each item In ctx.UserFollowUps.Where(Function(t) t.BBLE = BBLE And t.Type = Type And t.UserName = UserName And t.Status = FollowUpStatus.Active).ToList
                    item.Status = FollowUpStatus.Completed
                    item.UpdateBy = CreateBy
                    item.UpdateTime = DateTime.Now
                Next

                ctx.SaveChanges()
            End If

            ctx.SaveChanges()
        End Using

    End Sub

    ''' <summary>
    ''' Get user's all follow ups
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns></returns>
    Public Shared Function GetMyFollowUps(userName As String) As List(Of UserFollowUp)
        Using ctx As New PortalEntities
            Dim followups = ctx.UserFollowUps.Where(Function(u) u.UserName = userName And u.Status = FollowUpStatus.Active).ToList
            Return followups
        End Using
    End Function

    ''' <summary>
    ''' Get user's all follow ups
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns></returns>
    Public Shared Function GetMyTitleFollowUps(userName As String) As List(Of TitleCase)
        Using ctx As New PortalEntities
            Dim result = From fu In ctx.UserFollowUps.Where(Function(u) u.UserName = userName And u.Status = FollowUpStatus.Active)
                         Join t In ctx.TitleCases On fu.BBLE Equals t.BBLE
                         Where fu.Type = 15
                         Select t

            Return result.Distinct.ToList
        End Using
    End Function

    ''' <summary>
    ''' Get user's today's follow ups
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns></returns>
    Public Shared Function GetTodayFollowUps(userName As String) As List(Of UserFollowUp)
        Using ctx As New PortalEntities
            Dim dt = DateTime.Today.AddDays(1)
            Dim followups = ctx.UserFollowUps.Where(Function(u) u.UserName = userName AndAlso u.Status = FollowUpStatus.Active AndAlso u.FollowUpDate < dt).OrderBy(Function(u) u.FollowUpDate).ToList
            Return followups
        End Using
    End Function

    Public Sub SaveData(saveBy As String)

        Using ctx As New PortalEntities
            If ctx.UserFollowUps.Any(Function(t) t.BBLE = BBLE And t.Type = Type And t.UserName = UserName And t.Status = FollowUpStatus.Active) Then
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now
                Me.Status = FollowUpStatus.Active
                ctx.UserFollowUps.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Enum FollowUpStatus
        Active
        Completed
        Cleared
    End Enum
End Class

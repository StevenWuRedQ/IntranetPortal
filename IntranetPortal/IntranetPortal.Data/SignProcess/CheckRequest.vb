
''' <summary>
''' The CheckRequest Object
''' </summary>
Public Class CheckRequest

    ''' <summary>
    ''' The Check list
    ''' </summary>
    ''' <returns></returns>
    Public Property Checks As List(Of BusinessCheck)

    ''' <summary>
    ''' Return check request instance
    ''' </summary>
    ''' <param name="id">The instance id</param>
    ''' <returns></returns>
    Public Shared Function GetInstance(id As Integer) As CheckRequest

        Using ctx As New PortalEntities

            Dim cr = ctx.CheckRequests.Find(id)
            cr.Checks = ctx.BusinessChecks.Where(Function(c) c.RequestId = cr.RequestId).ToList

            Return cr
        End Using
    End Function

    ''' <summary>
    ''' Create a new Check Request
    ''' </summary>
    ''' <param name="saveBy"></param>
    Public Sub Create(saveBy As String)
        Using ctx As New PortalEntities

            Me.RequestBy = saveBy
            Me.RequestDate = DateTime.Now
            Me.CheckAmount = Checks.Sum(Function(c) c.Amount)

            ctx.CheckRequests.Add(Me)
            ctx.SaveChanges()

            For Each check In Checks
                check.RequestId = RequestId
                check.Save(saveBy)
            Next
        End Using
    End Sub

    ''' <summary>
    ''' Saving the check request
    ''' </summary>
    ''' <param name="saveBy"></param>
    Public Sub Save(saveBy As String)
        Using ctx As New PortalEntities
            If ctx.CheckRequests.Any(Function(cr) cr.RequestId = Me.RequestId) Then
                Me.UpdateBy = saveBy
                Me.UpdateDate = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.RequestBy = saveBy
                Me.RequestDate = DateTime.Now
                ctx.CheckRequests.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    ''' <summary>
    ''' Delete the instance
    ''' </summary>
    Public Sub Delete()
        Using ctx As New PortalEntities
            If ctx.CheckRequests.Any(Function(r) r.RequestId = RequestId) Then
                ctx.Entry(Me).State = Entity.EntityState.Deleted

                Dim checks = ctx.BusinessChecks.Where(Function(b) b.RequestId = RequestId)
                ctx.BusinessChecks.RemoveRange(checks)

                ctx.SaveChanges()
            End If
        End Using

    End Sub


End Class

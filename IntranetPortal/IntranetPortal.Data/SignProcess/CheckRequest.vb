
''' <summary>
''' The CheckRequest Object
''' </summary>
Public Class CheckRequest

    ''' <summary>
    ''' The Check list
    ''' </summary>
    ''' <returns></returns>
    Public Property Checks As List(Of BusinessCheck)
    Public Property PropertyAddress As String

    ''' <summary>
    ''' Load all check request list
    ''' </summary>
    ''' <returns>The check request array</returns>
    Public Shared Function GetRequests() As CheckRequest()
        Using ctx As New PortalEntities
            Dim result = From ck In ctx.CheckRequests
                         From li In ctx.ShortSaleLeadsInfoes.Where(Function(li) li.BBLE = ck.BBLE).DefaultIfEmpty
                         Let checks = ctx.BusinessChecks.Where(Function(b) b.RequestId = ck.RequestId)
                         Select ck, checks, li.PropertyAddress

            Return result.ToList.Select(Function(s)
                                            s.ck.Checks = s.checks.ToList
                                            s.ck.PropertyAddress = s.PropertyAddress
                                            Return s.ck
                                        End Function).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Return check request instance
    ''' </summary>
    ''' <param name="id">The instance id</param>
    ''' <returns></returns>
    Public Shared Function GetInstance(id As Integer) As CheckRequest

        Using ctx As New PortalEntities

            Dim cr = ctx.CheckRequests.Find(id)

            If cr IsNot Nothing Then
                cr.Checks = ctx.BusinessChecks.Where(Function(c) c.RequestId = cr.RequestId).ToList
                cr.PropertyAddress = ctx.ShortSaleLeadsInfoes.Where(Function(li) li.BBLE = cr.BBLE).Select(Function(li) li.PropertyAddress).FirstOrDefault
                Return cr
            End If

            Return Nothing
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
            ctx.SaveChanges(saveBy)

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
                Me.CheckAmount = Checks.Where(Function(c) Not c.Status.HasValue OrElse c.Status <> BusinessCheck.CheckStatus.Canceled).Sum(Function(c) c.Amount)

                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.Entry(Me).OriginalValues.SetValues(ctx.Entry(Me).GetDatabaseValues)
            Else
                Me.RequestBy = saveBy
                Me.RequestDate = DateTime.Now
                ctx.CheckRequests.Add(Me)
            End If

            ctx.SaveChanges(saveBy)
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

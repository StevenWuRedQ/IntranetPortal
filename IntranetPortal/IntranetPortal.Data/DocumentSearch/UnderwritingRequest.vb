''' <summary>
''' The UnderwritingRequest Object
''' </summary>
Partial Public Class UnderwritingRequest

    Public ReadOnly Property Status As Integer
        Get
            Using ctx As New PortalEntities
                Dim r = From c In ctx.LeadInfoDocumentSearches
                        Where c.BBLE = BBLE
                Return r.Count
            End Using
        End Get

    End Property

    ''' <summary>
    ''' Return UnderwritingRequest instance by Id
    ''' </summary>
    ''' <param name="id">The Instance Id</param>
    ''' <returns></returns>
    Public Shared Function GetInstance(id As Integer) As UnderwritingRequest
        Using ctx As New PortalEntities
            Return ctx.UnderwritingRequests.Find(id)
        End Using
    End Function

    ''' <summary>
    ''' Return UnderwritingRequest instance by property BBLE
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <returns></returns>
    Public Shared Function GetInstance(bble As String) As UnderwritingRequest
        If String.IsNullOrEmpty(bble)
            Return Nothing
        End If
        Using ctx As New PortalEntities
            Return ctx.UnderwritingRequests.Where(Function(ur) ur.BBLE = bble).FirstOrDefault
        End Using
    End Function

    ''' <summary>
    ''' Save the data
    ''' </summary>
    ''' <param name="saveBy"></param>
    Public Sub Save(saveBy As String)
        Using ctx As New PortalEntities
            If ctx.UnderwritingRequests.Any(Function(r) r.Id = Id) Then
                Me.UpdateDate = DateTime.Now
                Me.UpdateBy = saveBy

                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.Entry(Me).OriginalValues.SetValues(ctx.Entry(Me).GetDatabaseValues)
            Else
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now
                ctx.UnderwritingRequests.Add(Me)
            End If
            ctx.SaveChanges(saveBy)
        End Using
    End Sub
End Class

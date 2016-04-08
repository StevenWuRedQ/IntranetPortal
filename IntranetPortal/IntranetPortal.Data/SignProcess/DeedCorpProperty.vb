Public Class DeedCorpProperty

    ''' <summary>
    ''' Assign the deedcorp to property
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <param name="entityId">The entity Id</param>
    ''' <param name="assignBy">The user who assigned this property</param>
    ''' <returns>The new DeedCorpProperty</returns>
    Public Shared Function Assign(bble As String, entityId As Integer, assignBy As String) As DeedCorpProperty

        Using ctx As New PortalEntities

            If ctx.DeedCorpProperties.Any(Function(dp) dp.BBLE = bble AndAlso dp.Status = PropStatus.Assigned) Then
                Throw New Exception("The property had already assigned.")
            End If

            Dim prop As New DeedCorpProperty
            prop.BBLE = bble
            prop.EntityId = entityId
            prop.Status = PropStatus.Assigned
            prop.AssignBy = assignBy
            prop.AssignDate = DateTime.Now

            ctx.DeedCorpProperties.Add(prop)
            ctx.SaveChanges()

            Return prop
        End Using
    End Function


    ''' <summary>
    ''' Save DeedCorpProperty data
    ''' </summary>
    ''' <param name="saveBy"></param>
    Public Sub Save(saveBy As String)

        Using ctx As New PortalEntities

            If ctx.DeedCorpProperties.Any(Function(cr) cr.Id = Id) Then

                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                ctx.DeedCorpProperties.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    ''' <summary>
    ''' Used for unit test
    ''' </summary>
    Public Sub Delete()
        Using ctx As New PortalEntities
            If AssignBy = "Test" Then

                ctx.Entry(Me).State = Entity.EntityState.Deleted
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Public Enum PropStatus
        Assigned
        Recorded
        Withdrawed
        Completed
    End Enum

End Class

Public Class CleareneceNote
    Public Sub Save()
        Using context As New PortalEntities
            Dim obj = context.CleareneceNotes.Find(NoteId)

            If obj Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class

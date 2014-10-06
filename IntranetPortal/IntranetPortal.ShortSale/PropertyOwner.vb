Partial Public Class PropertyOwner

    Public Property DataStatus As ModelStatus

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyOwners.Find(BBLE, FirstName, LastName)

            If obj Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else

                If DataStatus = ModelStatus.Deleted Then
                    context.PropertyOwners.Remove(obj)
                Else
                    obj = ShortSaleUtility.SaveChangesObj(obj, Me)
                End If
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class

Partial Public Class PropertyOwner
    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyOwners.Find(BBLE, FirstName, LastName)

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

Public Class PropertyFloor
    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyFloors.Find(BBLE, FloorId)

            If obj Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub

    Public Shared Sub Delete(bble As String, floorId As Integer)
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyFloors.Find(bble, floorId)

            If obj IsNot Nothing Then
                context.PropertyFloors.Remove(obj)
                context.SaveChanges()
            End If
        End Using
    End Sub
End Class

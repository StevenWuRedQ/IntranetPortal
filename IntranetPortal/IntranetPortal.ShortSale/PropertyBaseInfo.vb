Partial Public Class PropertyBaseInfo

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = context.PropertyBaseInfoes.Find(BBLE)
            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                UpdateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Modified
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class

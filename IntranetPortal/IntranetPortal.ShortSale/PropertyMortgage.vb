Partial Public Class PropertyMortgage

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = context.PropertyMortgages.Find(MortgageId)

            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                pbi = Utility.SaveChangesObj(pbi, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class

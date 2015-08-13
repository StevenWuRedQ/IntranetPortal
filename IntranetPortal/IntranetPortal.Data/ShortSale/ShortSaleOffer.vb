Partial Public Class ShortSaleOffer

    Public Shared Function GetOffers(bble As String) As List(Of ShortSaleOffer)
        Using ctx As New ShortSaleEntities
            Return ctx.ShortSaleOffers.Where(Function(so) so.BBLE = bble).ToList
        End Using
    End Function

    Public Sub Save(saveBy As String)
        Using context As New ShortSaleEntities
            'context.ShortSaleCases.Attach(Me)
            If OfferId = 0 Then
                Me.CreateDate = DateTime.Now
                Me.CreateBy = saveBy
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.ShortSaleOffers.Find(OfferId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class

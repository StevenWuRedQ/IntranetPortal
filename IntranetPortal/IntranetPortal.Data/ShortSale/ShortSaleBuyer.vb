Partial Public Class ShortSaleBuyer

    Public Shared Function Instance(bble As String) As ShortSaleBuyer
        Using ctx As New PortalEntities
            Dim result = ctx.ShortSaleBuyers.Find(bble)
            If result Is Nothing Then
                result = New ShortSaleBuyer With {
                    .BBLE = bble
                    }
            End If

            Return result
        End Using
    End Function

    Public Sub Save(Optional saveby As String = Nothing)
        Using context As New PortalEntities
            'context.ShortSaleCases.Attach(Me)
            If Not context.ShortSaleBuyers.Any(Function(ss) ss.BBLE = BBLE) Then
                CreateDate = DateTime.Now
                Me.CreateBy = saveby
                context.ShortSaleBuyers.Add(Me)
            Else
                context.Entry(Me).State = System.Data.Entity.EntityState.Modified
                ' context.Entry(Me).OriginalValues.SetValues(context.Entry(Me).GetDatabaseValues)
                ' buyer = ShortSaleUtility.SaveChangesObj(buyer, Me)
            End If

            context.SaveChanges()
        End Using

    End Sub


End Class

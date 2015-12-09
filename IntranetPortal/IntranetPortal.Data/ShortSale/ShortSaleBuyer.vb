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

    Public Sub Save()
        Using context As New PortalEntities
            'context.ShortSaleCases.Attach(Me)
            Dim buyer = context.ShortSaleBuyers.Find(BBLE)

            If buyer Is Nothing Then
                CreateDate = DateTime.Now
                context.ShortSaleBuyers.Add(Me)
            Else
                buyer = ShortSaleUtility.SaveChangesObj(buyer, Me)
            End If

            context.SaveChanges()
        End Using

    End Sub


End Class

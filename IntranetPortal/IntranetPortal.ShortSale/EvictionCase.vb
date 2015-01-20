Partial Public Class EvictionCas

    Public Shared Sub AddEviction(bble As String, name As String, createBy As String)
        Using ctx As New ShortSaleEntities
            Dim evi = ctx.EvictionCases.SingleOrDefault(Function(ev) ev.BBLE = bble)
            If evi Is Nothing Then
                evi = New EvictionCas
                evi.BBLE = bble
                evi.Owner = name
                evi.CreateBy = createBy
                evi.CreateDate = DateTime.Now

                ctx.EvictionCases.Add(evi)
            Else
                evi.Owner = name
            End If

            ctx.SaveChanges()
        End Using
    End Sub

End Class

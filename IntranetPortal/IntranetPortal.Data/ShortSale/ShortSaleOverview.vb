
Public Class ShortSaleOverview

    Public Shared Function LoadOverview(bble As String, Optional category As String = Nothing) As List(Of ShortSaleOverview)
        Using ctx As New ShortSaleEntities
            Return ctx.ShortSaleOverviews.Where(Function(s) s.BBLE = bble And s.Category = category).OrderByDescending(Function(s) s.ActivityDate).ToList
        End Using
    End Function


    Public Shared Function LastOverview(bble As String, category As String) As ShortSaleOverview
        Using ctx As New ShortSaleEntities
            Return ctx.ShortSaleOverviews.Where(Function(s) s.BBLE = bble And s.Category = category).OrderByDescending(Function(s) s.ActivityDate).FirstOrDefault
        End Using
    End Function


    Public Sub Save()

        Using ctx As New ShortSaleEntities

            If LogId = 0 Then
                ctx.Entry(Me).State = Entity.EntityState.Added
            Else
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If

            ctx.SaveChanges()
        End Using
    End Sub


  

End Class

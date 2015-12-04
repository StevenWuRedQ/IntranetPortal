Public Class LegalJudge
    Public Shared Function GetAllJudge() As List(Of LegalJudge)
        Using ctx As New ShortSaleEntities
            Return ctx.LegalJudges.ToList()
        End Using
    End Function


End Class

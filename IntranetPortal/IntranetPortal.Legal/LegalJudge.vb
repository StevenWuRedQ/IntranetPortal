Public Class LegalJudge
    Public Shared Function GetAllJudge() As List(Of LegalJudge)
        Using ctx As New LegalModelContainer
            Return ctx.LegalJudges.ToList()
        End Using
    End Function


End Class

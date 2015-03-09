Partial Public Class Team
    Public Shared Function GetAllTeams() As List(Of Team)
        Using ctx As New Entities
            Return ctx.Teams.ToList
        End Using
    End Function

End Class

Public Class LegalRoboSignor
    Public Shared Function GetAllRoboSignor() As List(Of LegalRoboSignor)
        Using ctx As New LegalModelContainer
            Return ctx.LegalRoboSignors.ToList
        End Using
    End Function
End Class

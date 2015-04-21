Partial Public Class ListProperty

    Public Shared Function GetProperty(bble As String)
        Using ctx As New PublicSiteEntities
            Return ctx.ListProperties.Find(bble)
        End Using
    End Function



End Class

Partial Public Class ListProperty

    Public Shared Function GetProperty(bble As String)
        Using ctx As New PublicSiteEntities
            Return ctx.ListProperties.Find(bble)
        End Using
    End Function

    Public Shared Function GetListedPropertyByOwner(ownerNames As String()) As List(Of ListProperty)
        Using ctx As New PublicSiteEntities
            Return ctx.ListProperties.Where(Function(p) ownerNames.Contains(p.Agent)).ToList
        End Using
    End Function
End Class

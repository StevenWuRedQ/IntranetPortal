
Partial Public Class DataStatu

    Public Shared Function LoadDataStatus(category As String) As List(Of DataStatu)

        Using ctx As New PortalEntities
            Return ctx.DataStatus.Where(Function(ds) ds.Active = True AndAlso ds.Category = category).OrderBy(Function(ds) ds.DisplayOrder).ToList
        End Using
    End Function


    Public Shared Function Instance(category As String, statusId As Integer) As DataStatu
        Using ctx As New PortalEntities
            Return ctx.DataStatus.Find(category, statusId)
        End Using
    End Function


End Class

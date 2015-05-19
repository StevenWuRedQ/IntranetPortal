Public Class CommonData
    Private Shared CacheData As New Dictionary(Of String, List(Of CommonData))

    Public Shared Function GetData(title As String) As List(Of CommonData)
        If CacheData.ContainsKey(title) Then
            Return CacheData(title)
        End If

        Dim result = LoadCommonData(title)
        CacheData.Add(title, result)

        Return result
    End Function

    Private Shared Function LoadCommonData(title As String) As List(Of CommonData)
        Using ctx As New CoreEntities
            Return ctx.CommonDatas.Where(Function(d) d.Title = title).ToList
        End Using
    End Function
End Class

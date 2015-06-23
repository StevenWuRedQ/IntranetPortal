Public Class CommonData
    Private Shared CacheData As New Dictionary(Of String, List(Of CommonData))

    Public Shared Sub RefreshData()

        For Each item In CacheData.Keys.ToList
            CacheData.Item(item) = LoadCommonData(item)
        Next
        'If CacheData.Count > 0 Then
        '    CacheData = New Dictionary(Of String, List(Of CommonData))
        'End If
    End Sub

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

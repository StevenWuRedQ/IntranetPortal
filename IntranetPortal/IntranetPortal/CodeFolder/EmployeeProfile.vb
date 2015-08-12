<Serializable>
Public Class EmployeeProfile
    Public Property DoornockAddress As String
    Public Property UserEmail As String

    Private _recentEmpsData As List(Of String)
    Public Property RecentEmps As List(Of String)
        Get
            If _recentEmpsData Is Nothing Then
                _recentEmpsData = New List(Of String)
            End If

            Return _recentEmpsData
        End Get
        Set(value As List(Of String))
            _recentEmpsData = value
        End Set
    End Property

    Public Function GetData(key As String) As Object
        If EmployeeData Is Nothing Then
            EmployeeData = New Dictionary(Of String, Object)
        End If

        If EmployeeData.ContainsKey(key) Then
            Return EmployeeData(key)
        End If

        Return Nothing
    End Function

    Public Sub SetData(key As String, value As Object)
        If EmployeeData.ContainsKey(key) Then
            EmployeeData(key) = value
        Else
            EmployeeData.Add(key, value)
        End If
    End Sub

    Public Property ReportTemplates As StringDictionary
    Private EmployeeData As New Dictionary(Of String, Object)
End Class

<Serializable>
Public Class ReportTemplate
    Public Property Columns As String
    Public Property GroupBy As String
    Public Property FilterCondition As String
End Class

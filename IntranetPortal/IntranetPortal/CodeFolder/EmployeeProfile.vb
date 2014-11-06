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


    Public Property ReportTemplates As StringDictionary
End Class

<Serializable>
Public Class ReportTemplate
    Public Property Columns As String
    Public Property GroupBy As String
    Public Property FilterCondition As String
End Class

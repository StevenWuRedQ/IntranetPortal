<Serializable>
Public Class EmployeeProfile
    Public Property DoornockAddress As String
    Public Property UserEmail As String

    Public Property ReportTemplates As StringDictionary
End Class

<Serializable>
Public Class ReportTemplate
    Public Property Columns As String
    Public Property GroupBy As String
    Public Property FilterCondition As String
End Class

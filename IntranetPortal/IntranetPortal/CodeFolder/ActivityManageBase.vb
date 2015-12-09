
''' <summary>
''' The base class for activity log manage
''' </summary>
Public Class ActivityManageBase

    Public Property LogCategory As LeadsActivityLog.LogCategory
    Public Property TaskActionList() As String()
    Public Property LogCategoryFilter As LeadsActivityLog.LogCategory()
    Public Property CommentsControl As UserControl
    Public Property CommentsControlName As String

    Public Overridable Function AddComments(bble As String, comments As String, userName As String) As Boolean
        Return False
    End Function

    Public Overridable Function LogDataSource(bble As String) As List(Of LeadsActivityLog)
        Return LeadsActivityLog.GetLeadsActivityLogs(bble, {LogCategory.ToString, LeadsActivityLog.LogCategory.PublicUpdate.ToString})
    End Function
End Class

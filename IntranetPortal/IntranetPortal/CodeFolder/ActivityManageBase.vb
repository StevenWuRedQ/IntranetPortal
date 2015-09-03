

Public Class ActivityManageBase

    Public Property LogCategory As LeadsActivityLog.LogCategory
    Public Property TaskActionList() As String()
    Public Property LogCategoryFilter As LeadsActivityLog.LogCategory()

    Public Overridable Function LogDataSource(bble As String) As List(Of LeadsActivityLog)
        Return LeadsActivityLog.GetLeadsActivityLogs(bble, {LogCategory.ToString, LeadsActivityLog.LogCategory.PublicUpdate.ToString})
    End Function
End Class

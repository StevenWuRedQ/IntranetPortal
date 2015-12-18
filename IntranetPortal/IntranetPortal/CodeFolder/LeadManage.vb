Imports IntranetPortal
''' <summary>
''' Handle lead related action
''' </summary>
Public Class LeadManage
    Inherits ActivityManageBase


#Region "Activitylog Manage"

    Public Sub New()

    End Sub

    Public Sub New(actityLog As Boolean)
        Me.LogCategory = LeadsActivityLog.LogCategory.SalesAgent
        Me.LogCategoryFilter = {LeadsActivityLog.LogCategory.SalesAgent, LeadsActivityLog.LogCategory.Status}
    End Sub

    Public Overrides Function LogDataSource(bble As String) As List(Of LeadsActivityLog)
        Dim categories = Me.LogCategoryFilter.ToList
        Dim subCategories = {LeadsActivityLog.LogCategory.Approval, LeadsActivityLog.LogCategory.Approved, LeadsActivityLog.LogCategory.Appointment,
                             LeadsActivityLog.LogCategory.Declined, LeadsActivityLog.LogCategory.DoorknockTask, LeadsActivityLog.LogCategory.PublicUpdate}
        categories.AddRange(subCategories)

        Return LeadsActivityLog.GetLeadsActivityLogs(bble, categories.Select(Function(a) a.ToString).ToArray)
    End Function

#End Region

End Class

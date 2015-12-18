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
        Me.LogCategoryFilter = {LeadsActivityLog.LogCategory.SalesAgent}
    End Sub
#End Region

End Class

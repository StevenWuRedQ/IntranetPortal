Public Class TitleManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

#Region "Activitylog Manage"
    Private Shared _actionLists = {"Updated pics needed", "Material order update", "Head count", "Document needed"}

    Public Sub New()

    End Sub

    Public Sub New(actityLog As Boolean)
        Me.TaskActionList = _actionLists
        Me.LogCategory = LeadsActivityLog.LogCategory.Title
        Me.LogCategoryFilter = {LeadsActivityLog.LogCategory.Title, LeadsActivityLog.LogCategory.ShortSale}
    End Sub

#End Region



    Public Function GetAmount(navMenu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount

    End Function
End Class

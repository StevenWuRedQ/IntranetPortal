Imports IntranetPortal.Data

Public Class ConstructionManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Construction-Manager"


    Public Shared Sub StartConstruction(bble As String, caseName As String, userName As String)
        If ConstructionCase.GetCase(bble) Is Nothing Then
            Dim cc As New ConstructionCase
            cc.BBLE = bble
            cc.CaseName = caseName

            Dim ccMgr = Roles.GetUsersInRole(MgrRoleName)

            If ccMgr IsNot Nothing AndAlso ccMgr.Length > 0 Then
                cc.Owner = ccMgr(0)
            End If

            cc.Save(userName)
        End If
    End Sub

    Public Shared Function GetCase(bble As String, userName As String) As ConstructionCase
        Return ConstructionCase.GetCase(bble, userName)
    End Function

    Public Shared Function GetMyCases(userName As String) As ConstructionCase()
        If IsManager(userName) Then
            Return ConstructionCase.GetAllCases()
        Else
            Return ConstructionCase.GetAllCases(userName)
        End If
    End Function


    Public Function GetAmount(menu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount

        Return GetMyCases(userName).Length

    End Function


    Public Shared Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") Then
            Return True
        End If

        Return False
    End Function

#Region "Activitylog Manage"
    Private Shared _actionLists = {"Updated pics needed", "Material order update", "Head count", "Document needed"}

    Public Sub New()
        
    End Sub

    Public Sub New(actityLog As Boolean)
        Me.TaskActionList = _actionLists
        Me.LogCategory = LeadsActivityLog.LogCategory.Construction
        Me.LogCategoryFilter = {LeadsActivityLog.LogCategory.Construction, LeadsActivityLog.LogCategory.ShortSale}
    End Sub

#End Region
End Class

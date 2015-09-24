Imports IntranetPortal.Data
Imports Newtonsoft.Json.Linq

Public Class TitleManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Title-Manager"
    Private Const FormName As String = "TitleCase"

    Public Shared Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") OrElse IsViewable(userName) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function IsViewable(userName As String) As Boolean

        Dim roleNames = Core.PortalSettings.GetValue("TitleViewableRoles").Split(";")
        Dim rols = ""
        Dim b = Roles.GetRolesForUser(userName).Select(Function(r) r.Contains(rols)) IsNot Nothing

        Dim myRoles = Roles.GetRolesForUser(userName)

        If myRoles.Any(Function(r) roleNames.Contains(r)) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function IsInTitle(bble As String) As Boolean
        Return TitleCase.Exists(bble)
    End Function

    Public Shared Sub StartTitle(bble As String, caseName As String, userName As String)
        Dim tCase = TitleCase.GetCase(bble)

        If tCase Is Nothing Then
            'tCase = New TitleCase
            'tCase.BBLE = bble
            'tCase.CaseName = caseName
            'tCase.SaveData(userName)

            Dim caseData As New JObject
            caseData.Item("BBLE") = bble
            caseData.Item("CaseName") = caseName
            caseData.Item("Owner") = GetManager()

            Dim dataItem As New FormDataItem
            dataItem.FormName = FormName
            dataItem.FormData = caseData.ToString
            dataItem.Tag = bble
            dataItem.Save(userName)
        End If

        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("Start Title progress."), bble, LeadsActivityLog.LogCategory.PublicUpdate.ToString, LeadsActivityLog.EnumActionType.InProcess)
    End Sub

    Public Shared Function GetManager() As String
        Dim mgrs = Roles.GetUsersInRole(MgrRoleName)
        If mgrs.Count > 0 Then
            Return mgrs(0)
        End If

        Return Nothing
    End Function

    Public Shared Function GetMyCases(userName As String) As TitleCase()
        If IsManager(userName) Then
            Return TitleCase.GetAllCases()
        Else
            Return TitleCase.GetAllCases(userName)
        End If
    End Function

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

        Return GetMyCases(userName).Length

    End Function
End Class

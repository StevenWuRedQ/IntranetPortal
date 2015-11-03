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

    Public Shared Sub AssignTo(bble As String, userName As String, assignBy As String)
        Dim tCase = TitleCase.GetCase(bble)
        tCase.Owner = userName
        tCase.SaveData(assignBy)

        Dim comments = String.Format("The case is assign to {0}.", userName)
        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Title.ToString, LeadsActivityLog.EnumActionType.UpdateInfo)
    End Sub

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

    Public Shared Sub CompleteCase(bble As String, completedBy As String)
        Dim tCase = TitleCase.GetCase(bble)
        tCase.Status = TitleCase.DataStatus.Completed
        tCase.SaveData(completedBy)
    End Sub

    Public Shared Sub UnCompleteCase(bble As String, completedBy As String)
        Dim tcase = TitleCase.GetCase(bble)
        tcase.Status = TitleCase.DataStatus.All
        tcase.SaveData(completedBy)
    End Sub

    Public Shared Sub StartTitle(bble As String, caseName As String, userName As String)
    Public Shared Sub StartTitle(bble As String, caseName As String, userName As String, Optional owner As String = Nothing)
        Dim tCase = TitleCase.GetCase(bble)

        If tCase Is Nothing Then
            'tCase = New TitleCase
            'tCase.BBLE = bble
            'tCase.CaseName = caseName
            'tCase.SaveData(userName)

            Dim caseData As New JObject
            caseData.Item("BBLE") = bble
            caseData.Item("CaseName") = caseName

            If String.IsNullOrEmpty(owner) Then
                owner = GetManager()
            End If

            caseData.Item("Owner") = owner

            Dim dataItem As New FormDataItem
            dataItem.FormName = FormName
            dataItem.FormData = caseData.ToString
            dataItem.Tag = bble
            dataItem.Save(userName)

            LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("Start Title progress."), bble, LeadsActivityLog.LogCategory.PublicUpdate.ToString, LeadsActivityLog.EnumActionType.InProcess)
        Else
            Throw New Exception(caseName & " is already in title.")
        End If
    End Sub

    Public Shared Function GetManager() As String
        Dim mgrs = Roles.GetUsersInRole(MgrRoleName)
        If mgrs.Count > 0 Then
            Return mgrs(0)
        End If

        Return Nothing
    End Function

    Public Shared Function TitleUsers() As String()
        Return Employee.GetRoleUsers("Title-")
    End Function

    Public Shared Function GetMyCases(userName As String, Optional status As TitleCase.DataStatus = TitleCase.DataStatus.All) As TitleCase()
        If IsManager(userName) Then
            Return TitleCase.GetAllCases(status)
        Else
            Return TitleCase.GetAllCases(userName, status)
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
        Select Case navMenu.Name
            Case "Title-All"
                Return GetMyCases(userName).Length
            Case "Title-Completed"
                Return GetMyCases(userName, TitleCase.DataStatus.Completed).Length
            Case Else
                Return 0
        End Select

    End Function
End Class

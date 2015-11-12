Imports IntranetPortal.Data
Imports Newtonsoft.Json.Linq

Public Class TitleManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Title-Manager"
    Public Const FormName As String = "TitleCase"

    Public Shared Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") OrElse IsViewable(userName) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function GetTitleCaseName(bble As String) As String

        If IsInTitle(bble) Then
            Return TitleCase.GetCase(bble).CaseName
        End If

        Return Nothing
    End Function

    Public Shared Function GetTitleOwner(bble As String) As String

        If IsInTitle(bble) Then
            Return TitleCase.GetCase(bble).Owner
        End If

        Return Nothing
    End Function

    Public Shared Sub updateTitleOwner(bble As String, owner As String, assignBy As String)
        Dim tCase = TitleCase.GetCase(bble)

        If tCase.Owner = owner Then
            Return
        End If

        tCase.Owner = owner
        tCase.SaveData(assignBy)
    End Sub


    Public Shared Sub AssignTo(bble As String, userName As String, assignBy As String)
        Dim tCase = TitleCase.GetCase(bble)

        If tCase.Owner = userName Then
            Return
        End If

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

    Public Shared Sub UpdateStatus(bble As String, status As TitleCase.DataStatus, completedBy As String)
        If UpdateCaseStatus(bble, status, completedBy) Then
            Dim comments = "Move case to " & status.ToString
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Title.ToString, LeadsActivityLog.EnumActionType.UpdateInfo)
        Else
            Throw New Exception("Already in " & status.ToString)
        End If
    End Sub

    Private Shared Function UpdateCaseStatus(bble As String, status As TitleCase.DataStatus, completedBy As String) As Boolean
        Dim tCase = TitleCase.GetCase(bble)
        If tCase.Status <> status Then
            tCase.Status = status
            tCase.SaveData(completedBy)
            Return True
        End If

        Return False
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

            tCase = TitleCase.GetCase(bble)
            tCase.Status = TitleCase.DataStatus.InitialReview
            tCase.SaveData(userName)

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

    Public Shared Function GetManagers() As List(Of String)
        Dim mgrs = Roles.GetUsersInRole(MgrRoleName)
        If mgrs.Count > 0 Then
            Return mgrs.ToList
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
        Me.CommentsControlName = "~/TitleUI/TitleCommentControl.ascx"
        Me.LogCategory = LeadsActivityLog.LogCategory.Title
        Me.LogCategoryFilter = {LeadsActivityLog.LogCategory.Title, LeadsActivityLog.LogCategory.ShortSale}

    End Sub

    Public Overrides Function AddComments(bble As String, txtComments As String, userName As String) As Boolean

        Dim commentControl = CType(Me.CommentsControl, TitleCommentControl)
        Dim category = commentControl.Category
        Dim reviewmanager = commentControl.ReviewManager

        Dim comments = ""
        If Not String.IsNullOrEmpty(category) And commentControl.Status.HasValue Then
            UpdateCaseStatus(bble, commentControl.Status, userName)
            If category = "CTC" And Not String.IsNullOrEmpty(reviewmanager) And reviewmanager <> userName Then
                updateTitleOwner(bble, reviewmanager, userName)
                comments = comments & "Submit case to be reviewed by " & reviewmanager & "<br/>"
            End If

            comments = comments & String.Format("Category: {0}<br />", category)
        End If

        If commentControl.FollowUpDate > DateTime.Now Then
            comments = comments & String.Format("Follow Up Date: {0:d} <br />", commentControl.FollowUpDate)
            'Dim ssCase = ShortSaleCase.GetCaseByBBLE(hfBBLE.Value)
            'ssCase.SaveFollowUp(dtFollowup.Date)

            UserFollowUpManage.AddFollowUp(bble, userName, LeadsActivityLog.LogCategory.Title, commentControl.FollowUpDate)
        End If

        If Not String.IsNullOrEmpty(txtComments) Then
            comments = comments & txtComments
        End If

        Dim emp = Employee.GetInstance(userName)
        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LogCategory.ToString, emp.EmployeeID, emp.Name, LeadsActivityLog.EnumActionType.Comments)
        Return True
    End Function

#End Region

    Public Function GetAmount(navMenu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount
        Select Case navMenu.Name
            Case "Title-All"
                Return GetMyCases(userName).Length
            Case "Title-Completed"
                Return GetMyCases(userName, TitleCase.DataStatus.Completed).Length
            Case "Title-InitialReview"
                Return GetMyCases(userName, TitleCase.DataStatus.InitialReview).Length
            Case "Title-Clearance"
                Return GetMyCases(userName, TitleCase.DataStatus.Clearance).Length
            Case "Title-CTC"
                Return GetMyCases(userName, TitleCase.DataStatus.CTC).Length
            Case Else
                Return 0
        End Select

    End Function
End Class

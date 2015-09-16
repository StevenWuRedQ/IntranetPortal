Imports IntranetPortal.Data

Public Class ConstructionManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Construction-Manager"
    Private Const IntakeRoleName As String = "Construction-Intake"

    Public Shared Sub StartConstruction(bble As String, caseName As String, userName As String)
        If ConstructionCase.GetCase(bble) Is Nothing Then
            Dim cc As New ConstructionCase
            cc.BBLE = bble
            cc.CaseName = caseName
            cc.Status = ConstructionCase.CaseStatus.Intake

            Dim ccIntake = Roles.GetUsersInRole(IntakeRoleName)

            If ccIntake IsNot Nothing AndAlso ccIntake.Length > 0 Then
                cc.Owner = ccIntake(0)
            End If

            cc.Save(userName)
        End If
    End Sub

    Private Shared Function GetIntakeUser() As String
        Dim ccIntake = Roles.GetUsersInRole(IntakeRoleName)

        If ccIntake IsNot Nothing AndAlso ccIntake.Length > 0 Then
            Return ccIntake(0)
        End If

        Return Nothing
    End Function


    Public Shared Function GetCase(bble As String, userName As String) As ConstructionCase
        Return ConstructionCase.GetCase(bble, userName)
    End Function

    Public Shared Function GetMyCases(userName As String, Optional status As CaseStatus = -1) As ConstructionCase()
        If IsManager(userName) Then
            Return ConstructionCase.GetAllCasesByStatus(status)
        Else
            Return ConstructionCase.GetAllCases(userName, status)
        End If
    End Function

    Public Function GetAmount(menu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount
        If menu.Name.Split("-").Count > 1 Then
            Dim type = menu.Name.Split("-")(1)

            If (type = "All") Then
                Return GetMyCases(userName).Length
            End If

            Dim cStatus = ConstructionCase.CaseStatus.All
            If ([Enum].TryParse(Of ConstructionCase.CaseStatus)(type, cStatus)) Then

                Return GetMyCases(userName, cStatus).Length

            End If
        End If

        Return 0
    End Function

    Public Shared Sub MoveToIntake(bble As String, moveBy As String)
        Dim cCase = ConstructionCase.GetCase(bble)

        If cCase IsNot Nothing Then

            If cCase.Owner = moveBy Or IsManager(moveBy) Then

            End If

            cCase.Owner = GetIntakeUser()
            cCase.UpdateStatus(ConstructionCase.CaseStatus.Intake, moveBy)

            Dim comments = String.Format("The case is move to intake ({1}) by {0}.", moveBy, cCase.Owner)
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Construction.ToString, LeadsActivityLog.EnumActionType.Comments)
        End If
    End Sub

    Public Shared Sub AssignCase(bble As String, userName As String, assignBy As String)
        Dim cCase = ConstructionCase.GetCase(bble)
        cCase.Owner = userName

        cCase.Save(assignBy)

        Dim comments = String.Format("The case is assign to {0}.", userName)
        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Construction.ToString, LeadsActivityLog.EnumActionType.Comments)
    End Sub

    Public Shared Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function GetConstructionUsers() As String()
        Dim cRoles = Roles.GetAllRoles().ToList.Where(Function(r) r.StartsWith("Construction-")).ToList

        Dim result = New List(Of String)
        For Each r In cRoles
            result.AddRange(Roles.GetUsersInRole(r))
        Next

        Return result.Distinct.ToArray
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

Imports IntranetPortal.Data

Public Class ConstructionManage
    Inherits ActivityManageBase
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Construction-Manager"
    Private Const IntakeRoleName As String = "Construction-Intake"

    Public Shared Sub StartConstruction(bble As String, caseName As String, userName As String, Optional Owner As String = Nothing)
        If ConstructionCase.GetCase(bble) Is Nothing Then
            Dim cc As New ConstructionCase
            cc.BBLE = bble
            cc.CaseName = caseName
            cc.Status = ConstructionCase.CaseStatus.Intake
            If Owner Is Nothing Then
                Dim ccIntake = Roles.GetUsersInRole(IntakeRoleName)

                If ccIntake IsNot Nothing AndAlso ccIntake.Length > 0 Then
                    cc.Owner = ccIntake(0)
                End If
            Else
                cc.Owner = Owner
            End If
            cc.Save(userName)
        End If
    End Sub

    Public Shared Function IsInConstruction(bble As String) As Boolean

        Return ConstructionCase.Exists(bble)

    End Function

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

    Public Shared Function GetMyCases(userName As String, Optional status As ConstructionCase.CaseStatus = -1) As ConstructionCase()
        If IsManager(userName) Then
            Return ConstructionCase.GetAllCasesByStatus(status)
        Else
            Return ConstructionCase.GetAllCases(userName, status)
        End If
    End Function

    Public Shared Function GetMyLightCases(userName As String, Optional status As ConstructionCase.CaseStatus = -1) As ConstructionCase()
        If IsManager(userName) Then
            Return ConstructionCase.GetLightCasesByStatus(status)
        Else
            Return ConstructionCase.GetLightCases(userName, status)
        End If
    End Function

    Public Function GetAmount(menu As PortalNavItem, userName As String) As Integer Implements INavMenuAmount.GetAmount
        If menu.Name.Split("-").Count > 1 Then
            Dim type = menu.Name.Split("-")(1)

            If (type = "All") Then
                Return GetMyLightCases(userName).Length
            End If

            Dim cStatus = ConstructionCase.CaseStatus.All
            If ([Enum].TryParse(Of ConstructionCase.CaseStatus)(type, cStatus)) Then

                Return GetMyLightCases(userName, cStatus).Length

            End If
        End If

        Return 0
    End Function

    Public Shared Sub ChnageStatus(bble As String, status As ConstructionCase.CaseStatus, moveBy As String)
        Dim cCase = ConstructionCase.GetCase(bble)

        If cCase IsNot Nothing Then

            If cCase.Owner = moveBy Or IsManager(moveBy) Then

            End If

            If status = ConstructionCase.CaseStatus.Intake Then
                cCase.Owner = GetIntakeUser()
            End If

            cCase.UpdateStatus(status, moveBy)

            Dim comments = String.Format("The case is move to {2} ({1}) by {0}.", moveBy, cCase.Owner, status.ToString)
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Construction.ToString, LeadsActivityLog.EnumActionType.Comments)
        End If
    End Sub

    Public Shared Sub AssignCase(bble As String, userName As String, assignBy As String, status As ConstructionCase.CaseStatus)
        Dim cCase = ConstructionCase.GetCase(bble)
        cCase.Owner = userName

        If status <> ConstructionCase.CaseStatus.All Then
            cCase.Status = status
        End If

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

    Public Shared Sub NotifyWhenSpotCheck(form As Data.ConstructionSpotCheck)
        Dim spotCheck = Data.ConstructionSpotCheck.GetSpotCheck(form.Id)
        If Not spotCheck Is Nothing Then
            Dim builder = New StringBuilder
            For Each p In spotCheck.GetType.GetProperties
                If Not p.GetValue(form, Nothing) Is Nothing Then
                    If p.Name <> "Id" Then
                        If Not p.PropertyType.Name = "String" Then
                            builder.Append("<h5>" & Data.ConstructionSpotCheck.GetNameDesction(p.Name) & "</h5>")
                            builder.Append("<p>" & p.GetValue(form, Nothing) & "</p>")
                        Else 'this is a string
                            builder.Append("<h5>" & Data.ConstructionSpotCheck.GetNameDesction(p.Name) & "</h5>")
                            builder.Append("<p>" & p.GetValue(form, Nothing).Replace(vbLf, "<br>") & "</p>")
                        End If
                    End If
                End If
            Next
            Dim Body = builder.ToString
            Dim Address = spotCheck.propertyAddress
            Dim Manager = Data.ConstructionCase.GetCase(spotCheck.BBLE).Owner
            Dim User = spotCheck.owner
            Dim logDate = spotCheck.date
            Dim bble = spotCheck.BBLE

            ' write log
            LeadsActivityLog.AddActivityLog(logDate, Body, bble, LeadsActivityLog.LogCategory.Construction.ToString, Employee.GetInstance(User).EmployeeID, User)

            ' send email
            Dim emails = Employee.GetInstance(Manager).Email
            ' Dim emails = "stephenz@myidealprop.com"
            Dim maildata As New Dictionary(Of String, String)
            maildata.Add("Address", Address)
            maildata.Add("Manager", Manager)
            maildata.Add("User", User)
            maildata.Add("Body", Body)

            Core.EmailService.SendShortSaleMail(emails, "", "SpotCheckNotify", maildata)

        End If

    End Sub

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

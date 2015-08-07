Imports IntranetPortal.Data

Public Class ConstructionManage
    Implements INavMenuAmount

    Private Const MgrRoleName As String = "Construction-Manager"


    Public Shared Sub StartConstruction(bble As String, caseName As String, userName As String)
        Dim cc As New ConstructionCase
        cc.BBLE = bble
        cc.CaseName = caseName

        Dim ccMgr = Roles.GetUsersInRole(MgrRoleName)

        If ccMgr IsNot Nothing AndAlso ccMgr.Length > 0 Then
            cc.Owner = ccMgr(0)
        End If

        cc.Save(userName)
    End Sub


    Public Function GetAmount(type As String, userName As String) As Integer Implements INavMenuAmount.GetAmount

        If IsManager(userName) Then
            Return ConstructionCase.GetAllCases().Length
        Else
            Return ConstructionCase.GetAllCases(userName).Length
        End If

    End Function


    Public Function IsManager(userName As String) As String

        If Roles.IsUserInRole(userName, MgrRoleName) OrElse Roles.IsUserInRole(userName, "Admin") Then
            Return True
        End If

        Return False
    End Function
End Class

Imports IntranetPortal.Data

Public Class BusinessCheckManage

    ''' <summary>
    ''' Return if user has permission to cancel check
    ''' </summary>
    ''' <param name="userName">The User name</param>
    ''' <param name="check">The check object</param>
    ''' <returns></returns>
    Public Shared Function CheckCancelPermission(userName As String, check As BusinessCheck) As Boolean
        If check.Status = BusinessCheck.CheckStatus.Processed Then
            Return IsUserInAccounting(userName)
        End If

        Return True
    End Function

    ''' <summary>
    ''' Return if user is in accouting role
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns></returns>
    Public Shared Function IsUserInAccounting(userName As String) As Boolean
        Dim roles = {"Admin", "Accounting-*"}
        Return Employee.IsUserInRoles(userName, roles)

    End Function

End Class

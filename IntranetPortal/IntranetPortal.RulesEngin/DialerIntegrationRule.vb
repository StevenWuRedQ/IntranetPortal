Imports IntranetPortal
Imports System.Web.Security

Public Class DialerIntegrationRule
    Inherits BaseRule

    Public Overrides Sub Execute()

        Dim users = Roles.GetUsersInRole("Dialer-Users")
        For Each user In users
            Try
                Log("start dialer integration for: " & user)
                DialerServiceManage.RunDailyTask(user)
            Catch ex As Exception
                Log("Dialer Service Error on user: " & user, ex)
            End Try
        Next
    End Sub

End Class

Public Class ComplaintsManage

    Public Shared Function IsComplaintsManager(name As String) As Boolean

        If Roles.IsUserInRole(name, "Admin") Then
            Return True
        End If

        If Roles.IsUserInRole(name, "Complaints-Manager") Then
            Return True
        End If

        Return False

    End Function


End Class

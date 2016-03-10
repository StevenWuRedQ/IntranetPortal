Public Class UsersInRole

    Public Const AppName As String = "IntranetPortal"

    Public Sub Add()

        Using Context As New Entities
            Try
                If Not Context.UsersInRoles.Any(Function(a) a.Username = Username AndAlso a.Rolename = Rolename) Then
                    Me.ApplicationName = AppName
                    Context.UsersInRoles.Add(Me)
                    Context.SaveChanges()
                End If
            Catch ex As Exception
                Throw
            Finally

            End Try
        End Using
    End Sub

    Public Function IsExsit() As Boolean
        Using Context As New Entities
            Return Context.UsersInRoles.Any(Function(a) a.Username = Username AndAlso a.Rolename = Rolename)
        End Using
    End Function

    Public Sub Delete()
        Using Context As New Entities
            Try
                If Context.UsersInRoles.Any(Function(a) a.Username = Username AndAlso a.Rolename = Rolename) Then
                    Context.Entry(Me).State = Entity.EntityState.Deleted
                    Context.SaveChanges()
                Else
                    Throw New Exception("Not found. UserName: " & Username + ", Role Name: " & Rolename)
                End If
            Catch ex As Exception
                Throw
            Finally

            End Try
        End Using
    End Sub


End Class

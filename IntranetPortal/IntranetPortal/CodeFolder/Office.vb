Public Class Office

    Public Function Users() As String()
        If String.IsNullOrEmpty(Name) Then
            Return {""}
        End If

        Return Employee.GetAllDeptUsers(Name)
    End Function

    Public ReadOnly Property OfficeDescription As String
        Get
            If String.IsNullOrEmpty(Description) Then
                Return String.Format("{0}", Name)
            End If

            Return Description
        End Get
    End Property

    Public ReadOnly Property OfficeManagers As String
        Get
            If String.IsNullOrEmpty(Name) Then
                Return ""
            End If

            Dim users = Roles.GetUsersInRole("OfficeManager-" & Name)
            Return String.Join(",", users)
        End Get
    End Property

    Public Shared Function GetInstance(name As String) As Office
        Using context As New Entities

            Dim office = context.Offices.Where(Function(ofc) ofc.Name = name).FirstOrDefault
            If office Is Nothing Then
                Return New Office() With {
                    .Name = name
                    }
            Else
                Return office
            End If
        End Using
    End Function
End Class

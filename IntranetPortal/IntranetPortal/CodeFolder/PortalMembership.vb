Public Class PortalMembershipProvider
    Inherits MembershipProvider


    Public Overrides Property ApplicationName As String

    Public Overrides Function ChangePassword(username As String, oldPassword As String, newPassword As String) As Boolean
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.Name = username And em.Password = oldPassword).SingleOrDefault

            If emp IsNot Nothing Then
                emp.Password = newPassword
                context.SaveChanges()
                Return True
            Else
                Return False
            End If
        End Using
    End Function

    Public Overrides Function ChangePasswordQuestionAndAnswer(username As String, password As String, newPasswordQuestion As String, newPasswordAnswer As String) As Boolean
        Throw New NotImplementedException()

    End Function

    Public Overrides Function CreateUser(username As String, password As String, email As String, passwordQuestion As String, passwordAnswer As String, isApproved As Boolean, providerUserKey As Object, ByRef status As MembershipCreateStatus) As MembershipUser
        Throw New NotImplementedException()

    End Function

    Public Overrides Function DeleteUser(username As String, deleteAllRelatedData As Boolean) As Boolean
        Throw New NotImplementedException()

    End Function

    Public Overrides ReadOnly Property EnablePasswordReset As Boolean
        Get
            Throw New NotImplementedException()

        End Get
    End Property

    Public Overrides ReadOnly Property EnablePasswordRetrieval As Boolean
        Get
            Throw New NotImplementedException()

        End Get
    End Property

    Public Overrides Function FindUsersByEmail(emailToMatch As String, pageIndex As Integer, pageSize As Integer, ByRef totalRecords As Integer) As MembershipUserCollection
        Throw New NotImplementedException()

    End Function

    Public Overrides Function FindUsersByName(usernameToMatch As String, pageIndex As Integer, pageSize As Integer, ByRef totalRecords As Integer) As MembershipUserCollection
        Throw New NotImplementedException()

    End Function

    Public Overrides Function GetAllUsers(pageIndex As Integer, pageSize As Integer, ByRef totalRecords As Integer) As MembershipUserCollection
        Throw New NotImplementedException()
    End Function

    Public Overrides Function GetNumberOfUsersOnline() As Integer
        Throw New NotImplementedException()
    End Function

    Public Overrides Function GetPassword(username As String, answer As String) As String
        Throw New NotImplementedException()
    End Function

    Public Overloads Overrides Function GetUser(providerUserKey As Object, userIsOnline As Boolean) As MembershipUser
        Throw New NotImplementedException()
    End Function

    Public Overloads Overrides Function GetUser(username As String, userIsOnline As Boolean) As MembershipUser
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.Name = username).SingleOrDefault

            If emp IsNot Nothing Then
                Dim memUser = New MembershipUser("PortalMembershipProvider", emp.Name, emp.EmployeeID, emp.Email, String.Empty, emp.Description, True, emp.Active, emp.CreateDate, DateTime.Now, DateTime.Now, DateTime.MinValue, DateTime.MinValue)

                Return memUser
            End If
        End Using

        Return Nothing
    End Function

    Public Overrides Function GetUserNameByEmail(email As String) As String
        Throw New NotImplementedException()
    End Function



    Public Overrides ReadOnly Property MinRequiredPasswordLength As Integer
        Get
            Return 6
        End Get
    End Property

    Public Overrides ReadOnly Property RequiresUniqueEmail As Boolean
        Get
            Return True
        End Get
    End Property

    Public Overrides Function UnlockUser(userName As String) As Boolean
        Throw New NotImplementedException()
    End Function

    Public Overrides Sub UpdateUser(user As MembershipUser)
        Throw New NotImplementedException()
    End Sub

    Public Overrides Function ValidateUser(username As String, password As String) As Boolean
        Using context As New Entities
            Return context.Employees.Where(Function(em) (em.Name = username Or em.Email = username) And em.Password = password And em.Active = True).Count > 0
        End Using
    End Function

    Public Overrides ReadOnly Property MaxInvalidPasswordAttempts As Integer
        Get
            Return 3
        End Get
    End Property

    Public Overrides ReadOnly Property MinRequiredNonAlphanumericCharacters As Integer
        Get
            Throw New NotImplementedException()
        End Get
    End Property

    Public Overrides ReadOnly Property PasswordAttemptWindow As Integer
        Get
            Throw New NotImplementedException()
        End Get
    End Property

    Public Overrides ReadOnly Property PasswordFormat As MembershipPasswordFormat
        Get
            Throw New NotImplementedException()
        End Get
    End Property

    Public Overrides ReadOnly Property PasswordStrengthRegularExpression As String
        Get
            Throw New NotImplementedException()
        End Get
    End Property

    Public Overrides ReadOnly Property RequiresQuestionAndAnswer As Boolean
        Get
            Throw New NotImplementedException()
        End Get
    End Property

    Public Overrides Function ResetPassword(username As String, answer As String) As String
        Throw New NotImplementedException()
    End Function
End Class

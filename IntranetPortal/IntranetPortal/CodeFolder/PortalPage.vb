Public Class PortalPage
    Inherits Page

    Private _userName As String
    Public ReadOnly Property UserName As String
        Get
            If String.IsNullOrEmpty(_userName) Then
                _userName = Page.User.Identity.Name
            End If

            Return _userName
        End Get
    End Property

    Private _currentUser As Employee
    Public ReadOnly Property CurrentUser As Employee
        Get
            If _currentUser Is Nothing Then
                _currentUser = Employee.GetInstance(UserName)
            End If

            Return _currentUser
        End Get
    End Property

    Public ReadOnly Property CurrentAppId As Integer
        Get
            If CurrentUser IsNot Nothing Then
                Return CurrentUser.AppId
            End If

            Return Nothing
        End Get
    End Property

End Class

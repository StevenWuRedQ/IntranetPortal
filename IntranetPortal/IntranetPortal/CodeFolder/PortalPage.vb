Public Class PortalPage
    Inherits Page

    Public ReadOnly Property UserName As String
        Get
            Return Page.User.Identity.Name
        End Get
    End Property

    Public ReadOnly Property CurrentUser As Employee
        Get
            Return Employee.GetInstance(User.Identity.Name)
        End Get
    End Property

    Public ReadOnly Property CurrentAppId As Integer
        Get
            Return CurrentUser.AppId
        End Get
    End Property

End Class

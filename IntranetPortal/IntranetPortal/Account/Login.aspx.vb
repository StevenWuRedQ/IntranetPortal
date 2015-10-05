Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    'Protected Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
    '    'If Membership.ValidateUser(tbUserName.Text, tbPassword.Text) Then
    '    '    Dim name = StrConv(tbUserName.Text, VbStrConv.ProperCase)
    '    '    If tbPassword.Text = System.Configuration.ConfigurationManager.AppSettings("DefaultPassword").ToString Then
    '    '        FormsAuthentication.SetAuthCookie(name, False)
    '    '        Response.Redirect("~/Account/ChangePassword.aspx?t=active")
    '    '    End If

    '    '    OnlineUser.Refresh(HttpContext.Current)
    '    '    'If Not String.IsNullOrEmpty(name) Then
    '    '    '    Application.Lock()
    '    '    '    Dim users = CType(Application("Users"), ArrayList)
    '    '    '    If Not users.Contains(name) Then
    '    '    '        users.Add(name)
    '    '    '        Application("Users") = users
    '    '    '    End If
    '    '    '    Application.UnLock()
    '    '    'End If

    '    '    If String.IsNullOrEmpty(Request.QueryString("ReturnUrl")) Then
    '    '        FormsAuthentication.SetAuthCookie(name, False)

    '    '        Response.Redirect("~/")
    '    '    Else
    '    '        FormsAuthentication.RedirectFromLoginPage(name, False)
    '    '    End If
    '    'Else
    '    '    tbUserName.ErrorText = "Invalid user"
    '    '    tbUserName.IsValid = False
    '    'End If
    'End Sub

    Protected Sub LogInCallBack_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Dim name = e.Parameter.Split("|")(0)
        Dim password = e.Parameter.Split("|")(1)
        Dim rememberMe = e.Parameter.Split("|")(2)
        If Membership.ValidateUser(name, password) Then
            If Core.RegexUtilities.ValidEmail(name) Then
                name = Employee.GetInstanceByEmail(name).Name
            End If

            Dim names = Utility.FormatUserName(name) ' StrConv(name, VbStrConv.ProperCase)
            FormsAuthentication.SetAuthCookie(names, CBool(rememberMe))

            OnlineUser.Refresh(HttpContext.Current)
            If password = System.Configuration.ConfigurationManager.AppSettings("DefaultPassword").ToString Then
                e.Result = LoginStatus.FIRSTLOGIN
            Else
                e.Result = LoginStatus.SUCCESS
            End If
        Else
            e.Result = LoginStatus.FAILED
        End If
    End Sub

    Enum LoginStatus
        SUCCESS = 1
        FAILED = 2
        FIRSTLOGIN = 3
    End Enum
End Class
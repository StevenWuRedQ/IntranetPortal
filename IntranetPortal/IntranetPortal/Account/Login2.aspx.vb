Public Class Login2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindEmployeeList()
    End Sub

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        If Membership.ValidateUser(tbUserName.Text, tbPassword.Text) Then
            Dim name = StrConv(tbUserName.Text, VbStrConv.ProperCase)
            If tbPassword.Text = System.Configuration.ConfigurationManager.AppSettings("DefaultPassword").ToString Then
                FormsAuthentication.SetAuthCookie(name, False)
                Response.Redirect("~/Account/ChangePassword.aspx?t=active")
            End If

            Dim impUsers = System.Configuration.ConfigurationManager.AppSettings("ImpersonationUsers")
            If impUsers IsNot Nothing AndAlso impUsers.ToString.Contains(name) Then
                If Not String.IsNullOrEmpty(cbEmps.Text) Then
                    FormsAuthentication.SetAuthCookie(StrConv(cbEmps.Text, VbStrConv.ProperCase), False)
                End If
            End If

            If String.IsNullOrEmpty(Request.QueryString("ReturnUrl")) Then
                Response.Redirect("~/")
            Else
                FormsAuthentication.RedirectFromLoginPage(cbEmps.Text, False)
            End If
        Else
            tbUserName.ErrorText = "Invalid user"
            tbUserName.IsValid = False
        End If
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            cbEmps.DataSource = Context.Employees.Where(Function(em) em.Active = True).OrderBy(Function(em) em.Name).ToList
            cbEmps.TextField = "Name"
            cbEmps.ValueField = "EmployeeID"
            cbEmps.DataBind()
        End Using
    End Sub
End Class
Public Class ChangePassword
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnChangePassword_Click(sender As Object, e As EventArgs) Handles btnChangePassword.Click
        Dim currentUser As MembershipUser = Membership.GetUser(User.Identity.Name)
        If Not Membership.ValidateUser(currentUser.UserName, tbCurrentPassword.Text) Then
            tbCurrentPassword.ErrorText = "Old Password is not valid"
            tbCurrentPassword.IsValid = False
        ElseIf Not currentUser.ChangePassword(tbCurrentPassword.Text, tbPassword.Text) Then
            tbPassword.ErrorText = "Password is not valid"
            tbPassword.IsValid = False
        Else
            Response.Redirect("~/")
        End If
    End Sub
End Class
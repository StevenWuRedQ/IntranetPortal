Public Class ShortSaleManagement1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ddlTitleUsers.DataSource = TitleManage.TitleUsers
            ddlTitleUsers.DataBind()
        End If

    End Sub

    Protected Sub btnEnableTitle_Click(sender As Object, e As EventArgs) Handles btnEnableTitle.Click
        Dim bbles = txtBBLEs.Text.Split(",")
        Dim msg = ""
        For Each bble In bbles
            Try
                If TitleManage.IsInTitle(bble) Then
                    TitleManage.AssignTo(bble, ddlTitleUsers.SelectedValue, Page.User.Identity.Name)
                Else
                    ShortSaleManage.StartTitle(bble, Page.User.Identity.Name, ddlTitleUsers.SelectedValue)
                End If
            Catch ex As Exception
                msg += ex.Message + " "
            End Try
        Next

        lblMsg.Text = msg
    End Sub
End Class
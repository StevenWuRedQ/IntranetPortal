Public Class ComplainsMng
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindGrid()
        End If
    End Sub

    Protected Sub gdCases_DataBinding(sender As Object, e As EventArgs)
        If gdComplains.DataSource Is Nothing Then
            BindGrid()
        End If
    End Sub

    Private Sub BindGrid()
        gdComplains.DataSource = Data.CheckingComplain.GetAllComplains
        gdComplains.DataBind()
    End Sub

    Protected Sub btnCheck_ServerClick(sender As Object, e As EventArgs)
        lblAddress.Text = ""

        If rbBBLE.Checked Then
            Dim ld = LeadsInfo.GetInstance(txtBBLE.Text)
            If ld IsNot Nothing Then
                lblAddress.Text = ld.PropertyAddress
                txtNumber.Text = ld.Number
                txtStreet.Text = ld.StreetName
                txtCity.Text = ld.Neighborhood
            End If

            btnAdd.Visible = True
            Return
        Else
            Try
                txtBBLE.Text = Core.Utility.Address2BBLE(txtNumber.Text, txtStreet.Text, txtCity.Text)
                btnAdd.Visible = True
                Return
            Catch ex As Exception
                lblAddress.Text = "Error: " & ex.Message
                lblAddress.ForeColor = Drawing.Color.Red
            End Try
        End If

        btnAdd.Visible = False
    End Sub

    Protected Sub gdComplains_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters = "Add" Then

            Dim bble = txtBBLE.Text

            Dim cc As New Data.CheckingComplain
            cc.BBLE = bble
            cc.Address = lblAddress.Text
            cc.Save(User.Identity.Name)
        End If

        BindGrid()
    End Sub
End Class
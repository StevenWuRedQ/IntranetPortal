Public Class ComplainsMng
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindGrid()

            gdComplainsResult.FilterExpression = "[Status] LIKE '%ACT%'"
        End If
    End Sub

    Protected Sub gdCases_DataBinding(sender As Object, e As EventArgs)
        If gdComplains.DataSource Is Nothing Then
            BindGrid()
        End If
    End Sub

    Private Sub BindGrid()
        Dim lists = Data.CheckingComplain.GetAllComplains
        If lists IsNot Nothing Then
            gdComplains.DataSource = Data.CheckingComplain.GetAllComplains
            gdComplains.DataBind()
        End If
    End Sub

    Private Sub BindResult()
        Dim result = Data.CheckingComplain.GetComplainsResult

        If result IsNot Nothing Then
            gdComplainsResult.DataSource = result
            gdComplainsResult.DataBind()
        End If
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

                btnAdd.Disabled = False
            End If
        Else
            Try
                txtBBLE.Text = Core.Utility.Address2BBLE(txtNumber.Text, txtStreet.Text, txtCity.Text)
                btnAdd.Disabled = False
                Return
            Catch ex As Exception
                lblAddress.Text = "Error: " & ex.Message
                lblAddress.ForeColor = Drawing.Color.Red
            End Try
        End If
    End Sub

    Protected Sub gdComplains_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters = "Add" Then
            Dim bble = txtBBLE.Text

            Dim cc As New Data.CheckingComplain
            cc.BBLE = bble
            cc.Address = lblAddress.Text
            cc.Save(User.Identity.Name)
        End If

        If e.Parameters.StartsWith("Refresh") Then
            Dim bble = e.Parameters.Split("|")(1)
            Dim com = Data.CheckingComplain.Instance(bble)
            com.RefreshComplains(User.Identity.Name)
        End If

        If e.Parameters.StartsWith("Delete") Then
            Dim bble = e.Parameters.Split("|")(1)
            Data.CheckingComplain.Remove(bble)
        End If

        BindGrid()
    End Sub

    Sub AddProps()
        Dim bbles = txtBBLE.Text.Split(" ")

        For Each bble In bbles
            AddProperty(bble)
        Next
    End Sub

    Sub AddProperty(bble As String)
        Dim cc As New Data.CheckingComplain
        cc.BBLE = bble

        Dim ld = LeadsInfo.GetInstance(bble)

        cc.Address = ld.PropertyAddress
        cc.Save(User.Identity.Name)
    End Sub


    Protected Sub gdComplainsResult_DataBinding(sender As Object, e As EventArgs)
        If gdComplainsResult.DataSource Is Nothing Then
            BindResult()
        End If
    End Sub

    Protected Sub gdComplainsResult_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        BindResult()
    End Sub

    Protected Sub popupComplaintHistory_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        popCtrHistory.Visible = True

        Dim bble = e.Parameter

        gdComplainsHistory.DataSource = Data.CheckingComplain.GetComplaintsHistory(bble)
        gdComplainsHistory.DataBind()

    End Sub

    Protected Sub gdComplainsResult_DataBound(sender As Object, e As EventArgs)

    End Sub

    Protected Sub gdComplainsResult_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)

        Dim dtEntered = CDate(e.GetValue("DateEntered"))

        If dtEntered > DateTime.MinValue AndAlso Core.WorkingHours.GetWorkingDays(dtEntered, DateTime.Now, "").Days < 3 Then
            e.Row.ForeColor = Drawing.Color.Red
        End If
    End Sub
End Class
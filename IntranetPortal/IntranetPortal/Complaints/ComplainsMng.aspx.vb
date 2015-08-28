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

    Protected Sub gdComplains_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters = "Add" Then
            Dim bble = txtBBLE.Text
            AddProperty(bble)

            'Dim cc As New Data.CheckingComplain
            'cc.BBLE = bble
            'cc.Address = lblAddress.Text
            'cc.Save(User.Identity.Name)
        End If

        If e.Parameters.StartsWith("Refresh") Then
            Dim bble = e.Parameters.Split("|")(1)

            If bble = "All" Then
                Dim name = User.Identity.Name
                Dim callback = Sub()
                                   Try
                                       Dim complaints = Data.CheckingComplain.GetAllComplains()

                                       For Each cp In complaints
                                           cp.RefreshComplains(name)
                                       Next

                                   Catch ex As Exception
                                       Core.SystemLog.LogError("ManualRefreshAll", ex, "", name, "")
                                   End Try
                               End Sub
                Threading.ThreadPool.QueueUserWorkItem(callback)
            Else
                Dim com = Data.CheckingComplain.Instance(bble)
                com.RefreshComplains(User.Identity.Name)
            End If
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
        Dim cc = Data.CheckingComplain.Instance(bble)

        If cc Is Nothing Then
            cc = New Data.CheckingComplain
            cc.BBLE = bble
        End If

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
        'BindResult()
    End Sub

    Protected Sub popupComplaintHistory_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        popCtrHistory.Visible = True
        Dim bble = e.Parameter
        hfBBLE.Value = bble

        gdComplainsHistory.DataSource = Data.CheckingComplain.GetComplaintsHistory(bble)
        gdComplainsHistory.DataBind()

    End Sub

    Protected Sub gdComplainsResult_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)
        If e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Data OrElse e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Detail Then
            Dim dtEntered = CDate(e.GetValue("DateEntered"))

            If dtEntered > DateTime.MinValue Then
                Dim ts = DateTime.Now - dtEntered

                If ts.Days < 5 Then
                    If dtEntered > DateTime.MinValue AndAlso Core.WorkingHours.GetWorkingDays(dtEntered, DateTime.Now, "").Days < 3 Then
                        e.Row.ForeColor = Drawing.Color.Red
                    End If

                End If

            End If

        End If

    End Sub

    Protected Sub gdComplainsHistory_DataBinding(sender As Object, e As EventArgs)
        If gdComplainsHistory.DataSource Is Nothing Then
            gdComplainsHistory.DataSource = Data.CheckingComplain.GetComplaintsHistory(hfBBLE.Value)
        End If
    End Sub

    Protected Sub cpAddProperty_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        lblAddress.Visible = False

        If e.Parameter = "Add" Then
            Try
                If rbBBLE.Checked Then

                    Dim ld = LeadsInfo.GetInstance(txtBBLE.Text)

                    If ld Is Nothing Then
                        ld = DataWCFService.UpdateAssessInfo(txtBBLE.Text)
                    End If

                    If ld IsNot Nothing Then
                        lblAddress.Text = ld.PropertyAddress
                        txtNumber.Text = ld.Number
                        txtStreet.Text = ld.StreetName
                        txtCity.Text = ld.Neighborhood

                        btnAdd.Disabled = False
                    End If
                Else
                    txtBBLE.Text = Core.Utility.Address2BBLE(txtNumber.Text, txtStreet.Text, txtCity.Text)
                    btnAdd.Disabled = False
                    Return
                End If
            Catch ex As Exception
                lblAddress.Text = "Error: " & ex.Message
                lblAddress.ForeColor = Drawing.Color.Red
                lblAddress.Visible = True
            End Try
        End If
    End Sub

    Protected Sub ASPxPopupControl1_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        If e.Parameter.StartsWith("Show") Then
            tbUsers.DataSource = Employee.GetAllActiveEmps()
            tbUsers.DataBind()

            Dim bble = e.Parameter.Split("|")(1)
            hfBBLE2.Value = bble
            tbUsers.Text = Data.CheckingComplain.Instance(bble).NotifyUsers
        End If
        
        If e.Parameter.StartsWith("Save") Then
            Dim bble = hfBBLE2.Value
            Dim cp = Data.CheckingComplain.Instance(bble)
            cp.NotifyUsers = tbUsers.Text
            cp.Save(Page.User.Identity.Name)
        End If
    End Sub
End Class
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxGridView

Public Class PortalStatus
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gridOnlineUsers.DataSource = OnlineUsers
            gridOnlineUsers.DataBind()

            cbUsers.DataSource = OnlineUsers
            cbUsers.TextField = "UserName"
            cbUsers.ValueField = "UserName"
            cbUsers.DataBind()
            cbUsers.Items.Insert(0, New ListEditItem("ALL", "ALL"))

            BindLogs()

            BindSettings()

            cbEmployee.DataSource = Employee.GetAllActiveEmps()
            cbEmployee.DataBind()
            cbEmployee.Items.Insert(0, New ListEditItem("ALL", "ALL"))
        End If
    End Sub

    Sub BindSettings()
        gridSettings.DataSource = Core.PortalSettings.SettingData
        gridSettings.DataBind()
    End Sub

    Public ReadOnly Property OnlineUsers As List(Of OnlineUser)
        Get
            Return OnlineUser.OnlineUsers
        End Get
    End Property

    Public ReadOnly Property TLoCallCount As Integer
        Get
            Return Core.TLOApiLog.GetCount
        End Get
    End Property

    Protected Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        BindLogs()
    End Sub

    Sub BindLogs()
        Dim dt = dtLog.Date
        Dim endDate = dt.AddDays(1)
        Using Context As New Entities
            Dim logs = Context.LoginLogs.Where(Function(l) l.CreateDate < endDate And l.CreateDate >= dt).ToList
            gridLogs.DataSource = logs
            gridLogs.DataBind()
        End Using
    End Sub

    Protected Sub btnSend_Click(sender As Object, e As EventArgs) Handles btnSend.Click
        If cbUsers.Value = "ALL" Then
            For Each emp In OnlineUsers
                UserMessage.AddNewMessage(emp.UserName, "System Message", txtComments.Text, "")
            Next
        Else
            UserMessage.AddNewMessage(cbUsers.Value, "System Message", txtComments.Text, "")
        End If

        txtComments.Text = ""
    End Sub

    Protected Sub gridSettings_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        Dim grid As ASPxGridView = TryCast(sender, ASPxGridView)
        Core.PortalSettings.SaveValues(CInt(e.Keys(0)), e.NewValues("Value"))
        e.Cancel = True
        grid.CancelEdit()

        BindSettings()
    End Sub

    Protected Sub ASPxButton1_Click(sender As Object, e As EventArgs)
        If cbEmployee.Text = "ALL" Then

            Dim callback = Sub()
                               Dim users = Employee.GetAllActiveEmps()
                               For Each name In users
                                   SendEmail(name)
                               Next

                               UserMessage.AddNewMessage(Page.User.Identity.Name, "Send Mail Completed", "All the mail is send.", "", DateTime.Now, "Portal")
                           End Sub
            Threading.ThreadPool.QueueUserWorkItem(callback)
        Else
            SendEmail(cbEmployee.Text)
        End If
        lblResult.Text = "Email is schedule to send."
    End Sub

    Private Sub SendEmail(name As String)
        Dim emp = Employee.GetInstance(name)
        If emp IsNot Nothing Then
            Try
                Dim body = ASPxMemo1.Text
                body = body.Replace("{{$Name}}", name)
                Core.EmailService.SendMail(emp.Email, "", txtSubject.Text, body, Nothing)
            Catch ex As Exception
                UserMessage.AddNewMessage(Page.User.Identity.Name, "Send Mail Error", ex.Message, "", DateTime.Now, "Portal")
            End Try
        End If
    End Sub

    Protected Sub gridOnlineUsers_DataBinding(sender As Object, e As EventArgs)
        If gridOnlineUsers.DataSource Is Nothing Then
            gridOnlineUsers.DataSource = OnlineUsers
        End If
    End Sub
End Class
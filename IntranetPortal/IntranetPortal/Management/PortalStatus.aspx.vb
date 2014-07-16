Imports DevExpress.Web.ASPxEditors

Public Class PortalStatus
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        gridOnlineUsers.DataSource = OnlineUsers
        gridOnlineUsers.DataBind()

        cbUsers.DataSource = OnlineUsers
        cbUsers.TextField = "UserName"
        cbUsers.ValueField = "UserName"
        cbUsers.DataBind()
        cbUsers.Items.Insert(0, New ListEditItem("ALL", "ALL"))

        BindLogs()
    End Sub

    Public ReadOnly Property OnlineUsers As List(Of OnlineUser)
        Get
            Return OnlineUser.OnlineUsers
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
End Class
Public Class WhileAwayMsgs
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindMsgs()
    End Sub

    Sub BindMsgs()
        gridMsgs.DataSource = UserMessage.GetAllNewMessage(User.Identity.Name)
        gridMsgs.DataBind()

        Dim msgs = UserMessage.GetAllNewMessage(User.Identity.Name)

        For Each msg In msgs
            UserMessage.ReadMsg(User.Identity.Name, msg.MsgID)
        Next
    End Sub

    Protected Sub gridMsgs_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        Dim msgId = e.Parameters

        Dim userName = Context.User.Identity.Name
        If msgId IsNot Nothing Then
            msgId = CInt(msgId)
            UserMessage.ReadMsg(userName, msgId)
        End If

        BindMsgs()
    End Sub

    Function GetPropertyAddress(bble As String) As String
        Dim ld = Lead.GetInstance(bble)
        If ld IsNot Nothing Then
            Return ld.LeadsName
        End If

        Return ""
    End Function
End Class
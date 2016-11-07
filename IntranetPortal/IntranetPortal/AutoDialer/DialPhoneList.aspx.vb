Public Class DialPhoneList
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub


    Protected Sub gvDailPhoneList_Init(sender As Object, e As EventArgs)
        If (gvDailPhoneList.DataSource Is Nothing) Then
            BindGrid()
        End If
    End Sub
    Sub BindGrid()
        Dim phoneList = Controllers.AutoDialerController.db
        gvDailPhoneList.DataSource = phoneList
        gvDailPhoneList.DataBind()
    End Sub
    Protected Sub gvDailPhoneList_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        BindGrid()
    End Sub

    Protected Sub callAll_Click(sender As Object, e As EventArgs)
        Dim ctrl = New Controllers.AutoDialerController
        ctrl.GetCallNumber("test")

    End Sub
End Class
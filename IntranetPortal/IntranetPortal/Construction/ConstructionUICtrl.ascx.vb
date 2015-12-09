Public Class ConstructionUICtrl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub


    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        PopupContentReAssign.Visible = True

        If e.Parameter.StartsWith("Show") Then
            If e.Parameter.Split("|").Length > 1 Then
                hfUserType.Value = e.Parameter.Split("|")(1)
            End If

            listboxEmployee.DataSource = ConstructionManage.GetConstructionUsers()
            listboxEmployee.DataBind()
        End If

        If Not String.IsNullOrEmpty(e.Parameter) AndAlso e.Parameter.StartsWith("Save") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim user = e.Parameter.Split("|")(2)
            Dim status = Data.ConstructionCase.CaseStatus.All

            If Not String.IsNullOrEmpty(hfUserType.Value) Then
                status = CType(hfUserType.Value, Data.ConstructionCase.CaseStatus)
            End If

            ConstructionManage.AssignCase(bble, user, Page.User.Identity.Name, status)
        End If
    End Sub
End Class
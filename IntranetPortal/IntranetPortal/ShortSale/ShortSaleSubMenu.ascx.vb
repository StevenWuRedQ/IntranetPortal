Imports IntranetPortal.ShortSale

Public Class ShortSaleSubMenu
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub getAddressCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim propInfo = ShortSale.PropertyBaseInfo.GetInstance(e.Parameter)
        e.Result = propInfo.PropertyAddress + "|Block:" + propInfo.Block + " Lot:" + propInfo.Lot
    End Sub

    Protected Sub statusCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim status As ShortSale.CaseStatus
        If [Enum].TryParse(Of ShortSale.CaseStatus)(e.Parameter.Split("|")(0), status) Then
            'Dim status = [Enum].Parse(GetType(ShortSale.CaseStatus), e.Parameter.Split("|")(0))
            Dim caseId = CInt(e.Parameter.Split("|")(1))
            ShortSale.ShortSaleCase.GetCase(caseId).SaveStatus(status)
        End If
    End Sub

    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        If String.IsNullOrEmpty(e.Parameter) Then
            PopupContentReAssign.Visible = True
            BindEmployeeList()
            Return
        End If

        If e.Parameter.Split("|").Length > 0 Then
            Dim bble = e.Parameter.Split("|")(0)
            Dim name = e.Parameter.Split("|")(1)
            ShortSaleCase.ReassignOwner(bble, name)
            LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} reassign this case to {1}.", Page.User.Identity.Name, name), bble, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)
        End If
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            listboxEmployee.DataSource = Employee.GetDeptUsers("Short Sale")
            listboxEmployee.DataBind()
        End Using
    End Sub
End Class
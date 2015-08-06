Imports IntranetPortal.Data
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxPopupControl

Public Class TitleControl
    Inherits System.Web.UI.UserControl

    Public Property ShortSaleCaseData As New ShortSaleCase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub BindData(ssCase As ShortSaleCase)
        ShortSaleCaseData = ssCase
    End Sub

    Protected Sub ASPxPopupControl1_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        Dim popup = CType(source, ASPxPopupControl)
        Dim issue = txtIssue.Value
        Dim name = txtContactName.Value
        Dim number = txtContactNum.Value
        Dim email = txtContactEmail.Value

        Dim contact = New PartyContact(name, number, email)
        contact.CorpName = txtCompanyName.Value
        contact.Save()

        Dim clearence As New TitleClearence
        clearence.Issue = issue
        clearence.ContactId = contact.ContactId
        clearence.CaseId = CInt(e.Parameter)
        If Not String.IsNullOrEmpty(txtAmount.Value) Then
            clearence.Amount = CDec(txtAmount.Value)
        End If

        clearence.Save()
    End Sub

    Protected Sub callbackClearence_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        Dim caseId = 0

        If e.Parameter.StartsWith("Delete") Then
            Dim clearenceId = e.Parameter.Split("|")(1)
            caseId = e.Parameter.Split("|")(2)
            TitleClearence.Delete(clearenceId)
        Else
            If e.Parameter.StartsWith("Clear") Then
                Dim clearenceId = e.Parameter.Split("|")(1)
                caseId = e.Parameter.Split("|")(2)
                TitleClearence.Cleared(clearenceId)
            Else
                caseId = CInt(e.Parameter)
            End If
        End If

        ShortSaleCaseData = ShortSaleCase.GetCase(caseId)
    End Sub

    Protected Sub ASPxPopupControl2_WindowCallback(source As Object, e As PopupWindowCallbackArgs)
        Dim note As New CleareneceNote
        note.ClearenceId = CInt(e.Parameter)
        note.Notes = txtNotes.Text
        note.CreateBy = Page.User.Identity.Name
        note.CreateDate = DateTime.Now
        note.Save()

        txtNotes.Text = ""
    End Sub

    Protected Sub callbackMakeUrgent_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If Not String.IsNullOrEmpty(e.Parameter) Then
            Dim caseId = CInt(e.Parameter)

            Dim ssCase = ShortSaleCase.GetCase(caseId)

            If ssCase.IsUrgent.HasValue Then
                If ssCase.IsUrgent Then
                    ssCase.IsUrgent = False
                Else
                    ssCase.IsUrgent = True
                End If
            Else
                ssCase.IsUrgent = True
            End If

            ssCase.Save()

            e.Result = ssCase.IsUrgent
        End If
    End Sub
End Class
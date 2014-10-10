Imports DevExpress.Web.ASPxGridView
Imports IntranetPortal.ShortSale
Imports System.Web.Script.Serialization

Public Class SelectPartyUC
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub gridParties_DataBinding(sender As Object, e As EventArgs)
        Dim grid = CType(sender, ASPxGridView)

        If grid.DataSource Is Nothing Then
            Dim type = rblType.Value
            grid.DataSource = PartyContact.GetTitleCompanies(rblType.Value)
        End If
    End Sub

    Protected Sub gridParties_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim grid = CType(sender, ASPxGridView)
        Dim name = CType(grid.FindEditFormTemplateControl("txtContact"), HtmlInputText).Value
        Dim companyname = CType(grid.FindEditFormTemplateControl("txtCompanyName"), HtmlInputText).Value

        Dim contact As New PartyContact
        contact.Name = name
        contact.CorpName = companyname
        contact.Address = CType(grid.FindEditFormTemplateControl("txtAddress"), HtmlInputText).Value
        contact.OfficeNO = CType(grid.FindEditFormTemplateControl("txtOffice"), HtmlInputText).Value
        contact.Cell = CType(grid.FindEditFormTemplateControl("txtCell"), HtmlInputText).Value
        contact.Email = CType(grid.FindEditFormTemplateControl("txtEmail"), HtmlInputText).Value
        contact.Type = PartyContact.ContactType.TitleCompany
        contact.Save()
        e.Cancel = True
        grid.CancelEdit()
        grid.DataBind()
    End Sub

    Protected Sub gridParties_CustomDataCallback(sender As Object, e As ASPxGridViewCustomDataCallbackEventArgs)
        Dim contactId = gridParties.GetSelectedFieldValues("ContactId")(0)

        Dim json As New JavaScriptSerializer
        e.Result = json.Serialize(PartyContact.GetContact(contactId))
    End Sub

    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        popupContentSelectParty.Visible = True
        gridParties.DataBind()
    End Sub

    Protected Sub gridParties_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        Dim grid = CType(sender, ASPxGridView)
        Dim contactId = e.Keys("ContactId")
        PartyContact.DeleteContact(contactId)

        e.Cancel = True

        gridParties.DataBind()
    End Sub
End Class
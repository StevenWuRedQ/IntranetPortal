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
            grid.DataSource = PartyContact.GetTitleCompanies
        End If
    End Sub

    Protected Sub gridParties_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim grid = CType(sender, ASPxGridView)
        Dim name = CType(grid.FindEditFormTemplateControl("txtContact"), HtmlInputText).Value
        Dim companyname = CType(grid.FindEditFormTemplateControl("txtCompanyName"), HtmlInputText).Value

        Dim contact As New PartyContact
        contact.Name = name
        contact.CorpName = companyname
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
End Class
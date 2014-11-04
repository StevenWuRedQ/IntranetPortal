Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports IntranetPortal.ShortSale
Public Class CallBackSevices
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Response.Clear()
        Response.ContentType = "application/json; charset=utf-8"
        Response.Write(GetContact())
        Response.End()


    End Sub
    <WebMethod()> _
    Public Shared Function GetContact() As String
        Dim allContact = PartyContact.getAllContact

        Dim json As New JavaScriptSerializer
        Return json.Serialize(allContact)
    End Function
End Class
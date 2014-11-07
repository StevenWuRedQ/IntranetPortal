Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports IntranetPortal.ShortSale
Imports Newtonsoft.Json
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
        Dim json = JsonConvert.SerializeObject(allContact)
        'Dim json As New JavaScriptSerializer
        Return json
    End Function

    <WebMethod()> _
    Public Shared Sub SaveContact(json As String)
        Dim json_serializer As New JavaScriptSerializer()
        Dim contact = json_serializer.Deserialize(Of PartyContact)(json)
        contact.Save()
    End Sub
End Class
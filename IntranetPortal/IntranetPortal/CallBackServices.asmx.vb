Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.Web.Script.Services
Imports IntranetPortal.ShortSale
Imports Newtonsoft.Json
Imports System.Web.Script.Serialization

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
<ScriptService>
Public Class CallBackServices
    Inherits System.Web.Services.WebService


    <WebMethod()> _
    Public Function GetContact(p As String) As List(Of PartyContact)
        Dim allContact = PartyContact.getAllContact
        Return allContact
    End Function

    <WebMethod()> _
    Public Sub SaveContact(json As PartyContact)
        
        json.Save()
    End Sub

    <WebMethod()> _
    Public Function addContact(contact As PartyContact) As PartyContact
        
        contact.Save()
        Return contact
    End Function
End Class
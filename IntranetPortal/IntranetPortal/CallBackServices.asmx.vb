Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.Web.Script.Services
Imports IntranetPortal.Data
Imports Newtonsoft.Json
Imports System.Web.Script.Serialization

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
'<System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
<ScriptService>
Public Class CallBackServices
    Inherits System.Web.Services.WebService


    <WebMethod()> _
    Public Function GetContact(p As String) As List(Of PartyContact)
        Dim allContact = PartyContact.getAllContact(Employee.CurrentAppId)
        Return allContact
    End Function

    <WebMethod()> _
    <ScriptMethod(UseHttpGet:=True)> _
    Public Function GetContact2() As List(Of PartyContact)
        Dim allContact = PartyContact.getAllContact(Employee.CurrentAppId)
        Return allContact
    End Function

    <WebMethod()> _
    Public Sub SaveContact(json As PartyContact)

        json.Save()

    End Sub

    <WebMethod()> _
    Public Function AddContact(contact As PartyContact) As PartyContact
        Dim c = PartyContact.GetContactByName(contact.Name)
        If (c IsNot Nothing) Then
            Throw New Exception("Already have " & contact.Name & " in system please change name to identify ")
        End If
        contact.CreateBy = HttpContext.Current.User.Identity.Name
        contact.AppId = Employee.CurrentAppId
        contact.Save()
        Return contact
    End Function
    <WebMethod()> _
    Public Function GetBroughName(bro As Integer) As String
        Return Utility.Borough2BoroughName(bro)
    End Function
    <WebMethod()> _
    Public Function GetLenderList() As List(Of String)
        Dim l = PartyContact.GetContactByType(PartyContact.ContactType.Lender, Employee.CurrentAppId).Where(Function(c) c.CorpName IsNot Nothing).Select(Function(c) c.CorpName).Distinct().ToList()
        Return l
    End Function
    <WebMethod()> _
    Public Function GetAllGroups() As List(Of GroupType)
        Dim g = GroupType.GetAllGroupType(False)
        Return g
    End Function
    <WebMethod()> _
    Public Function GetContactByGroup(gId? As Integer) As List(Of PartyContact)
        If gId = 0 Then
            Return PartyContact.getAllContact(Employee.CurrentAppId)
        End If
        Dim g = GroupType.GetGroup(gId)
        Return g.Contacts(Employee.CurrentAppId)
    End Function

    <WebMethod()> _
    Public Function AddGroups(gid As Integer, groupName As String, addUser As String) As GroupType

        Return GroupType.AddGroups(gid, groupName, addUser)
    End Function
End Class
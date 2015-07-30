Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services
Imports IntranetPortal.ShortSale

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class ContactService

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml"
    <OperationContract()>
    <WebGet()>
    Public Function GetContacts(args As String) As Channels.Message
        Dim p = PartyContact.SearchContacts(args)
        Return p.ToJson()
        ' Add your operation implementation here
    End Function
    <OperationContract()>
   <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetBankList() As Channels.Message
        'the id of "Lender" is 5
        Dim gp = GroupType.GetGroup(5)

        If gp IsNot Nothing Then
            Return gp.Contacts.Where(Function(a) (a.Disable Is Nothing Or a.Disable = False)).OrderBy(Function(p) p.Name).ToList.ToJson
        End If

        Return Nothing
    End Function
    <OperationContract()>
    <WebGet()>
    Public Function LoadContacts() As Channels.Message ' As List(Of PartyContact)
        Return PartyContact.getAllContact().ToJson()
       
    End Function
    <OperationContract()>
    <WebGet()>
    Public Function GetAllContacts(id As Integer) As Channels.Message ' As List(Of PartyContact)
        If (id = 0) Then
            Return PartyContact.getAllContact().ToJson()
        End If
        Dim p = PartyContact.getAllContact().Where(Function(ps) ps.ContactId = id)

        Return p.ToJson()
        ' Add your operation implementation here
    End Function
    <OperationContract()>
    Public Function CheckInShortSale(BBLE) As Channels.Message ' As List(Of PartyContact)

        Return ShortSaleCase.InShortSale(BBLE).ToJson
        ' Add your operation implementation here
    End Function
    ' Add more operations here and mark them with <OperationContract()>

End Class

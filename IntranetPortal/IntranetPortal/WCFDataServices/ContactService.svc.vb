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
    <WebGet()>
    Public Function GetAllContacts() As Channels.Message
        Dim p = PartyContact.getAllContact()
        Return p.ToJson()
        ' Add your operation implementation here
    End Function

    ' Add more operations here and mark them with <OperationContract()>

End Class

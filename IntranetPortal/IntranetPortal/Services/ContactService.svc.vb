Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services
Imports IntranetPortal.Data
Imports System.IO

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class ContactService

    <OperationContract()>
    <WebGet()>
    Public Function GetContacts(args As String) As Channels.Message
        Dim p = PartyContact.SearchContacts(args, Employee.CurrentAppId)
        Return p.ToJson()
    End Function

    <OperationContract()>
   <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetBankList() As Channels.Message
        Dim gp = GroupType.GetGroup(5)
        If gp IsNot Nothing Then
            Return gp.Contacts(0).Where(Function(a) (a.Disable Is Nothing Or a.Disable = False)).OrderBy(Function(p) p.Name).ToList.ToJson
        End If
        Return Nothing
    End Function

    <OperationContract()>
    <WebGet()>
    Public Function LoadContacts() As Channels.Message ' As List(Of PartyContact)
        Return PartyContact.getAllContact(Employee.CurrentAppId).ToJson()

    End Function

    <OperationContract()>
    <WebGet()>
    Public Function GetAllContacts(id As Integer) As Channels.Message ' As List(Of PartyContact)
        If (id = 0) Then
            Return PartyContact.getAllContact(Employee.CurrentAppId).ToJson()
        End If
        Dim p = PartyContact.getAllContact(Employee.CurrentAppId).Where(Function(ps) ps.ContactId = id)

        Return p.ToJson()
        ' Add your operation implementation here
    End Function

    <OperationContract()>
     <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function CheckInShortSale(BBLE As String) As Channels.Message ' As List(Of PartyContact)

        Return ShortSaleCase.InShortSale(BBLE).ToJson
        ' Add your operation implementation here
    End Function

    <OperationContract()>
   <WebGet()>
    Public Function GetAllBuyerEntities() As Channels.Message
        Return CorporationEntity.GetAllEntities(Employee.CurrentAppId).OrderBy(Function(c) c.CorpName).ToJson
    End Function

    <OperationContract()>
    <WebGet()>
    Public Function GetCorpEntityByStatus(n As String, s As String) As Channels.Message
        Return CorporationEntity.GetEntitiesByStatus(n, s).ToJson()
    End Function

    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function SaveCorpEntitiy(c As String) As Channels.Message
        If (Not String.IsNullOrEmpty(c)) Then
            Dim entity = Newtonsoft.Json.JsonConvert.DeserializeObject(Of CorporationEntity)(c)
            If (entity.EntityId = 0 AndAlso CorporationEntity.GetEntityByCorpName(entity.CorpName) IsNot Nothing) Then
                Return Nothing
            End If
            If (entity.EntityId = 0) Then
                entity.AppId = Employee.CurrentAppId
            End If

            entity.Save()
                Return entity.ToJson
            End If
            Return Nothing
    End Function
    <OperationContract()>
  <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function AssginEntity(c As String) As Channels.Message
        If (Not String.IsNullOrEmpty(c)) Then
            Dim entity = Newtonsoft.Json.JsonConvert.DeserializeObject(Of CorporationEntity)(c)

            Try
                Dim BBLE = IntranetPortal.Core.Utility.Address2BBLE(entity.PropertyAssigned)
                entity.BBLE = BBLE

                entity.Save()
                Return entity.BBLE.ToJson
            Catch ex As Exception
                Throw ex
            End Try

        End If
        Throw New Exception("entiy is emplty")
    End Function
    ' Add more operations here and mark them with <OperationContract()>
    <OperationContract()>
    <WebInvoke(Method:="POST", ResponseFormat:=WebMessageFormat.Json)>
    Public Function UploadFile(stream As Stream) As String

        Dim ms As New MemoryStream
        stream.CopyTo(ms)
        ms.Position = 0

        Dim id = HttpContext.Current.Request.QueryString("id")
        Dim fileName = HttpContext.Current.Request.QueryString("type")

        Return CorporationEntity.UploadFile(id, fileName & ".pdf", ms.ToArray, HttpContext.Current.User.Identity.Name)
    End Function
End Class

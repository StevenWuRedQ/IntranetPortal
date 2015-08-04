Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports Newtonsoft.Json

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class LegalServices

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml" 

#Region "Law References"

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetLawReference(refId As Integer) As Channels.Message
        Return Legal.LawReference.GetReference(refId).ToJson
    End Function


    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetAllReference() As Channels.Message
        Return Legal.LawReference.GetAllReference().ToJson
    End Function

    <OperationContract()>
   <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function SaveLaeReference(lawRef As String) As Channels.Message

        Dim res = JsonConvert.DeserializeObject(Of Legal.LawReference)(lawRef)

        Try
            res.Save()

        Catch ex As Exception
            Throw ex
        End Try

        Return Nothing
    End Function

#End Region

End Class

Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports Twilio
<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class DialerAjaxService

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml"
    <OperationContract()>
    <WebGet(UriTemplate:="CallLog/{BBLE},{Log}")>
    Public Function CallLog(BBLE As String, Log As String) As Channels.Message


        LeadsActivityLog.AddActivityLog(Date.Now, Log, BBLE, LeadsActivityLog.LogCategory.Status, LeadsActivityLog.EnumActionType.CallOwner)
        Return New With {.status = True}.ToJson

    End Function
    <OperationContract()>
    <WebGet(UriTemplate:="GetCallDuration/{CallSid}")>
    Public Function GetCallDuration(CallSid As String) As Channels.Message
        Dim AccountSid As String = "AC7a286d92694557dd36277876d0c1564d"
        Dim AuthToken As String = "4d10548e8f394c399ff01bb21038dc53"
        Dim twilio = New TwilioRestClient(AccountSid, AuthToken)

        Dim [call] = twilio.GetCall(CallSid)
        Dim times = TimeSpan.FromSeconds([call].Duration)
        Dim duration = times.ToString("hh\:mm\:ss").Replace("00:", "").Replace("00:00:", "")
        Return duration.ToJson()

    End Function
    ' Add more operations here and mark them with <OperationContract()>

End Class

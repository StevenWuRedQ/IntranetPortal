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
    Shared AccountSid As String = "AC7a286d92694557dd36277876d0c1564d"
    Shared AuthToken As String = "4d10548e8f394c399ff01bb21038dc53"
    <OperationContract()>
    <WebGet(UriTemplate:="CallLog/{BBLE},{Log}")>
    Public Function CallLog(BBLE As String, Log As String) As Channels.Message


        LeadsActivityLog.AddActivityLog(Date.Now, Log, BBLE, LeadsActivityLog.LogCategory.Status, LeadsActivityLog.EnumActionType.CallOwner)
        Return New With {.status = True}.ToJson

    End Function
    <OperationContract()>
    <WebGet(UriTemplate:="GetCallDuration/{CallSid}")>
    Public Function GetCallDuration(CallSid As String) As Channels.Message

            Dim twilio = New TwilioRestClient(AccountSid, AuthToken)

            Dim [call] = twilio.GetCall(CallSid)
            Dim duration = "services error can't get duration "
            ' try to get confercens call
            If ([call] Is Nothing) Then
                [call] = GetOutboundCallInConference(CallSid)

            End If
            If ([call] IsNot Nothing AndAlso Not String.IsNullOrEmpty([call].Duration)) Then
                Dim times = TimeSpan.FromSeconds([call].Duration)

                duration = times.ToString("hh\:mm\:ss").Replace("00:", "").Replace("00:00:", "")
            Else
                Return duration.ToJson
            End If

            Return duration.ToJson()

    End Function
    Public Shared Function GetOutboundCallInConference(conferenceID) As Twilio.Call
        Dim twilio = New TwilioRestClient(AccountSid, AuthToken)
        Dim cofrence = Twilio.ListConferenceParticipants(conferenceID, False).Participants
        For Each p In cofrence
            Dim vcall = twilio.GetCall(p.CallSid)

            If (Not String.IsNullOrEmpty(vcall.To)) Then
                Return vcall
            End If
        Next
        Return Nothing
    End Function
    <OperationContract()>
   <WebGet(UriTemplate:="CallNumber/{PhoneNumber},{userName}")>
    Public Function CallNumber(PhoneNumber As String, userName As String) As Channels.Message

        Dim twilio = New TwilioRestClient(AccountSid, AuthToken)
        Dim options = New CallOptions()
        options.Url = "http://tasks.myidealprop.com/AutoDialer/Twiml.aspx" + "?ConfrenceName=" + userName.Replace(" ", "%20") + "&isout=true"
        'options.Url = HttpContext.Current.Server.UrlEncode(options.Url)
        options.To = PhoneNumber
        options.From = "+19179633481"
        Dim tcall = twilio.InitiateOutboundCall(options)

        Return tcall.Sid.ToJson

    End Function
    <OperationContract()>
    <WebGet(UriTemplate:="GetInporcesCallList")>
    Function GetInporcesCallList() As Channels.Message

        Dim twilio = New TwilioRestClient(AccountSid, AuthToken)

        ' Build the parameters 
        'Dim options = New CallListRequest()
        ''options.Status = "in-progress"
        'Dim calls = twilio.ListCalls(options)
        ''calls.Calls = calls.Calls.Take(10)
        'Return calls.Calls.Where(Function(c) Not String.IsNullOrEmpty(c.To)).ToList
        Dim request = New ConferenceListRequest()
        request.Status = "in-progress"
        Dim conferences = twilio.ListConferences(request)
        For Each c In conferences.Conferences
            Dim vcall = DialerAjaxService.GetOutboundCallInConference(c.Sid)
            If (vcall IsNot Nothing) Then
                c.AccountSid = vcall.To
                c.Status = vcall.Duration.ToString
                Exit For
            End If
            'Dim partics = twilio.ListConferenceParticipants(c.Sid, False).Participants
            'For Each p In partics
            '    Dim calls = twilio.GetCall(p.CallSid)
            '    If (Not String.IsNullOrEmpty(calls.To)) Then
            '        c.AccountSid = calls.To
            '        c.Status = calls.Duration.ToString
            '    End If
            'Next
            'c.Sid
        Next
        Return conferences.Conferences.ToJson
    End Function
    ' Add more operations here and mark them with <OperationContract()>

End Class

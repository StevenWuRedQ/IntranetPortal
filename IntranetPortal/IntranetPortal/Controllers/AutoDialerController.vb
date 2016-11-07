
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports Twilio
Imports Twilio.TwiML
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''' <summary>
''' for testing
''' should move to data base later
''' call it TwilioRecord maybe batter
''' </summary>
Public Class AutoDialerRecord
    Public Enum CallingStatus
        Pendding
        Calling
        Completed
        Waiting
        NoAnswer
    End Enum
    ''' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''' <summary>
    ''' Twilio call status constants
    ''' </summary>
    Public Shared ReadOnly TWILIO_CALL_STATUS_PENDDING As String = "pendding"

    ''' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Public Property BBLE As String
    Public Property LeadName As String
    Public Property Phone As String
    Public Property OwnerName As String
    ' Public Property Status As String = TWILIO_CALL_STATUS_PENDDING
    Public Property CallSid As String
    Public Property CallStatus As String = TWILIO_CALL_STATUS_PENDDING
    Public Sub update(tCall As [Call])
        CallStatus = tCall.Status
        CallSid = tCall.Sid
    End Sub

    Public Sub update(m_voice_request As VoiceRequest)
        CallStatus = m_voice_request.CallStatus
        CallSid = m_voice_request.CallSid
    End Sub

    Public Sub update(m_number_request As NumberRequest)
        CallStatus = m_number_request.CallStatus
        CallSid = m_number_request.CallSid
    End Sub
    Public Function IsThisNumber(c_phone As String) As Boolean

        Return Regex.Match(c_phone, "\d+").Value = Regex.Match(Phone, "\d+").Value
    End Function
    Public Function IsThisCall(call_id As String) As Boolean
        Return call_id = CallSid
    End Function
    Public Function IsAviable() As Boolean
        Return CallStatus = TWILIO_CALL_STATUS_PENDDING
    End Function
End Class

Public Class NumberRequest
    Public Property CallSid As String
    Public Property ParentCallSid As String
    Public Property CallStatus As String
    Public Property [Timestamp] As TimeSpan
    Public Property CallbackSource As String
    Public Property SequenceNumber As Integer

End Class

''' <summary>
''' This class can be used as the parameter on your voice action. Incoming parameters will be bound here.
''' </summary>
''' <remarks>http://www.twilio.com/docs/api/twiml/twilio_request</remarks>
Public Class VoiceRequest

    Public Property AccountSid() As String
        Get
            Return m_AccountSid
        End Get
        Set
            m_AccountSid = Value
        End Set
    End Property
    Private m_AccountSid As String

    ''' <summary>
    ''' The phone number or client identifier of the party that initiated the call
    ''' </summary>
    ''' <remarks>
    ''' Phone numbers are formatted with a '+' and country code, e.g. +16175551212 (E.164 format). Client identifiers begin with the client: URI scheme; for example, for a call from a client named 'tommy', the From parameter will be client:tommy.
    ''' </remarks>
    Public Property From() As String
        Get
            Return m_From
        End Get
        Set
            m_From = Value
        End Set
    End Property
    Private m_From As String

    ''' <summary>
    ''' The phone number or client identifier of the called party
    ''' </summary>
    ''' <remarks>
    ''' Phone numbers are formatted with a '+' and country code, e.g. +16175551212 (E.164 format). Client identifiers begin with the client: URI scheme; for example, for a call to a client named 'jenny', the To parameter will be client:jenny.
    ''' </remarks>
    Public Property [To]() As String
        Get
            Return m_To
        End Get
        Set
            m_To = Value
        End Set
    End Property
    Private m_To As String


    ''' <summary>
    ''' The city of the caller
    ''' </summary>
    Public Property FromCity() As String
        Get
            Return m_FromCity
        End Get
        Set
            m_FromCity = Value
        End Set
    End Property
    Private m_FromCity As String

    ''' <summary>
    ''' The state or province of the caller
    ''' </summary>
    Public Property FromState() As String
        Get
            Return m_FromState
        End Get
        Set
            m_FromState = Value
        End Set
    End Property
    Private m_FromState As String

    ''' <summary>
    ''' The postal code of the caller
    ''' </summary>
    Public Property FromZip() As String
        Get
            Return m_FromZip
        End Get
        Set
            m_FromZip = Value
        End Set
    End Property
    Private m_FromZip As String

    ''' <summary>
    ''' The country of the caller
    ''' </summary>
    Public Property FromCountry() As String
        Get
            Return m_FromCountry
        End Get
        Set
            m_FromCountry = Value
        End Set
    End Property
    Private m_FromCountry As String

    ''' <summary>
    ''' The city of the called party
    ''' </summary>
    Public Property ToCity() As String
        Get
            Return m_ToCity
        End Get
        Set
            m_ToCity = Value
        End Set
    End Property
    Private m_ToCity As String

    ''' <summary>
    ''' The state or province of the called party
    ''' </summary>
    Public Property ToState() As String
        Get
            Return m_ToState
        End Get
        Set
            m_ToState = Value
        End Set
    End Property
    Private m_ToState As String

    ''' <summary>
    ''' The postal code of the called party
    ''' </summary>
    Public Property ToZip() As String
        Get
            Return m_ToZip
        End Get
        Set
            m_ToZip = Value
        End Set
    End Property
    Private m_ToZip As String

    ''' <summary>
    ''' The country of the called party
    ''' </summary>
    Public Property ToCountry() As String
        Get
            Return m_ToCountry
        End Get
        Set
            m_ToCountry = Value
        End Set
    End Property
    Private m_ToCountry As String
    ''' <summary>
    ''' A unique identifier for this call, generated by Twilio
    ''' </summary>
    Public Property CallSid() As String
        Get
            Return m_CallSid
        End Get
        Set
            m_CallSid = Value
        End Set
    End Property
    Private m_CallSid As String

    ''' <summary>
    ''' A descriptive status for the call. The value is one of queued, ringing, in-progress, completed, busy, failed or no-answer
    ''' </summary>
    Public Property CallStatus() As String
        Get
            Return m_CallStatus
        End Get
        Set
            m_CallStatus = Value
        End Set
    End Property
    Private m_CallStatus As String

    ''' <summary>
    ''' The version of the Twilio API used to handle this call. For incoming calls, this is determined by the API version set on the called number. For outgoing calls, this is the API version used by the outgoing call's REST API request
    ''' </summary>
    Public Property ApiVersion() As String
        Get
            Return m_ApiVersion
        End Get
        Set
            m_ApiVersion = Value
        End Set
    End Property
    Private m_ApiVersion As String

    ''' <summary>
    ''' Indicates the direction of the call. In most cases this will be inbound, but if you are using Dial it will be outbound-dial
    ''' </summary>
    Public Property Direction() As String
        Get
            Return m_Direction
        End Get
        Set
            m_Direction = Value
        End Set
    End Property
    Private m_Direction As String

    ''' <summary>
    ''' This parameter is set only when Twilio receives a forwarded call, but its value depends on the caller's carrier including information when forwarding. Not all carriers support passing this information
    ''' </summary>
    Public Property ForwardedFrom() As String
        Get
            Return m_ForwardedFrom
        End Get
        Set
            m_ForwardedFrom = Value
        End Set
    End Property
    Private m_ForwardedFrom As String

    ''' <summary>
    ''' This parameter is set when the IncomingPhoneNumber that received the call has had its VoiceCallerIdLookup value set to true.
    ''' </summary>
    Public Property CallerName() As String
        Get
            Return m_CallerName
        End Get
        Set
            m_CallerName = Value
        End Set
    End Property
    Private m_CallerName As String

#Region "Gather & Record Parameters"

    ''' <summary>
    ''' When used with the Gather verb, the digits the caller pressed, excluding the finishOnKey digit if used.  
    ''' When used with the Record verb, the key (if any) pressed to end the recording or 'hangup' if the caller hung up
    ''' </summary>
    Public Property Digits() As String
        Get
            Return m_Digits
        End Get
        Set
            m_Digits = Value
        End Set
    End Property
    Private m_Digits As String

    ''' <summary>
    ''' The URL of the recorded audio.  When the result of a transcription, the URL for the transcription's source recording resource.
    ''' </summary>
    Public Property RecordingUrl() As String
        Get
            Return m_RecordingUrl
        End Get
        Set
            m_RecordingUrl = Value
        End Set
    End Property
    Private m_RecordingUrl As String

    ''' <summary>
    ''' The duration of the recorded audio (in seconds)
    ''' </summary>
    Public Property RecordingDuration() As String
        Get
            Return m_RecordingDuration
        End Get
        Set
            m_RecordingDuration = Value
        End Set
    End Property
    Private m_RecordingDuration As String

#End Region

#Region "Transcription Parameters"

    ''' <summary>
    ''' The unique 34 character ID of the transcription
    ''' </summary>
    Public Property TranscriptionSid() As String
        Get
            Return m_TranscriptionSid
        End Get
        Set
            m_TranscriptionSid = Value
        End Set
    End Property
    Private m_TranscriptionSid As String

    ''' <summary>
    ''' Contains the text of the transcription
    ''' </summary>
    Public Property TranscriptionText() As String
        Get
            Return m_TranscriptionText
        End Get
        Set
            m_TranscriptionText = Value
        End Set
    End Property
    Private m_TranscriptionText As String

    ''' <summary>
    ''' The status of the transcription attempt: either 'completed' or 'failed'
    ''' </summary>
    Public Property TranscriptionStatus() As String
        Get
            Return m_TranscriptionStatus
        End Get
        Set
            m_TranscriptionStatus = Value
        End Set
    End Property
    Private m_TranscriptionStatus As String

    ''' <summary>
    ''' The URL for the transcription's REST API resource
    ''' </summary>
    Public Property TranscriptionUrl() As String
        Get
            Return m_TranscriptionUrl
        End Get
        Set
            m_TranscriptionUrl = Value
        End Set
    End Property
    Private m_TranscriptionUrl As String

    ''' <summary>
    ''' The unique 34 character ID of the recording from which the transcription was generated
    ''' </summary>
    Public Property RecordingSid() As String
        Get
            Return m_RecordingSid
        End Get
        Set
            m_RecordingSid = Value
        End Set
    End Property
    Private m_RecordingSid As String

#End Region

#Region "Dial Parameters"

    ''' <summary>
    ''' The outcome of the Dial attempt. See the DialCallStatus section below for details
    ''' </summary>
    Public Property DialCallStatus() As String
        Get
            Return m_DialCallStatus
        End Get
        Set
            m_DialCallStatus = Value
        End Set
    End Property
    Private m_DialCallStatus As String

    ''' <summary>
    ''' The call sid of the new call leg. This parameter is not sent after dialing a conference
    ''' </summary>
    Public Property DialCallSid() As String
        Get
            Return m_DialCallSid
        End Get
        Set
            m_DialCallSid = Value
        End Set
    End Property
    Private m_DialCallSid As String

    ''' <summary>
    ''' The duration in seconds of the dialed call. This parameter is not sent after dialing a conference
    ''' </summary>
    Public Property DialCallDuration() As String
        Get
            Return m_DialCallDuration
        End Get
        Set
            m_DialCallDuration = Value
        End Set
    End Property
    Private m_DialCallDuration As String

#End Region
End Class
'''' call list if desgin database should combine Voice Request and AutoDaler Record
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Namespace Controllers
    <AllowAnonymous>
    Public Class AutoDialerController
        Inherits ApiController
        ''' <summary>
        ''' '''''''''''''''''''''''''''''''''''''''''''''''''''''
        ''' db example will move to database later
        ''' '''''''''''''''''''''''''''''''''''''''''''''''''''''
        ''' </summary>
        Public Shared db As List(Of AutoDialerRecord) = New List(Of AutoDialerRecord) From
                {
                   New AutoDialerRecord With {
                   .LeadName = "123 Main Street Flushing NY, 10000",
                   .Phone = "19298883289",
                   .OwnerName = "Steven Wu",
                   .CallStatus = AutoDialerRecord.TWILIO_CALL_STATUS_PENDDING
                   },
                   New AutoDialerRecord With {
                   .LeadName = "124 Main Street Queens NY, 10000",
                   .Phone = "19175175856",
                   .OwnerName = "Stephen Zhange",
                   .CallStatus = AutoDialerRecord.TWILIO_CALL_STATUS_PENDDING
                   }
                }
        ' Public Shared db2 As List(Of [Call]) = New List(Of [Call])
        Public Shared ReadOnly TwilioAPICallBackBase = "http://68.132.93.20:52585/"
        ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

        Shared AccountSid As String = "AC7a286d92694557dd36277876d0c1564d"
        Shared AuthToken As String = "4d10548e8f394c399ff01bb21038dc53"

        <AllowAnonymous>
        <Route("api/AutoDialer/{phone}")>
        Function GetCallNumber(phone As String) As IHttpActionResult
            Dim callNumber = db.Where(Function(p) p.IsAviable()).FirstOrDefault()

            Dim tcall = TwilioCallNumber(callNumber.Phone)

            callNumber.update(tcall)
            ' db2.Add(tcall)
            Return Ok(tcall)
        End Function

        Function TwilioCallNumber(phone As String) As [Call]
            Dim twilio = New TwilioRestClient(AccountSid, AuthToken)
            Dim options = New CallOptions()

            ' Get agent number here use Chris's number for testing now 
            ' but have a problem is showing called from number is custom self's number 
            ' using conference or do more research will solve this problem.
            ' Call agent first
            options.To = "19179633481"
            ' from set up 
            options.From = phone ' 
            options.Timeout = 999 'for testing 
            options.Url = TwilioAPICallBackBase & "/api/AutoDialer/Answer/" & options.From
            ' options.Url = HttpContext.Current.Server.UrlEncode(options.Url)
            ' options.Method = "GET"
            Dim tCall = twilio.InitiateOutboundCall(options)
            Dim c_call = db.Where(Function(c) c.IsThisNumber(phone)).FirstOrDefault()
            c_call.update(tCall)
            Return tCall
        End Function

        <AllowAnonymous>
        <Route("api/AutoDialer/Answer/{phone}")>
        Function PostAnswerNumber(phone As String, obj As VoiceRequest) As HttpResponseMessage
            Dim tr = New TwilioResponse()

            ' Dim tcall = db2.Where(Function(c) c.From.Contains(phone)).FirstOrDefault()
            Dim tcall = db.Where(Function(c) c.IsThisNumber(obj.[From])).FirstOrDefault()
            tcall.update(obj)
            Dim options = New PhoneNumberOptions()


            Dim c_number = New Number(obj.[From], New With {
                                      .statusCallbackEvent = "completed", 'add other events initiated ringing answered completed
                                      .statusCallback = TwilioAPICallBackBase & "/api/AutoDialer/StatusChange"
                                      })
            tr.Dial(c_number, New With {.callerId = obj.CallSid})
            Dim res = Request.CreateResponse(HttpStatusCode.OK)
            res.Content = New StringContent(tr.Element.ToString(), Encoding.UTF8, "application/xml")
            Return res
        End Function
        <AllowAnonymous>
        <Route("api/AutoDialer/StatusChange")>
        Function PostStatusChange(obj As NumberRequest) As IHttpActionResult
            ' Dim tr = New TwilioResponse()
            Dim t_call = db.Where(Function(c) c.IsThisCall(obj.ParentCallSid)).FirstOrDefault()
            t_call.update(obj)

            Dim nextCall = db.Where(Function(c) c.IsAviable()).FirstOrDefault()
            If (nextCall IsNot Nothing) Then
                Dim nextTwilioCall = TwilioCallNumber(nextCall.Phone)
                nextCall.update(nextTwilioCall)
            End If
            Return Ok(db)
            ' Dim tcall = db2.Where(Function(c) c.From.Contains(phone)).FirstOrDefault()

        End Function

    End Class
End Namespace
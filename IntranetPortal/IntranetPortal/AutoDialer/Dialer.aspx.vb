Imports Twilio
Imports RestSharp


Public Class Dialer
    Inherits System.Web.UI.Page
    Public CalledNumber As String
    Public CallModel = True
    Public Monitor As String
    Public BBLE As String
    Public TrainingMode As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then

            CalledNumber = Request.QueryString("PN")
            BBLE = Request.QueryString("BBLE")
            Monitor = Request.QueryString("Monitor")

        End If
    End Sub
   
    Public ReadOnly Property TwilioToken As String
        Get

            Dim accountSid = "AC7a286d92694557dd36277876d0c1564d"
            Dim authToken = "4d10548e8f394c399ff01bb21038dc53"
            Dim appSid = "AP28c5fe5b36df57231d5e021de14c62ab"

            Dim capability = New TwilioCapability(accountSid, authToken)

            capability.AllowClientOutgoing(appSid)

            'If (Not String.IsNullOrEmpty(Monitor)) Then
            '    capability.AllowClientIncoming("jenny")
            'End If

            Return capability.GenerateToken()
        End Get
    End Property



    Protected Sub CallManger_ServerClick(sender As Object, e As EventArgs)
        Dim accountSid = "AC7a286d92694557dd36277876d0c1564d"
        Dim authToken = "4d10548e8f394c399ff01bb21038dc53"
        Dim client = New TwilioRestClient(accountSid, authToken)
        Dim c = client.GetConference("abc")


        Dim twiml = New Twilio.TwiML.TwilioResponse()
        twiml.Say("Connecting you to agent 1. All calls are recorded.")
        ' @end snippet
        twiml.Dial(New Twilio.TwiML.Number("+19298883289", New With { _
            Key .url = "screen-caller.xml", _
            Key .method = "GET" _
        }), New With { _
            Key .record = "true" _
        })

    End Sub
End Class
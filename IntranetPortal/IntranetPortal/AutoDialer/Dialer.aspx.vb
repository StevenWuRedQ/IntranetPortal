Imports Twilio

Public Class Dialer
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then

            CalledNumber = Request.QueryString("PN")
        End If
    End Sub
    Public CalledNumber As String

    Public ReadOnly Property TwilioToken As String
        Get

            Dim accountSid = "AC7a286d92694557dd36277876d0c1564d"
            Dim authToken = "4d10548e8f394c399ff01bb21038dc53"
            Dim appSid = "AP28c5fe5b36df57231d5e021de14c62ab"

            Dim capability = New TwilioCapability(accountSid, authToken)
            capability.AllowClientOutgoing(appSid)
            capability.AllowClientIncoming("jenny")
            Return capability.GenerateToken()
        End Get
    End Property



End Class
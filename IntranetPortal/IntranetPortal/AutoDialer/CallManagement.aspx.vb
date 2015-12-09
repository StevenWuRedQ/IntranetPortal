Imports Twilio

Public Class CallManagement
    Inherits System.Web.UI.Page
    Public Property CallList As List(Of Twilio.Conference)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            CallList = GetInporcesCallList()
        End If
    End Sub
    Function GetInporcesCallList() As List(Of Twilio.Conference)
        Dim AccountSid As String = "AC7a286d92694557dd36277876d0c1564d"
        Dim AuthToken As String = "4d10548e8f394c399ff01bb21038dc53"
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
                c.Status = vcall.Direction.ToString
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
        Return conferences.Conferences
    End Function
End Class
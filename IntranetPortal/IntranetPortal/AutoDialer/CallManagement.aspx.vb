Imports Twilio

Public Class CallManagement
    Inherits System.Web.UI.Page
    Public Property CallList As List(Of Twilio.Call)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            CallList = GetInporcesCallList()
        End If
    End Sub
    Function GetInporcesCallList() As List(Of Twilio.Call)
        Dim AccountSid As String = "AC7a286d92694557dd36277876d0c1564d"
        Dim AuthToken As String = "4d10548e8f394c399ff01bb21038dc53"
        Dim twilio = New TwilioRestClient(AccountSid, AuthToken)

        ' Build the parameters 
        Dim options = New CallListRequest()
        'options.Status = "in-progress"
        Dim calls = twilio.ListCalls(options)
        'calls.Calls = calls.Calls.Take(10)
        Return calls.Calls.Where(Function(c) Not String.IsNullOrEmpty(c.To)).ToList
    End Function
End Class
Imports Twilio

Public Class TwilioClient

    Const AccountSid As String = "AC7a286d92694557dd36277876d0c1564d"
    Const AuthToken As String = "4d10548e8f394c399ff01bb21038dc53"

    Public Function SendMessge(number As String, msgText As String) As String

        Dim client As New TwilioRestClient(AccountSid, AuthToken)

        Dim msg = client.SendMessage("+15168740602", number, msgText)

        Return msg.Sid
    End Function

End Class

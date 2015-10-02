Imports ImapX
Imports ImapX.Flags

Public Class ParseEmailService
    Public Shared Function LogInEmail() As String
        Dim client = New ImapClient("box1030.bluehost.com", True)

        If client.Connect() Then

            ' login successful
            If client.Login("Portal.etrack@myidealprop.com", "ColorBlue1") Then
                'For Each message In client.Folders.Inbox.Messages
                '    message.DownloadRawMessage()
                'Next
                Dim message = client.Folders.Inbox.Search("ALL", -1, -1).Where(Function(s) Not s.Seen).FirstOrDefault

                If (message IsNot Nothing) Then

                    message.Flags.Add(MessageFlags.Seen)
                    Return message.Date & ":" & message.Body.Text

                Else
                    Return "Can not read inbox message"
                End If

                Return "Success"
            End If

            ' connection not successful
        Else

        End If
        Return "Fail"
    End Function
End Class

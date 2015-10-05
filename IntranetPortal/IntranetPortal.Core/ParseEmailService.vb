Imports ImapX
Imports ImapX.Flags

Public Class ParseEmailService

    Property Password As String
    Property Email As String
    Public Sub New(email As String, password As String)
        Me.Password = password
        Me.Email = email

        ' ConntectEmail()
    End Sub


    Function ConntectEmail() As ImapClient
        Dim client = New ImapClient("box1030.bluehost.com", True)
        If (client.IsConnected) Then
            client.Disconnect()
        End If

        If client.Connect() Then
            If client.Login(Email, Password) Then
                Return client
            End If

        End If

        Return Nothing

    End Function

    Public Function GetNewEmails() As List(Of Message)
        Dim client = ConntectEmail()
        Return client.Folders.Inbox.Search("UNSEEN", -1, -1).ToList


    End Function

    Public Shared Function LogInEmail() As List(Of Message)
        Dim client = New ImapClient("box1030.bluehost.com", True)

        If client.Connect() Then

            ' login successful
            If client.Login("Portal.etrack@myidealprop.com", "ColorBlue1") Then
                'For Each message In client.Folders.Inbox.Messages
                '    message.DownloadRawMessage()
                'Next
                Dim msgs = client.Folders.Inbox.Search("UNSEEN", -1, -1)
                Return msgs.ToList
                For Each message In msgs

                    If (message IsNot Nothing) Then

                        'message.Flags.Add(MessageFlags.Seen)

                        'Return message.Date & ":" & message.Body.Text

                    Else
                        'Return "Can not read inbox message"
                    End If
                Next
                Return Nothing
            End If

            ' connection not successful
        Else

        End If
        Return Nothing
    End Function
End Class

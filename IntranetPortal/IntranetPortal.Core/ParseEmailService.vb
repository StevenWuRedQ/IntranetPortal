Imports ImapX
Imports ImapX.Flags

Public Class ParseEmailService

    Public Delegate Function ParseAction(msg As Message) As Boolean
    Private client As ImapClient
    Property Password As String
    Property Email As String
    Public Sub New(email As String, password As String)
        Me.Password = password
        Me.Email = email

        client = ConnectEmail()
    End Sub

    Function SearchEamil(query As String) As List(Of Message)
        Return client.Folders.Inbox.Search(query, -1, -1).ToList
    End Function
    Function ConnectEmail() As ImapClient
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

    Function IsLogedIn() As Boolean
        Return client IsNot Nothing AndAlso client.Folders IsNot Nothing And client.Folders.Inbox IsNot Nothing
    End Function
    Sub ParseNewEmails(action As ParseAction)
        Dim msgs = GetNewEmails()
        If (action IsNot Nothing) Then
            For Each m In msgs
                If (action(m)) Then
                    'If parse sucess then mark message as read otherwise check all unreed message
                    m.Flags.Add(MessageFlags.Seen)
                End If
                'All the message subject  contain reminder should mark as read automatically   
                If (m IsNot Nothing And Not String.IsNullOrEmpty(m.Subject) And m.Subject.Contains("reminder")) Then
                    m.Flags.Add(MessageFlags.Seen)
                End If
            Next
        End If
    End Sub

    Public Function GetNewEmails() As List(Of Message)
        If (Not IsLogedIn()) Then
            client = ConnectEmail()
        End If
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

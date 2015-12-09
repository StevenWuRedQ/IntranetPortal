Partial Public Class UserMessage
    Public Shared Function GetNewMessage(userName As String) As UserMessage
        Using context As New Entities
            Return context.UserMessages.Where(Function(msg) msg.UserName = userName And msg.Status = MsgStatus.Active And msg.NotifyTime < DateTime.Now).OrderByDescending(Function(msg) msg.NotifyTime).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetAllNewMessage(userName As String) As List(Of UserMessage)
        Using context As New Entities
            Return context.UserMessages.Where(Function(msg) msg.UserName = userName And msg.Status = MsgStatus.Active And msg.NotifyTime < DateTime.Now).OrderByDescending(Function(msg) msg.NotifyTime).ToList
        End Using
    End Function

    Public Shared Function GetUserMessages(createUser As String) As List(Of UserMessage)
        Using context As New Entities
            Return context.UserMessages.Where(Function(msg) msg.Createby = createUser And msg.Status = MsgStatus.Active).OrderBy(Function(msg) msg.NotifyTime).ToList
        End Using
    End Function

    Public Shared Function AddNewMessage(userName As String, title As String, message As String, bble As String, Optional msgUrl As String = Nothing)
        Dim createBy = ""
        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing Then
            createBy = HttpContext.Current.User.Identity.Name
        Else
            createBy = "Portal"
        End If

        Return AddNewMessage(userName, title, message, bble, DateTime.Now, createBy, msgUrl)
    End Function

    'Public Shared Function AddNewMessage(userName As String, title As String, message As String, bble As String, notifyTime As DateTime)
    '    Dim createBy = ""
    '    If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing Then
    '        createBy = HttpContext.Current.User.Identity.Name
    '    Else
    '        createBy = "Portal"
    '    End If

    '    Return AddNewMessage(userName, title, message, bble, notifyTime, createBy, Nothing)
    'End Function

    Public Shared Function AddNewMessage(userName As String, title As String, message As String, bble As String, notifyTime As DateTime, createBy As String, Optional msgUrl As String = Nothing)
        Dim msg As New UserMessage
        msg.BBLE = bble
        msg.Title = title
        msg.UserName = userName
        msg.Message = message
        msg.NotifyTime = notifyTime

        If Not String.IsNullOrEmpty(msgUrl) Then
            msg.MsgUrl = msgUrl
        End If

        msg.Status = UserMessage.MsgStatus.Active
        msg.Createby = createBy
        msg.CreateTime = DateTime.Now
        Try
            Using context As New Entities
                context.UserMessages.Add(msg)
                context.SaveChanges()

                Return True
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Shared Function ReadMsg(userName As String, msgId As Integer) As Boolean
        Using context As New Entities

            Dim msg = context.UserMessages.Where(Function(m) m.MsgID = msgId And m.UserName = userName).FirstOrDefault

            If msg IsNot Nothing Then
                msg.Status = MsgStatus.Read
                msg.ReceiveTime = DateTime.Now

                context.SaveChanges()
                Return True
            End If
        End Using
        Return False
    End Function

    Public Enum MsgStatus
        Active
        Read
    End Enum
End Class

Imports System.Text.RegularExpressions
Imports ImapX
Public Class LegalECourt


    Public Sub UpdateApperanceDate()
        If (BodyText IsNot Nothing) Then
            Dim regexDate = "\d{2}\/\d{2}\/\d{4}"
            Dim AppearanceDateregex = "Appearance Date: " & regexDate
            Dim AppearDateList As New List(Of DateTime)
            Dim matches = Regex.Matches(BodyText, AppearanceDateregex)
            For Each m In Regex.Matches(BodyText, AppearanceDateregex)
                AppearDateList.Add(DateTime.Parse(Regex.Match(m.Value.ToString(), regexDate).Value))
            Next
            Dim matchedDate = AppearDateList.OrderByDescending(Function(i) i).FirstOrDefault
            If (matchedDate > Date.MinValue) Then
                AppearanceDate = matchedDate
            End If

        End If
    End Sub
    Public Sub UpdateIndexNumber()
        If (BodyText IsNot Nothing) Then
            Dim regexIndexNum = "\d{6}\/\d{4}"
            Dim IndexNumregex = "Index Number: " & regexIndexNum
            Dim IndexNumMatch = Regex.Match(BodyText, IndexNumregex)
            If (IndexNumMatch.Success) Then
                Dim indexNum = Regex.Match(IndexNumMatch.Value, regexIndexNum).Value
                If (Not String.IsNullOrEmpty(indexNum)) Then
                    Me.IndexNumber = indexNum
                End If
            End If
        End If
    End Sub
    Public Sub UpdateBBLE()
        If (Not String.IsNullOrEmpty(Me.IndexNumber)) Then
            Dim lcase = LegalCase.GetLegalCaseByFcIndex(Me.IndexNumber)
            If (lcase IsNot Nothing) Then
                Me.BBLE = lcase.BBLE
            End If
        End If
    End Sub

    Public Shared Function GetCaseByNoticeyDay(day As Integer) As List(Of LegalECourt)
        Using ctx As New LegalModelContainer
            Return ctx.LegalECourts.Where(Function(e) (e.AppearanceDate <= Date.Now.AddDays(day) AndAlso e.AppearanceDate > Date.Now.AddDays(day - 1)) AndAlso (Not String.IsNullOrEmpty(e.BBLE))).ToList
        End Using
    End Function
    Public Shared Function GetLegalEcourt(bble As String) As LegalECourt
        Using ctx As New LegalModelContainer
            Return ctx.LegalECourts.Where(Function(e) e.BBLE = bble).OrderByDescending(Function(e) e.UpdateTime).FirstOrDefault
        End Using
    End Function
    Public Shared Function Parse(msg As ImapX.Message) As LegalECourt
        Dim eCourt As LegalECourt
        If msg Is Nothing Then
            Throw New Exception("msg can't be null !")
        End If
        Using ctx As New LegalModelContainer
            eCourt = ctx.LegalECourts.Where(Function(e) e.UpdateTime = msg.Date AndAlso msg.Subject = msg.Subject).FirstOrDefault
            If (eCourt Is Nothing) Then
                eCourt = New LegalECourt
                eCourt.CreateDate = DateTime.Now
                ctx.LegalECourts.Add(eCourt)
            End If
            eCourt.MessageId = msg.MessageId
            eCourt.UpdateTime = msg.Date
            eCourt.Subject = msg.Subject
            eCourt.BodyHtml = msg.Body.Html
            eCourt.BodyText = msg.Body.Text
            eCourt.UpdateApperanceDate()
            eCourt.UpdateIndexNumber()
            eCourt.UpdateBBLE()

            ctx.SaveChanges()

        End Using
        Return eCourt
    End Function
End Class

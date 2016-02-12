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
            Dim regexIndexNum = "\d{6,}\/\d{4}"

            Dim IndexNumregex = "Index Number: " & regexIndexNum
            Dim IndexNumMatch = Regex.Match(BodyText, IndexNumregex)
            If (IndexNumMatch.Success) Then
                Dim indexNum = Regex.Match(IndexNumMatch.Value, regexIndexNum).Value
                indexNum = indexNum.Trim()
                'only take 6 when there are 7 digit on front
                Dim leadZeroRegx = New Regex("^0*")
                indexNum = leadZeroRegx.Replace(indexNum, "")
                If (Not String.IsNullOrEmpty(indexNum)) Then
                    Me.IndexNumber = indexNum
                End If
            End If
        End If
    End Sub
    Public Function UpdateBBLE() As Boolean
        If (Not String.IsNullOrEmpty(Me.IndexNumber)) Then
            Dim lcase = LegalCase.GetLegalCaseByFcIndex(Me.IndexNumber)
            If (lcase IsNot Nothing) Then
                Dim Changed = Me.BBLE Is Nothing Or Me.BBLE <> lcase.BBLE
                Me.BBLE = lcase.BBLE

                'When changed save it to database
                If (Changed) Then
                    Using db As New PortalEntities

                        Dim original = db.LegalECourts.Find(Me.Id)
                        If (original IsNot Nothing) Then
                            original.BBLE = Me.BBLE
                            db.SaveChanges()
                        End If

                    End Using
                End If

                Return Changed
            End If
        End If
        Return False
    End Function

    Public Shared Function GetIndexLegalECourts() As List(Of LegalECourt)
        Using ctx As New PortalEntities
            Return ctx.LegalECourts.Where(Function(e) Not String.IsNullOrEmpty(e.IndexNumber)).ToList
        End Using
    End Function

    ''' <summary>
    ''' Get all legal ecourt case apperance date between days form now.
    ''' todo: change get all list only have the last appearance date
    ''' </summary>
    ''' <param name="day">Interval days to AppearanceDate  </param>
    ''' <returns> legal ecourt list need notice</returns>
    Public Shared Function GetCaseByNoticeyDay(day As Integer) As List(Of LegalECourt)

        Using ctx As New PortalEntities
            Dim MaxDate = Date.Now.AddDays(day)
            Return ctx.LegalECourts.Where(Function(e) (e.AppearanceDate <= MaxDate AndAlso e.AppearanceDate > Date.Now) AndAlso (Not String.IsNullOrEmpty(e.BBLE))).ToList
        End Using
    End Function
    Public Shared Function GetLegalEcourt(bble As String) As LegalECourt
        Using ctx As New PortalEntities
            Return ctx.LegalECourts.Where(Function(e) e.BBLE = bble And e.AppearanceDate.HasValue).OrderByDescending(Function(e) e.UpdateTime).FirstOrDefault
        End Using
    End Function
    Public Shared Function GetLeaglECourtIndexnum(index As String) As LegalECourt
        Dim trimIndex = LegalCase.IndexNumberFormat(index)
        Using ctx As New PortalEntities
            Dim IndexList = ctx.LegalECourts.Where(Function(e) e.IndexNumber.Contains(trimIndex) And e.AppearanceDate.HasValue).ToList
            Dim mathList = New List(Of LegalECourt)
            For Each e In IndexList
                If (trimIndex = LegalCase.IndexNumberFormat(e.IndexNumber)) Then
                    mathList.Add(e)
                End If
            Next

            Return mathList.OrderByDescending(Function(e) e.AppearanceDate).FirstOrDefault()
        End Using
    End Function

    Public Shared Function GetParseErrorECourts() As List(Of LegalECourt)
        Using ctx As New PortalEntities
            Return ctx.LegalECourts.Where(Function(e) (Not String.IsNullOrEmpty(e.IndexNumber)) AndAlso String.IsNullOrEmpty(e.BBLE)).ToList()
        End Using
    End Function

    Public Shared Function Parse(msg As ImapX.Message) As LegalECourt

        Dim eCourt As LegalECourt
        If msg Is Nothing Then
            Throw New Exception("msg can't be null !")
        End If
        Using ctx As New PortalEntities
            eCourt = ctx.LegalECourts.Where(Function(e) e.UpdateTime = msg.Date AndAlso e.Subject = msg.Subject).FirstOrDefault
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

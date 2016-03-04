Imports System.Runtime.Serialization

<DataContract>
Public Class NoticeECourtRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        Log("======================Start Notify ECourt date==============================")
        NotifyEcourtDate()

        Log("======================End Notify ECourt date==============================")

        Log("======================Start Notify ECourt Parse Error==============================")
        NotifyECourtParseError()
        Log("======================End Notify ECourt Parse Error==============================")
    End Sub

    Public Sub NotifyECourtParseError()
        Dim lCases = Data.LegalECourt.GetParseErrorECourts()
        If (lCases IsNot Nothing And lCases.Count > 0) Then
            Dim IndexNumbers = lCases.Select(Function(e) e.IndexNumber).Select(Function(i)
                                                                                   Return Data.LegalCase.DeCodeIndexNumber(i)
                                                                               End Function).Distinct().ToList()

            Dim names = String.Join(";", LegalCaseManage.GetLegalManagers().Select(Function(e) e.Name))


            Log("===========Send email to " & names & "to notify all the missing case in portal ===========")
            Log("------missing index list ---------------")
            Log(":" & vbCrLf & String.Join(vbCrLf, IndexNumbers))
            Log("------end index list ---------------")
            Using client As New PortalService.CommonServiceClient
                Dim maildata = New Dictionary(Of String, String)
                maildata.Add("IndexCount", IndexNumbers.Count)
                maildata.Add("IndexList", String.Join("<br />", IndexNumbers))
                client.SendEmailByTemplate(names, "LegalECourtMissingCase", maildata)
            End Using

        End If
    End Sub
    Public Sub NotifyEcourtDate()
        'Dim NoticeDays = {14, 6, 2, 0}
        Dim d = 15
        'For Each d In NoticeDays
        Log("To Notify Ecourt per lead before " & d & " days")
        Dim caseNoticey = Data.LegalECourt.GetCaseByNoticeyDay(d)
        Dim cases = (From x In caseNoticey Join y In Data.LegalCase.GetAllCases() On x.IndexNumber Equals y.FCIndexNum Select x)
        Dim bbles = (From s In cases Group s By s.BBLE Into r = Group Select BBLE, AppearanceDate = r.Max(Function(o) o.AppearanceDate))

        For Each b In bbles
            Dim names = LegalCaseManage.GetCaseRelateUsersName(b.BBLE)
            If ((Not String.IsNullOrEmpty(names)) And b.AppearanceDate IsNot Nothing) Then
                Using client As New PortalService.CommonServiceClient
                    Dim lCase = Data.LegalCase.GetCase(b.BBLE)
                    Dim ECourt = Data.LegalECourt.GetLegalEcourt(b.BBLE)
                    Dim maildata = New Dictionary(Of String, String)
                    maildata.Add("CaseName", lCase.CaseName)
                    maildata.Add("AppearanceDate", ECourt.AppearanceDate)
                    maildata.Add("IndexNumber", ECourt.IndexNumber)
                    maildata.Add("BBLE", ECourt.BBLE)
                    Dim stamp = (ECourt.AppearanceDate - Date.Now)
                    maildata.Add("Days", (stamp.Value.Days + 1).ToString)
                    client.SendEmailByTemplate(names, "LegalECourtDateNotify", maildata)
                End Using
                Log("Send email to " & names & " the next Ecourt date Is " & b.BBLE)
            Else
                Log("Can't find relate user for legal case " & b.BBLE)
        End If
            Log("To Notify per lead : " & b.BBLE & " for " & names)
        Next
        'Next
    End Sub

End Class

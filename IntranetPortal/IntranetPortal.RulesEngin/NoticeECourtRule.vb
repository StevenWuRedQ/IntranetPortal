Imports System.Runtime.Serialization

<DataContract>
Public Class NoticeECourtRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        Log("======================Start Notify ECourt date==============================")
        'Dim NoticeDays = {14, 6, 2, 0}
        Dim d = 15
        'For Each d In NoticeDays
        Log("To Notify Ecourt per lead before " & d & " days")
        Dim cases = Data.LegalECourt.GetCaseByNoticeyDay(d)
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
                Log("Send email to " & names & " the next Ecourt date is " & b.BBLE)
            Else
                Log("Can't find relate user for legal case " & b.BBLE)
            End If
            Log("To Notify per lead : " & b.BBLE & " for " & names)
        Next
        'Next
        Log("======================End Notify ECourt date==============================")
    End Sub

End Class

Imports System.Runtime.Serialization

<DataContract>
Public Class ScanECourtsRule
    Inherits BaseRule
    ''' <summary>
    ''' Parse each email and send user email when the parse get the right BBLE
    ''' </summary>
    ''' <param name="msg"> the message you want parse</param>
    ''' <returns>if the message the the right index number and AppearanceDate day</returns>
    Function ParseEourtEmail(msg As ImapX.Message) As Boolean

        Dim eCourt = Data.LegalECourt.Parse(msg)

        Dim parseSuccess = eCourt IsNot Nothing AndAlso (Not String.IsNullOrEmpty(eCourt.BBLE))


        If (parseSuccess) Then
            'Log("sucessed parse mail get Legal Case BBLE :" & eCourt.BBLE & " LegalECourt Id :" & eCourt.Id)

            If (Not eCourt.AppearanceDate.HasValue) Then
                Log("this email do not contain AppearanceDate id = " & eCourt.Id)
                Return False
            End If
            Dim legalManger = LegalCaseManage.GetLegalManger()
            If (legalManger IsNot Nothing) Then

                Dim lcase = Data.LegalCase.GetCase(eCourt.BBLE)
                'Log("LegalCase bble: " & lcase.BBLE & "  IndexNumber: " & lcase.FCIndexNum & " == eCourt IndexNumber: " & eCourt.IndexNumber & " eCourt Id: " & eCourt.Id)
                If (lcase.FCIndexNum <> eCourt.IndexNumber) Then
                    Log("There are an error happan get woring BBLE eCourt id: " & eCourt.Id)
                End If
                Dim SendList = {lcase.Attorney, lcase.ResearchBy}
                Dim eList = SendList.Where(Function(e) Not String.IsNullOrEmpty(e)).Select(Function(e) Employee.GetInstance(e)).ToList

                eList.Add(legalManger)
                Dim emails = String.Join(";", eList.Select(Function(e) e.Email).Distinct.ToArray)
                Dim Users = String.Join(";", eList.Select(Function(e) e.Name).Distinct.ToArray)
                Dim maildata = New Dictionary(Of String, String)
                maildata.Add("IndexNumber", eCourt.IndexNumber)
                maildata.Add("Users", Users)
                maildata.Add("CaseName", lcase.CaseName)
                maildata.Add("BBLE", eCourt.BBLE)
                maildata.Add("AppearanceDate", eCourt.AppearanceDate)

                If (String.IsNullOrEmpty(Users)) Then
                    Log("Can't get users for case BBLE: " & eCourt.BBLE)
                End If
                If (String.IsNullOrEmpty(emails)) Then
                    Log("Can't get emails for case BBLE: " & eCourt.BBLE)
                End If
                Using client As New PortalService.CommonServiceClient
                    client.SendEmailByTemplate(Users, "LegalScanECourtNotify", maildata)
                End Using
                'Core.EmailService.SendMail(emails, Nothing, "LegalScanECourtNotify", maildata)
                Log("Send email to  :" & Users & " for BBLE: " & lcase.BBLE)

            Else
                Log("Can not find legal didn't send email please notice !")
            End If

        Else
            If (msg.Date IsNot Nothing AndAlso msg.Date > Date.Now.AddMinutes(-30)) Then
                Log("Parse mail Failed ! email subject : " & msg.Subject & " Recived Date: " & msg.Date)

            End If
        End If
        Return parseSuccess
    End Function
    Public Overrides Sub Execute()
        Log("========================Starting scan email for ECourts============================================")

        Dim serv = New Core.ParseEmailService("Portal.etrack@myidealprop.com", "ColorBlue1")
        If (Not serv.IsLogedIn()) Then
            Log("Can not Login Etrack account email please notice !")
        End If
        serv.ParseNewEmails(AddressOf Me.ParseEourtEmail)
        Log("======================== Scan email for ECourts Completed. ========================================")

        Log("======================== Start Upadate BBLE for all ECourt Email ========================================")
        Dim eCases = Data.LegalECourt.GetIndexLegalECourts()
        For Each c In eCases
            If (c.UpdateBBLE()) Then
                Log("Update Ecourt :" & c.IndexNumber & "Legal Ecourt Id: " & c.Id & "To BBLE: " & c.BBLE)
            End If
        Next
        Log("======================== End Upadate BBLE for all ECourt Email ==========================================")
    End Sub
End Class

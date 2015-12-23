Imports ImapX
Imports IntranetPortal
Imports IntranetPortal.Data
Imports IntranetPortal.RulesEngine

<TestClass()>
Public Class EmailParseTest

    <TestMethod()>
    Public Sub ParseEmailsTest()

        Dim MessageStr = <string>Index Number: 012011/2014
The following case which you have subscribed to in eTrack has been updated. Changes from the last update are shown in red and are annotated.

Court: Queens Civil Supreme
Index Number: 012011/2014
Case Name: LEON, JEANETH vs. MUNOZ, ANGEL
Case Type: Other Real Property
Track: Standard
Upstate RJI Number: 
Disposition Date: 
Date NOI Due: 
NOI Filed: 
Calendar Number: 
RJI Filed: 09/17/2014
Jury Status: 
Justice Name: COMPLIANCE CONF JUDGE

Attorney/Firm for Plaintiff: 
LIZARRAGA LAW FIRM, PLLC
37-53 90 STR. SUITE 03        
JACKSON HEIGHTS   NY 11372
Attorney Type: Attorney Of Record
Status: Active

Attorney/Firm for Defendant: 
ANGEL MUNOZ                    - Prose


Attorney Type: Pro se
Status: Active

Attorney/Firm for Defendant: 
CBJ HOLDINGS, INC.             - Prose


Attorney Type: Pro se
Status: Active

Last Appearance:
Appearance Date: 12/02/2015
Appearance Time: 
On For: Motion
Appearance Outcome: Fully Submitted
Justice: TIMOTHY J. DUFFICY
Part: CENTRALIZED MOTION PART
Comments: 102815


Future Appearances:
Appearance Date: 03/18/2016
Appearance Time: 
On For: Supreme Trial
Appearance Outcome: 
Justice: TIMOTHY J. DUFFICY
Part: NOTE OF ISSUE DUE
Comments: 

Appearance Date: 12/23/2015
Appearance Time: 
On For: Motion
Appearance Outcome: 
Justice: TIMOTHY J. DUFFICY
Part: CENTRALIZED MOTION PART
Comments: 



Older appearances may exist but are not shown.

Motions: Motion Number: 7
Date Filed: 12/14/2015
Filed By: PLAINT
Relief Sought: Compel (Other)
Submit Date: 
Answer Demanded: Yes
Status: Open: 

 Before Justice: DUFFICY
Decision:   
Order Signed Date: 

Motion Number: 6
Date Filed: 10/15/2015
Filed By: DEF
Relief Sought: Deposit Monies Into Court
Submit Date: 12/02/2015
Answer Demanded: No
Status: Decided: 17-DEC-15 --- Information updated
SEE DECISION --- Information updated
 Before Justice: DUFFICY
Decision: Short Form Order  --- Information updated
Order Signed Date: 12/17/2015 --- Information updated

Motion Number: 5
Date Filed: 01/23/2015
Filed By: PLAINT
Relief Sought: Stay Action/Proceeding
Submit Date: 
Answer Demanded: No
Status: Decided: 24-MAR-15
MARKED OFF
 Before Justice: DUFFICY
Decision: Oral 
Order Signed Date: 

Motion Number: 4
Date Filed: 12/22/2014
Filed By: DEF
Relief Sought: Other Motion (See Comment)
Submit Date: 03/10/2015
Answer Demanded: Yes
Status: Decided: 19-MAR-15
SEE DECISION
 Before Justice: DUFFICY
Decision: Short Form Order 
Order Signed Date: 03/19/2015

Motion Number: 3
Date Filed: 10/20/2014
Filed By: PLAINT
Relief Sought: Default Judgment/Inquest
Submit Date: 02/03/2015
Answer Demanded: Yes
Status: Decided: 10-FEB-15
INQUEST AT TIME OF TRIAL
 Before Justice: DUFFICY
Decision: Short Form Order 
Order Signed Date: 02/10/2015

Motion Number: 2
Date Filed: 09/23/2014
Filed By: PLAINT
Relief Sought: Stay Action/Proceeding
Submit Date: 10/09/2014
Answer Demanded: No
Status: Decided: 17-OCT-14
MOTION DENIED
 Before Justice: DUFFICY
Decision: Short Form Order 
Order Signed Date: 10/17/2014

Motion Number: 1
Date Filed: 09/17/2014
Filed By: PLAINT
Relief Sought: Stay Action/Proceeding
Submit Date: 10/09/2014
Answer Demanded: No
Status: Decided: 17-OCT-14
GRANTED TO THE EXTENT
 Before Justice: DUFFICY
Decision: Short Form Order 
Order Signed Date: 10/17/2014


Scanned Decisions: None on file.

To access this case directly https://iapps.courts.state.ny.us/webcivil/FCASJcaptcha?forward_url=/webcivil/FCASSearch%3FtxtIndex%3D012011/2014%26cboCounty%3D40%26from%3DY click here. --- Information updated
This is an automated e-mail. If you have questions please e-mail eCourts@nycourts.gov --- Information updated


</string>


        Dim ecourt = New LegalECourt()
        ecourt.BodyText = MessageStr
        ecourt.UpdateApperanceDate()
        ecourt.UpdateIndexNumber()
        ecourt.UpdateBBLE()
        Assert.IsTrue(ecourt.AppearanceDate > DateTime.MinValue)
        Assert.IsTrue(Not String.IsNullOrEmpty(ecourt.IndexNumber))
        Assert.IsTrue(Not String.IsNullOrEmpty(ecourt.BBLE))
    End Sub
    ''' <summary>
    ''' test if there are get the right BBLE
    ''' </summary>
    <TestMethod()>
    Public Sub TestLegalECourtParse()
        Dim client = New ImapClient("box1030.bluehost.com", True)

        If client.Connect() Then

            If client.Login("Portal.etrack@myidealprop.com", "ColorBlue1") Then

                Dim msg = client.Folders.Inbox.Search("UNSEEN", -1, -1).Where(Function(m) m.Subject = "eTrack Supreme: LEON, JEANETH vs. MUNOZ, ANGEL (012011/2014) Updated").OrderByDescending(Function(m) m.Date).FirstOrDefault()
                Dim l = LegalECourt.Parse(msg)


                Assert.IsTrue(String.IsNullOrEmpty(l.BBLE))
            End If

        End If




    End Sub
    <TestMethod()>
    Public Sub EmailConnectedTest()
        Dim serv = New Core.ParseEmailService("Portal.etrack@myidealprop.com", "ColorBlue1")


        ''''''''''''''''''''''''''''''''
        Dim msg = serv.GetNewEmails
        For Each m In msg
            LegalECourt.Parse(m)
        Next
        Dim eCases = Data.LegalECourt.GetIndexLegalECourts()
        For Each c In eCases
            If (c.UpdateBBLE()) Then

            End If
        Next
        Assert.IsTrue(msg.Count > 0)
        ''''''''''''''''''''''''

        Assert.IsTrue(serv.IsLogedIn)
    End Sub
    <TestMethod()>
    Public Sub TestNeedCorrectLegalECourt()
        Dim eCases = Data.LegalECourt.GetIndexLegalECourts()
        'For Each c In eCases
        '    If (c.UpdateBBLE()) Then
        '        Console.WriteLine("UpDate Ecourt :" & c.IndexNumber & "Legal Ecourt Id: " & c.Id & "To BBLE: " & c.BBLE)
        '    End If
        'Next
        Assert.IsTrue(eCases.Count > 0)
    End Sub

End Class

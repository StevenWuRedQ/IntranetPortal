Imports IntranetPortal
Imports IntranetPortal.Data
Imports IntranetPortal.RulesEngine

<TestClass()>
Public Class EmailParseTest

    <TestMethod()>
    Public Sub ParseEmailsTest()

        Dim MessageStr = <string>This is the first update you have received for this case and provides a snapshot of the case as of this date. Subsequent emails will highlight all changes in red.

Index Number: 509289/2015
The following case which you have subscribed to in eTrack has been updated. 

Court: Kings Civil Supreme
Index Number: 509289/2015
Case Name: NYCTL 2014-A TRUST vs. KARAMANITES, GLORIA
Case Type: E-Filed Foreclosure
Track: Standard
Upstate RJI Number: 
Disposition Date: 
Date NOI Due: 
NOI Filed: 
Calendar Number: 
RJI Filed: 11/01/2015
Jury Status: 
Justice Name: KATHY J. KING

Attorney/Firm for Plaintiff: 
WINDELS MARX LANE  MITTENDORF
156 WEST 56TH STREET          
NEW YORK, NEW YORK   10019
Attorney Type: Attorney Of Record
Status: Active

Attorney/Firm for Defendant: 
GLORIA KARAMANITES             - Prose


Attorney Type: Pro se
Status: Active

Last Appearance:
Appearance Date: 11/24/2015
Appearance Time: 
On For: Motion
Appearance Outcome: Adjourned
Justice: KATHY J. KING
Part: MOTION PART
Comments: 


Future Appearances:
Appearance Date: 12/16/2015
Appearance Time: 
On For: Motion
Appearance Outcome: 
Justice: KATHY J. KING
Part: MOTION TRIAL TERM 64
Comments: 



Older appearances may exist but are not shown.

Motions: Motion Number: 1
Date Filed: 11/02/2015
Filed By: PLAINT
Relief Sought: Appt Referee Examine Acct
Submit Date: 
Answer Demanded: Yes
Status: Open: 

 Before Justice: KING
Decision:   
Order Signed Date: 


Scanned Decisions: None on file.

To access this case directly https://iapps.courts.state.ny.us/webcivil/FCASJcaptcha?forward_url=/webcivil/FCASSearch%3FtxtIndex%3D509289/2015%26cboCounty%3D23%26from%3DY click here.
This is an automated e-mail. If you have questions please e-mail eCourts@nycourts.gov

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

    <TestMethod()>
    Public Sub EmailConnectedTest()
        Dim serv = New Core.ParseEmailService("Portal.etrack@myidealprop.com", "ColorBlue1")


        ''''''''''''''''''''''''''''''''
        Dim msg = serv.GetNewEmails
        For Each m In msg
            LegalECourt.Parse(m)
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

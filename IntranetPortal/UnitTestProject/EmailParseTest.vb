Imports IntranetPortal
Imports IntranetPortal.Data

<TestClass()>
Public Class EmailParseTest

    <TestMethod()>
    Public Sub ParseEmailsTest()

        Dim MessageStr = <string>This is the first update you have received for this case and provides a snapshot of the case as of this date. Subsequent emails will highlight all changes in red.

Index Number: 013917/2008
The following case which you have subscribed to in eTrack has been updated. 

Court: Kings Civil Supreme
Index Number: 013917/2008
Case Name: WELLS FARGO BANK, NA vs. FORDE, MILLIAN
Case Type: Foreclosure
Track: Standard
Upstate RJI Number: 
Disposition Date: 05/20/2014
Date NOI Due: 
NOI Filed: 
Calendar Number: 
RJI Filed: 09/24/2008
Jury Status: 
Justice Name: SYLVIA G. ASH, PT. 71

Attorney/Firm for Plaintiff: 
FRENKEL LAMBERT
20 WEST MAIN STREET           
BAY SHORE, NY        11706
Attorney Type: Attorney Of Record
Status: Active

Last Appearance:
Appearance Date: 12/11/2014
Appearance Time: 
On For: Post Judgment
Appearance Outcome: Pd - Auction Not Held
Justice: SYLVIA G. ASH, PT. 71
Part: FORECLOSURE AUCTION PART
Comments: 88 LIVO




Older appearances may exist but are not shown.

Motions: Motion Number: 3
Date Filed: 02/06/2014
Filed By: PLAINT
Relief Sought: Judgment Foreclosure/Sale
Submit Date: 04/02/2014
Answer Demanded: Yes
Status: Decided: 20-MAY-14
CASE DISPOSED
 Before Justice: ASH
Decision: Pltf Long Form Order 
Order Signed Date: 05/20/2014

Motion Number: 2
Date Filed: 11/20/2012
Filed By: PLAINT
Relief Sought: Vacate Order/Judgment
Submit Date: 03/27/2013
Answer Demanded: Yes
Status: Decided: 29-MAY-13
GRANTED SHORT FORM ORDER
 Before Justice: ASH
Decision: Short Form Order 
Order Signed Date: 05/29/2013

Motion Number: 1
Date Filed: 03/23/2010
Filed By: PLAINT
Relief Sought: Judgment Foreclosure/Sale
Submit Date: 
Answer Demanded: Yes
Status: Decided: 01-OCT-10
MOTION WITHDRAWN
 Before Justice: KRAMER
Decision: Oral 
Order Signed Date: 


Scanned Decisions: None on file.

To access this case directly https://iapps.courts.state.ny.us/webcivil/FCASJcaptcha?forward_url=/webcivil/FCASSearch%3FtxtIndex%3D013917/2008%26cboCounty%3D23%26from%3DY click here.
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


        '''''''''''''''''''''''''''''''''
        'Dim msg = serv.GetNewEmails
        'For Each m In msg
        '    LegalECourt.Parse(m)
        'Next
        'Assert.IsTrue(msg.Count > 0)
        '''''''''''''''''''''''''
        Dim client = serv.ConntectEmail()
        Assert.IsTrue(client IsNot Nothing)
    End Sub

End Class

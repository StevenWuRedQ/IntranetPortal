Imports ImapX
Imports IntranetPortal
Imports IntranetPortal.Data
Imports IntranetPortal.RulesEngine
Imports System.Configuration
Imports System.IO
Imports System.Data.Entity

<TestClass()>
Public Class EmailParseTest
    Shared CURPATH = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.FullName

    Shared origConStr = "metadata=res://*/ADOEntity.PortalEntities.csdl|res://*/ADOEntity.PortalEntities.ssdl|res://*/ADOEntity.PortalEntities.msl;provider=System.Data.SqlClient;provider connection string='data source=chrispc,4436;initial catalog=IntranetPortal;User ID=Steven;Password=P@ssw0rd;multipleactiveresultsets=True;application name=EntityFramework'"
    Shared tempConStr = "metadata=res://*/ADOEntity.PortalEntities.csdl|res://*/ADOEntity.PortalEntities.ssdl|res://*/ADOEntity.PortalEntities.msl;provider=System.Data.SqlClient;provider connection string='data source=.\SQLEXPRESS;AttachDbFilename=" & CURPATH & "\testdb.mdf;Integrated Security=True;User Instance=True;application name=EntityFramework'"

    Shared MessageStr = <string>Index Number: 0120111/2014
The following case which you have subscribed to in eTrack has been updated. Changes from the last update are shown in red and are annotated.

Court: Queens Civil Supreme
Index Number: 0120111/2014
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


    Public Shared Sub setup(context As TestContext)
        Dim conf = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None)
        origConStr = ConfigurationManager.ConnectionStrings("PortalEntities").ConnectionString
        Dim consec = CType(conf.GetSection("connectionStrings"), ConnectionStringsSection)
        consec.ConnectionStrings("PortalEntities").ConnectionString = tempConStr
        conf.Save(ConfigurationSaveMode.Minimal)
        ConfigurationManager.RefreshSection(conf.ConnectionStrings.SectionInformation.SectionName)
        Database.SetInitializer(New DropCreateDatabaseAlways(Of PortalEntities)())

        Using ctx As New PortalEntities
            ctx.Database.ExecuteSqlCommand("TRUNCATE TABLE [dbo].[LegalECourts]")
            ctx.LegalECourts.Add(New LegalECourt() With {.BBLE = "123456", .IndexNumber = "123456/1990", .AppearanceDate = New Date(1990, 12, 25), .CreateDate = New Date(1990, 1, 1), .Subject = "Case 1"})
            ctx.LegalECourts.Add(New LegalECourt() With {.BBLE = "123456", .IndexNumber = "123456/1990", .AppearanceDate = New Date(1990, 12, 25), .CreateDate = New Date(1990, 1, 2), .Subject = "Case 2"})
            ctx.Database.ExecuteSqlCommand("TRUNCATE TABLE [dbo].[LegalCase]")
            ctx.LegalCases.Add(New LegalCase() With {.BBLE = "654321", .FCIndexNum = "120111/2014"})
            ctx.SaveChanges()
        End Using
    End Sub

    <TestMethod()>
    Public Sub EmailConnectedTest()
        Dim serv = New Core.ParseEmailService("Portal.etrack@myidealprop.com", "ColorBlue1")
        Assert.IsTrue(serv.IsLogedIn, "connection should established")

        Dim msg = serv.GetNewEmails
        Assert.IsTrue(msg.Count >= 0, "there should be some emails")

    End Sub

    <TestMethod()>
    Public Sub ParseEmailsTest()


        Dim ecourt = New LegalECourt()
        ecourt.BodyText = MessageStr.ToString
        ecourt.UpdateApperanceDate()
        Assert.IsTrue(ecourt.AppearanceDate > DateTime.MinValue)
        Assert.IsTrue(ecourt.AppearanceDate = Convert.ToDateTime("03/18/2016"))

        ecourt.UpdateIndexNumber()
        Assert.IsTrue(Not String.IsNullOrEmpty(ecourt.IndexNumber))
        Assert.IsTrue(ecourt.IndexNumber = "120111/2014")

        'ecourt.UpdateBBLE()
        'Assert.IsTrue(Not String.IsNullOrEmpty(ecourt.BBLE))
        'Assert.IsTrue(ecourt.BBLE.Trim = "654321")
    End Sub


    <TestMethod()>
    Public Sub TestNeedCorrectLegalECourt()
        Dim eCases = Data.LegalECourt.GetIndexLegalECourts()
        Assert.IsTrue(eCases.Count > 0)
    End Sub
    <TestMethod()>
    Public Sub TestIndexMath()
        Dim l = LegalCase.GetCase("1004490003 ")
        Dim e = New LegalECourt()
        e.IndexNumber = "123/0000"

        e.UpdateBBLE()

        Assert.IsTrue(e.BBLE = "1004490003 ")
    End Sub

    <TestMethod()>
    Public Sub TestFindLegalEcourtIndex()
        Dim l = LegalECourt.GetLeaglECourtIndexnum("12011/2014")
        Assert.IsTrue(l IsNot Nothing)

    End Sub
End Class

Imports ImapX
Imports IntranetPortal
Imports IntranetPortal.Data
Imports IntranetPortal.RulesEngine
Imports System.Configuration
Imports System.IO
Imports System.Data.Entity
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json

<TestClass()>
Public Class EmailParseTest
    Shared CURPATH = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.FullName

    Shared origConStr = "metadata=res://*/ADOEntity.PortalEntities.csdl|res://*/ADOEntity.PortalEntities.ssdl|res://*/ADOEntity.PortalEntities.msl;provider=System.Data.SqlClient;provider connection string='data source=chrispc,4436;initial catalog=IntranetPortal;User ID=Steven;Password=P@ssw0rd;multipleactiveresultsets=True;application name=EntityFramework'"
    Shared tempConStr = "metadata=res://*/ADOEntity.PortalEntities.csdl|res://*/ADOEntity.PortalEntities.ssdl|res://*/ADOEntity.PortalEntities.msl;provider=System.Data.SqlClient;provider connection string='data source=.\SQLEXPRESS;AttachDbFilename=" & CURPATH & "\testdb.mdf;Integrated Security=True;User Instance=True;application name=EntityFramework'"

    Shared MessageStr = <string>
This is the first update you have received for this case and provides a snapshot of the case as of this date. Subsequent emails will highlight all changes in red.

Index Number: 511818/2015
The following case which you have subscribed to in eTrack has been updated. 

Court: Kings Civil Supreme
Index Number: 511818/2015
Case Name: U.S. BANK TRUST, N.A., AS vs. HUDSON, WAYNE
Case Type: E-Res Foreclosure Fsc Eligible
Track: Standard
Upstate RJI Number: 
Appearance Date: 02/02/2016 --- Information updated
Disposition Date: 
Date NOI Due: 
NOI Filed: 
Calendar Number: 
RJI Filed: 11/19/2015
Jury Status: 
Justice Name: BERT BUNYAN (PT. 8)

Attorney/Firm for Plaintiff: 
MCCABE, WEISBERG  CONWAY
145 HUGUENOT STREET, SUITE 210
NEW ROCHELLE, NY     10801
Attorney Type: Attorney Of Record
Status: Active

Attorney/Firm for Defendant: 
WAYNE HUDSON                   - Prose


Attorney Type: Pro se
Status: Active

Attorney/Firm for Defendant: 
WAYNE HUDSON                   - Prose


Attorney Type: Pro se
Status: Active

Appearances: None on file.
Motions: None on file.
Scanned Decisions: None on file</string>


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
        Assert.IsTrue(ecourt.AppearanceDate = Convert.ToDateTime("02/02/2016"))

        ecourt.UpdateIndexNumber()
        Assert.IsTrue(Not String.IsNullOrEmpty(ecourt.IndexNumber))
        Assert.IsTrue(ecourt.IndexNumber = "511818/2015")

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

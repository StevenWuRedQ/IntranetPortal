Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data
Imports IntranetPortal.Controllers
Imports System.Web.Http.Results

<TestClass()> Public Class AuctionPropertyTest

    <TestMethod()> Public Sub ImportDataTest()
        Dim fileName = "Files/AuctionsPropTest.xls"
        Dim result = AuctionProperty.LoadAuctionProperties(fileName)

        Assert.IsTrue(result.Count > 0)
        Assert.AreEqual(28, result.Count)

        Dim prop = result(0)

        Assert.AreEqual("52-54 E 78 St #3C, New York, NY 10075", prop.Address)
        Assert.AreEqual("10075", prop.Zipcode)
        Assert.AreEqual("Lenox Hill", prop.Neighborhood)
        Assert.AreEqual("D4", prop.BuildingClass)
        Assert.AreEqual("1-01392-0046-cp3C", prop.BBL)
        Assert.AreEqual("1013920046", prop.BBLE)
        Assert.AreEqual(New DateTime(2016, 1, 27, 13, 30, 0), prop.AuctionDate)
        Dim lien As Decimal = 786299
        Assert.AreEqual(lien, prop.Lien)
        Assert.IsNull(prop.Judgment)
        Assert.AreEqual(New DateTime(2016, 1, 12), prop.DateEntered)
        Assert.AreEqual("Washington Mutual Bank, Fa., Et.Al.", prop.Plaintiff)
        Assert.AreEqual("Lionel Lespinasse, Et.Al.", prop.Defendant)
        Assert.AreEqual("N/A", prop.IndexNo)
        Assert.AreEqual(Nothing, prop.Referee)
        Assert.AreEqual("New York County Courthouse, 60 Centre Street, New York, NY 10007.", prop.AuctionLocation)
        Assert.AreEqual("SHAPIRO, DICARO & BARAK, LLC", prop.PlaintiffAttorney)
        Assert.AreEqual("631-844-9611", prop.AttorneyPhone)
        Assert.AreEqual("Mortgage Foreclosure", prop.ForeclosureType)
    End Sub

    <TestMethod()> Public Sub GetAuctionProperty_ShouldReturnProperty()
        Dim id = 1
        Dim controller = New AuctionPropertiesController
        Dim result = CType(controller.GetAuctionProperty(id), OkNegotiatedContentResult(Of AuctionProperty))

        Assert.IsNotNull(result)
        Assert.AreEqual(id, result.Content.AuctionId)

        'Dim ldi = IntranetPortal.LeadsInfo.GetInstance(result.Content.BBLE)
        'Assert.AreEqual(ldi.C1stMotgrAmt, result.Content.LeadsInfo)
    End Sub

End Class
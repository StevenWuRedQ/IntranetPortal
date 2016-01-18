Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class AuctionPropertyTest

    <TestMethod()> Public Sub ImportDataTest()
        Dim fileName = "Files/AuctionsPropTest.xls"
        Dim result = AuctionProperty.LoadAuctionProperties(fileName)

        Assert.IsTrue(result.Count > 0)
        Assert.AreEqual(28, result.Count)
    End Sub

End Class
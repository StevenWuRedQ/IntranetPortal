Imports RedQ.UnderwritingService.Models.NewYork

<TestClass()>
Public Class UnderwritingTest
    <TestMethod()>
    Public Sub SimpleTest()
        Dim lc = new UnderwritingLienCosts()
        Assert.IsTrue(lc.ECBCityPay = 0.0)
        Assert.IsTrue(lc.VacateOrder = false)
    End Sub
End Class

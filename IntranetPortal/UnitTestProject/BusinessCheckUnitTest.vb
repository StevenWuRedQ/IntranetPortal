Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

''' <summary>
''' The UnitTest for BusinessCheck object
''' </summary>
<TestClass()> Public Class BusinessCheckUnitTest

    <TestMethod()> Public Sub Create_returnCheckId()

        Dim check As New BusinessCheck
        check.CheckFor = "Test"
        check.Amount = 1000
        check.Date = DateTime.Today
        check.Description = "TestCheck"
        check.RequestId = 1
        check.PaybleTo = "Test"

        check.Save("UnitTest")

        Assert.IsTrue(check.CheckId > 0)

        check = BusinessCheck.GetInstance(check.CheckId)
        Assert.AreEqual("Test", check.CheckFor)
        Assert.AreEqual(CDec(1000), check.Amount)

        check.Delete()

        check = BusinessCheck.GetInstance(check.CheckId)

        Assert.IsNull(check)

    End Sub

End Class
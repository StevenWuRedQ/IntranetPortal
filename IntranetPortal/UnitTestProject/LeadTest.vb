<TestClass()>
Public Class LeadTest
    <TestMethod()>
    Public Sub TestAddress2BBLE()
        Dim bble = IntranetPortal.Core.Utility.Address2BBLE("515 Wilson Ave , Brooklyn  NY 11221 ")
        Assert.AreEqual(bble, "3033980006")
    End Sub



End Class

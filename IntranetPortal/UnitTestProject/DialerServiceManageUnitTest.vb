Imports IntranetPortal

<TestClass()>
Public Class DialerServiceManageUnitTest

    <TestMethod()> Public Sub TestInitContact()
        Dim ld = Lead.GetInstance("1000251493")
        Dim result = DialerServiceManage.InitContact(ld)
        Assert.IsNotNull(result)
        Assert.IsNotNull(result.OwnerPhone1)
    End Sub

    <TestMethod()> Public Async Function TestLoadContactList() As Task
        Dim userName = "Chris Yan"
        Dim result = Await DialerServiceManage.LoadContactList(userName)
        Assert.IsTrue(result > 0)
    End Function

End Class

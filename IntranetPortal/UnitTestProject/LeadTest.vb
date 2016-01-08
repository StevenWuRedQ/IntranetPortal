Imports IntranetPortal

<TestClass()>
Public Class LeadTest
    <TestMethod()>
    Public Sub TestAddress2BBLE()
        Dim bble = IntranetPortal.Core.Utility.Address2BBLE("515 Wilson Ave , Brooklyn  NY 11221 ")
        Assert.AreEqual(bble, "3033980006")
    End Sub

    <TestMethod()>
    Public Sub ClearSharedUserTest()
        Dim bble = "3047790022 "
        Dim sharedUser = "Chris Yan"

        Dim ld = IntranetPortal.Lead.GetInstance(bble)
        ld.AddSharedUser(sharedUser, "Unit Test")

        Assert.IsTrue(ld.SharedUsers.Count > 0)
        Assert.IsTrue(ld.SharedUsers.Contains(sharedUser))

        ld.ClearSharedUser()
        Assert.IsTrue(ld.SharedUsers.Count = 0)
    End Sub

    <TestMethod()>
    Public Sub RefreshMortgageDataTest()
        Dim bble = "2022860035 "
        Dim result = DataWCFService.UpdateLeadInfo(bble, False, True, False, False, False, False, False)
        Assert.IsTrue(result)
    End Sub

End Class

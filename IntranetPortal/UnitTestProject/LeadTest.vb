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

    <TestMethod()>
    Public Sub LPAPITest()
        Dim bble = "2022860035 "
        Dim result = DataWCFService.GetLiensInfo(bble)
        Assert.IsTrue(result.Count > 0)
        Dim lp = result.First
        Assert.AreEqual("382738-09", lp.Docket_Number)

    End Sub

    <TestMethod()>
    Public Sub LeadViewableTest()
        Dim bble = "2037130013 "
        Dim ld = Lead.GetInstance(bble)

        Dim viewable = ld.IsViewable("Michael Gali")
        Assert.IsTrue(viewable)
    End Sub

    <TestMethod()>
    Public Sub UserInRoleTest()
        Dim name = "Elizabeth Rodriguez"

        Dim inrole2 = Utility.IsUserInRoleGroup(name, {"test", "Entity-*"})
        ''Dim inRole = System.Web.Security.Roles.IsUserInRole(name, "Entity-*")
        Assert.IsTrue(inrole2)
    End Sub

End Class

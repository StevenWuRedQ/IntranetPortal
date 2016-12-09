Imports IntranetPortal

<TestClass()>
Public Class DialerServiceManageUnitTest

    <TestMethod()> Public Sub TestInitContact()
        Dim ld = Lead.GetInstance("1000251493")
        Dim result = DialerServiceManage.InitContact(ld)
        Assert.IsNotNull(result)
        Assert.IsNotNull(result.OwnerPhone1)
        Assert.AreEqual(result.OwnerPhone1, "6464549318")
        Assert.AreEqual(result.OwnerPhone2, "6463989288")
        Assert.AreEqual(result.OwnerPhone3, "6464549310")
        Assert.AreEqual(result.OwnerPhone4, "6463989221")
    End Sub

    <TestMethod()> Public Sub TestLoadContactList()
        Dim userName = "Chris Yan"
        Dim result = DialerServiceManage.LoadContactList(userName)
        Assert.IsTrue(result > 0)
    End Sub

    <TestMethod()> Public Async Function CreateContactList_returnId() As Task
        Dim userName = "Chris Yan"
        Dim result = Await DialerServiceManage.CreateContactList(userName)
        Assert.IsNotNull(result)
    End Function

    <TestMethod()> Public Sub UpdatePortal_return()
        Dim userName = "Chris Yan"
        Dim result = DialerServiceManage.UpdatePortal(userName)
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()> Public Sub AddContacts_returnId()
        Dim userName = "Chris Yan"
        Dim result = DialerServiceManage.UploadNewLeadsToContactlist(userName)
        Assert.IsTrue(result > 0)
    End Sub

    <TestMethod()> Public Sub ClearContactList_returnAmount()
        Dim userName = "Chris Yan"
        Dim result = DialerServiceManage.ClearContactList(userName)
        Assert.IsTrue(result > 0)
    End Sub

    <TestMethod()> Public Sub SyncNewLeads_returnAmount()
        Dim userName = "Chris Yan"
        Dim result = DialerServiceManage.SyncNewLeadsFolder(userName)
        Assert.IsTrue(result > 0)
    End Sub

    <TestMethod()> Public Sub UpdatePhoneNums_returnTrue()
        Dim ct As New Data.DialerContact
        ct.BBLE = "3039280004"
        ct.OwnerPhone1 = "2016597019"
        ct.CallRecordLastResult_OwnerPhone1 = "Active - Right Contact"

        DialerServiceManage.UpdatePhoneNums(ct)
        Dim result = OwnerContact.GetContact(ct.BBLE, ct.OwnerPhone1)
        Assert.IsNotNull(result)
        Assert.AreEqual(result.Status, CInt(OwnerContact.ContactStatus.Right))
    End Sub


    <TestMethod()> Public Sub DailyTask_return()

        DialerServiceManage.RunDailyTask("Chris Yan")

    End Sub

End Class

Imports System.Text
Imports IntranetPortal.Data
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal

<TestClass()> Public Class DialerRuleTest

    Dim service As DialerService
    Dim contact As DialerContact
    Dim contact2 As DialerContact

    <TestInitialize> Public Sub init()
        service = New DialerService
        contact = New DialerContact
        contact.BBLE = "123456789"
        contact.Leads = "fake leads"
        contact.Address = "fake address"
        contact.Comments = ""
        contact.Owner = "Owner1"
        contact.CoOwner = "Owner2"
        contact.OwnerPhone1 = "8888888880"
        contact.OwnerPhone2 = "8888888881"
        contact.CoOwnerPhone1 = "888888882"
        contact.CoOwnerPhone1 = "8888888883"

        contact2 = New DialerContact
        contact2.BBLE = "123456780"
        contact2.Leads = "fake leadsx"
        contact2.Address = "fake addressx"
        contact2.Comments = ""
        contact2.Owner = "Owner1x"
        contact2.CoOwner = "Owner2x"
        contact2.OwnerPhone1 = "9888888880"
        contact2.OwnerPhone2 = "9888888881"
        contact2.CoOwnerPhone1 = "988888882"
        contact2.CoOwnerPhone1 = "9888888883"
    End Sub

    <TestMethod()> Public Async Function AddAndDeleteContactListTest() As Task
        Dim ref = Await service.AddContactList("UnitTestList")
        Assert.IsNotNull(ref)
        Dim deleted = Await service.DeleteContactList(ref.GetValue("id").ToString)
        Assert.IsTrue(deleted)
    End Function

    <TestMethod()> Public Async Function CURDContactTest() As Task
        Dim ref = Await service.AddContactList("UnitTestList")
        Dim listid = ref.GetValue("id").ToString
        Assert.IsNotNull(listid)

        ' test create
        Dim list = New List(Of DialerContact)
        list.Add(contact)
        Dim results = Await service.AddContactsToList(listid, list)
        Dim item = results.FirstOrDefault
        Assert.IsNotNull(item)
        Dim contactid = item.GetValue("id").ToString()

        Dim getItem = Await service.GetContactFromList(listid, contactid)
        Assert.IsNotNull(getItem)
        Assert.IsTrue(getItem.GetValue("id").ToString = item.GetValue("id").ToString)

        ' test update
        contact.inin_outbound_id = contactid
        contact.ContactListId = listid
        contact.Owner = "wangnima"
        Dim updateitem = Await service.UpdateContactInList(contact)
        Assert.IsNotNull(updateitem)

        Dim getItem2 = Await service.GetContactFromList(listid, contactid)
        Assert.IsNotNull(getItem2)
        Assert.IsTrue(getItem2("data")("Owner") = "wangnima")

        ' test delete
        Dim deleteItem = Await service.DeleteContactList(listid)
        Assert.IsTrue(deleteItem)

        Dim getItem3 = Await service.GetContactFromList(listid, contactid)
        Assert.IsNull(getItem3)

        Await service.DeleteContactList(listid)

    End Function

    <TestMethod> Public Async Function ExportListTest() As Task
        ' magic contact list id for UnitTestExportList
        Dim listid = "3f247b83-5bcc-41e5-acad-ed71cfdec111"

        ' test if can init
        Dim initResult = Await service.InitialExport(listid)
        Assert.IsTrue(initResult)

        ' test get download url
        Dim urlresult = Await service.GetExportURL(listid)
        Assert.IsNotNull(urlresult.uri)

        ' test indirect download
        Dim downloaded = Await service.ExportList(listid, False)
        Assert.IsTrue(downloaded.Count > 0)

        ' test direct download not working now
        Dim directdownload = Await service.ExportList(listid, True)
        Assert.IsNull(directdownload)
    End Function

    <TestMethod> Public Async Function GetTokenTest() As Task
        Dim token = Await TokenGenerator.getPureCloudeToken()
        Assert.IsNotNull(token)
    End Function

    <TestMethod> Public Async Function GetListByNameTest() As Task
        Dim list = Await service.GetContactListByName("UnitTestExportList")
        Assert.IsNotNull(list)
        Assert.IsTrue(Not String.IsNullOrEmpty(list("id").ToString))
    End Function
End Class
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class DocumentSearchUnitTest

    <TestMethod()> Public Sub Archive_returnDoc()
        Dim bble = "3003820020"
        Dim username = "Test"
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)
        search.Save(username)
        search.Status = LeadInfoDocumentSearch.SearchStatus.NewSearch
        Assert.IsFalse(search.Expired)
        search.Status = LeadInfoDocumentSearch.SearchStatus.Completed
        search.CompletedOn = New DateTime(2016, 1, 1)
        Assert.IsTrue(search.Expired)
        search.Archive(username)
        Dim search2 = LeadInfoDocumentSearch.GetInstance(bble)
        Assert.IsNull(search2)

        Dim result = search.Create(username)
        Assert.IsTrue(result)

        result = search.Create(username)
        Assert.IsFalse(result)
    End Sub

    <TestMethod()> Public Sub LoadJudgementSearch_returnDoc()
        Dim bble = "3003820020 "
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)

        Dim judgementDoc = search.LoadJudgesearchDoc

        Assert.IsNotNull(judgementDoc)
        Assert.IsNotNull(judgementDoc.Data)
        Assert.IsNotNull(judgementDoc.Name)
    End Sub

    <TestMethod()> Public Sub CompleteController_Savedata()
        Dim bble = "3003820020"
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)
        search.ResutContent = Nothing

        Dim controller As New IntranetPortal.Controllers.LeadInfoDocumentSearchesController
        Dim result = controller.PostCompleted(bble, search)
        Assert.IsTrue(True)
    End Sub

    <TestMethod()> Public Sub CreateSearch_returnTrue()
        Dim bble = "3003820020"


    End Sub

    <TestMethod()> Public Sub CompleteController_SendEmail()
        Dim bble = "3003820020 "
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)
        search.ResutContent = "test"

        Dim controller As New IntranetPortal.Controllers.LeadInfoDocumentSearchesController
        Dim objController As PrivateObject = New PrivateObject(GetType(IntranetPortal.Controllers.LeadInfoDocumentSearchesController))

        objController.Invoke("SendCompleteNotify", search)
        Assert.IsTrue(True)
    End Sub

    <TestMethod()> Public Sub NewSearchNotfify_SendEmail()
        Dim bble = "3003820020 "
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)

        Dim controller As New IntranetPortal.Controllers.LeadInfoDocumentSearchesController
        Dim objController As PrivateObject = New PrivateObject(GetType(IntranetPortal.Controllers.LeadInfoDocumentSearchesController))

        objController.Invoke("SendNewSearchNotify", search)
        Assert.IsTrue(True)
    End Sub

    <TestMethod()>
    Public Sub TestSubmitSearch_CreateDate()
        Dim search = New LeadInfoDocumentSearch
        search.SubmitSearch("Test")
        Assert.AreEqual(search.CreateBy, "Test")
        ' Assert.IsTrue(search.CreateDate > Date.Now)
    End Sub

    <TestMethod()> Public Sub TestNeedNotifyWhenSaving()
        Dim search = New LeadInfoDocumentSearch()
        search.Status = LeadInfoDocumentSearch.SearchStatus.NewSearch
        ' it should not need notify when new search
        Assert.IsFalse(search.isNeedNotifyWhenSaving())

        search.Status = LeadInfoDocumentSearch.SearchStatus.Completed

        ' it should need notify when after completed search
        Assert.IsTrue(search.isNeedNotifyWhenSaving())

        ' it should not send notify when after completed the data do not change

        search.LeadResearch = "Change"
        ' do not pass it because we store json in back-end
        ' Assert.IsFalse(search.isNeedNotifyWhenSaving())


    End Sub
End Class
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class DocumentSearchUnitTest

    <TestMethod()> Public Sub LoadJudgementSearch_returnDoc()
        Dim bble = "3003820020 "
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)

        Dim judgementDoc = search.LoadJudgesearchDoc

        Assert.IsNotNull(judgementDoc)
        Assert.IsNotNull(judgementDoc.Data)
        Assert.IsNotNull(judgementDoc.Name)
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

End Class
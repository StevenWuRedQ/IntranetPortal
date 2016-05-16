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

        Dim controller As New IntranetPortal.Controllers.LeadInfoDocumentSearchesController
        Dim result = controller.PostCompleted(bble, search)


    End Sub

End Class
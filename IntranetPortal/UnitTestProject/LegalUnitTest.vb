Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data
Imports System.Web.Http
Imports IntranetPortal
Imports IntranetPortal.RulesEngine

<TestClass()> Public Class LegalUnitTest

    Dim bble = "1004490003"

    <TestMethod()> Public Sub DataStatusTest()

        Dim statusList = DataStatu.LoadDataStatus(LegalCase.ForeclosureStatusCategory)
        Assert.IsTrue(statusList.Count > 0)
        Assert.IsFalse(statusList.Any(Function(a) a.Active = False))

        Dim lcase = LegalCase.GetCase(bble)
        Dim dStatu = DataStatu.Instance(LegalCase.ForeclosureStatusCategory, lcase.LegalStatus)
        Assert.AreEqual(lcase.LegalStatusString, dStatu.Name)
        Assert.IsTrue(lcase.LegalStatusString = "Judgment Granted")
    End Sub

    <TestMethod()> Public Sub DataStatusSaveTest()
        Dim dStatu = New DataStatu With {
            .Category = LegalCase.ForeclosureStatusCategory,
            .Status = -1,
            .Name = "Testing",
            .Active = True
            }

        dStatu.Save()

        Assert.IsTrue(dStatu.Status > 0)

        dStatu.Delete()

        Dim instance = DataStatu.Instance(LegalCase.ForeclosureStatusCategory, dStatu.Status)
        Assert.IsNull(instance)
    End Sub

    <TestMethod()> Public Sub DataStatusControllerTest()
        Dim controller = New IntranetPortal.Controllers.LegalController
        Dim status = controller.GetForeclosureStatus()
        Assert.IsInstanceOfType(status, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(status, GetType(Results.OkNegotiatedContentResult(Of DataStatu())))
        Dim statusArray = CType(status, Results.OkNegotiatedContentResult(Of DataStatu())).Content
        Assert.IsTrue(statusArray.Count > 0)
    End Sub

    <TestMethod()> Public Sub SaveHistoryTest()
        Dim controller = New IntranetPortal.Controllers.LegalController
        Dim history = controller.GetSaveHistories(bble)
        Assert.IsInstanceOfType(history, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(history, GetType(Results.OkNegotiatedContentResult(Of IntranetPortal.Core.SystemLog())))
        Dim logs = CType(history, Results.OkNegotiatedContentResult(Of IntranetPortal.Core.SystemLog())).Content
        Assert.IsTrue(logs.Count > 0)
    End Sub

    <TestMethod()> Public Sub GetSavedHistoryTest()
        Dim controller = New IntranetPortal.Controllers.LegalController
        Dim logs = CType(controller.GetSaveHistories(bble), Results.OkNegotiatedContentResult(Of IntranetPortal.Core.SystemLog())).Content
        Dim history = controller.GetSavedHistory(logs(0).LogId)

        Assert.IsInstanceOfType(history, GetType(IHttpActionResult))
        Dim caseData = CType(history, Results.OkNegotiatedContentResult(Of String)).Content

        Assert.IsTrue(Not String.IsNullOrEmpty(caseData))
        Dim jsCase = Newtonsoft.Json.Linq.JObject.Parse(caseData)
        Assert.AreEqual(jsCase("PropertyInfo")("BBLE").ToString.Trim, bble)

        history = controller.GetSavedHistory(0)
        caseData = CType(history, Results.OkNegotiatedContentResult(Of String)).Content
        Assert.AreEqual("{}", caseData)
    End Sub

    <TestMethod> Public Sub GetCaseOwner_returnOwnerName()
        Dim lcase = LegalCase.GetCase(bble)

        lcase.Attorney = "Chris Yan"
        Assert.AreEqual(lcase.Attorney, LegalCaseManage.GetCaseOwner(bble))
        Assert.AreEqual("Amy Beckwith", LegalCaseManage.GetCaseOwner("2022870021"))
        Assert.IsNull(LegalCaseManage.GetCaseOwner("2022890122"))
        Assert.IsNull(LegalCaseManage.GetCaseOwner("12321321321"))
    End Sub
    <TestMethod> Public Sub GetPassErrorTest()
        Dim index = "123/1234"

        Assert.AreEqual(LegalCase.DeCodeIndexNumber(index), "000123/1234")
        'Dim rule = New NoticeECourtRule()
        'rule.NotifyECourtParseError()

    End Sub

End Class
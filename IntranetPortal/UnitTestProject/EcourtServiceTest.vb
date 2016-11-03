Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class EcourtServiceTest

    <TestMethod()> Public Sub GetCase_CasesList()
        Dim bble = "3033880016 "

        Dim cases = EcourtService.Instance.GetCases(bble)
        Assert.IsNotNull(cases)
        Assert.IsTrue(cases.Count > 0)
    End Sub

    <TestMethod()> Public Sub GetCaseDetail_CasesList()
        Dim bble = "3033880016"
        Dim cases = EcourtService.Instance.GetCaseDetail("51", "20120005195")
        Assert.IsNotNull(cases)
    End Sub

    <TestMethod()> Public Sub GetCaseChanges_changelist()
        Dim startDate = DateTime.Today.AddDays(-2)
        Dim endDate = startDate.AddDays(1)

        Dim cases = EcourtService.Instance.GetStatusChanges(startDate, endDate)
        Assert.IsNotNull(cases)
        Assert.IsTrue(cases.Count > 0)
    End Sub

    <TestMethod()>
    Public Sub GetCaseChanges_exception()
        Dim startDate = DateTime.Today.AddDays(-5)
        Dim endDate = startDate.AddDays(1)
        Dim cases = EcourtService.Instance.GetStatusChanges(startDate, endDate)
        Assert.IsTrue(cases.Count > 0)
    End Sub

    <TestMethod()>
    Public Sub GetNewCases_True()
        Dim startDate = New DateTime(2016, 10, 27)
        Dim endDate = startDate.AddDays(1)
        Dim cases = EcourtService.Instance.GetNewCases(startDate, endDate)
        Assert.IsTrue(cases.Count > 0)
        Assert.IsFalse(cases.Any(Function(a) a.BBLE Is Nothing))
    End Sub

End Class
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal

<TestClass()> Public Class PortalReportUnitTest

    <TestMethod()> Public Sub LeadsImportReport_ReturnDic()

        Dim report = PortalReport.LeadsImportReport("1/1/2016", "2/1/2016")
        Assert.IsNotNull(report)
        Assert.IsTrue(report.Count > 0)
    End Sub

End Class
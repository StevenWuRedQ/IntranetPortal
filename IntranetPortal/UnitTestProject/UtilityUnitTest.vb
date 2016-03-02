Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()> Public Class UtilityUnitTest

    <TestMethod()> Public Sub TestIsCorp()
        Dim name = "1030 LONGFELLOW CORP."
        Assert.IsTrue(IntranetPortal.Utility.IsCompany(name))

        Assert.IsTrue(IntranetPortal.Utility.IsCompany("PROOF HOLDINGS LTD"))

        Assert.IsTrue(Not IntranetPortal.Utility.IsCompany("Steven Wu"))
        Assert.IsTrue(Not IntranetPortal.Utility.IsCompany("OLR MM HOUSING DEVELOPMENT FUND COMPANY, INC."))
    End Sub

End Class
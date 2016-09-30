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


    <TestMethod()> Public Sub TestTest()
        Using ctx As New IntranetPortal.Data.CodeFirstEntity

            Dim d = New IntranetPortal.Data.Underwriting
            d.PropertyInfo = New IntranetPortal.Data.UnderwritingPropertyInfo
            d.PropertyInfo.OccupancyStatus = IntranetPortal.Data.UnderwritingPropertyInfo.OccupancyStatusEnum.Seller

            ctx.Underwritings.Add(d)
            ctx.SaveChanges()

        End Using

    End Sub
End Class
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports IntranetPortal.Data

<TestClass()> Public Class DataServiceIntegrationTest

    <TestMethod()>
    Public Sub GetFullAssessInfo_ReturnLeadsInfo()
        Dim bble = "1010901183"
        Dim li = LeadsInfo.GetInstance(bble)
        li.PropertyAddress = "test"
        li = DataWCFService.GetFullAssessInfo(bble, li)
        Assert.IsFalse(li.PropertyAddress = "test")
    End Sub

    <TestMethod()>
    Public Sub UpdateLeadInfo_Return()
        Dim bble = "1010901183"

        Dim result = DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, True, False)
        Assert.IsTrue(result)
    End Sub

    <TestMethod()>
    Public Sub ExternalResult_JSON()
        Dim result = New ExternalData
        result.taxbill = New Taxbill
        result.waterbill = New Waterbill
        result.mortgageServicer = New MortgageServicer
        result.dobPenaltiesAndViolationsSummary = New Dobpenaltiesandviolations
        result.zillowPorperty = New ZillowProperty
        Dim json = result.ToJsonString
        Assert.IsFalse(String.IsNullOrEmpty(json))
    End Sub

End Class
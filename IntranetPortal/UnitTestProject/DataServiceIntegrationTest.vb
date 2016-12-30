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
        Dim provider As New IntranetPortal.PropertyServiceProvider
        li = provider.GetFullAssessInfo(bble, li)
        Assert.IsFalse(li.PropertyAddress = "test")
    End Sub

    <TestMethod()>
    Public Sub UpdateAssessInfo_ReturnLeadsInfo()
        Dim bble = "3044650105"

        Dim result = DataWCFService.UpdateAssessInfo(bble)
        Assert.AreEqual(result.BBLE, bble)
    End Sub

    '4065270031
    <TestMethod()>
    Public Sub GetLatestSalesInfo_Return()
        Dim bble = "4065270031"
        DataWCFService.GetLatestSalesInfo(bble)
        Assert.IsTrue(True)
    End Sub


    <TestMethod()>
    Public Sub UpdateLeadInfo_Return()
        Dim bble = "3044650105"

        Dim result = DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, True, False)
        Assert.IsTrue(result)
    End Sub

    <TestMethod()>
    Public Sub UpdateLeadInfo_BadBBLE()
        Dim bble = "4065270031"

        Dim result = DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, True, False)
        Assert.IsTrue(result)
    End Sub

    <TestMethod()>
    Public Sub BatchUpdateLeadInfo_Return()
        Dim bble = "4094390054"

        Dim fun = Sub()
                      For i = 1 To 10
                          Dim result = DataWCFService.UpdateAssessInfo(bble)
                      Next
                  End Sub

        Threading.ThreadPool.QueueUserWorkItem(fun)
        Threading.ThreadPool.QueueUserWorkItem(fun)
        Threading.ThreadPool.QueueUserWorkItem(fun)
        Threading.ThreadPool.QueueUserWorkItem(fun)
        Threading.ThreadPool.QueueUserWorkItem(fun)
        Threading.ThreadPool.QueueUserWorkItem(fun)

        While (True)

        End While
    End Sub

    <TestMethod()>
    Public Sub AddressSearchByBBLE_GeneralInfo()
        Dim bble = "4094390054"
        Dim result = DataWCFService.AddressSearch(bble)
        Assert.IsNotNull(result)
        Assert.AreEqual(result(0).propertyInformation.BBLE, bble)
    End Sub

    <TestMethod()>
    Public Sub AddressSearchByBlockLot_GeneralInfo()
        Dim bble = "4094390054"
        Dim result = DataWCFService.AddressSearch(4, 9439, 54)
        Assert.IsNotNull(result)
        Assert.AreEqual(result(0).propertyInformation.BBLE, bble)
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
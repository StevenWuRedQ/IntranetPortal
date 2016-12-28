Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()>
Public Class PropertyServiceTest

    Private testContextInstance As TestContext

    '''<summary>
    '''Gets or sets the test context which provides
    '''information about and functionality for the current test run.
    '''</summary>
    Public Property TestContext() As TestContext
        Get
            Return testContextInstance
        End Get
        Set(ByVal value As TestContext)
            testContextInstance = Value
        End Set
    End Property

#Region "Additional test attributes"
    '
    ' You can use the following additional attributes as you write your tests:
    '
    ' Use ClassInitialize to run code before running the first test in the class
    ' <ClassInitialize()> Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
    ' End Sub
    '
    ' Use ClassCleanup to run code after all tests in a class have run
    ' <ClassCleanup()> Public Shared Sub MyClassCleanup()
    ' End Sub
    '
    ' Use TestInitialize to run code before running each test
    ' <TestInitialize()> Public Sub MyTestInitialize()
    ' End Sub
    '
    ' Use TestCleanup to run code after each test has run
    ' <TestCleanup()> Public Sub MyTestCleanup()
    ' End Sub
    '
#End Region

    <TestMethod()>
    Public Sub GetMortgages_MortgagesList()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetMortgages(bble)
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetGeneralInformation_GeneralInfo()
        Dim bble = "1010901183"
        Dim service As New PropertyService
        Dim result = service.GetGeneralInformation(bble)
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetGeneralInformationByStreet_GeneralInfo()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetGeneralInformation("4418", "park ave", "Bronx")
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetBills_PropertyBills()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetBills(bble, 1)
        Assert.IsNotNull(result)
        Assert.AreEqual(bble, result.taxBill.BBL)
    End Sub

    <TestMethod()>
    Public Sub GetViolation_PropertyViolations()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetViolations(bble, 1)
        Assert.IsNotNull(result)
        Assert.AreEqual(bble, result.dobPenaltiesAndViolations.BBL)
    End Sub

    <TestMethod()>
    Public Sub GetServicer_MortgageServicer()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetServicer(bble, 1)
        Assert.IsNotNull(result)
        Assert.AreEqual(bble, result.BBL)
    End Sub

    <TestMethod()>
    Public Sub GetLpLiens_LPCases()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetLpLiens(bble)
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetLpLiens_nothing()
        Dim bble = "3033887987"
        Dim service As New PropertyService
        Dim result = service.GetLpLiens(bble)
        Assert.IsNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetZestimate_ZillowProperty()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetZestimate(bble, 1)
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetLatestDeed_PropertyDeed()
        Dim bble = "3033880016"
        Dim service As New PropertyService
        Dim result = service.GetLatestDeed(bble)
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetBBLEByAddress_PropertyDeed()
        Dim bble = "4089170025"
        Dim service As New PropertyService
        Dim result = service.GetBBLEByAddress("80-72", "87th Rd", "4")
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetPropAddress_PhysicalData()
        Dim bble = "4089170025"
        Dim service As New PropertyService
        Dim result = service.GetPropByAddress("80-72", "87th Rd", "4")
        Assert.IsNotNull(result)
        Assert.AreEqual(bble, result.address.bbl)
    End Sub

End Class

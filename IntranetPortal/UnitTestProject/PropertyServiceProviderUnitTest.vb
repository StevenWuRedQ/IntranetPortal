Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports IntranetPortal.Data

<TestClass()> Public Class PropertyServiceProviderUnitTest

    <TestMethod()>
    Public Sub GetFullAssessInfo_ReturnLeadsInfo()
        Dim bble = "4162140012"
        Dim li = New LeadsInfo()
        li.PropertyAddress = "test"
        Dim provider As New IntranetPortal.PropertyServiceProvider
        li = provider.UpdateLeadsGeneralData(bble)
        Assert.IsFalse(li.PropertyAddress = "test")
    End Sub

End Class
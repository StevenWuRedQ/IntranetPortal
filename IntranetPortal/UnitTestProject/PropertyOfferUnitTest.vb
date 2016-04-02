Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal

<TestClass()> Public Class PropertyOfferUnitTest

    Dim BBLE As String = "4089170024"

    <TestMethod()> Public Sub GeneratePackage_ReturnLink()

        Dim link = PropertyOfferManage.GeneratePackage(BBLE, Nothing)
        Assert.IsTrue(link.Contains(BBLE))
    End Sub

End Class
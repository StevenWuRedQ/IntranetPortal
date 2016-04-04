Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports System.IO

''' <summary>
''' The UnitTest for PropertyOffer function
''' </summary>
<TestClass()> Public Class PropertyOfferUnitTest

    Dim BBLE As String = "4089170024"

    ''' <summary>
    ''' Generate document package testing
    ''' </summary>
    <TestMethod()> Public Sub GeneratePackage_ReturnLink()
        Dim path = "G:\Working Folder\WebApp\IntranetPortalGit\IntranetPortal\IntranetPortal\App_Data\OfferDoc"
        Dim destPath = "G:\Working Folder\WebApp\IntranetPortalGit\IntranetPortal\IntranetPortal\TempDataFile\OfferDoc\"
        Dim link = PropertyOfferManage.GeneratePackage(BBLE, Nothing, path, destPath)

        Assert.IsTrue(link.Contains(BBLE))
        Assert.IsTrue(File.Exists(destPath & link))
    End Sub

End Class
Imports System.Text
Imports IntranetPortal.Data
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports Newtonsoft.Json.Linq

''' <summary>
''' The BusinessForm unit test
''' </summary>
<TestClass()> Public Class BusinessFormUnitTest

    Dim BBLE As String = "4089170024"
    Dim PropertyAddress As String = "8072 87th rd"
    Dim Owner As String = "Chris Yan"
    Dim type As String = "ShortSale"

    ''' <summary>
    ''' The create form function test, shoud return form data 
    ''' and the form tag should be the identity of business data
    ''' </summary>
    <TestMethod()> Public Sub Create_returnFormWithTag()
        Dim caseData As New JObject

        caseData.Item("BBLE") = BBLE
        caseData.Item("PropertyAddress") = PropertyAddress
        caseData.Item("Owner") = Owner
        caseData.Item("Type") = type

        Dim dataItem = New IntranetPortal.Data.FormDataItem
        dataItem.FormName = "PropertyOffer"
        dataItem.FormData = caseData.ToString
        dataItem.Save("Test")

        dataItem = FormDataItem.Instance(dataItem.DataId)

        Assert.IsTrue(dataItem.Tag IsNot Nothing)
        Dim offer = CType(dataItem.BusinessData, PropertyOffer)
        Assert.AreEqual(offer.BBLE.Trim, BBLE.trim)
        Assert.AreEqual(offer.Title, PropertyAddress)
        Assert.AreEqual(offer.Owner, Owner)
        Assert.AreEqual(dataItem.Tag, offer.OfferId.ToString)

    End Sub

End Class
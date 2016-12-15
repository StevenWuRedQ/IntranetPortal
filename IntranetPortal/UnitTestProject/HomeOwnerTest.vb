Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports IntranetPortal.Data

<TestClass()> Public Class HomeOwnerTest

    <TestMethod()> Public Sub GetOwnerPhone_HomeOwner()
        Dim owner As New HomeOwner
        Dim phone As New DataAPI.BasicPhoneListing()
        phone.listingTypeField = DataAPI.ListingTypes.Business
        phone.scoreField = Nothing

        Dim result = owner.GetOwnerPhone("test", "test", phone)
        Assert.AreEqual(result.Score, Nothing)
        Assert.AreEqual(result.ListingType, 2)

    End Sub

End Class
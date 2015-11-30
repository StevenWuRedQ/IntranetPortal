Imports System.Text
Imports IntranetPortal.Data
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()>
Public Class ShortSaleUnitTest

    <TestMethod()> Public Sub UpdateCheckListTest()
        Dim bble = "2039970011"
        Dim checkList = <string>
                            {
                              "DateIssued": "08/27/2015",
                              "DateExpired": "09/27/2015",
                              "BuyerName": "BRILL 264 LLC",
                              "ContractPrice": "300000",
                              "IsFirstLienMatch": "Y",
                              "IsSecondLienMatch": "N",
                              "FirstLien": "267806.78",
                              "CommissionPercentage": "6",
                              "CommissionAmount": "18000",
                              "IsTransferTaxAmount": "Y",
                              "IsApprovalLetterSaved": "N",
                              "ConfirmOccupancy": "Tenant"
                            }
                        </string>

        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        Assert.IsTrue(ssCase.UpdateCheckList(checkList, "Chris Yan"))

        Using ctx As New ShortSaleEntities
            Dim clist = ctx.ShortSaleCheckLists.Find(bble)
            Assert.IsTrue(clist IsNot Nothing)
            Assert.IsTrue(clist.UpdateBy = "Chris Yan")
            Assert.IsTrue(clist.CommissionAmount = 18000)
            Assert.IsTrue(clist.FirstLien = 267806.78)
            Assert.IsTrue(clist.IsTransferTaxAmount)
            Assert.IsFalse(clist.IsApprovalLetterSaved)
            Assert.IsTrue(clist.ConfirmOccupancy = "Tenant")
            Assert.IsTrue((DateTime.Now - clist.LastUpdate.Value).TotalMinutes < 1)

            ctx.ShortSaleCheckLists.Remove(clist)
            ctx.SaveChanges()

            'clist = ctx.ShortSaleCheckLists.Find(bble)
            'Assert.IsTrue(clist Is Nothing)
        End Using

        checkList = <string>
                            {
                              "DateExpired": "tw",                           
                              "BuyerName": "BRILL 264 LLC",
                              "ContractPrice": "300000",
                              "IsFirstLienMatch": "Y",
                              "IsSecondLienMatch": "N",
                              "FirstLien": "267806.78",
                              "CommissionPercentage": "6",
                              "CommissionAmount": "18000",
                              "IsTransferTaxAmount": "Y",
                              "IsApprovalLetterSaved": "N",
                              "ConfirmOccupancy": "Tenant"
                            }
                        </string>

        Assert.IsTrue(ssCase.UpdateCheckList(checkList, "Chris Yan"))

        Using ctx As New ShortSaleEntities
            Dim clist = ctx.ShortSaleCheckLists.Find(bble)
            Assert.IsTrue(clist IsNot Nothing)
            Assert.IsTrue(clist.UpdateBy = "Chris Yan")
            Assert.IsTrue(clist.DateIssued Is Nothing)
            Assert.IsTrue(clist.DateExpired Is Nothing)
            Assert.IsTrue(clist.CommissionAmount = 18000)
            Assert.IsTrue(clist.FirstLien = 267806.78)
            Assert.IsTrue(clist.IsTransferTaxAmount)
            Assert.IsFalse(clist.IsApprovalLetterSaved)
            Assert.IsTrue(clist.ConfirmOccupancy = "Tenant")
            Assert.IsTrue((DateTime.Now - clist.LastUpdate.Value).TotalMinutes < 1)

            ctx.ShortSaleCheckLists.Remove(clist)
            ctx.SaveChanges()

            clist = ctx.ShortSaleCheckLists.Find(bble)
            Assert.IsTrue(clist Is Nothing)
        End Using
    End Sub

End Class
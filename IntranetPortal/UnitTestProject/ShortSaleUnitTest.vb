Imports System.Text
Imports IntranetPortal.Data
Imports IntranetPortal
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()>
Public Class ShortSaleUnitTest

    <TestMethod()> Public Sub ReassignOwnerTest()
        Dim bble = "4089170024"
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Dim oldOwner = ssCase.Owner
        Dim owner = "Steven Wu"
        ShortSaleCase.ReassignOwner(bble, owner)
        ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Assert.AreEqual(owner, ssCase.Owner)
        Assert.AreEqual(owner, ssCase.ProcessorName)
        ShortSaleCase.ReassignOwner(bble, oldOwner)
        ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Assert.AreEqual(oldOwner, ssCase.Owner)
        Assert.AreEqual(oldOwner, ssCase.ProcessorName)
    End Sub

    <TestMethod()> Public Sub SaveFollowUpTest()
        Dim bble = "4089170024"
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Dim fpDate = ssCase.CallbackDate
        Dim newDate = DateTime.Today.AddDays(1)
        ssCase.SaveFollowUp(newDate)
        Assert.AreEqual(newDate, ssCase.CallbackDate)
        ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Assert.AreEqual(newDate, ssCase.CallbackDate)
        ssCase.SaveFollowUp(fpDate)
        ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Assert.AreEqual(fpDate, ssCase.CallbackDate)
    End Sub

    <TestMethod()> Public Sub ShortSaleProcessTest()
        Dim newCase = ShortSaleManage.NewCaseProcess
        Assert.IsInstanceOfType(newCase, GetType(ShortSaleProcess))
        Assert.AreEqual("New Case", newCase.TaskName)
        Assert.AreEqual("ShortSale-AssignReviewer", newCase.RoleName)

        Dim proc = ShortSaleManage.ReassignProcess
        Assert.IsInstanceOfType(newCase, GetType(ShortSaleProcess))
        Assert.AreEqual("Reassign Case Approval", proc.TaskName)
        Assert.AreEqual("ShortSale-Manager", proc.RoleName)

        proc = ShortSaleManage.AssignProcess
        Assert.IsInstanceOfType(newCase, GetType(ShortSaleProcess))
        Assert.AreEqual("Assign Case Approval", proc.TaskName)
        Assert.AreEqual("ShortSale-Manager", proc.RoleName)

        proc = ShortSaleManage.ArchivedProcess
        Assert.IsInstanceOfType(newCase, GetType(ShortSaleProcess))
        Assert.AreEqual("Case Archive Approval", proc.TaskName)
        Assert.AreEqual("ShortSale-Manager", proc.RoleName)
    End Sub

    <TestMethod()> Public Sub UpdateCheckListTest()
        Dim bble = "4089170024"
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

        Using ctx As New PortalEntities
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

        Using ctx As New PortalEntities
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
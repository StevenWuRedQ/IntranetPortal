Imports System.Text
Imports IntranetPortal.Data
Imports IntranetPortal
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()>
Public Class ShortSaleUnitTest
    Dim caseId = 13
    Dim saveBy = "UnitTest"
    Dim loan = "Test Loan " & (New Random).Next(1000).ToString
    Dim dateOfSale As DateTime = DateTime.Today.AddDays(-1)

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

    <TestMethod()> Public Sub MortgageSaveTest()
        Dim ssCase = ShortSaleCase.GetCase(caseId)
        Dim mtgs = ssCase.Mortgages.ToList
        Assert.IsTrue(mtgs.Count > 0)

        Dim firstMtg = mtgs(0)

        'Mortgages change data

        firstMtg.Loan = loan
        firstMtg.DateOfSale = dateOfSale
        ssCase.Save(saveBy)
        ssCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(ssCase.FirstMortgage.Loan, loan)
        Assert.AreEqual(DateTime.Compare(ssCase.FirstMortgage.DateOfSale, dateOfSale), 0)
    End Sub

    <TestMethod()> Public Sub MortgageRemoveTest()
        Dim ssCase = ShortSaleCase.GetCase(caseId)
        Dim mtgs = ssCase.Mortgages.ToList
        Dim mtgAmount = mtgs.Count   '=1

        Assert.IsTrue(mtgs.Count > 0)
        Dim newMtg = New PropertyMortgage
        mtgs.Add(newMtg)
        newMtg.Loan = loan
        newMtg.DateOfSale = dateOfSale
        ssCase.Mortgages = mtgs.ToArray
        ssCase.Save(saveBy)

        'Remove Mortgages test
        ssCase = ShortSaleCase.GetCase(caseId)
        mtgs = ssCase.Mortgages.ToList
        Dim lastMtg = mtgs.Last
        lastMtg.DataStatus = ModelStatus.Deleted  'set status as deleted
        ssCase.Save(saveBy)
        Dim newCase = ShortSaleCase.GetCase(caseId)
        Assert.IsFalse(newCase.Mortgages.Any(Function(m) m.MortgageId = lastMtg.MortgageId))

        ssCase.Mortgages = mtgs.ToArray
        ssCase.Save(saveBy) 'Save again shortsalecase
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.IsFalse(newCase.Mortgages.Any(Function(m) m.MortgageId = lastMtg.MortgageId))
        Assert.AreEqual(mtgAmount, newCase.Mortgages.Count)

        'after delete and add a new case
        newMtg = New PropertyMortgage
        mtgs.Add(newMtg)
        newMtg.Loan = loan
        newMtg.DateOfSale = dateOfSale
        ssCase.Mortgages = mtgs.ToArray
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgAmount + 1, newCase.Mortgages.Count)
        Assert.AreEqual(newMtg.Loan, newCase.Mortgages.Last.Loan)

        newMtg.DataStatus = ModelStatus.Deleted
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.IsFalse(newCase.Mortgages.Any(Function(m) m.MortgageId = lastMtg.MortgageId))
        Assert.AreEqual(mtgAmount, newCase.Mortgages.Count)

        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.IsFalse(newCase.Mortgages.Any(Function(m) m.MortgageId = lastMtg.MortgageId))
        Assert.AreEqual(mtgAmount, newCase.Mortgages.Count)
    End Sub

    <TestMethod()> Public Sub MortgageAddTest()
        Dim ssCase = ShortSaleCase.GetCase(caseId)
        Dim mtgs = ssCase.Mortgages.ToList
        Dim amount = mtgs.Count
        Assert.IsTrue(mtgs.Count > 0)

        Dim newMtg = New PropertyMortgage
        mtgs.Add(newMtg)
        newMtg.Loan = loan
        newMtg.DateOfSale = dateOfSale
        ssCase.Mortgages = mtgs.ToArray
        ssCase.Save(saveBy)
        Dim newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgs.Count, newCase.Mortgages.Count)
        Assert.AreEqual(loan, newCase.Mortgages.Last.Loan)

        'Save again shortsalecase
        newMtg.MortgageId = 0
        Assert.AreEqual(newMtg.MortgageId, 0)
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgs.Count, newCase.Mortgages.Count)
        Assert.AreEqual(loan, newCase.Mortgages.Last.Loan)

        newMtg.DataStatus = ModelStatus.Deleted
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgs.Count - 1, newCase.Mortgages.Count)
    End Sub

    <TestMethod()> Public Sub MortgageAddThenRemoveTest()
        Dim ssCase = ShortSaleCase.GetCase(caseId)
        Dim mtgs = ssCase.Mortgages.ToList
        Assert.IsTrue(mtgs.Count > 0)

        Dim newMtg = New PropertyMortgage
        mtgs.Add(newMtg)
        newMtg.Loan = loan
        newMtg.DateOfSale = dateOfSale
        newMtg.DataStatus = ModelStatus.Deleted

        newMtg = New PropertyMortgage
        mtgs.Add(newMtg)
        Dim loan2 = "Loan" & (New Random()).Next(1000)
        newMtg.Loan = loan2
        ssCase.Mortgages = mtgs.ToArray
        ssCase.Save(saveBy)

        Dim newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(ssCase.Mortgages.Count - 1, newCase.Mortgages.Count)
        Assert.AreEqual(loan2, newCase.Mortgages.Last.Loan)

        'Save again shortsalecase
        newMtg.MortgageId = 0
        Assert.AreEqual(newMtg.MortgageId, 0)
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgs.Count - 1, newCase.Mortgages.Count)
        Assert.AreEqual(loan2, newCase.Mortgages.Last.Loan)

        newMtg.DataStatus = ModelStatus.Deleted
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgs.Count - 2, newCase.Mortgages.Count)

        newMtg.MortgageId = 0
        ssCase.Save(saveBy)
        newCase = ShortSaleCase.GetCase(caseId)
        Assert.AreEqual(mtgs.Count - 2, newCase.Mortgages.Count)
    End Sub

    <TestMethod()> Public Sub IsViewableTest()
        'Admin
        Assert.IsTrue(ShortSaleManage.IsViewable(Nothing, "Chris Yan"))

        'ShortSale Manager
        Assert.IsTrue(ShortSaleManage.IsViewable(Nothing, "Michael Kay"))

        'ShortSale user
        Assert.IsTrue(ShortSaleManage.IsViewable(Nothing, "Gladys Best"))

        'legal User
        Assert.IsTrue(ShortSaleManage.IsViewable(Nothing, "Alex Frias"))

        'Agent
        Assert.IsFalse(ShortSaleManage.IsViewable(Nothing, "Tom Aronov"))
    End Sub

    <TestMethod> Public Sub GetCaseCategory_returnMortCategory()
        Dim ssCases = ShortSaleCase.GetAllCase()

        For Each ss In ssCases
            Assert.AreEqual(ss.FirstMortgage.Category, ShortSaleCase.GetCaseCategory(ss.BBLE))
        Next

        Assert.IsNull(ShortSaleCase.GetCaseCategory("dddd"))
        Assert.IsNull(ShortSaleCase.GetCaseCategory(Nothing))
    End Sub
End Class
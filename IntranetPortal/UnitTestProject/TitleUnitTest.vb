Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data
Imports IntranetPortal

<TestClass()> Public Class TitleUnitTest

    <TestMethod()> Public Sub GetSSCategories_returnCategories()
        Dim category = 3
        Dim categories = TitleCase.LoadSSCategories(category)
        Assert.AreEqual(6, categories.ShortSaleCategories.Count)
    End Sub

    <TestMethod()>
    Public Sub GetTitleCategory_returnString()
        For Each mapts In TitleCase.MapTitleShortSaleCategory
            For Each cate In mapts.ShortSaleCategories
                Assert.AreEqual(mapts.Category, TitleCase.GetTitleCategory(cate))
            Next
        Next

        Assert.IsNull(TitleCase.GetTitleCategory(Nothing))
        Assert.IsNull(TitleCase.GetTitleCategory("d"))
        Assert.IsNull(TitleCase.GetTitleCategory(""))
    End Sub

    <TestMethod>
    Public Sub GetExternalCases_returnCases()
        Dim tCases = TitleCase.GetExternalCases("All")
        Assert.IsNotNull(tCases)

        Dim allTitleCaes = TitleCase.GetAllCases(TitleCase.DataStatus.All).Select(Function(t) t.BBLE).ToArray
        Dim sscase As New List(Of String)
        For Each mapts In TitleCase.MapTitleShortSaleCategory
            For Each cate In mapts.ShortSaleCategories
                sscase.AddRange(ShortSaleCase.GetCaseByCategory(cate, 1).Select(Function(s) s.BBLE).ToArray)
            Next
        Next

        Dim result1 = allTitleCaes.Where(Function(a) Not sscase.Contains(a)).OrderBy(Function(s) s).ToList
        Dim result2 = tCases.Select(Function(t) t.BBLE).OrderBy(Function(s) s).ToList

        Assert.IsTrue(result1.SequenceEqual(result2))
    End Sub

    <TestMethod()> Public Sub GetCasesBySSCategory_returnCases()

        Dim allTitleCaes = TitleCase.GetAllCases(TitleCase.DataStatus.All).Select(Function(t) t.BBLE).ToArray
        For Each mapts In TitleCase.MapTitleShortSaleCategory

            Dim sscase As New List(Of ShortSaleCase)
            For Each cate In mapts.ShortSaleCategories
                sscase.AddRange(ShortSaleCase.GetCaseByCategory(cate, 1))
            Next

            Dim ssbbles = sscase.Select(Function(s) s.BBLE).Where(Function(ss) allTitleCaes.Contains(ss)).OrderBy(Function(s) s).ToArray

            Dim cases = TitleCase.GetCasesBySSCategory("All", mapts.Id)
            Dim tbbles = cases.Select(Function(t) t.BBLE).OrderBy(Function(s) s).ToArray

            Assert.AreEqual(tbbles.Count, ssbbles.Count)

            Dim result = ssbbles.SequenceEqual(tbbles)

            Assert.IsTrue(result)
        Next
    End Sub

    <TestMethod()> Public Sub TitleCategoryFunction_CategoryChangedInShortSale()
        Dim bble = "1020570051"
        Dim newCategory = "Homepath"
        Dim newStatus = "Value Dispute"
        Dim testBy = "TestUnit"

        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
        Dim tCase = TitleCase.GetCase(bble)
        Assert.AreEqual(tCase.SSCategory, ssCase.MortgageCategory)

        Dim cate = TitleCase.MapTitleShortSaleCategory.Where(Function(s) s.Category = tCase.TitleCategory).SingleOrDefault
        Assert.IsTrue(cate.ShortSaleCategories.Contains(ssCase.MortgageCategory))

        Dim ssCategory = ssCase.MortgageCategory
        Dim ssStatus = ssCase.FirstMortgage.Status
        Dim updateBy = ssCase.FirstMortgage.UpdateBy

        ssCase.UpdateMortgageStatus(0, newCategory, newStatus, testBy)
        tCase = TitleCase.GetCase(bble)
        Assert.AreEqual(tCase.SSCategory, newCategory)
        ssCase.UpdateMortgageStatus(0, ssCategory, ssStatus, updateBy)
    End Sub

    <TestMethod()> Public Sub TitleStatus_Changing()
        Dim bble = "1020570051"
        Dim tCase = TitleCase.GetCase(bble)
        Dim tStatus = tCase.Status
        Dim updateBy = tCase.UpdateBy

        Dim newStatus = TitleCase.DataStatus.InitialReview
        TitleManage.UpdateCaseStatus(bble, newStatus, "TestUnit")
        Dim newStatus2 = TitleCase.DataStatus.CTC
        TitleManage.UpdateCaseStatus(bble, newStatus2, "TestUnit")

        tCase = TitleCase.GetCase(bble)
        Assert.AreEqual(tCase.Status, CInt(newStatus2))

        TitleManage.UpdateCaseStatus(bble, newStatus, updateBy)
        TitleManage.UpdateCaseStatus(bble, tStatus, updateBy)
    End Sub

    <TestMethod()> Public Sub ManagerView_returnAllCases()

        Dim allCases = TitleCase.GetCasesBySSCategory("All")

        Dim userName = "Reina Avila"
        Dim reinaCases = TitleCase.GetCasesBySSCategory(userName)

        Assert.IsTrue(allCases.Count > reinaCases.Count)

        Dim rCaseBBLEs1 = allCases.Where(Function(s) s.Owner = userName).Select(Function(s) s.BBLE).OrderBy(Function(s) s).ToArray
        Dim rCaseBBLEs2 = reinaCases.Select(Function(s) s.BBLE).OrderBy(Function(s) s).ToArray

        Assert.IsTrue(rCaseBBLEs1.SequenceEqual(rCaseBBLEs2))
    End Sub

    <TestMethod()> Public Sub CheckTitleInstanceCategory_ShouldEqualToMap()

        Dim allTitleCases = TitleCase.GetAllCases(TitleCase.DataStatus.All).Select(Function(t) t.BBLE).ToArray

        For Each bble In allTitleCases
            Dim tCase = TitleCase.GetCase(bble)
            Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

            If ssCase IsNot Nothing Then
                Assert.AreEqual(tCase.SSCategory, ssCase.MortgageCategory)
                Assert.AreEqual(tCase.TitleCategory, TitleCase.GetTitleCategory(ssCase.MortgageCategory))
            Else
                Assert.IsNull(tCase.TitleCategory)
            End If
        Next

    End Sub

End Class
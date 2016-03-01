
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data
Imports IntranetPortal

''' <summary>
''' The title feature related testing
''' </summary>
<TestClass()> Public Class TitleUnitTest

    ''' <summary>
    ''' Testing map relation between title category and shortsale category
    ''' </summary>
    <TestMethod()> Public Sub GetSSCategories_returnCategories()
        Dim category = 3
        Dim categories = TitleCase.LoadSSCategories(category)
        Assert.AreEqual(6, categories.ShortSaleCategories.Count)
    End Sub

    ''' <summary>
    ''' UnitTest for GetTitleCategory function, the method should return the title category if shortsalecategory was given
    ''' </summary>
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

    ''' <summary>
    ''' UnitTest for GetExternalCases function, the function should return the cases which is not in ShortSaleCategory
    ''' </summary>
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

    ''' <summary>
    ''' UnitTest for GetCasesBySSCategory function, the function should return title cases under given category 
    ''' </summary>
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

    ''' <summary>
    ''' Function Test for Title Category Syncing with ShortSale Category, 
    ''' the Title category should changed along with category changing in ShortSale
    ''' </summary>
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

    ''' <summary>
    ''' UnitTest for TitleStatus method, the method should changed to given status
    ''' </summary>
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

    ''' <summary>
    ''' FunctionTest for AllCase, the AllCase should include all the users' cases
    ''' </summary>
    <TestMethod()> Public Sub AllCase_returnAllCases()

        Dim allCases = TitleCase.GetCasesBySSCategory("All")

        Dim userName = "Reina Avila"
        Dim reinaCases = TitleCase.GetCasesBySSCategory(userName)

        Assert.IsTrue(allCases.Count > reinaCases.Count)

        Dim rCaseBBLEs1 = allCases.Where(Function(s) s.Owner = userName).Select(Function(s) s.BBLE).OrderBy(Function(s) s).ToArray
        Dim rCaseBBLEs2 = reinaCases.Select(Function(s) s.BBLE).OrderBy(Function(s) s).ToArray

        Assert.IsTrue(rCaseBBLEs1.SequenceEqual(rCaseBBLEs2))
    End Sub

    ''' <summary>
    ''' RegressionTest for map relationship between Title Category and ShortSale Category,
    ''' all title cases' category should map to ShortSale Cases' category
    ''' </summary>
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

    ''' <summary>
    ''' UnitTest for TitleCategories function, The function should return category name of given category id,
    ''' Nothing would return, if category id is not valid
    ''' </summary>
    <TestMethod> Public Sub TitleCategory_returnCategory()

        Dim map = TitleCase.MapTitleShortSaleCategory

        For Each item In map
            Assert.AreEqual(item.Category, TitleManage.TitleCategories(item.Id))
        Next

        Assert.IsNull(TitleManage.TitleCategories(100))
    End Sub

End Class
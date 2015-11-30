Imports System.Text
Imports System.Web.Http
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data
Imports System.Net

''' <summary>
''' Construction Case Unit testing
''' </summary>
<TestClass()>
Public Class ConstructionTest

    ''' <summary>
    ''' Get Case testing
    ''' </summary>
    <TestMethod()>
    Public Sub GetCaseTest()
        Dim bble = "1004490003"
        Dim controller As New IntranetPortal.Controllers.ConstructionCasesController
        Dim caseData = controller.GetConstructionCase(bble)
        Assert.IsInstanceOfType(caseData, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(caseData, GetType(Results.OkNegotiatedContentResult(Of IntranetPortal.Data.ConstructionCase)))
        Dim cData = CType(caseData, Results.OkNegotiatedContentResult(Of IntranetPortal.Data.ConstructionCase)).Content
        Assert.AreEqual(bble, cData.BBLE.Trim)
    End Sub

    ''' <summary>
    ''' Saving case testing
    ''' </summary>
    <TestMethod()>
    Public Sub SaveCaseTest()
        Dim bble = "1004490003"
        Dim controller As New IntranetPortal.Controllers.ConstructionCasesController
        Dim caseData = controller.GetConstructionCase(bble)
        Assert.IsInstanceOfType(caseData, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(caseData, GetType(Results.OkNegotiatedContentResult(Of IntranetPortal.Data.ConstructionCase)))
        Dim cData = CType(caseData, Results.OkNegotiatedContentResult(Of IntranetPortal.Data.ConstructionCase)).Content
        Assert.AreEqual(bble, cData.BBLE.Trim)

        Dim jsCase = JToken.Parse(cData.CSCase)
        Dim buildingClass = jsCase("InitialIntake")("BuildingClass").ToString
        Assert.AreEqual("O8", buildingClass)
        jsCase("InitialIntake")("BuildingClass") = "O9"
        cData.CSCase = jsCase.ToString
        Dim result = controller.PutConstructionCase(bble, cData)
        Assert.IsInstanceOfType(result, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(result, GetType(Results.StatusCodeResult))
        Assert.IsTrue(CType(result, Results.StatusCodeResult).StatusCode = HttpStatusCode.NoContent)

        cData = ConstructionCase.GetCase(bble)
        jsCase = JToken.Parse(cData.CSCase)
        Assert.AreEqual("O9", jsCase("InitialIntake")("BuildingClass").ToString())
        jsCase("InitialIntake")("BuildingClass") = "O8"
        cData.CSCase = jsCase.ToString
        cData.Save("")

        cData = ConstructionCase.GetCase(bble)
        jsCase = JToken.Parse(cData.CSCase)
        Assert.AreEqual("O8", jsCase("InitialIntake")("BuildingClass").ToString())
    End Sub

End Class
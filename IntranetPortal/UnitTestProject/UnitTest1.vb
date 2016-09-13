Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports ClosedXML.Excel
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data

<TestClass()> Public Class DocumentGeneratorTest

    Shared Function decideBBaseOnA(field1 As String, field2 As String) As Func(Of Object, String)
        Dim temp = Function(data)
                       Dim Has1st = data.SelectToken(field1)
                       If Has1st Is Nothing OrElse Has1st.ToString.Equals("False") Then
                           Return ""
                       Else
                           Dim Has1stMg = data.SelectToken(field2)
                           If Not Has1stMg Is Nothing Then
                               Return Has1stMg.ToString
                           Else
                               Return "0.0"
                           End If

                       End If
                   End Function
        Return temp
    End Function

    Shared Function booleanToYN(field1 As String) As Func(Of Object, String)
        Dim temp = Function(data)
                       Dim Has1st = data.SelectToken(field1)
                       If Has1st Is Nothing Then
                           Return ""
                       ElseIf Has1st.ToString.Equals("True") Then
                           Return "Yes"
                       Else
                           Return "No"
                       End If
                   End Function
        Return temp
    End Function

    Shared Function concatOtherLiens() As Func(Of Object, String)
        Dim temp = Function(d As JObject)
                       Dim hasother = d.SelectToken("Has_Other_Liens")
                       If hasother IsNot Nothing AndAlso hasother.ToString.Equals("True") Then
                           Dim otherliens = d.SelectToken("OtherLiens")
                           If Not otherliens Is Nothing Then
                               Dim liens = From lien In otherliens
                                           Select lien("Lien")
                               If liens.Count > 0 Then
                                   Return String.Join(",", liens)
                               Else
                                   Return ""
                               End If
                           Else
                               Return ""
                           End If
                       Else
                           Return ""
                       End If
                   End Function
        Return temp
    End Function
    <TestMethod()> Public Sub GenerateExcel_returnTrue()
        Using wb = New XLWorkbook("D:\TasksWebApplication\IntranetPortal\IntranetPortal\App_Data\underwriter.xlsx")

            Dim ds As LeadInfoDocumentSearch
            Dim li As LeadsInfo

            li = LeadsInfo.GetInstance("4121710045")

            Using ctx As New PortalEntities
                ds = ctx.LeadInfoDocumentSearches.Find("4121710045")

            End Using

            Dim ws = wb.Worksheet("Data Input")
            Dim jsonStr = ds.LeadResearch
            Dim jobj = JObject.Parse(jsonStr)
            jobj.Add("LeadsInfo", JObject.Parse(li.ToJsonString))


            Dim fileConfig As New GenerateFileConfig
            Dim file = New GenerateFileConfig With {.ConfigKey = "Test"}
            Dim phs = {
                       New DocumentPlaceHolder("C3", "LeadsInfo.PropertyAddress"),
                       New DocumentPlaceHolder("C4", "LeadsInfo.TaxClass"),
                       New DocumentPlaceHolder("C5", "LeadsInfo.BuildingDem"),
                       New DocumentPlaceHolder("C6", "LeadsInfo.Lot"),
                       New DocumentPlaceHolder("C7", "LeadsInfo.Zoning"),
                       New DocumentPlaceHolder("C8", "", DocumentPlaceHolder.ValueType.FixedString),
                       New DocumentPlaceHolder("C9", "Property_Taxes_per_YR_Property_Taxes_Due"),
                       New DocumentPlaceHolder("F3", decideBBaseOnA("Has_c_1st_Mortgage_c_1st_Mortgage", "mortgageAmount")),
                       New DocumentPlaceHolder("F4", decideBBaseOnA("Has_c_2nd_Mortgage_c_2nd_Mortgage", "secondMortgageAmount")),
                       New DocumentPlaceHolder("F5", booleanToYN("Has_COS_Recorded")),
                       New DocumentPlaceHolder("F6", booleanToYN("Has_Deed_Recorded")),
                       New DocumentPlaceHolder("F7", concatOtherLiens())
          }

            file.PlaceHolders = phs.ToList

            Dim gene As New DocumentGenerator(jobj, "1017700038")
            gene.GenerateExcel(ws, file)
            wb.SaveAs("D:\TasksWebApplication\IntranetPortal\IntranetPortal\TempDataFile\underwriter.xlsx")
        End Using

        Assert.IsTrue(True)
    End Sub

End Class
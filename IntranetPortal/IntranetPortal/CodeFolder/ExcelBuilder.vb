Imports System.IO
Imports ClosedXML.Excel
Imports IntranetPortal.Data
Imports Newtonsoft.Json.Linq


Public Class ExcelBuilder

    Public Shared Function BuildBudgetReport(address As String, owner As String, budgetData As BudgetRow(), fs As Stream) As Byte()

        Using wb = New XLWorkbook(fs)
            Dim ws = wb.Worksheet("CHECK REQUEST")
            ws.Cell("B3").Value = owner
            ws.Cell("B5").Value = "Construction"
            ws.Cell("B7").Value = DateTime.Now
            Dim index = 10

            For Each row In budgetData
                If (index <= 35) Then
                    ws.Cell("A" & index).Value = address
                    ws.Cell("B" & index).Value = row.contract
                    ws.Cell("C" & index).Value = row.toDay
                    ws.Cell("D" & index).Value = row.paid
                    ws.Cell("G" & index).Value = row.description
                    index = index + 1
                Else
                    ws.Cell("A" & index).InsertCellsAbove(1)
                    ws.Cell("A" & index).Value = address
                    ws.Cell("B" & index).Value = row.contract
                    ws.Cell("C" & index).Value = row.toDay
                    ws.Cell("D" & index).Value = row.paid
                    ws.Cell("G" & index).Value = row.description
                    index = index + 1
                End If

            Next

            Using ms As New MemoryStream
                wb.SaveAs(ms)
                Return ms.ToArray
            End Using
        End Using

    End Function

    Public Shared Function BuildTitleReport(json As JObject) As Byte()
        Dim ColorGrey = XLColor.FromArgb(191, 192, 191)
        Dim ColorYellow = XLColor.Yellow
        Dim ColorLightBlue = XLColor.FromArgb(155, 194, 230)
        Dim temp As JToken
        Dim index As Integer


        Using wb = New XLWorkbook()

            Dim report = wb.AddWorksheet("report")
            report.Column("A").Width = 45
            report.Column("B").Width = 45
            report.Column("B").Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Left)
            report.Column("C").Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Left)
            report.Column("C").Width = 45
            report.Column("D").Width = 3
            report.Column("D").Style.Fill.BackgroundColor = ColorGrey
            report.Column("E").Width = 20
            report.Column("F").Width = 20
            report.Column("G").Width = 20
            report.Column("G").Style.NumberFormat.SetNumberFormatId(4)

            Dim a1c1 = report.Range("A1:C1")
            a1c1.Style.Fill.BackgroundColor = ColorGrey

            report.Cell("A1").Value = "CLEARANCE MEMO"

            report.Cell("C2").Value = "Notes"
            report.Cell("C2").Style.Fill.BackgroundColor = ColorLightBlue
            report.Cell("C2").Style.Font.SetBold()

            report.Cell("A3").Value = "PROPERTY ADDRESS"
            temp = json.SelectToken("FormData.info.PROPERTY_ADDRESS")
            If temp IsNot Nothing Then
                report.Cell("B3").Value = temp.ToString()
                report.Cell("E3").Value = temp.ToString()
            End If

            report.Cell("A4").Value = "BLOCK"
            temp = json.SelectToken("FormData.info.Block")
            If temp IsNot Nothing Then
                report.Cell("B4").Value = temp.ToString()
            End If

            report.Cell("A5").Value = "LOT"
            temp = json.SelectToken("FormData.info.Lot")
            If temp IsNot Nothing Then
                report.Cell("B5").Value = temp.ToString()
            End If

            report.Cell("A6").Value = "LEGAL C/O"
            temp = json.SelectToken("FormData.info.Total_Units")
            If temp IsNot Nothing Then
                report.Cell("B6").Value = temp.ToString()
            End If

            report.Cell("A6").Value = "DO WE HAVE TITLE"
            temp = json.SelectToken("FormData.info.Title_Num")
            If temp IsNot Nothing Then
                report.Cell("B6").Value = "Yes"
            Else
                report.Cell("B6").Value = "Yes"
            End If

            report.Cell("A7").Value = "TITLE NUMBER"
            temp = json.SelectToken("FormData.info.Title_Num")
            If temp IsNot Nothing Then
                report.Cell("B7").Value = temp.ToString
            End If

            report.Cell("A8").Value = "BUYER on COS/HUD/APPROVAL/CORP DOCS MATCH"
            temp = json.SelectToken("FormData.info.BUERY_MATCH")
            If temp IsNot Nothing Then
                report.Cell("B8").Value = Boolean.Parse(temp.ToString)
            End If

            Dim a1a8 = report.Range("A3:A8")
            a1a8.Style.Fill.BackgroundColor = ColorLightBlue
            a1a8.Style.Font.SetBold()


            index = 10

            temp = json.SelectToken("FormData.preclosing.ApprovalData")
            If temp IsNot Nothing Then
                Dim approvals = temp.ToList()
                For Each tdata In approvals
                    report.Cell("A" & index).Value = "APPROVAL " & approvals.IndexOf(tdata) & " EXPIRES"
                    report.Cell("A" & index).Style.Fill.BackgroundColor = ColorLightBlue
                    report.Cell("A" & index).Style.Font.SetBold()
                    report.Cell("B" & index).Value = If(tdata("Expired_Date") Is Nothing, "", tdata("Expired_Date").ToString)
                    report.Cell("C" & index).Value = If(tdata("Note") Is Nothing, "", tdata("Note").ToString)
                    index = index + 2
                Next

            End If

            report.Cell("A" & index).Value = "CHAIN OF TITLE"
            report.Cell("A" & index).Style.Fill.BackgroundColor = ColorLightBlue
            report.Cell("A" & index).Style.Font.SetBold()
            temp = json.SelectToken("FormData.info.DeedChain")
            If temp IsNot Nothing Then
                report.Cell("C" & index).Value = temp.ToString
            End If
            index = index + 2

            temp = json.SelectToken("FormData.Owners")
            If temp IsNot Nothing Then
                Dim owners = temp.ToList
                For Each owner In owners
                    report.Cell("A" & index).Value = owner("name").ToString & " ISSUES"
                    report.Cell("A" & index).Style.Fill.BackgroundColor = ColorLightBlue
                    report.Cell("A" & index).Style.Font.SetBold()
                    index = index + 1
                    Dim shownlist = owner("shownlist")
                    Dim sectionlist = New ArrayList({"Mortgages", "Lis_Pendens", "Judgements", "ECB_Notes", "PVB_Notes", "Bankruptcy_Notes", "UCCs", "FederalTaxLiens", "MechanicsLiens", "TaxLiensSaleCerts", "VacateRelocationLiens"})
                    For Each section In sectionlist
                        Dim tsec = owner(section)
                        Dim tindex = sectionlist.IndexOf(section)
                        If tsec IsNot Nothing AndAlso Boolean.Parse(shownlist(tindex).ToString) Then
                            Dim i = 1
                            For Each item In tsec.ToList
                                Dim o = JObject.Parse(item.ToString)
                                If o IsNot Nothing Then
                                    For Each p In o.Properties
                                        If p.Value IsNot Nothing AndAlso p.Name <> "$$hashKey" Then
                                            report.Cell("B" & index).Value = sectionlist(tindex).ToString & " " & i & " " & p.Name
                                            report.Cell("C" & index).Value = p.Value.ToString
                                            index = index + 1
                                        End If
                                    Next
                                End If
                                i = i + 1
                            Next
                        End If
                    Next
                    index = index + 1
                Next
            End If

            ' FEE BreakDown
            report.Cell("E4").Value = "FEES"
            index = 5
            temp = json.SelectToken("FormData.FeeClearance.data")
            If temp IsNot Nothing Then
                Dim fees = temp.ToList
                For Each f In fees
                    report.Cell("F" & index).Value = If(f("name") Is Nothing Or String.IsNullOrEmpty(f("name").ToString), "", f("name").ToString())
                    report.Cell("G" & index).Value = Double.Parse(If(f("cost") Is Nothing Or String.IsNullOrEmpty(f("cost").ToString), "0", f("cost").ToString()))
                    index = index + 1
                Next
                report.Cell("F" & index).Value = "Total"
                report.Cell("F" & index).Style.Fill.BackgroundColor = ColorYellow
                report.Cell("F" & index).Style.Font.SetBold()
                report.Cell("G" & index).SetFormulaA1("=SUM(G5:G" & (index - 1) & ")")
            End If


            Using ms = New MemoryStream
                wb.SaveAs(ms)
                Return ms.ToArray
            End Using
        End Using


    End Function


    Public Shared Function fillUpUnderWriterSheet(fs As MemoryStream, li As LeadsInfo, ds As LeadInfoDocumentSearch) As Byte()
        Using wb = New XLWorkbook(fs)
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
                        New DocumentPlaceHolder("F7", concatOtherLiens()),
                        New DocumentPlaceHolder("F8", booleanToYN("fha")),
                        New DocumentPlaceHolder("F9", booleanToYN("fannie")),
                        New DocumentPlaceHolder("F10", booleanToYN("Freddie_Mac_")),
                        New DocumentPlaceHolder("F11", "servicer"),
                        New DocumentPlaceHolder("F12", "LP_Index___Num_LP_Index___Num"),
                        New DocumentPlaceHolder("F13", "", DocumentPlaceHolder.ValueType.FixedString),
                        New DocumentPlaceHolder("F14", "Servicer_notes"),
                        New DocumentPlaceHolder("F16", "", DocumentPlaceHolder.ValueType.FixedString),
                        New DocumentPlaceHolder("F17", "", DocumentPlaceHolder.ValueType.FixedString),
                        New DocumentPlaceHolder("F18", "", DocumentPlaceHolder.ValueType.FixedString),
                        New DocumentPlaceHolder("F19", "", DocumentPlaceHolder.ValueType.FixedString),
                        New DocumentPlaceHolder("I3", addUpTaxLienCertificate()),
                        New DocumentPlaceHolder("I4", decideBBaseOnA("Has_Due_Property_Taxes_Due", "propertyTaxes")),
                         New DocumentPlaceHolder("I5", decideBBaseOnA("Has_Due_Water_Charges_Due", "waterCharges")),
                         New DocumentPlaceHolder("I6", decideBBaseOnA("Is_Open_HPD_Charges_Not_Paid_Transferred", "Open_Amount_HPD_Charges_Not_Paid_Transferred")),
                         New DocumentPlaceHolder("I7", decideBBaseOnA("has_ECB_Tickets_ECB_Tickets", "Amount_ECB_Tickets")),
                         New DocumentPlaceHolder("I8", decideBBaseOnA("Has_Open_DOB_Violoations", "dobWebsites")),
                         New DocumentPlaceHolder("I9", decideBBaseOnA("has_Judgments_Personal_Judgments", "Amount_Personal_Judgments")),
                         New DocumentPlaceHolder("I10", decideBBaseOnA("has_Judgments_HPD_Judgments", "HPDjudgementAmount")),
                         New DocumentPlaceHolder("I11", addIRSNYS()),
                         New DocumentPlaceHolder("I12", booleanToYN("has_Vacate_Order_Vacate_Order")),
                         New DocumentPlaceHolder("I13", decideBBaseOnA("has_Vacate_Order_Vacate_Order", "Amount_Vacate_Order")),
                         New DocumentPlaceHolder("I14", "", DocumentPlaceHolder.ValueType.FixedString)
           }

            file.PlaceHolders = phs.ToList

            Dim gene As New DocumentGenerator(jobj, "1017700038")
            gene.GenerateExcel(ws, file)
            Using ms As New MemoryStream
                wb.SaveAs(ms)
                Return ms.ToArray()
            End Using

        End Using

    End Function

    ''' <summary>
    ''' add up NYS and IRS value in the json string
    ''' </summary>
    ''' <returns></returns>
    Public Shared Function addIRSNYS() As Func(Of Object, String)
        Dim temp = Function(data As JObject)
                       Dim total = 0.0
                       Dim hasIRS = data.SelectToken("has_IRS_Tax_Lien_IRS_Tax_Lien")
                       Dim hasNYS = data.SelectToken("hasNysTaxLien")
                       If Not hasIRS Is Nothing AndAlso hasIRS.ToString.Equals("True") Then
                           Dim irsv = data.SelectToken("irsTaxLien")
                           If irsv IsNot Nothing Then
                               total = total + CType(irsv.ToString, Double)
                           End If
                       End If
                       If Not hasNYS Is Nothing AndAlso hasNYS.ToString.Equals("True") Then
                           Dim nysv = data.SelectToken("Amount_NYS_Tax_Lien")
                           If nysv IsNot Nothing Then
                               total = total + CType(nysv.ToString, Double)
                           End If
                       End If
                       Return total.ToString
                   End Function
        Return temp
    End Function


    ''' <summary>
    ''' if filed a in json is not false or nothing
    ''' then with return b's value
    ''' </summary>
    ''' <param name="field1"></param>
    ''' <param name="field2"></param>
    ''' <returns></returns>
    Public Shared Function decideBBaseOnA(field1 As String, field2 As String) As Func(Of Object, String)
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


    ''' <summary>
    ''' convert boolean true/false to yes/no
    ''' if nothing, return blank string
    ''' </summary>
    ''' <param name="field1"></param>
    ''' <returns></returns>
    Public Shared Function booleanToYN(field1 As String) As Func(Of Object, String)
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

    ''' <summary>
    ''' concat other liens with ',' as seperator
    ''' for example
    ''' "lien1, line2, line3"
    ''' </summary>
    ''' <returns></returns>
    Public Shared Function concatOtherLiens() As Func(Of Object, String)
        Dim temp = Function(d As JObject)
                       Dim hasother = d.SelectToken("Has_Other_Liens")
                       If hasother IsNot Nothing AndAlso hasother.ToString.Equals("True") Then
                           Dim otherliens = d.SelectToken("OtherLiens")
                           If Not otherliens Is Nothing Then
                               Dim liens = From lien In otherliens
                                           Select lien("Lien")
                               If liens.Count > 0 Then
                                   Return String.Join(", ", liens)
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

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns>double format number in string format</returns>
    Public Shared Function addUpTaxLienCertificate() As Func(Of Object, String)
        Dim temp = Function(d As JObject)
                       Dim hasother = d.SelectToken("Has_TaxLiensCertifcate")
                       If hasother IsNot Nothing AndAlso hasother.ToString.Equals("True") Then
                           Dim xliens = d.SelectToken("TaxLienCertificate")
                           If Not xliens Is Nothing Then
                               Dim liens = From lien In xliens
                                           Select lien("Amount")
                               If liens.Count > 0 Then
                                   Dim total = 0.0
                                   For Each lien In liens
                                       total = total + CType(lien, Double)
                                   Next
                                   Return total.ToString
                               Else
                                   Return "0.0"
                               End If
                           Else
                               Return "0.0"
                           End If
                       Else
                           Return "0.0"
                       End If
                   End Function
        Return temp
    End Function

    Class BudgetRow
        Public balance As Double
        Public contract As Double
        Public toDay As Double
        Public paid As Double
        Public description As String
    End Class



End Class




Imports System.IO
Imports ClosedXML.Excel
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
                    Dim sectionlist = New ArrayList({"Mortgages", "Lis_Pendens", "Judgements", "ECB_Notes", "PVB_Notes", "Bankruptcy_Notes", "UCCs", "FederalTaxLiens", "MechanicsLiens"})
                    For Each section In sectionlist
                        Dim tsec = owner(section)
                        Dim tindex = sectionlist.IndexOf(section)
                        If tsec IsNot Nothing And Boolean.Parse(shownlist(tindex).ToString) Then
                            Dim i = 1
                            For Each item In tsec.ToList
                                Dim o = JObject.Parse(item.ToString)
                                If o IsNot Nothing Then
                                    For Each p In o.Properties
                                        If p.Value IsNot Nothing And p.Name <> "$$hashKey" Then
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
                    report.Cell("F" & index).Value = f.SelectToken("name").ToString
                    report.Cell("G" & index).Value = Double.Parse(f.SelectToken("cost").ToString)
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
    Class BudgetRow
        Public balance As Double
        Public contract As Double
        Public toDay As Double
        Public paid As Double
        Public description As String
    End Class
End Class

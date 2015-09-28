Imports Microsoft.VisualBasic
Imports System
Imports System.Drawing
Imports System.Globalization
Imports DevExpress.Spreadsheet

Public Class ConstructionBudgetTab
    Inherits System.Web.UI.UserControl
    Private worksheet As Worksheet

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            worksheet = Spreadsheet.Document.Worksheets(0)
            PrepareHeaderCells()
            InitializeDataCellsValues()
            Spreadsheet.Document.Options.Culture = CultureInfo.InvariantCulture
            Spreadsheet.Document.History.Clear()
        End If
    End Sub
    Private Sub PrepareHeaderCells()
        Dim header As Range = worksheet.Range("A1:H1")
        header(0).Value = "Description"
        header(1).Value = "Estimate"
        header(2).Value = "Qty"
        header(3).Value = "Materials"
        header(4).Value = "Labor"
        header(5).Value = "Contract Price"
        header(6).Value = "Paid"
        header(7).Value = "Balance"
        header.Style = worksheet.Workbook.Styles("Heading 2")
        header.Alignment.Horizontal = SpreadsheetHorizontalAlignment.Center
        worksheet.Columns("A").Width = 640
        Dim eCol = worksheet.Range("B2:B111")
        eCol.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
        Dim mCol = worksheet.Range("D2:D111")
        mCol.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
        Dim lCol = worksheet.Range("E2:E111")
        lCol.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
        Dim cCol = worksheet.Range("F2:F111")
        cCol.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
        Dim pCol = worksheet.Range("G2:G111")
        pCol.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
        Dim bCol = worksheet.Range("H2:H111")
        bCol.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
    End Sub
    Private Sub InitializeDataCellsValues()
#Region "WorkSheet Data"
        worksheet.Cells("A2").Value = "Pre-Construction"
        worksheet.Cells("A2").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A2").Font.Bold = True
        worksheet.Cells("A3").Value = "Asbestos"
        worksheet.Cells("A4").Value = "Survey"
        worksheet.Cells("A5").Value = "Borings"
        worksheet.Cells("A6").Value = "Exhibits"
        worksheet.Cells("A7").Value = "Architectual Fees"
        worksheet.Cells("A8").Value = "Structural Engineer"
        worksheet.Cells("A9").Value = "Mechanical Engineer"
        worksheet.Cells("A10").Value = "Expeditor"
        worksheet.Cells("A11").Value = "DOB fees"
        worksheet.Cells("A12").Value = "Sprinkler Plans"
        worksheet.Cells("A13").Value = "Construction Permits"
        worksheet.Cells("A14").Value = "Site Work"
        worksheet.Cells("A14").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A14").Font.Bold = True
        worksheet.Cells("A15").Value = "Demolition 100%"
        worksheet.Cells("A16").Value = "  Demo Work 50%"
        worksheet.Cells("A17").Value = "  Garbadge/Clean 50%"
        worksheet.Cells("A18").Value = "Sewers"
        worksheet.Cells("A19").Value = "Blasting"
        worksheet.Cells("A20").Value = "Sidewalks"
        worksheet.Cells("A21").Value = "Water Main Dig"
        worksheet.Cells("A22").Value = ""
        worksheet.Cells("A23").Value = "BUILDING FRAME/ENVELOPE"
        worksheet.Cells("A23").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A23").Font.Bold = True
        worksheet.Cells("A24").Value = "Labor"
        worksheet.Cells("A25").Value = "Foundation"
        worksheet.Cells("A26").Value = "Framing Material/Metal"
        worksheet.Cells("A27").Value = "Metal Joist/Studs/Track"
        worksheet.Cells("A28").Value = "Wood Joists"
        worksheet.Cells("A29").Value = "Framing Labor"
        worksheet.Cells("A30").Value = "Roofing/Deck"
        worksheet.Cells("A31").Value = "Gutters"
        worksheet.Cells("A32").Value = "Insulation + Soundproofing"
        worksheet.Cells("A33").Value = "Siding/Facade"
        worksheet.Cells("A34").Value = "  Material"
        worksheet.Cells("A35").Value = "  Labor"
        worksheet.Cells("A36").Value = "  Capping"
        worksheet.Cells("A37").Value = "Windows/Skylights"
        worksheet.Cells("A38").Value = "  Interior Glass"
        worksheet.Cells("A39").Value = "  Front Door/Glass/Metal Doors"
        worksheet.Cells("A40").Value = "Roof Deck"
        worksheet.Cells("A41").Value = "Railings (Internal/Roof)"
        worksheet.Cells("A42").Value = "Staircases"
        worksheet.Cells("A43").Value = "  Railings"
        worksheet.Cells("A44").Value = "Bulkhead"
        worksheet.Cells("A45").Value = "Metal Gates/ Front And Window"
        worksheet.Cells("A46").Value = "INTERIOR WALLS"
        worksheet.Cells("A46").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A46").Font.Bold = True
        worksheet.Cells("A47").Value = "Labor"
        worksheet.Cells("A48").Value = "Sheetrock"
        worksheet.Cells("A49").Value = "Tape"
        worksheet.Cells("A50").Value = "Plaster"
        worksheet.Cells("A51").Value = "Molding"
        worksheet.Cells("A52").Value = "Insulation + Soundproofing"
        worksheet.Cells("A53").Value = "INTERIOR DOORS"
        worksheet.Cells("A54").Value = "Handles"
        worksheet.Cells("A55").Value = "Closet Knobs"
        worksheet.Cells("A56").Value = "Front Door"
        worksheet.Cells("A57").Value = "Rear Door"
        worksheet.Cells("A58").Value = "Metal Doors"
        worksheet.Cells("A59").Value = "Interior Painting/Material"
        worksheet.Cells("A59").Value = "PLUMBING"
        worksheet.Cells("A59").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A60").Font.Bold = True
        worksheet.Cells("A61").Value = "Labor"
        worksheet.Cells("A62").Value = "General"
        worksheet.Cells("A63").Value = "  Meters"
        worksheet.Cells("A64").Value = "  Toilets"
        worksheet.Cells("A65").Value = "  Vanities"
        worksheet.Cells("A66").Value = "  Mirrors"
        worksheet.Cells("A67").Value = "  Shower Glass"
        worksheet.Cells("A68").Value = "  Tubs"
        worksheet.Cells("A69").Value = "Water Meter"
        worksheet.Cells("A70").Value = "RPZ Testing"
        worksheet.Cells("A71").Value = "Hydrant Test Flow"
        worksheet.Cells("A72").Value = "Fire Sprinkler System"
        worksheet.Cells("A73").Value = "Sump Pump"
        worksheet.Cells("A74").Value = "Back Valve"
        worksheet.Cells("A75").Value = "Plumbing Permits"
        worksheet.Cells("A76").Value = "HVAC Labor/Black"
        worksheet.Cells("A76").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A76").Font.Bold = True
        worksheet.Cells("A77").Value = "General"
        worksheet.Cells("A78").Value = ""
        worksheet.Cells("A79").Value = "ELECTRIC"
        worksheet.Cells("A79").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A79").Font.Bold = True
        worksheet.Cells("A80").Value = "Labor"
        worksheet.Cells("A81").Value = "General Wiring"
        worksheet.Cells("A82").Value = "Permits"
        worksheet.Cells("A83").Value = "Meters"
        worksheet.Cells("A84").Value = "Electric Permits"
        worksheet.Cells("A85").Value = ""
        worksheet.Cells("A86").Value = "KITCHENS"
        worksheet.Cells("A86").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A86").Font.Bold = True
        worksheet.Cells("A87").Value = "Kitchen Cabinets"
        worksheet.Cells("A88").Value = "Granite Countertops/Windowsills"
        worksheet.Cells("A89").Value = "Faucets"
        worksheet.Cells("A90").Value = "Appliances"
        worksheet.Cells("A91").Value = ""
        worksheet.Cells("A92").Value = "TILE"
        worksheet.Cells("A92").Fill.BackgroundColor = Color.IndianRed
        worksheet.Cells("A92").Font.Bold = True
        worksheet.Cells("A93").Value = "Tile Kitchens/BackSplash/Floor"
        worksheet.Cells("A94").Value = "Tile Baths"
        worksheet.Cells("A95").Value = "Cellar"
        worksheet.Cells("A96").Value = ""
        worksheet.Cells("A97").Value = "FLOORS"
        worksheet.Cells("A97").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A97").Font.Bold = True
        worksheet.Cells("A98").Value = "Wood Flooring"
        worksheet.Cells("A99").Value = ""
        worksheet.Cells("A100").Value = "EXTRA"
        worksheet.Cells("A100").Fill.BackgroundColor = Color.Red
        worksheet.Cells("A100").Font.Bold = True
        worksheet.Cells("A101").Value = "GC Salary"
        worksheet.Cells("A102").Value = "Fireplaces"
        worksheet.Cells("A103").Value = "Closet Systems"
        worksheet.Cells("A104").Value = "Mirror Work"
        worksheet.Cells("A105").Value = "Backyard Work/Structure/Fence"
        worksheet.Cells("A106").Value = "Steel Deck"
        worksheet.Cells("A107").Value = "Landscaping"
        worksheet.Cells("A108").Value = "Iron Deck"
        worksheet.Cells("A109").Value = "Print"
        worksheet.Cells("A110").Value = "Finishes (inc: lighting,vanities, etc.)"
        worksheet.Cells("A111").Value = "TOTALS"

        worksheet.Cells("A112").Value = ""
        worksheet.Cells("A113").Value = "Signing Contract - 10%"
        worksheet.Cells("A114").Value = "Finish Framing - 10%"
        worksheet.Cells("A115").Value = "Finish Plumbing and Elctrical Roughing - 10%"
        worksheet.Cells("A116").Value = "Finish Sheetrock, Tiling, and Paining - 20%"
        worksheet.Cells("A117").Value = "Install Kitchens and Doors - 20%"
        worksheet.Cells("A118").Value = "Complete all Outisde work (decks, garden, facade) - 20%"
        worksheet.Cells("A119").Value = ""
        worksheet.Cells("A120").Value = "Contingency - 10%"
        worksheet.Cells("A121").Value = "Turn Key - 5%"
        worksheet.Cells("A122").Value = "Punch List Completed - 5%"
        worksheet.Cells("A123").Value = ""
        worksheet.Cells("A124").Value = "Start Job"
        worksheet.Cells("A125").Value = "Anticipated Completion"
#End Region

        worksheet.Cells("H2").Formula = "=(F2-G2)"
        worksheet.Cells("H3").Formula = "=(F3-G3)"
        worksheet.Cells("H4").Formula = "=(F4-G4)"
        worksheet.Cells("H5").Formula = "=(F5-G5)"
        worksheet.Cells("H6").Formula = "=(F6-G6)"
        worksheet.Cells("H7").Formula = "=(F7-G7)"
        worksheet.Cells("H8").Formula = "=(F8-G8)"
        worksheet.Cells("H9").Formula = "=(F9-G9)"
        worksheet.Cells("H10").Formula = "=(F10-G10)"
        worksheet.Cells("H11").Formula = "=(F11-G11)"
        worksheet.Cells("H12").Formula = "=(F12-G12)"
        worksheet.Cells("H13").Formula = "=(F13-G13)"
        worksheet.Cells("H14").Formula = "=(F14-G14)"
        worksheet.Cells("H15").Formula = "=(F15-G15)"
        worksheet.Cells("H16").Formula = "=(F16-G16)"
        worksheet.Cells("H17").Formula = "=(F17-G17)"
        worksheet.Cells("H18").Formula = "=(F18-G18)"
        worksheet.Cells("H19").Formula = "=(F19-G19)"
        worksheet.Cells("H20").Formula = "=(F20-G20)"
        worksheet.Cells("H21").Formula = "=(F21-G21)"
        worksheet.Cells("H22").Formula = "=(F22-G22)"
        worksheet.Cells("H23").Formula = "=(F23-G23)"
        worksheet.Cells("H24").Formula = "=(F24-G24)"
        worksheet.Cells("H25").Formula = "=(F25-G25)"
        worksheet.Cells("H26").Formula = "=(F26-G26)"
        worksheet.Cells("H27").Formula = "=(F27-G27)"
        worksheet.Cells("H28").Formula = "=(F28-G28)"
        worksheet.Cells("H29").Formula = "=(F29-G29)"
        worksheet.Cells("H30").Formula = "=(F30-G30)"
        worksheet.Cells("H31").Formula = "=(F31-G31)"
        worksheet.Cells("H32").Formula = "=(F32-G32)"
        worksheet.Cells("H33").Formula = "=(F33-G33)"
        worksheet.Cells("H34").Formula = "=(F34-G34)"
        worksheet.Cells("H35").Formula = "=(F35-G35)"
        worksheet.Cells("H36").Formula = "=(F36-G36)"
        worksheet.Cells("H37").Formula = "=(F37-G37)"
        worksheet.Cells("H38").Formula = "=(F38-G38)"
        worksheet.Cells("H39").Formula = "=(F39-G39)"
        worksheet.Cells("H40").Formula = "=(F40-G40)"
        worksheet.Cells("H41").Formula = "=(F41-G41)"
        worksheet.Cells("H42").Formula = "=(F42-G42)"
        worksheet.Cells("H43").Formula = "=(F43-G43)"
        worksheet.Cells("H44").Formula = "=(F44-G44)"
        worksheet.Cells("H45").Formula = "=(F45-G45)"
        worksheet.Cells("H46").Formula = "=(F46-G46)"
        worksheet.Cells("H47").Formula = "=(F47-G47)"
        worksheet.Cells("H48").Formula = "=(F48-G48)"
        worksheet.Cells("H49").Formula = "=(F49-G49)"
        worksheet.Cells("H50").Formula = "=(F50-G50)"
        worksheet.Cells("H51").Formula = "=(F51-G51)"
        worksheet.Cells("H52").Formula = "=(F52-G52)"
        worksheet.Cells("H53").Formula = "=(F53-G53)"
        worksheet.Cells("H54").Formula = "=(F54-G54)"
        worksheet.Cells("H55").Formula = "=(F55-G55)"
        worksheet.Cells("H56").Formula = "=(F56-G56)"
        worksheet.Cells("H57").Formula = "=(F57-G57)"
        worksheet.Cells("H58").Formula = "=(F58-G58)"
        worksheet.Cells("H59").Formula = "=(F59-G59)"
        worksheet.Cells("H60").Formula = "=(F60-G60)"
        worksheet.Cells("H61").Formula = "=(F61-G61)"
        worksheet.Cells("H62").Formula = "=(F62-G62)"
        worksheet.Cells("H63").Formula = "=(F63-G63)"
        worksheet.Cells("H64").Formula = "=(F64-G64)"
        worksheet.Cells("H65").Formula = "=(F65-G65)"
        worksheet.Cells("H66").Formula = "=(F66-G66)"
        worksheet.Cells("H67").Formula = "=(F67-G67)"
        worksheet.Cells("H68").Formula = "=(F68-G68)"
        worksheet.Cells("H69").Formula = "=(F69-G69)"
        worksheet.Cells("H70").Formula = "=(F70-G70)"
        worksheet.Cells("H71").Formula = "=(F71-G71)"
        worksheet.Cells("H72").Formula = "=(F72-G72)"
        worksheet.Cells("H73").Formula = "=(F73-G73)"
        worksheet.Cells("H74").Formula = "=(F74-G74)"
        worksheet.Cells("H75").Formula = "=(F75-G75)"
        worksheet.Cells("H76").Formula = "=(F76-G76)"
        worksheet.Cells("H77").Formula = "=(F77-G77)"
        worksheet.Cells("H78").Formula = "=(F78-G78)"
        worksheet.Cells("H79").Formula = "=(F79-G79)"
        worksheet.Cells("H80").Formula = "=(F80-G80)"
        worksheet.Cells("H81").Formula = "=(F81-G81)"
        worksheet.Cells("H82").Formula = "=(F82-G82)"
        worksheet.Cells("H83").Formula = "=(F83-G83)"
        worksheet.Cells("H84").Formula = "=(F84-G84)"
        worksheet.Cells("H85").Formula = "=(F85-G85)"
        worksheet.Cells("H86").Formula = "=(F86-G86)"
        worksheet.Cells("H87").Formula = "=(F87-G87)"
        worksheet.Cells("H88").Formula = "=(F88-G88)"
        worksheet.Cells("H89").Formula = "=(F89-G89)"
        worksheet.Cells("H90").Formula = "=(F90-G90)"
        worksheet.Cells("H91").Formula = "=(F91-G91)"
        worksheet.Cells("H92").Formula = "=(F92-G92)"
        worksheet.Cells("H93").Formula = "=(F93-G93)"
        worksheet.Cells("H94").Formula = "=(F94-G94)"
        worksheet.Cells("H95").Formula = "=(F95-G95)"
        worksheet.Cells("H96").Formula = "=(F96-G96)"
        worksheet.Cells("H97").Formula = "=(F97-G97)"
        worksheet.Cells("H98").Formula = "=(F98-G98)"
        worksheet.Cells("H99").Formula = "=(F99-G99)"
        worksheet.Cells("H100").Formula = "=(F100-G100)"
        worksheet.Cells("H101").Formula = "=(F101-G101)"
        worksheet.Cells("H102").Formula = "=(F102-G102)"
        worksheet.Cells("H103").Formula = "=(F103-G103)"
        worksheet.Cells("H104").Formula = "=(F104-G104)"
        worksheet.Cells("H105").Formula = "=(F105-G105)"
        worksheet.Cells("H106").Formula = "=(F106-G106)"
        worksheet.Cells("H107").Formula = "=(F107-G107)"
        worksheet.Cells("H108").Formula = "=(F108-G108)"
        worksheet.Cells("H109").Formula = "=(F109-G109)"
        worksheet.Cells("H110").Formula = "=(F110-G110)"

        worksheet.Cells("F111").Formula = "=SUM(F2:F111)"
        worksheet.Cells("G111").Formula = "=SUM(G2:G111)"
        worksheet.Cells("H111").Formula = "=(F111-G111)"

        Dim TotalRange = worksheet.Range("A111:H111")
        TotalRange.Fill.BackgroundColor = Color.Yellow
        TotalRange.Font.Bold = True

    End Sub

End Class
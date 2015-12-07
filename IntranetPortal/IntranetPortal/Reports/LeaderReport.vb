Imports System.Drawing
Imports System.IO
Imports DevExpress.XtraReports.UI

Public Class LeaderReport
    Inherits DevExpress.XtraReports.UI.XtraReport

#Region " Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'XtraReport overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub
    Friend WithEvents ReportHeader As DevExpress.XtraReports.UI.ReportHeaderBand
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblCreatedDate As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblPropertyAddress As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel17 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel16 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel15 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel20 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel19 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel18 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel24 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel23 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel22 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel21 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblSaleDate As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblFirstMortgage As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblTax As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblBlock As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblYearBuilt As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lbl2ndMortgage As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblNumOfFloor As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblLot As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel33 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblBuildingDem As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblLotDem As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblEstValue As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblViolationAmount As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblWaterAmount As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblTaxAmount As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents chkLisPenNo As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkLisPenYes As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkOtherLiensYes As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkOtherLiensNo As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkViolationDOB As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkViolationECB As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkWaterNo As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkWaterYes As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkTaxNo As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkTaxYes As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrLine1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel40 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel41 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblOwner As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblCoOwner As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel44 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel47 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel46 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel45 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLine2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel49 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel48 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel56 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents BBLE As DevExpress.XtraReports.Parameters.Parameter
    Friend WithEvents DetailReport As DevExpress.XtraReports.UI.DetailReportBand
    Friend WithEvents Detail1 As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents XrRichText2 As DevExpress.XtraReports.UI.XRRichText
    Friend WithEvents XrRichText1 As DevExpress.XtraReports.UI.XRRichText
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents LienTable As DevExpress.XtraReports.UI.XRTable
    Friend WithEvents XrTableRow1 As DevExpress.XtraReports.UI.XRTableRow
    Friend WithEvents TYPE As DevExpress.XtraReports.UI.XRTableCell
    Friend WithEvents EFFECTIVE As DevExpress.XtraReports.UI.XRTableCell
    Friend WithEvents EXPIRATION As DevExpress.XtraReports.UI.XRTableCell
    Friend WithEvents PLAINTIFF As DevExpress.XtraReports.UI.XRTableCell
    Friend WithEvents DEFENDANT As DevExpress.XtraReports.UI.XRTableCell
    Friend WithEvents INDEX As DevExpress.XtraReports.UI.XRTableCell

    'Required by the Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Designer
    'It can be modified using the Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(LeaderReport))
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLabel56 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel49 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel48 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine2 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLabel47 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel46 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel45 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel44 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblCoOwner = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblOwner = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel41 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel40 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine1 = New DevExpress.XtraReports.UI.XRLine()
        Me.chkViolationDOB = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkViolationECB = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkWaterNo = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkWaterYes = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkTaxNo = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkTaxYes = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkOtherLiensYes = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkOtherLiensNo = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkLisPenNo = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkLisPenYes = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.lblBuildingDem = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblLotDem = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblEstValue = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblViolationAmount = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblWaterAmount = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblTaxAmount = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel33 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lbl2ndMortgage = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblNumOfFloor = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblLot = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblFirstMortgage = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblTax = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblBlock = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblYearBuilt = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblSaleDate = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel24 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel23 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel22 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel21 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel20 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel19 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel18 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel17 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel16 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel15 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel11 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblPropertyAddress = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.ReportHeader = New DevExpress.XtraReports.UI.ReportHeaderBand()
        Me.lblCreatedDate = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.BBLE = New DevExpress.XtraReports.Parameters.Parameter()
        Me.DetailReport = New DevExpress.XtraReports.UI.DetailReportBand()
        Me.Detail1 = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrRichText2 = New DevExpress.XtraReports.UI.XRRichText()
        Me.XrRichText1 = New DevExpress.XtraReports.UI.XRRichText()
        Me.LienTable = New DevExpress.XtraReports.UI.XRTable()
        Me.XrTableRow1 = New DevExpress.XtraReports.UI.XRTableRow()
        Me.TYPE = New DevExpress.XtraReports.UI.XRTableCell()
        Me.EFFECTIVE = New DevExpress.XtraReports.UI.XRTableCell()
        Me.EXPIRATION = New DevExpress.XtraReports.UI.XRTableCell()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.PLAINTIFF = New DevExpress.XtraReports.UI.XRTableCell()
        Me.INDEX = New DevExpress.XtraReports.UI.XRTableCell()
        Me.DEFENDANT = New DevExpress.XtraReports.UI.XRTableCell()
        CType(Me.XrRichText2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.XrRichText1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.LienTable, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel3, Me.LienTable, Me.XrLabel56, Me.XrLabel49, Me.XrLabel48, Me.XrLine2, Me.XrLabel47, Me.XrLabel46, Me.XrLabel45, Me.XrLabel44, Me.lblCoOwner, Me.lblOwner, Me.XrLabel41, Me.XrLabel40, Me.XrLine1, Me.chkViolationDOB, Me.chkViolationECB, Me.chkWaterNo, Me.chkWaterYes, Me.chkTaxNo, Me.chkTaxYes, Me.chkOtherLiensYes, Me.chkOtherLiensNo, Me.chkLisPenNo, Me.chkLisPenYes, Me.lblBuildingDem, Me.lblLotDem, Me.lblEstValue, Me.lblViolationAmount, Me.lblWaterAmount, Me.lblTaxAmount, Me.XrLabel33, Me.lbl2ndMortgage, Me.lblNumOfFloor, Me.lblLot, Me.lblFirstMortgage, Me.lblTax, Me.lblBlock, Me.lblYearBuilt, Me.lblSaleDate, Me.XrLabel24, Me.XrLabel23, Me.XrLabel22, Me.XrLabel21, Me.XrLabel14, Me.XrLabel20, Me.XrLabel19, Me.XrLabel18, Me.XrLabel17, Me.XrLabel16, Me.XrLabel15, Me.XrLabel13, Me.XrLabel12, Me.XrLabel11, Me.XrLabel10, Me.XrLabel9, Me.XrLabel8, Me.XrLabel7, Me.XrLabel6, Me.lblPropertyAddress, Me.XrLabel4})
        Me.Detail.HeightF = 884.375!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel56
        '
        Me.XrLabel56.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel56.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 450.0!)
        Me.XrLabel56.Name = "XrLabel56"
        Me.XrLabel56.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel56.SizeF = New System.Drawing.SizeF(349.0416!, 23.0!)
        Me.XrLabel56.StylePriority.UseBorders = False
        Me.XrLabel56.StylePriority.UseTextAlignment = False
        Me.XrLabel56.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel49
        '
        Me.XrLabel49.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel49.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 487.5!)
        Me.XrLabel49.Name = "XrLabel49"
        Me.XrLabel49.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel49.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel49.StylePriority.UseBorders = False
        Me.XrLabel49.StylePriority.UseTextAlignment = False
        Me.XrLabel49.Text = "LP Index: [LPindex]"
        Me.XrLabel49.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel48
        '
        Me.XrLabel48.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel48.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 450.0!)
        Me.XrLabel48.Name = "XrLabel48"
        Me.XrLabel48.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel48.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel48.StylePriority.UseBorders = False
        Me.XrLabel48.StylePriority.UseTextAlignment = False
        Me.XrLabel48.Text = "Deed: [Deed]"
        Me.XrLabel48.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLine2
        '
        Me.XrLine2.BorderWidth = 2.0!
        Me.XrLine2.LineWidth = 2
        Me.XrLine2.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 425.0!)
        Me.XrLine2.Name = "XrLine2"
        Me.XrLine2.SizeF = New System.Drawing.SizeF(687.5!, 23.0!)
        Me.XrLine2.StylePriority.UseBorderWidth = False
        '
        'XrLabel47
        '
        Me.XrLabel47.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel47.LocationFloat = New DevExpress.Utils.PointFloat(463.4584!, 387.5!)
        Me.XrLabel47.Name = "XrLabel47"
        Me.XrLabel47.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel47.SizeF = New System.Drawing.SizeF(236.5416!, 23.0!)
        Me.XrLabel47.StylePriority.UseBorders = False
        Me.XrLabel47.StylePriority.UseTextAlignment = False
        Me.XrLabel47.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel46
        '
        Me.XrLabel46.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel46.LocationFloat = New DevExpress.Utils.PointFloat(125.0!, 387.5!)
        Me.XrLabel46.Name = "XrLabel46"
        Me.XrLabel46.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel46.SizeF = New System.Drawing.SizeF(210.4167!, 23.0!)
        Me.XrLabel46.StylePriority.UseBorders = False
        Me.XrLabel46.StylePriority.UseTextAlignment = False
        Me.XrLabel46.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel45
        '
        Me.XrLabel45.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.XrLabel45.LocationFloat = New DevExpress.Utils.PointFloat(350.9584!, 387.5!)
        Me.XrLabel45.Name = "XrLabel45"
        Me.XrLabel45.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel45.SizeF = New System.Drawing.SizeF(112.5!, 23.0!)
        Me.XrLabel45.StylePriority.UseFont = False
        Me.XrLabel45.StylePriority.UseTextAlignment = False
        Me.XrLabel45.Text = "Phone Number:"
        Me.XrLabel45.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel44
        '
        Me.XrLabel44.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.XrLabel44.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 387.5!)
        Me.XrLabel44.Name = "XrLabel44"
        Me.XrLabel44.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel44.SizeF = New System.Drawing.SizeF(112.5!, 23.0!)
        Me.XrLabel44.StylePriority.UseFont = False
        Me.XrLabel44.StylePriority.UseTextAlignment = False
        Me.XrLabel44.Text = "Phone Number:"
        Me.XrLabel44.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblCoOwner
        '
        Me.lblCoOwner.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblCoOwner.LocationFloat = New DevExpress.Utils.PointFloat(451.0833!, 350.0!)
        Me.lblCoOwner.Name = "lblCoOwner"
        Me.lblCoOwner.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblCoOwner.SizeF = New System.Drawing.SizeF(248.9166!, 23.0!)
        Me.lblCoOwner.StylePriority.UseBorders = False
        Me.lblCoOwner.StylePriority.UseTextAlignment = False
        Me.lblCoOwner.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblOwner
        '
        Me.lblOwner.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblOwner.LocationFloat = New DevExpress.Utils.PointFloat(112.5!, 350.0!)
        Me.lblOwner.Name = "lblOwner"
        Me.lblOwner.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblOwner.SizeF = New System.Drawing.SizeF(222.9167!, 23.0!)
        Me.lblOwner.StylePriority.UseBorders = False
        Me.lblOwner.StylePriority.UseTextAlignment = False
        Me.lblOwner.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel41
        '
        Me.XrLabel41.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel41.LocationFloat = New DevExpress.Utils.PointFloat(350.9584!, 350.0!)
        Me.XrLabel41.Name = "XrLabel41"
        Me.XrLabel41.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel41.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel41.StylePriority.UseFont = False
        Me.XrLabel41.StylePriority.UseTextAlignment = False
        Me.XrLabel41.Text = "Co-Owner:"
        Me.XrLabel41.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel40
        '
        Me.XrLabel40.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel40.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 350.0!)
        Me.XrLabel40.Name = "XrLabel40"
        Me.XrLabel40.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel40.SizeF = New System.Drawing.SizeF(100.0!, 23.0!)
        Me.XrLabel40.StylePriority.UseFont = False
        Me.XrLabel40.StylePriority.UseTextAlignment = False
        Me.XrLabel40.Text = "Owner:"
        Me.XrLabel40.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLine1
        '
        Me.XrLine1.BorderWidth = 2.0!
        Me.XrLine1.LineWidth = 2
        Me.XrLine1.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 312.5!)
        Me.XrLine1.Name = "XrLine1"
        Me.XrLine1.SizeF = New System.Drawing.SizeF(687.5!, 23.0!)
        Me.XrLine1.StylePriority.UseBorderWidth = False
        '
        'chkViolationDOB
        '
        Me.chkViolationDOB.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.DOBViolation")})
        Me.chkViolationDOB.LocationFloat = New DevExpress.Utils.PointFloat(162.7499!, 275.0!)
        Me.chkViolationDOB.Name = "chkViolationDOB"
        Me.chkViolationDOB.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkViolationDOB.StylePriority.UseTextAlignment = False
        Me.chkViolationDOB.Text = "DOB"
        Me.chkViolationDOB.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkViolationECB
        '
        Me.chkViolationECB.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsECBViolations")})
        Me.chkViolationECB.LocationFloat = New DevExpress.Utils.PointFloat(112.6249!, 275.0!)
        Me.chkViolationECB.Name = "chkViolationECB"
        Me.chkViolationECB.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkViolationECB.StylePriority.UseTextAlignment = False
        Me.chkViolationECB.Text = "ECB"
        Me.chkViolationECB.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkWaterNo
        '
        Me.chkWaterNo.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsWaterOwed")})
        Me.chkWaterNo.LocationFloat = New DevExpress.Utils.PointFloat(162.75!, 237.5!)
        Me.chkWaterNo.Name = "chkWaterNo"
        Me.chkWaterNo.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkWaterNo.StylePriority.UseTextAlignment = False
        Me.chkWaterNo.Text = "No"
        Me.chkWaterNo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkWaterYes
        '
        Me.chkWaterYes.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsWaterOwed")})
        Me.chkWaterYes.LocationFloat = New DevExpress.Utils.PointFloat(112.625!, 237.5!)
        Me.chkWaterYes.Name = "chkWaterYes"
        Me.chkWaterYes.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkWaterYes.StylePriority.UseTextAlignment = False
        Me.chkWaterYes.Text = "Yes"
        Me.chkWaterYes.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkTaxNo
        '
        Me.chkTaxNo.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsTaxesOwed")})
        Me.chkTaxNo.LocationFloat = New DevExpress.Utils.PointFloat(162.7499!, 200.0!)
        Me.chkTaxNo.Name = "chkTaxNo"
        Me.chkTaxNo.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkTaxNo.StylePriority.UseTextAlignment = False
        Me.chkTaxNo.Text = "No"
        Me.chkTaxNo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkTaxYes
        '
        Me.chkTaxYes.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsTaxesOwed")})
        Me.chkTaxYes.LocationFloat = New DevExpress.Utils.PointFloat(112.6249!, 200.0!)
        Me.chkTaxYes.Name = "chkTaxYes"
        Me.chkTaxYes.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkTaxYes.StylePriority.UseTextAlignment = False
        Me.chkTaxYes.Text = "Yes"
        Me.chkTaxYes.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkOtherLiensYes
        '
        Me.chkOtherLiensYes.LocationFloat = New DevExpress.Utils.PointFloat(112.625!, 162.5!)
        Me.chkOtherLiensYes.Name = "chkOtherLiensYes"
        Me.chkOtherLiensYes.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkOtherLiensYes.StylePriority.UseTextAlignment = False
        Me.chkOtherLiensYes.Text = "Yes"
        Me.chkOtherLiensYes.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkOtherLiensNo
        '
        Me.chkOtherLiensNo.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsOtherLiens")})
        Me.chkOtherLiensNo.LocationFloat = New DevExpress.Utils.PointFloat(162.75!, 162.5!)
        Me.chkOtherLiensNo.Name = "chkOtherLiensNo"
        Me.chkOtherLiensNo.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkOtherLiensNo.StylePriority.UseTextAlignment = False
        Me.chkOtherLiensNo.Text = "No"
        Me.chkOtherLiensNo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkLisPenNo
        '
        Me.chkLisPenNo.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsLisPendenNo")})
        Me.chkLisPenNo.LocationFloat = New DevExpress.Utils.PointFloat(162.75!, 125.0!)
        Me.chkLisPenNo.Name = "chkLisPenNo"
        Me.chkLisPenNo.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkLisPenNo.StylePriority.UseTextAlignment = False
        Me.chkLisPenNo.Text = "No"
        Me.chkLisPenNo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'chkLisPenYes
        '
        Me.chkLisPenYes.LocationFloat = New DevExpress.Utils.PointFloat(112.625!, 125.0!)
        Me.chkLisPenYes.Name = "chkLisPenYes"
        Me.chkLisPenYes.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.chkLisPenYes.StylePriority.UseTextAlignment = False
        Me.chkLisPenYes.Text = "Yes"
        Me.chkLisPenYes.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblBuildingDem
        '
        Me.lblBuildingDem.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblBuildingDem.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 200.0!)
        Me.lblBuildingDem.Name = "lblBuildingDem"
        Me.lblBuildingDem.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblBuildingDem.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblBuildingDem.StylePriority.UseBorders = False
        Me.lblBuildingDem.StylePriority.UseTextAlignment = False
        Me.lblBuildingDem.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblLotDem
        '
        Me.lblLotDem.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblLotDem.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 237.5!)
        Me.lblLotDem.Name = "lblLotDem"
        Me.lblLotDem.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblLotDem.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblLotDem.StylePriority.UseBorders = False
        Me.lblLotDem.StylePriority.UseTextAlignment = False
        Me.lblLotDem.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblEstValue
        '
        Me.lblEstValue.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblEstValue.LocationFloat = New DevExpress.Utils.PointFloat(600.0!, 275.0!)
        Me.lblEstValue.Name = "lblEstValue"
        Me.lblEstValue.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblEstValue.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblEstValue.StylePriority.UseBorders = False
        Me.lblEstValue.StylePriority.UseTextAlignment = False
        Me.lblEstValue.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblViolationAmount
        '
        Me.lblViolationAmount.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblViolationAmount.LocationFloat = New DevExpress.Utils.PointFloat(350.9583!, 275.0!)
        Me.lblViolationAmount.Name = "lblViolationAmount"
        Me.lblViolationAmount.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblViolationAmount.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblViolationAmount.StylePriority.UseBorders = False
        Me.lblViolationAmount.StylePriority.UseTextAlignment = False
        Me.lblViolationAmount.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblWaterAmount
        '
        Me.lblWaterAmount.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblWaterAmount.LocationFloat = New DevExpress.Utils.PointFloat(350.9583!, 237.5!)
        Me.lblWaterAmount.Name = "lblWaterAmount"
        Me.lblWaterAmount.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblWaterAmount.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblWaterAmount.StylePriority.UseBorders = False
        Me.lblWaterAmount.StylePriority.UseTextAlignment = False
        Me.lblWaterAmount.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblTaxAmount
        '
        Me.lblTaxAmount.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblTaxAmount.LocationFloat = New DevExpress.Utils.PointFloat(350.9584!, 200.0!)
        Me.lblTaxAmount.Name = "lblTaxAmount"
        Me.lblTaxAmount.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblTaxAmount.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblTaxAmount.StylePriority.UseBorders = False
        Me.lblTaxAmount.StylePriority.UseTextAlignment = False
        Me.lblTaxAmount.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel33
        '
        Me.XrLabel33.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel33.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 162.5!)
        Me.XrLabel33.Name = "XrLabel33"
        Me.XrLabel33.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel33.SizeF = New System.Drawing.SizeF(462.5!, 23.0!)
        Me.XrLabel33.StylePriority.UseBorders = False
        Me.XrLabel33.StylePriority.UseTextAlignment = False
        Me.XrLabel33.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lbl2ndMortgage
        '
        Me.lbl2ndMortgage.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lbl2ndMortgage.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.C2ndMotgrAmt", "{0:$0.00}")})
        Me.lbl2ndMortgage.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 125.0!)
        Me.lbl2ndMortgage.Name = "lbl2ndMortgage"
        Me.lbl2ndMortgage.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lbl2ndMortgage.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lbl2ndMortgage.StylePriority.UseBorders = False
        Me.lbl2ndMortgage.StylePriority.UseTextAlignment = False
        Me.lbl2ndMortgage.Text = "$"
        Me.lbl2ndMortgage.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblNumOfFloor
        '
        Me.lblNumOfFloor.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblNumOfFloor.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 87.5!)
        Me.lblNumOfFloor.Name = "lblNumOfFloor"
        Me.lblNumOfFloor.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblNumOfFloor.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblNumOfFloor.StylePriority.UseBorders = False
        Me.lblNumOfFloor.StylePriority.UseTextAlignment = False
        Me.lblNumOfFloor.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblLot
        '
        Me.lblLot.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblLot.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 50.0!)
        Me.lblLot.Name = "lblLot"
        Me.lblLot.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblLot.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblLot.StylePriority.UseBorders = False
        Me.lblLot.StylePriority.UseTextAlignment = False
        Me.lblLot.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblFirstMortgage
        '
        Me.lblFirstMortgage.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblFirstMortgage.LocationFloat = New DevExpress.Utils.PointFloat(350.9584!, 125.0!)
        Me.lblFirstMortgage.Name = "lblFirstMortgage"
        Me.lblFirstMortgage.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblFirstMortgage.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblFirstMortgage.StylePriority.UseBorders = False
        Me.lblFirstMortgage.StylePriority.UseTextAlignment = False
        Me.lblFirstMortgage.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblTax
        '
        Me.lblTax.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblTax.LocationFloat = New DevExpress.Utils.PointFloat(350.9583!, 87.5!)
        Me.lblTax.Name = "lblTax"
        Me.lblTax.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblTax.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblTax.StylePriority.UseBorders = False
        Me.lblTax.StylePriority.UseTextAlignment = False
        Me.lblTax.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblBlock
        '
        Me.lblBlock.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblBlock.LocationFloat = New DevExpress.Utils.PointFloat(350.9583!, 50.0!)
        Me.lblBlock.Name = "lblBlock"
        Me.lblBlock.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblBlock.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblBlock.StylePriority.UseBorders = False
        Me.lblBlock.StylePriority.UseTextAlignment = False
        Me.lblBlock.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblYearBuilt
        '
        Me.lblYearBuilt.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblYearBuilt.LocationFloat = New DevExpress.Utils.PointFloat(112.6249!, 87.5!)
        Me.lblYearBuilt.Name = "lblYearBuilt"
        Me.lblYearBuilt.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblYearBuilt.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblYearBuilt.StylePriority.UseBorders = False
        Me.lblYearBuilt.StylePriority.UseTextAlignment = False
        Me.lblYearBuilt.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblSaleDate
        '
        Me.lblSaleDate.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblSaleDate.LocationFloat = New DevExpress.Utils.PointFloat(112.6249!, 50.0!)
        Me.lblSaleDate.Name = "lblSaleDate"
        Me.lblSaleDate.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblSaleDate.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.lblSaleDate.StylePriority.UseBorders = False
        Me.lblSaleDate.StylePriority.UseTextAlignment = False
        Me.lblSaleDate.Text = "07/31/2014"
        Me.lblSaleDate.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel24
        '
        Me.XrLabel24.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel24.LocationFloat = New DevExpress.Utils.PointFloat(485.4167!, 275.0!)
        Me.XrLabel24.Name = "XrLabel24"
        Me.XrLabel24.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel24.SizeF = New System.Drawing.SizeF(114.5833!, 23.0!)
        Me.XrLabel24.StylePriority.UseFont = False
        Me.XrLabel24.StylePriority.UseTextAlignment = False
        Me.XrLabel24.Text = "Est Value:"
        Me.XrLabel24.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel23
        '
        Me.XrLabel23.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel23.LocationFloat = New DevExpress.Utils.PointFloat(485.4167!, 237.5!)
        Me.XrLabel23.Name = "XrLabel23"
        Me.XrLabel23.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel23.SizeF = New System.Drawing.SizeF(114.5833!, 23.0!)
        Me.XrLabel23.StylePriority.UseFont = False
        Me.XrLabel23.StylePriority.UseTextAlignment = False
        Me.XrLabel23.Text = "Lot Dem:"
        Me.XrLabel23.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel22
        '
        Me.XrLabel22.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel22.LocationFloat = New DevExpress.Utils.PointFloat(485.4167!, 200.0!)
        Me.XrLabel22.Name = "XrLabel22"
        Me.XrLabel22.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel22.SizeF = New System.Drawing.SizeF(114.5833!, 23.0!)
        Me.XrLabel22.StylePriority.UseFont = False
        Me.XrLabel22.StylePriority.UseTextAlignment = False
        Me.XrLabel22.Text = "Building Dem:"
        Me.XrLabel22.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel21
        '
        Me.XrLabel21.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel21.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 237.5!)
        Me.XrLabel21.Name = "XrLabel21"
        Me.XrLabel21.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel21.SizeF = New System.Drawing.SizeF(113.4583!, 23.0!)
        Me.XrLabel21.StylePriority.UseFont = False
        Me.XrLabel21.StylePriority.UseTextAlignment = False
        Me.XrLabel21.Text = "Amount:"
        Me.XrLabel21.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel14
        '
        Me.XrLabel14.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel14.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 275.0!)
        Me.XrLabel14.Name = "XrLabel14"
        Me.XrLabel14.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel14.SizeF = New System.Drawing.SizeF(113.4583!, 23.0!)
        Me.XrLabel14.StylePriority.UseFont = False
        Me.XrLabel14.StylePriority.UseTextAlignment = False
        Me.XrLabel14.Text = "Amount:"
        Me.XrLabel14.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel20
        '
        Me.XrLabel20.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel20.LocationFloat = New DevExpress.Utils.PointFloat(485.4167!, 87.5!)
        Me.XrLabel20.Name = "XrLabel20"
        Me.XrLabel20.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel20.SizeF = New System.Drawing.SizeF(114.5833!, 23.0!)
        Me.XrLabel20.StylePriority.UseFont = False
        Me.XrLabel20.StylePriority.UseTextAlignment = False
        Me.XrLabel20.Text = "# of Floors:"
        Me.XrLabel20.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel19
        '
        Me.XrLabel19.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel19.LocationFloat = New DevExpress.Utils.PointFloat(485.4167!, 125.0!)
        Me.XrLabel19.Name = "XrLabel19"
        Me.XrLabel19.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel19.SizeF = New System.Drawing.SizeF(114.5833!, 23.0!)
        Me.XrLabel19.StylePriority.UseFont = False
        Me.XrLabel19.StylePriority.UseTextAlignment = False
        Me.XrLabel19.Text = "2nd Mortgage:"
        Me.XrLabel19.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel18
        '
        Me.XrLabel18.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel18.LocationFloat = New DevExpress.Utils.PointFloat(485.4167!, 50.0!)
        Me.XrLabel18.Name = "XrLabel18"
        Me.XrLabel18.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel18.SizeF = New System.Drawing.SizeF(114.5833!, 23.0!)
        Me.XrLabel18.StylePriority.UseFont = False
        Me.XrLabel18.StylePriority.UseTextAlignment = False
        Me.XrLabel18.Text = "Lot:"
        Me.XrLabel18.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel17
        '
        Me.XrLabel17.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel17.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 50.0!)
        Me.XrLabel17.Name = "XrLabel17"
        Me.XrLabel17.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel17.SizeF = New System.Drawing.SizeF(113.4583!, 23.0!)
        Me.XrLabel17.StylePriority.UseFont = False
        Me.XrLabel17.StylePriority.UseTextAlignment = False
        Me.XrLabel17.Text = "Block:"
        Me.XrLabel17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel16
        '
        Me.XrLabel16.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel16.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 87.5!)
        Me.XrLabel16.Name = "XrLabel16"
        Me.XrLabel16.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel16.SizeF = New System.Drawing.SizeF(113.4583!, 23.0!)
        Me.XrLabel16.StylePriority.UseFont = False
        Me.XrLabel16.StylePriority.UseTextAlignment = False
        Me.XrLabel16.Text = "Tax Class:"
        Me.XrLabel16.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel15
        '
        Me.XrLabel15.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel15.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 125.0!)
        Me.XrLabel15.Name = "XrLabel15"
        Me.XrLabel15.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel15.SizeF = New System.Drawing.SizeF(113.4584!, 23.0!)
        Me.XrLabel15.StylePriority.UseFont = False
        Me.XrLabel15.StylePriority.UseTextAlignment = False
        Me.XrLabel15.Text = "1st Mortgage:"
        Me.XrLabel15.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel13
        '
        Me.XrLabel13.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel13.LocationFloat = New DevExpress.Utils.PointFloat(237.5!, 200.0!)
        Me.XrLabel13.Name = "XrLabel13"
        Me.XrLabel13.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel13.SizeF = New System.Drawing.SizeF(113.4583!, 23.0!)
        Me.XrLabel13.StylePriority.UseFont = False
        Me.XrLabel13.StylePriority.UseTextAlignment = False
        Me.XrLabel13.Text = "Amount:"
        Me.XrLabel13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel12
        '
        Me.XrLabel12.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel12.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 237.5!)
        Me.XrLabel12.Name = "XrLabel12"
        Me.XrLabel12.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel12.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel12.StylePriority.UseFont = False
        Me.XrLabel12.StylePriority.UseTextAlignment = False
        Me.XrLabel12.Text = "Water Owed:"
        Me.XrLabel12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel11
        '
        Me.XrLabel11.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel11.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 275.0!)
        Me.XrLabel11.Name = "XrLabel11"
        Me.XrLabel11.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel11.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel11.StylePriority.UseFont = False
        Me.XrLabel11.StylePriority.UseTextAlignment = False
        Me.XrLabel11.Text = "Violations:"
        Me.XrLabel11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel10
        '
        Me.XrLabel10.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel10.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 50.0!)
        Me.XrLabel10.Name = "XrLabel10"
        Me.XrLabel10.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel10.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel10.StylePriority.UseFont = False
        Me.XrLabel10.StylePriority.UseTextAlignment = False
        Me.XrLabel10.Text = "Sale Date:"
        Me.XrLabel10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel9
        '
        Me.XrLabel9.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel9.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 87.5!)
        Me.XrLabel9.Name = "XrLabel9"
        Me.XrLabel9.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel9.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel9.StylePriority.UseFont = False
        Me.XrLabel9.StylePriority.UseTextAlignment = False
        Me.XrLabel9.Text = "Year Built:"
        Me.XrLabel9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel8
        '
        Me.XrLabel8.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel8.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 200.0!)
        Me.XrLabel8.Name = "XrLabel8"
        Me.XrLabel8.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel8.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel8.StylePriority.UseFont = False
        Me.XrLabel8.StylePriority.UseTextAlignment = False
        Me.XrLabel8.Text = "Taxes Owed:"
        Me.XrLabel8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel7
        '
        Me.XrLabel7.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel7.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 125.0!)
        Me.XrLabel7.Name = "XrLabel7"
        Me.XrLabel7.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel7.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel7.StylePriority.UseFont = False
        Me.XrLabel7.StylePriority.UseTextAlignment = False
        Me.XrLabel7.Text = "Lis Pendens:"
        Me.XrLabel7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel6
        '
        Me.XrLabel6.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel6.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 162.5!)
        Me.XrLabel6.Name = "XrLabel6"
        Me.XrLabel6.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel6.SizeF = New System.Drawing.SizeF(100.1249!, 23.0!)
        Me.XrLabel6.StylePriority.UseFont = False
        Me.XrLabel6.StylePriority.UseTextAlignment = False
        Me.XrLabel6.Text = "Other Liens:"
        Me.XrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'lblPropertyAddress
        '
        Me.lblPropertyAddress.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblPropertyAddress.LocationFloat = New DevExpress.Utils.PointFloat(162.4999!, 12.5!)
        Me.lblPropertyAddress.Name = "lblPropertyAddress"
        Me.lblPropertyAddress.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblPropertyAddress.SizeF = New System.Drawing.SizeF(537.5001!, 23.0!)
        Me.lblPropertyAddress.StylePriority.UseBorders = False
        Me.lblPropertyAddress.StylePriority.UseTextAlignment = False
        Me.lblPropertyAddress.Text = "144-12 GRAVETT ROAD, QUEENS, NY 11367"
        Me.lblPropertyAddress.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel4
        '
        Me.XrLabel4.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 12.5!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(149.9999!, 23.0!)
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.StylePriority.UseTextAlignment = False
        Me.XrLabel4.Text = "Property Address:"
        Me.XrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'TopMargin
        '
        Me.TopMargin.HeightF = 75.04167!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'BottomMargin
        '
        Me.BottomMargin.HeightF = 87.5!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.lblCreatedDate, Me.XrLabel2, Me.XrLabel1})
        Me.ReportHeader.HeightF = 70.83334!
        Me.ReportHeader.Name = "ReportHeader"
        Me.ReportHeader.StylePriority.UseTextAlignment = False
        Me.ReportHeader.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblCreatedDate
        '
        Me.lblCreatedDate.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.lblCreatedDate.LocationFloat = New DevExpress.Utils.PointFloat(600.0!, 37.5!)
        Me.lblCreatedDate.Name = "lblCreatedDate"
        Me.lblCreatedDate.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblCreatedDate.SizeF = New System.Drawing.SizeF(100.0!, 23.0!)
        Me.lblCreatedDate.StylePriority.UseBorders = False
        Me.lblCreatedDate.Text = "lblCreatedDate"
        '
        'XrLabel2
        '
        Me.XrLabel2.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(450.0!, 37.5!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(149.9999!, 23.0!)
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.Text = "Lead Created Date:"
        '
        'XrLabel1
        '
        Me.XrLabel1.Font = New System.Drawing.Font("Arial", 15.0!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Underline), System.Drawing.FontStyle))
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(280.2083!, 10.00001!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(136.4584!, 31.33334!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        Me.XrLabel1.Text = "Lead Sheet"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'BBLE
        '
        Me.BBLE.Description = "Parameter1"
        Me.BBLE.Name = "BBLE"
        '
        'DetailReport
        '
        Me.DetailReport.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail1})
        Me.DetailReport.Level = 0
        Me.DetailReport.Name = "DetailReport"
        '
        'Detail1
        '
        Me.Detail1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrRichText2, Me.XrRichText1})
        Me.Detail1.HeightF = 100.0!
        Me.Detail1.Name = "Detail1"
        '
        'XrRichText2
        '
        Me.XrRichText2.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.XrRichText2.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 0!)
        Me.XrRichText2.Name = "XrRichText2"
        Me.XrRichText2.SerializableRtfString = resources.GetString("XrRichText2.SerializableRtfString")
        Me.XrRichText2.SizeF = New System.Drawing.SizeF(349.0414!, 100.0!)
        '
        'XrRichText1
        '
        Me.XrRichText1.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.XrRichText1.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 0!)
        Me.XrRichText1.Name = "XrRichText1"
        Me.XrRichText1.SerializableRtfString = resources.GetString("XrRichText1.SerializableRtfString")
        Me.XrRichText1.SizeF = New System.Drawing.SizeF(322.9167!, 100.0!)
        '
        'LienTable
        '
        Me.LienTable.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 569.7917!)
        Me.LienTable.LockedInUserDesigner = True
        Me.LienTable.Name = "LienTable"
        Me.LienTable.Rows.AddRange(New DevExpress.XtraReports.UI.XRTableRow() {Me.XrTableRow1})
        Me.LienTable.SizeF = New System.Drawing.SizeF(685.0!, 30.0!)
        '
        'XrTableRow1
        '
        Me.XrTableRow1.Cells.AddRange(New DevExpress.XtraReports.UI.XRTableCell() {Me.TYPE, Me.EFFECTIVE, Me.EXPIRATION, Me.PLAINTIFF, Me.DEFENDANT, Me.INDEX})
        Me.XrTableRow1.LockedInUserDesigner = True
        Me.XrTableRow1.Name = "XrTableRow1"
        Me.XrTableRow1.Weight = 1.0R
        '
        'TYPE
        '
        Me.TYPE.LockedInUserDesigner = True
        Me.TYPE.Name = "TYPE"
        Me.TYPE.Text = "TYPE"
        Me.TYPE.Weight = 0.3622467777836556R
        '
        'EFFECTIVE
        '
        Me.EFFECTIVE.LockedInUserDesigner = True
        Me.EFFECTIVE.Name = "EFFECTIVE"
        Me.EFFECTIVE.Text = "EFFECTIVE"
        Me.EFFECTIVE.Weight = 0.42617269900370963R
        '
        'EXPIRATION
        '
        Me.EXPIRATION.LockedInUserDesigner = True
        Me.EXPIRATION.Name = "EXPIRATION"
        Me.EXPIRATION.Text = "EXPIRATION"
        Me.EXPIRATION.Weight = 0.4261726979885348R
        '
        'XrLabel3
        '
        Me.XrLabel3.Font = New System.Drawing.Font("Arial", 11.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 534.3333!)
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 96.0!)
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(100.0!, 23.0!)
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.Text = "LIENS"
        '
        'PLAINTIFF
        '
        Me.PLAINTIFF.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.PLAINTIFF.LockedInUserDesigner = True
        Me.PLAINTIFF.Name = "PLAINTIFF"
        Me.PLAINTIFF.StylePriority.UseFont = False
        Me.PLAINTIFF.Text = "PLAINTIFF"
        Me.PLAINTIFF.Weight = 0.63925901587033507R
        '
        'INDEX
        '
        Me.INDEX.LockedInUserDesigner = True
        Me.INDEX.Name = "INDEX"
        Me.INDEX.Text = "INDEX"
        Me.INDEX.Weight = 0.4261727666832007R
        '
        'DEFENDANT
        '
        Me.DEFENDANT.LockedInUserDesigner = True
        Me.DEFENDANT.Name = "DEFENDANT"
        Me.DEFENDANT.Text = "DEFENDANT"
        Me.DEFENDANT.Weight = 0.63925901636072113R
        '
        'LeaderReport
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.ReportHeader, Me.DetailReport})
        Me.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.Margins = New System.Drawing.Printing.Margins(63, 68, 75, 88)
        Me.Parameters.AddRange(New DevExpress.XtraReports.Parameters.Parameter() {Me.BBLE})
        Me.Version = "15.1"
        CType(Me.XrRichText2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.XrRichText1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.LienTable, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand

#End Region

    Public Sub BindData(bble As String)
        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

            If li IsNot Nothing Then
                If li.CreateDate.HasValue Then
                    lblCreatedDate.Text = li.CreateDate.Value.ToShortDateString
                End If

                lblPropertyAddress.Text = li.PropertyAddress

                If li.SaleDate.HasValue Then
                    lblSaleDate.Text = li.SaleDate.Value.ToShortDateString
                End If

                lblBlock.Text = li.Block
                lblLot.Text = li.Lot
                lblYearBuilt.Text = li.YearBuilt
                lblNumOfFloor.Text = li.NumFloors
                lblBuildingDem.Text = li.BuildingDem
                lblLotDem.Text = li.LotDem
                lblTax.Text = li.TaxClass

                lblOwner.Text = li.Owner
                lblCoOwner.Text = li.CoOwner

                If li.IsLisPendens.HasValue Then
                    If li.IsLisPendens.Value Then
                        chkLisPenYes.Checked = True
                    Else
                        chkLisPenNo.Checked = True
                    End If
                End If

                If li.IsOtherLiens.HasValue Then
                    If li.IsOtherLiens.Value Then
                        chkOtherLiensYes.Checked = True
                    Else
                        chkOtherLiensYes.Checked = True
                    End If
                End If

                If li.IsTaxesOwed.HasValue Then
                    If li.IsTaxesOwed.Value Then
                        chkTaxYes.Checked = True
                    Else
                        chkTaxNo.Checked = True
                    End If
                End If

                If li.IsWaterOwed.HasValue Then
                    If li.IsWaterOwed.Value Then
                        chkWaterYes.Checked = True
                    Else
                        chkWaterNo.Checked = True
                    End If
                End If

                If li.IsECBViolations.HasValue Then
                    If li.IsECBViolations.Value Then
                        chkViolationECB.Checked = True
                    End If
                End If

                If li.IsDOBViolations.HasValue Then
                    If li.IsDOBViolations.Value Then
                        chkViolationDOB.Checked = True
                    End If
                End If

                If li.C1stMotgrAmt.HasValue AndAlso li.C1stMotgrAmt.Value > 0 Then
                    lblFirstMortgage.Text = li.C1stMotgrAmt.Value.ToString("C")
                End If

                If li.C2ndMotgrAmt.HasValue AndAlso li.C2ndMotgrAmt.Value > 0 Then
                    lbl2ndMortgage.Text = li.C2ndMotgrAmt.Value.ToString("C")
                End If

                If li.TaxesAmt.HasValue AndAlso li.TaxesAmt.Value > 0 Then
                    lblTaxAmount.Text = li.TaxesAmt.Value.ToString("C")
                End If

                If li.EstValue.HasValue AndAlso li.EstValue.Value > 0 Then
                    lblEstValue.Text = li.EstValue.Value.ToString("C")
                End If

                If li.WaterAmt.HasValue AndAlso li.WaterAmt.Value > 0 Then
                    lblWaterAmount.Text = li.WaterAmt.Value.ToString("C")
                End If

                If li.ViolationAmount > 0 Then
                    lblViolationAmount.Text = li.ViolationAmount.ToString("C")
                End If

                LienTable.StylePriority.UseFont = False

                Dim liens = li.LisPens

                For Each lp In liens
                    Dim newRow = New XRTableRow()
                    newRow.CanGrow = True
                    newRow.Height = 30
                    LienTable.Rows.Add(newRow)


                    Dim typeCell = New XRTableCell()
                    typeCell.Font = New Font("Tohoma", 8)
                    typeCell.Text = lp.Type.Trim
                    newRow.Cells.Add(typeCell)

                    Dim effectiveCell = New XRTableCell()
                    effectiveCell.Font = New Font("Tohoma", 8)
                    effectiveCell.Text = lp.Effective
                    newRow.Cells.Add(effectiveCell)

                    Dim expirationCell = New XRTableCell()
                    expirationCell.Font = New Font("Tohoma", 8)
                    expirationCell.Text = lp.Expiration
                    newRow.Cells.Add(expirationCell)

                    Dim plaintiffCell = New XRTableCell()
                    plaintiffCell.Font = New Font("Tohoma", 8)
                    plaintiffCell.Text = lp.Plaintiff.Trim
                    newRow.Cells.Add(plaintiffCell)

                    Dim defendantCell = New XRTableCell()
                    defendantCell.Font = New Font("Tohoma", 8)
                    defendantCell.Text = lp.Defendant.Trim
                    newRow.Cells.Add(defendantCell)

                    Dim indexCell = New XRTableCell()
                    indexCell.Font = New Font("Tohoma", 8)
                    indexCell.Text = lp.Index.Trim
                    newRow.Cells.Add(indexCell)

                    newRow.Cells(0).WidthF = 85
                    newRow.Cells(1).WidthF = 100
                    newRow.Cells(2).WidthF = 100
                    newRow.Cells(3).WidthF = 150
                    newRow.Cells(4).WidthF = 150
                    newRow.Cells(5).WidthF = 100


                Next

                LienTable.AdjustSize()

                Dim resControl As HomeOwnerInfo
                Using mainPage As New System.Web.UI.Page
                    'mainPage.EnableViewState = False
                    'mainPage.EnableEventValidation = False
                    resControl = mainPage.LoadControl(String.Format("~/UserControl/HomeOwnerInfo.ascx"))
                    resControl.BBLE = bble
                    resControl.OwnerName = li.Owner
                    resControl.BindData(bble)

                    Dim stringWriter As New StringWriter
                    Dim htmlWriter As New HtmlTextWriter(stringWriter)
                    resControl.RenderControl(htmlWriter)
                    Dim html = stringWriter.ToString
                    XrRichText1.Html = html

                    If Not String.IsNullOrEmpty(li.CoOwner) Then

                        resControl.OwnerName = li.CoOwner
                        resControl.BindData(bble)

                        stringWriter = New StringWriter
                        htmlWriter = New HtmlTextWriter(stringWriter)
                        resControl.RenderControl(htmlWriter)
                        XrRichText2.Html = stringWriter.ToString
                    Else
                        XrRichText2.Html = ""
                    End If
                End Using
            End If
        End Using


    End Sub

End Class
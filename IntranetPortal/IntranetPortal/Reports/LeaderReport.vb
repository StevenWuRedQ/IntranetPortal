Imports System.IO

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
    Friend WithEvents XrLabel32 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel31 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblLot As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel33 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel39 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel38 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel37 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel36 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel35 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel34 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents chkLisPenNo As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents chkLisPenYes As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox3 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox4 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox9 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox10 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox7 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox8 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox5 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrCheckBox6 As DevExpress.XtraReports.UI.XRCheckBox
    Friend WithEvents XrLine1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel40 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel41 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel42 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel43 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel44 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel47 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel46 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel45 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLine2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel51 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel52 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel53 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel50 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel49 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel48 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel54 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel55 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel68 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel69 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel64 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel65 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel66 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel67 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel62 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel63 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel56 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel57 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel58 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel59 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel60 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel61 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents BBLE As DevExpress.XtraReports.Parameters.Parameter
    Friend WithEvents DetailReport As DevExpress.XtraReports.UI.DetailReportBand
    Friend WithEvents Detail1 As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents XrRichText2 As DevExpress.XtraReports.UI.XRRichText
    Friend WithEvents XrRichText1 As DevExpress.XtraReports.UI.XRRichText

    'Required by the Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Designer
    'It can be modified using the Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(LeaderReport))
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLabel68 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel69 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel64 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel65 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel66 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel67 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel62 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel63 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel56 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel57 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel58 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel59 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel60 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel61 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel54 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel55 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel51 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel52 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel53 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel50 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel49 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel48 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine2 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLabel47 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel46 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel45 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel44 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel43 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel42 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel41 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel40 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine1 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrCheckBox9 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox10 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox7 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox8 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox5 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox6 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox3 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrCheckBox4 = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkLisPenNo = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.chkLisPenYes = New DevExpress.XtraReports.UI.XRCheckBox()
        Me.XrLabel39 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel38 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel37 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel36 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel35 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel34 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel33 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel32 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel31 = New DevExpress.XtraReports.UI.XRLabel()
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
        Me.XrRichText1 = New DevExpress.XtraReports.UI.XRRichText()
        Me.XrRichText2 = New DevExpress.XtraReports.UI.XRRichText()
        CType(Me.XrRichText1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.XrRichText2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel68, Me.XrLabel69, Me.XrLabel64, Me.XrLabel65, Me.XrLabel66, Me.XrLabel67, Me.XrLabel62, Me.XrLabel63, Me.XrLabel56, Me.XrLabel57, Me.XrLabel58, Me.XrLabel59, Me.XrLabel60, Me.XrLabel61, Me.XrLabel54, Me.XrLabel55, Me.XrLabel51, Me.XrLabel52, Me.XrLabel53, Me.XrLabel50, Me.XrLabel49, Me.XrLabel48, Me.XrLine2, Me.XrLabel47, Me.XrLabel46, Me.XrLabel45, Me.XrLabel44, Me.XrLabel43, Me.XrLabel42, Me.XrLabel41, Me.XrLabel40, Me.XrLine1, Me.XrCheckBox9, Me.XrCheckBox10, Me.XrCheckBox7, Me.XrCheckBox8, Me.XrCheckBox5, Me.XrCheckBox6, Me.XrCheckBox3, Me.XrCheckBox4, Me.chkLisPenNo, Me.chkLisPenYes, Me.XrLabel39, Me.XrLabel38, Me.XrLabel37, Me.XrLabel36, Me.XrLabel35, Me.XrLabel34, Me.XrLabel33, Me.XrLabel32, Me.XrLabel31, Me.lblLot, Me.lblFirstMortgage, Me.lblTax, Me.lblBlock, Me.lblYearBuilt, Me.lblSaleDate, Me.XrLabel24, Me.XrLabel23, Me.XrLabel22, Me.XrLabel21, Me.XrLabel14, Me.XrLabel20, Me.XrLabel19, Me.XrLabel18, Me.XrLabel17, Me.XrLabel16, Me.XrLabel15, Me.XrLabel13, Me.XrLabel12, Me.XrLabel11, Me.XrLabel10, Me.XrLabel9, Me.XrLabel8, Me.XrLabel7, Me.XrLabel6, Me.lblPropertyAddress, Me.XrLabel4})
        Me.Detail.HeightF = 884.375!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel68
        '
        Me.XrLabel68.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel68.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 825.0!)
        Me.XrLabel68.Name = "XrLabel68"
        Me.XrLabel68.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel68.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel68.StylePriority.UseBorders = False
        Me.XrLabel68.StylePriority.UseTextAlignment = False
        Me.XrLabel68.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel69
        '
        Me.XrLabel69.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel69.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 825.0!)
        Me.XrLabel69.Name = "XrLabel69"
        Me.XrLabel69.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel69.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel69.StylePriority.UseBorders = False
        Me.XrLabel69.StylePriority.UseTextAlignment = False
        Me.XrLabel69.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel64
        '
        Me.XrLabel64.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel64.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 750.0!)
        Me.XrLabel64.Name = "XrLabel64"
        Me.XrLabel64.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel64.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel64.StylePriority.UseBorders = False
        Me.XrLabel64.StylePriority.UseTextAlignment = False
        Me.XrLabel64.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel65
        '
        Me.XrLabel65.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel65.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 787.5!)
        Me.XrLabel65.Name = "XrLabel65"
        Me.XrLabel65.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel65.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel65.StylePriority.UseBorders = False
        Me.XrLabel65.StylePriority.UseTextAlignment = False
        Me.XrLabel65.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel66
        '
        Me.XrLabel66.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel66.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 750.0!)
        Me.XrLabel66.Name = "XrLabel66"
        Me.XrLabel66.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel66.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel66.StylePriority.UseBorders = False
        Me.XrLabel66.StylePriority.UseTextAlignment = False
        Me.XrLabel66.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel67
        '
        Me.XrLabel67.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel67.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 787.5!)
        Me.XrLabel67.Name = "XrLabel67"
        Me.XrLabel67.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel67.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel67.StylePriority.UseBorders = False
        Me.XrLabel67.StylePriority.UseTextAlignment = False
        Me.XrLabel67.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel62
        '
        Me.XrLabel62.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel62.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 712.5!)
        Me.XrLabel62.Name = "XrLabel62"
        Me.XrLabel62.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel62.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel62.StylePriority.UseBorders = False
        Me.XrLabel62.StylePriority.UseTextAlignment = False
        Me.XrLabel62.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel63
        '
        Me.XrLabel63.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel63.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 675.0!)
        Me.XrLabel63.Name = "XrLabel63"
        Me.XrLabel63.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel63.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel63.StylePriority.UseBorders = False
        Me.XrLabel63.StylePriority.UseTextAlignment = False
        Me.XrLabel63.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
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
        'XrLabel57
        '
        Me.XrLabel57.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel57.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 562.5!)
        Me.XrLabel57.Name = "XrLabel57"
        Me.XrLabel57.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel57.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel57.StylePriority.UseBorders = False
        Me.XrLabel57.StylePriority.UseTextAlignment = False
        Me.XrLabel57.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel58
        '
        Me.XrLabel58.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel58.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 525.0!)
        Me.XrLabel58.Name = "XrLabel58"
        Me.XrLabel58.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel58.SizeF = New System.Drawing.SizeF(349.0415!, 22.99994!)
        Me.XrLabel58.StylePriority.UseBorders = False
        Me.XrLabel58.StylePriority.UseTextAlignment = False
        Me.XrLabel58.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel59
        '
        Me.XrLabel59.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel59.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 487.5!)
        Me.XrLabel59.Name = "XrLabel59"
        Me.XrLabel59.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel59.SizeF = New System.Drawing.SizeF(349.0415!, 23.0!)
        Me.XrLabel59.StylePriority.UseBorders = False
        Me.XrLabel59.StylePriority.UseTextAlignment = False
        Me.XrLabel59.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel60
        '
        Me.XrLabel60.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel60.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 600.0!)
        Me.XrLabel60.Name = "XrLabel60"
        Me.XrLabel60.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel60.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel60.StylePriority.UseBorders = False
        Me.XrLabel60.StylePriority.UseTextAlignment = False
        Me.XrLabel60.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel61
        '
        Me.XrLabel61.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel61.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 637.5!)
        Me.XrLabel61.Name = "XrLabel61"
        Me.XrLabel61.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel61.SizeF = New System.Drawing.SizeF(349.0414!, 23.0!)
        Me.XrLabel61.StylePriority.UseBorders = False
        Me.XrLabel61.StylePriority.UseTextAlignment = False
        Me.XrLabel61.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel54
        '
        Me.XrLabel54.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel54.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 712.5!)
        Me.XrLabel54.Name = "XrLabel54"
        Me.XrLabel54.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel54.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel54.StylePriority.UseBorders = False
        Me.XrLabel54.StylePriority.UseTextAlignment = False
        Me.XrLabel54.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel55
        '
        Me.XrLabel55.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel55.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 675.0!)
        Me.XrLabel55.Name = "XrLabel55"
        Me.XrLabel55.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel55.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel55.StylePriority.UseBorders = False
        Me.XrLabel55.StylePriority.UseTextAlignment = False
        Me.XrLabel55.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel51
        '
        Me.XrLabel51.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel51.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 562.5!)
        Me.XrLabel51.Name = "XrLabel51"
        Me.XrLabel51.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel51.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel51.StylePriority.UseBorders = False
        Me.XrLabel51.StylePriority.UseTextAlignment = False
        Me.XrLabel51.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel52
        '
        Me.XrLabel52.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel52.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 600.0!)
        Me.XrLabel52.Name = "XrLabel52"
        Me.XrLabel52.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel52.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel52.StylePriority.UseBorders = False
        Me.XrLabel52.StylePriority.UseTextAlignment = False
        Me.XrLabel52.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel53
        '
        Me.XrLabel53.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel53.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 637.5!)
        Me.XrLabel53.Name = "XrLabel53"
        Me.XrLabel53.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel53.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel53.StylePriority.UseBorders = False
        Me.XrLabel53.StylePriority.UseTextAlignment = False
        Me.XrLabel53.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel50
        '
        Me.XrLabel50.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel50.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 525.0!)
        Me.XrLabel50.Name = "XrLabel50"
        Me.XrLabel50.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel50.SizeF = New System.Drawing.SizeF(322.9167!, 23.0!)
        Me.XrLabel50.StylePriority.UseBorders = False
        Me.XrLabel50.StylePriority.UseTextAlignment = False
        Me.XrLabel50.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
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
        'XrLabel43
        '
        Me.XrLabel43.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel43.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.CoOwner")})
        Me.XrLabel43.LocationFloat = New DevExpress.Utils.PointFloat(451.0833!, 350.0!)
        Me.XrLabel43.Name = "XrLabel43"
        Me.XrLabel43.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel43.SizeF = New System.Drawing.SizeF(248.9166!, 23.0!)
        Me.XrLabel43.StylePriority.UseBorders = False
        Me.XrLabel43.StylePriority.UseTextAlignment = False
        Me.XrLabel43.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel42
        '
        Me.XrLabel42.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel42.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.Owner")})
        Me.XrLabel42.LocationFloat = New DevExpress.Utils.PointFloat(112.5!, 350.0!)
        Me.XrLabel42.Name = "XrLabel42"
        Me.XrLabel42.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel42.SizeF = New System.Drawing.SizeF(222.9167!, 23.0!)
        Me.XrLabel42.StylePriority.UseBorders = False
        Me.XrLabel42.StylePriority.UseTextAlignment = False
        Me.XrLabel42.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
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
        'XrCheckBox9
        '
        Me.XrCheckBox9.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.DOBViolation")})
        Me.XrCheckBox9.LocationFloat = New DevExpress.Utils.PointFloat(162.7499!, 275.0!)
        Me.XrCheckBox9.Name = "XrCheckBox9"
        Me.XrCheckBox9.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox9.StylePriority.UseTextAlignment = False
        Me.XrCheckBox9.Text = "DOB"
        Me.XrCheckBox9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox10
        '
        Me.XrCheckBox10.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsECBViolations")})
        Me.XrCheckBox10.LocationFloat = New DevExpress.Utils.PointFloat(112.6249!, 275.0!)
        Me.XrCheckBox10.Name = "XrCheckBox10"
        Me.XrCheckBox10.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox10.StylePriority.UseTextAlignment = False
        Me.XrCheckBox10.Text = "ECB"
        Me.XrCheckBox10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox7
        '
        Me.XrCheckBox7.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsWaterOwed")})
        Me.XrCheckBox7.LocationFloat = New DevExpress.Utils.PointFloat(162.75!, 237.5!)
        Me.XrCheckBox7.Name = "XrCheckBox7"
        Me.XrCheckBox7.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox7.StylePriority.UseTextAlignment = False
        Me.XrCheckBox7.Text = "No"
        Me.XrCheckBox7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox8
        '
        Me.XrCheckBox8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsWaterOwed")})
        Me.XrCheckBox8.LocationFloat = New DevExpress.Utils.PointFloat(112.625!, 237.5!)
        Me.XrCheckBox8.Name = "XrCheckBox8"
        Me.XrCheckBox8.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox8.StylePriority.UseTextAlignment = False
        Me.XrCheckBox8.Text = "Yes"
        Me.XrCheckBox8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox5
        '
        Me.XrCheckBox5.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsTaxesOwed")})
        Me.XrCheckBox5.LocationFloat = New DevExpress.Utils.PointFloat(162.7499!, 200.0!)
        Me.XrCheckBox5.Name = "XrCheckBox5"
        Me.XrCheckBox5.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox5.StylePriority.UseTextAlignment = False
        Me.XrCheckBox5.Text = "No"
        Me.XrCheckBox5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox6
        '
        Me.XrCheckBox6.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsTaxesOwed")})
        Me.XrCheckBox6.LocationFloat = New DevExpress.Utils.PointFloat(112.6249!, 200.0!)
        Me.XrCheckBox6.Name = "XrCheckBox6"
        Me.XrCheckBox6.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox6.StylePriority.UseTextAlignment = False
        Me.XrCheckBox6.Text = "Yes"
        Me.XrCheckBox6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox3
        '
        Me.XrCheckBox3.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsOtherLiens")})
        Me.XrCheckBox3.LocationFloat = New DevExpress.Utils.PointFloat(112.625!, 162.5!)
        Me.XrCheckBox3.Name = "XrCheckBox3"
        Me.XrCheckBox3.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox3.StylePriority.UseTextAlignment = False
        Me.XrCheckBox3.Text = "Yes"
        Me.XrCheckBox3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCheckBox4
        '
        Me.XrCheckBox4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("CheckState", Nothing, "ALL_NYC_Tax_Liens_CO_Info.IsOtherLiens")})
        Me.XrCheckBox4.LocationFloat = New DevExpress.Utils.PointFloat(162.75!, 162.5!)
        Me.XrCheckBox4.Name = "XrCheckBox4"
        Me.XrCheckBox4.SizeF = New System.Drawing.SizeF(49.87501!, 23.0!)
        Me.XrCheckBox4.StylePriority.UseTextAlignment = False
        Me.XrCheckBox4.Text = "No"
        Me.XrCheckBox4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
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
        'XrLabel39
        '
        Me.XrLabel39.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel39.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 200.0!)
        Me.XrLabel39.Name = "XrLabel39"
        Me.XrLabel39.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel39.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel39.StylePriority.UseBorders = False
        Me.XrLabel39.StylePriority.UseTextAlignment = False
        Me.XrLabel39.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel38
        '
        Me.XrLabel38.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel38.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 237.5!)
        Me.XrLabel38.Name = "XrLabel38"
        Me.XrLabel38.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel38.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel38.StylePriority.UseBorders = False
        Me.XrLabel38.StylePriority.UseTextAlignment = False
        Me.XrLabel38.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel37
        '
        Me.XrLabel37.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel37.LocationFloat = New DevExpress.Utils.PointFloat(600.0!, 275.0!)
        Me.XrLabel37.Name = "XrLabel37"
        Me.XrLabel37.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel37.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel37.StylePriority.UseBorders = False
        Me.XrLabel37.StylePriority.UseTextAlignment = False
        Me.XrLabel37.Text = "$"
        Me.XrLabel37.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel36
        '
        Me.XrLabel36.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel36.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.DOBViolationsAmt")})
        Me.XrLabel36.LocationFloat = New DevExpress.Utils.PointFloat(350.9583!, 275.0!)
        Me.XrLabel36.Name = "XrLabel36"
        Me.XrLabel36.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel36.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel36.StylePriority.UseBorders = False
        Me.XrLabel36.StylePriority.UseTextAlignment = False
        Me.XrLabel36.Text = "$"
        Me.XrLabel36.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel35
        '
        Me.XrLabel35.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel35.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.WaterAmt")})
        Me.XrLabel35.LocationFloat = New DevExpress.Utils.PointFloat(350.9583!, 237.5!)
        Me.XrLabel35.Name = "XrLabel35"
        Me.XrLabel35.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel35.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel35.StylePriority.UseBorders = False
        Me.XrLabel35.StylePriority.UseTextAlignment = False
        Me.XrLabel35.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel34
        '
        Me.XrLabel34.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel34.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.TaxesAmt")})
        Me.XrLabel34.LocationFloat = New DevExpress.Utils.PointFloat(350.9584!, 200.0!)
        Me.XrLabel34.Name = "XrLabel34"
        Me.XrLabel34.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel34.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel34.StylePriority.UseBorders = False
        Me.XrLabel34.StylePriority.UseTextAlignment = False
        Me.XrLabel34.Text = "$"
        Me.XrLabel34.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
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
        'XrLabel32
        '
        Me.XrLabel32.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel32.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ALL_NYC_Tax_Liens_CO_Info.C2ndMotgrAmt", "{0:$0.00}")})
        Me.XrLabel32.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 125.0!)
        Me.XrLabel32.Name = "XrLabel32"
        Me.XrLabel32.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel32.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel32.StylePriority.UseBorders = False
        Me.XrLabel32.StylePriority.UseTextAlignment = False
        Me.XrLabel32.Text = "$"
        Me.XrLabel32.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel31
        '
        Me.XrLabel31.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel31.LocationFloat = New DevExpress.Utils.PointFloat(599.9999!, 87.5!)
        Me.XrLabel31.Name = "XrLabel31"
        Me.XrLabel31.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel31.SizeF = New System.Drawing.SizeF(100.0001!, 23.0!)
        Me.XrLabel31.StylePriority.UseBorders = False
        Me.XrLabel31.StylePriority.UseTextAlignment = False
        Me.XrLabel31.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
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
        Me.lblFirstMortgage.Text = "$"
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
        Me.Detail1.Name = "Detail1"
        '
        'XrRichText1
        '
        Me.XrRichText1.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.XrRichText1.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 0.0!)
        Me.XrRichText1.Name = "XrRichText1"
        Me.XrRichText1.SerializableRtfString = resources.GetString("XrRichText1.SerializableRtfString")
        Me.XrRichText1.SizeF = New System.Drawing.SizeF(322.9167!, 100.0!)
        '
        'XrRichText2
        '
        Me.XrRichText2.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.XrRichText2.LocationFloat = New DevExpress.Utils.PointFloat(350.0!, 0.0!)
        Me.XrRichText2.Name = "XrRichText2"
        Me.XrRichText2.SerializableRtfString = resources.GetString("XrRichText2.SerializableRtfString")
        Me.XrRichText2.SizeF = New System.Drawing.SizeF(349.0414!, 100.0!)
        '
        'LeaderReport
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.ReportHeader, Me.DetailReport})
        Me.Font = New System.Drawing.Font("Arial", 11.0!)
        Me.Margins = New System.Drawing.Printing.Margins(63, 68, 75, 88)
        Me.Parameters.AddRange(New DevExpress.XtraReports.Parameters.Parameter() {Me.BBLE})
        Me.Version = "13.2"
        CType(Me.XrRichText1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.XrRichText2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand

#End Region

    Public Sub BindData(bble As String)
        Using context As New Entities
            Dim lead = context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

            If lead IsNot Nothing Then
                If lead.AssignDate.HasValue Then
                    lblCreatedDate.Text = lead.AssignDate.Value.ToShortDateString
                End If

                lblPropertyAddress.Text = lead.LeadsInfo.PropertyAddress

                If lead.LeadsInfo.SaleDate.HasValue Then
                    lblSaleDate.Text = lead.LeadsInfo.SaleDate.Value.ToShortDateString
                End If

                lblBlock.Text = lead.LeadsInfo.Block
                lblLot.Text = lead.LeadsInfo.Lot

                'lblYearBuilt.Text = lead.LeadsInfo

                lblTax.Text = lead.LeadsInfo.TaxClass

                If lead.LeadsInfo.IsLisPendens.HasValue Then
                    If lead.LeadsInfo.IsLisPendens.Value Then
                        chkLisPenYes.Checked = True
                    Else
                        chkLisPenNo.Checked = True
                    End If
                End If

                If lead.LeadsInfo.C1stMotgrAmt.HasValue Then
                    lblFirstMortgage.Text = lead.LeadsInfo.C1stMotgrAmt.Value.ToString("C")
                End If

                Dim resControl As HomeOwnerInfo
                Using Page As New Page
                    resControl = Page.LoadControl(String.Format("~/UserControl/HomeOwnerInfo.ascx"))
                    resControl.BBLE = bble
                    resControl.OwnerName = lead.LeadsInfo.Owner
                    resControl.BindData(bble)

                    Dim stringWriter As New StringWriter
                    Dim htmlWriter As New HtmlTextWriter(stringWriter)
                    resControl.RenderControl(htmlWriter)
                    XrRichText1.Html = stringWriter.ToString

                    If Not String.IsNullOrEmpty(lead.LeadsInfo.CoOwner) Then

                        resControl.OwnerName = lead.LeadsInfo.CoOwner
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
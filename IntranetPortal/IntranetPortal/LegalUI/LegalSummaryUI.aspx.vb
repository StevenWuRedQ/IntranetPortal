Imports IntranetPortal.Data

Public Class LegalSummaryUI
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            BindGrid()
            BindUpCommingFCGrid()
            gridOSCs_DataBinding(Nothing, Nothing)
            gridDeedReversions_DataBinding(Nothing, Nothing)
            gridPartitions_DataBinding(Nothing, Nothing)
            gridSPAndOther_DataBinding(Nothing, Nothing)
            gridQTAs_DataBinding(Nothing, Nothing)
        End If
    End Sub
    Sub BindGrid()
        Dim mCases = LegalCase.GetAllCases.Where(Function(c) c.Status <> LegalCaseStatus.Closed).ToList

        mCases = FilterByLogIn(mCases)
        gdCases.DataSource = mCases
        gdCases.DataBind()
    End Sub

    Sub BindUpCommingFCGrid()
        Dim mCases = LegalCaseReport.GetAllReport.Where(Function(r) r.SaleDate IsNot Nothing AndAlso r.LegalStatus.HasValue AndAlso r.LegalStatus = 7).ToList


        If (Not (User.IsInRole("Admin") Or User.IsInRole("Legal-Manager"))) Then
            Dim loginName = Page.User.Identity.Name
            mCases = mCases.Where(Function(c) c.Attorney = loginName Or c.ResearchBy = loginName).ToList
        End If
        gridUpCommingFCSale.DataSource = mCases
        gridUpCommingFCSale.GroupBy(gridUpCommingFCSale.Columns("SaleDate"))
        gridUpCommingFCSale.ExpandAll()
        gridUpCommingFCSale.DataBind()
    End Sub
    Function FilterByLogIn(cases As List(Of LegalCase)) As List(Of LegalCase)
        If (Not (User.IsInRole("Admin") Or User.IsInRole("Legal-Manager"))) Then
            Dim loginName = Page.User.Identity.Name
            Return cases.Where(Function(c) (c.Attorney = loginName And c.Status = LegalCaseStatus.AttorneyHandle) Or (c.ResearchBy = loginName And c.Status = LegalCaseStatus.LegalResearch)).ToList
        End If
        Return cases
    End Function

    Protected Sub gdCases_DataBinding(sender As Object, e As EventArgs)

        If (gdCases.DataSource Is Nothing) Then
            BindGrid()
        End If
    End Sub

    Protected Sub lbExportExcel_Click(sender As Object, e As EventArgs)

        CaseExporter.WriteXlsxToResponse()

    End Sub

    Protected Sub gridUpCommingFCSale_DataBinding(sender As Object, e As EventArgs)
        If (gridUpCommingFCSale.DataSource Is Nothing) Then
            BindUpCommingFCGrid()
        End If
    End Sub

  

    Protected Sub gridOSCs_DataBinding(sender As Object, e As EventArgs)
        If (gridOSCs.DataSource Is Nothing) Then
            gridOSCs.DataSource = GetSecondaryTypeList(LegalSencdaryType.OSC)
            gridOSCs.DataBind()
        End If
    End Sub
    Function GetSecondaryTypeList(type As LegalSencdaryType) As List(Of LegalCase)

        If (gdCases.DataSource IsNot Nothing) Then
            Dim Cases = TryCast(gdCases.DataSource, List(Of LegalCase))
            If (Cases IsNot Nothing) Then
                Return Cases.Where(Function(c) c.SecondaryTypes IsNot Nothing AndAlso c.SecondaryTypes.Contains(CInt(type).ToString)).ToList()
            End If

        End If
        Return Nothing
    End Function

    Protected Sub gridPartitions_DataBinding(sender As Object, e As EventArgs)
        BindTypeGrid(gridPartitions, LegalSencdaryType.Partitions)
    End Sub

    Protected Sub gridQTAs_DataBinding(sender As Object, e As EventArgs)
        BindTypeGrid(gridQTAs, LegalSencdaryType.QTA)

    End Sub
    

    Protected Sub gridDeedReversions_DataBinding(sender As Object, e As EventArgs)
        BindTypeGrid(gridDeedReversions, LegalSencdaryType.DeedReversions)
    End Sub

    Protected Sub gridSPAndOther_DataBinding(sender As Object, e As EventArgs)
        BindTypeGrid(gridSPAndOther, LegalSencdaryType.Other)
    End Sub

    Private Sub BindTypeGrid(grid As DevExpress.Web.ASPxGridView, lType As LegalSencdaryType)
        If (grid.DataSource Is Nothing) Then
            grid.DataSource = GetSecondaryTypeList(lType)
            grid.DataBind()
        End If
    End Sub

    Sub BindMangerReport()
        If (MangerReportGrid.Visible AndAlso (MangerReportGrid.DataSource Is Nothing)) Then
            MangerReportGrid.DataSource = LegalManagerReport.GetAllCase
            MangerReportGrid.DataBind()
        End If
    End Sub
    Protected Sub MangerReportGrid_DataBinding(sender As Object, e As EventArgs)
        BindMangerReport()
    End Sub

    Protected Sub MangerReportGrid_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        BindMangerReport()
    End Sub

    Protected Sub mangerExport_Click(sender As Object, e As EventArgs)
        MangerReportExporter.WriteXlsxToResponse()
    End Sub
End Class
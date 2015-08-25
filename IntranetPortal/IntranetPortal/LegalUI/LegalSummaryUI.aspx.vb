Imports IntranetPortal.Data

Public Class LegalSummaryUI
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            BindGrid()
            BindUpCommingFCGrid()
        End If
    End Sub
    Sub BindGrid()
        Dim mCases = LegalCase.GetAllCases

        mCases = FilterByLogIn(mCases)
        gdCases.DataSource = mCases
        gdCases.DataBind()
    End Sub

    Sub BindUpCommingFCGrid()
        Dim mCases = LegalCaseReport.GetAllReport.Where(Function(r) r.SaleDate IsNot Nothing AndAlso r.LegalStatus.HasValue AndAlso r.LegalStatus = 7).ToList


        If (Not (User.IsInRole("Admin") Or User.IsInRole("Legal-Manager"))) Then
            Dim loginName = Page.User.Identity.Name
            mCases = mCases.Where(Function(c) c.Attorney = loginName Or c.Attorney = loginName).ToList
        End If
        gridUpCommingFCSale.DataSource = mCases
        gridUpCommingFCSale.GroupBy(gridUpCommingFCSale.Columns("SaleDate"))
        gridUpCommingFCSale.ExpandAll()
        gridUpCommingFCSale.DataBind()
    End Sub
    Function FilterByLogIn(cases As List(Of LegalCase)) As List(Of LegalCase)
        If (Not (User.IsInRole("Admin") Or User.IsInRole("Legal-Manager"))) Then
            Dim loginName = Page.User.Identity.Name
            Return cases.Where(Function(c) c.Attorney = loginName Or c.Attorney = loginName).ToList
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

  

End Class
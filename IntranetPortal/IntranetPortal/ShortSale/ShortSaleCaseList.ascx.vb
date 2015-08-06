Imports IntranetPortal.Data

Public Class ShortSaleCaseList
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()
    End Sub

    Public Sub BindCaseListByCategory(category As String)
        hfCaseCategory.Value = category
        lblLeadCategory.Text = category

        If Employee.IsShortSaleManager(Page.User.Identity.Name) Then
            gridCase.DataSource = ShortSaleCase.GetCaseByCategory(category)
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                If category = "Upcoming" Then
                    gridCase.GroupBy(gridCase.Columns("SaleDate"))
                End If

                If category = "All" Then
                    gridCase.GroupBy(gridCase.Columns("Owner"))
                    gridCase.GroupBy(gridCase.Columns("MortgageCategory"))
                    gridCase.GroupBy(gridCase.Columns("MortgageStatus"))
                Else
                    gridCase.GroupBy(gridCase.Columns("Owner"))
                    gridCase.GroupBy(gridCase.Columns("MortgageStatus"))
                End If
            End If
        Else
            gridCase.DataSource = ShortSaleCase.GetCaseByCategory(category, Page.User.Identity.Name)
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                If category = "Upcoming" Then
                    gridCase.GroupBy(gridCase.Columns("SaleDate"))
                End If

                If category = "All" Then
                    gridCase.GroupBy(gridCase.Columns("MortgageCategory"))
                End If

                gridCase.GroupBy(gridCase.Columns("MortgageStatus"))
            End If
        End If
    End Sub

    Public Sub BindCaseList(status As CaseStatus)
        hfCaseStatus.Value = status

        If status = CaseStatus.Eviction Then
            gridCase.DataSource = ShortSaleCase.GetEvictionCases
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                gridCase.GroupBy(gridCase.Columns("EvictionOwner"))
            End If

            Return
        End If

        If status = CaseStatus.Archived Then
            gridCase.DataSource = ShortSaleCase.GetArchivedCases
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                gridCase.GroupBy(gridCase.Columns("MortgageCategory"))
            End If

            Return
        End If

        If Employee.IsShortSaleManager(Page.User.Identity.Name) Then
            gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status)

            gridCase.DataBind()

            If Not Page.IsPostBack Then
                gridCase.GroupBy(gridCase.Columns("Owner"))
            End If
        Else
            gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status, Page.User.Identity.Name)
            gridCase.DataBind()
        End If

        If Not Page.IsPostBack Then
            If status = CaseStatus.FollowUp Then
                gridCase.GroupBy(gridCase.Columns("CallbackDate"))
            End If
        End If
    End Sub

    Public Sub BindCaseByBBLEs(bbles As List(Of String))
        hfCaseBBLEs.Value = String.Join(";", bbles.ToArray)
        gridCase.DataSource = ShortSaleCase.GetCaseByBBLEs(bbles)
        gridCase.DataBind()
    End Sub
    Public Sub BindCaseForTest(needGorup As Boolean)
        'hfCaseStatus.Value = CaseStatus.NewFile
        BindCaseList(CaseStatus.NewFile)
        'gridCase.DataBind()

        If (Not needGorup) Then
            gridCase.UnGroup(gridCase.Columns("Owner"))
        End If

        'Using ctx As New ShortSaleEntities
        '    gridCase.DataSource = ctx.ShortSaleCases.Take(20).ToList


        '    gridCase.DataBind()
        'End Using
    End Sub
    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing AndAlso gridCase.IsCallback Then
            If Not String.IsNullOrEmpty(hfCaseStatus.Value) Then
                BindCaseList(hfCaseStatus.Value)
            End If

            If (Not String.IsNullOrEmpty(hfCaseBBLEs.Value)) Then
                BindCaseByBBLEs(hfCaseBBLEs.Value.Split(";").ToList())
            End If

            If Not String.IsNullOrEmpty(hfCaseCategory.Value) Then
                BindCaseListByCategory(hfCaseCategory.Value)
            End If
        End If
    End Sub

    Public Property AutoLoadCase As Boolean
        Get
            Return gridCase.SettingsBehavior.AllowClientEventsOnLoad
        End Get
        Set(value As Boolean)
            gridCase.SettingsBehavior.AllowClientEventsOnLoad = value
        End Set
    End Property

End Class
Imports IntranetPortal.Data

Public Class ShortSaleCaseList
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("action")) Then
                If Request.QueryString("action") = "Create" Then
                    Me.CreateNew.Visible = True
                    'If Not Page.ClientScript.IsStartupScriptRegistered("ShowCreateNewWindow") Then
                    '    Dim cstext1 As String = "<script type=""text/javascript"">" &
                    '                    String.Format("ShowCreateNew();") & "</script>"
                    '    Page.ClientScript.RegisterStartupScript(Me.GetType, "ShowCreateNewWindow", cstext1)
                    'End If
                End If
            End If
        End If
    End Sub

    ''' <summary>
    ''' Loading ShortSale Cases to Case list
    ''' </summary>
    ''' <param name="category">Case Category</param>
    ''' <param name="appId">Application Id</param>
    Public Sub BindCaseListByCategory(category As String, appId As Integer)
        hfCaseCategory.Value = category
        lblLeadCategory.Text = category

        If Employee.IsShortSaleManager(Page.User.Identity.Name) Then
            gridCase.DataSource = ShortSaleCase.GetCaseByCategory(category, appId)
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
            Dim owners = Employee.GetManagedEmployees(Page.User.Identity.Name)
            gridCase.DataSource = ShortSaleCase.GetCaseByCategory(category, appId, owners)
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                If category = "Upcoming" Then
                    gridCase.GroupBy(gridCase.Columns("SaleDate"))
                End If

                If owners.Count > 1 Then
                    gridCase.GroupBy(gridCase.Columns("Owner"))
                End If

                If category = "All" Then
                    gridCase.GroupBy(gridCase.Columns("MortgageCategory"))
                End If

                gridCase.GroupBy(gridCase.Columns("MortgageStatus"))
            End If
        End If
    End Sub

    Public Sub BindCaseList(status As CaseStatus, appId As Integer)
        hfCaseStatus.Value = status

        If status = CaseStatus.Eviction Then
            gridCase.DataSource = ShortSaleCase.GetEvictionCases
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                gridCase.GroupBy(gridCase.Columns("EvictionOwner"))
            End If

            Return
        End If

        'If status = CaseStatus.Archived Then
        '    gridCase.DataSource = ShortSaleCase.GetArchivedCases(appId)
        '    gridCase.DataBind()

        '    If Not Page.IsPostBack Then
        '        gridCase.GroupBy(gridCase.Columns("MortgageCategory"))
        '    End If

        '    Return
        'End If

        If Employee.IsShortSaleManager(Page.User.Identity.Name) Then
            gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status, appId)

            gridCase.DataBind()

            If Not Page.IsPostBack Then
                gridCase.GroupBy(gridCase.Columns("Owner"))
            End If
        Else
            Dim owners = Employee.GetManagedEmployees(Page.User.Identity.Name)

            gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status, owners, appId)
            gridCase.DataBind()

            If Not Page.IsPostBack Then
                If owners.Count > 1 Then
                    gridCase.GroupBy(gridCase.Columns("Owner"))
                End If
            End If
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
    Public Sub BindCaseForTest(needGorup As Boolean, appId As Integer)
        'hfCaseStatus.Value = CaseStatus.NewFile
        BindCaseList(CaseStatus.NewFile, appId)
        'gridCase.DataBind()

        If (Not needGorup) Then
            gridCase.UnGroup(gridCase.Columns("Owner"))
        End If

        'Using ctx As New PortalEntities
        '    gridCase.DataSource = ctx.ShortSaleCases.Take(20).ToList


        '    gridCase.DataBind()
        'End Using
    End Sub
    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing AndAlso gridCase.IsCallback Then
            If Not String.IsNullOrEmpty(hfCaseStatus.Value) Then
                BindCaseList(hfCaseStatus.Value, CType(Page, PortalPage).CurrentAppId)
            End If

            If (Not String.IsNullOrEmpty(hfCaseBBLEs.Value)) Then
                BindCaseByBBLEs(hfCaseBBLEs.Value.Split(";").ToList())
            End If

            If Not String.IsNullOrEmpty(hfCaseCategory.Value) Then
                BindCaseListByCategory(hfCaseCategory.Value, CType(Page, PortalPage).CurrentAppId)
            End If
        End If
    End Sub

    Public Sub CreateNewLeads(bble As String) Handles CreateNew.CaseCreatedEvent
        For Each item In bble.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            If Not String.IsNullOrEmpty(item) Then
                Dim ld = LeadsInfo.GetInstance(item)

                If ld Is Nothing Then
                    Lead.CreateLeads(item, LeadStatus.InProcess, Page.User.Identity.Name)
                End If

                ShortSaleManage.MoveLeadsToShortSale(item, Page.User.Identity.Name, Employee.CurrentAppId)
            End If
        Next
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
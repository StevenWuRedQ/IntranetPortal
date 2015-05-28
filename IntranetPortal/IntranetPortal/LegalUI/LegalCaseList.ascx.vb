Imports IntranetPortal.Legal
Imports System.Reflection
Imports System.ComponentModel

Public Class LegalCaseList
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()
    End Sub

    Public Sub BindCaseList(status As LegalCaseStatus)
        hfCaseStatus.Value = status

        lblLeadCategory.Text = Core.Utility.GetEnumDescription(status)

        gridCase.DataSource = LegalCase.GetCaseList(status)
        gridCase.DataBind()

        If status = LegalCaseStatus.LegalResearch Then
            gridCase.GroupBy(gridCase.Columns("ResearchBy"))
        End If

        If status = LegalCaseStatus.AttorneyHandle Then
            gridCase.GroupBy(gridCase.Columns("Attorney"))
        End If

        'If status = CaseStatus.Eviction Then
        '    gridCase.DataSource = ShortSaleCase.GetEvictionCases
        '    gridCase.DataBind()

        '    If Not Page.IsPostBack Then
        '        gridCase.GroupBy(gridCase.Columns("EvictionOwner"))
        '    End If

        '    Return
        'End If

        'If Employee.IsShortSaleManager(Page.User.Identity.Name) Then
        '    gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status)

        '    gridCase.DataBind()

        '    If Not Page.IsPostBack Then
        '        gridCase.GroupBy(gridCase.Columns("Owner"))
        '    End If
        'Else
        '    gridCase.DataSource = ShortSaleCase.GetCaseByStatus(status, Page.User.Identity.Name)
        '    gridCase.DataBind()
        'End If

        'If Not Page.IsPostBack Then
        '    If status = CaseStatus.FollowUp Then
        '        gridCase.GroupBy(gridCase.Columns("CallbackDate"))
        '    End If
        'End If
    End Sub

    Public Sub BindCaseByBBLEs(bbles As List(Of String))
        'hfCaseBBLEs.Value = String.Join(";", bbles.ToArray)
        'gridCase.DataSource = ShortSaleCase.GetCaseByBBLEs(bbles)
        'gridCase.DataBind()
    End Sub

    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing AndAlso gridCase.IsCallback Then
            If Not String.IsNullOrEmpty(hfCaseStatus.Value) Then
                BindCaseList(hfCaseStatus.Value)
            End If

            'If (Not String.IsNullOrEmpty(hfCaseBBLEs.Value)) Then
            '    BindCaseByBBLEs(hfCaseBBLEs.Value.Split(";").ToList())
            'End If
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
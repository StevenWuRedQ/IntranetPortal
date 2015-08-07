Imports IntranetPortal.Data
Imports System.Reflection
Imports System.ComponentModel

Public Class ConstructionCaseList
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()
    End Sub

    Public Sub BindCaseList()
        'hfCaseStatus.Value = status

        lblLeadCategory.Text = "Cases" 'Core.Utility.GetEnumDescription(status)
        BindData()

        If Page.User.IsInRole("Construction-Manager") OrElse Page.User.IsInRole("Admin") Then
            gridCase.GroupBy(gridCase.Columns("Owner"))
        End If

        gridCase.DataBind()
    End Sub

    Private Sub BindData()
        If Page.User.IsInRole("Construction-Manager") OrElse Page.User.IsInRole("Admin") Then
            gridCase.DataSource = ConstructionCase.GetAllCases
        Else
            gridCase.DataSource = ConstructionCase.GetAllCases(Page.User.Identity.Name)
        End If
    End Sub

    Public Sub BindCaseByBBLEs(bbles As List(Of String))
        'hfCaseBBLEs.Value = String.Join(";", bbles.ToArray)
        'gridCase.DataSource = ShortSaleCase.GetCaseByBBLEs(bbles)
        'gridCase.DataBind()
    End Sub

    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing AndAlso gridCase.IsCallback Then
            BindData()
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
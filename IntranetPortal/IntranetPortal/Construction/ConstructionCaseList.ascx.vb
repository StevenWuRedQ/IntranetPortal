Imports IntranetPortal.Legal
Imports System.Reflection
Imports System.ComponentModel

Public Class ConstructionCaseList
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()
    End Sub

    Public Sub BindCaseList(status As LegalCaseStatus)
        hfCaseStatus.Value = status

        lblLeadCategory.Text = Core.Utility.GetEnumDescription(status)

        BindLegalData(status)
        gridCase.DataBind()

        If status = LegalCaseStatus.LegalResearch Then
            gridCase.GroupBy(gridCase.Columns("ResearchBy"))
        End If

        If status = LegalCaseStatus.AttorneyHandle Then
            gridCase.GroupBy(gridCase.Columns("Attorney"))
        End If
    End Sub

    Private Sub BindLegalData(status As LegalCaseStatus)
        If Page.User.IsInRole("Legal-Manager") OrElse Page.User.IsInRole("Admin") Then
            gridCase.DataSource = LegalCase.GetCaseList(status)
        Else
            gridCase.DataSource = LegalCase.GetCaseList(status, Page.User.Identity.Name)
        End If
    End Sub

    Public Sub BindCaseByBBLEs(bbles As List(Of String))
        'hfCaseBBLEs.Value = String.Join(";", bbles.ToArray)
        'gridCase.DataSource = ShortSaleCase.GetCaseByBBLEs(bbles)
        'gridCase.DataBind()
    End Sub

    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing AndAlso gridCase.IsCallback Then
            If Not String.IsNullOrEmpty(hfCaseStatus.Value) Then
                BindLegalData(hfCaseStatus.Value)
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
Imports IntranetPortal.Data
Imports System.Reflection
Imports System.ComponentModel
Imports DevExpress.Web

Public Class ConstructionCaseList
    Inherits System.Web.UI.UserControl

    Dim Status As ConstructionCase.CaseStatus = ConstructionCase.CaseStatus.All

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()

    End Sub

    Public Sub BindCaseList()
        'hfCaseStatus.Value = status
        If Request.QueryString("s") IsNot Nothing Then
            Status = CInt(Request.QueryString("s"))
        End If

        lblLeadCategory.Text = Core.Utility.GetEnumDescription(Status)
        BindData()

        If ConstructionManage.IsManager(Page.User.Identity.Name) Then
            gridCase.GroupBy(gridCase.Columns("Owner"))
        End If

        If Status = ConstructionCase.CaseStatus.All Then
            gridCase.GroupBy(gridCase.Columns("StatusStr"))
        End If

        gridCase.DataBind()
    End Sub

    Private Sub BindData()
        If Status = ConstructionCase.CaseStatus.All Then
            If Request.QueryString("s") IsNot Nothing Then
                Status = CInt(Request.QueryString("s"))
            End If
        End If

        gridCase.DataSource = ConstructionManage.GetMyLightCases(Page.User.Identity.Name, Status)
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

    Protected Sub gridCase_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridViewTableRowEventArgs)
        If e.RowType <> GridViewRowType.Data Then
            Return
        End If
        Dim isCompleted = Convert.ToBoolean(e.GetValue("IntakeCompleted"))
        If isCompleted Then
            e.Row.BackColor = System.Drawing.Color.LightCyan
        End If
    End Sub
End Class
Imports IntranetPortal.Data
Imports System.Reflection
Imports System.ComponentModel

Public Class TitleCaseList
    Inherits BusinessListControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'BindCaseList()
    End Sub

    Public Overrides Sub BindList()
        MyBase.BindList()
        BindCaseList()
    End Sub

    Public Sub BindCaseList()
        'hfCaseStatus.Value = status

        lblLeadCategory.Text = "Cases" 'Core.Utility.GetEnumDescription(status)
        BindData()

        If TitleManage.IsManager(Page.User.Identity.Name) Then
            gridCase.GroupBy(gridCase.Columns("Owner"))
        End If

        If String.IsNullOrEmpty(Request.QueryString("s")) Then
            gridCase.GroupBy(gridCase.Columns("StatusStr"))
        End If

        gridCase.DataBind()
    End Sub

    Private Sub BindData()
        If String.IsNullOrEmpty(Request.QueryString("s")) Then
            gridCase.DataSource = TitleManage.GetMyCases(Page.User.Identity.Name)
        Else
            Dim status = CInt(Request.QueryString("s"))
            gridCase.DataSource = TitleManage.GetMyCases(Page.User.Identity.Name, status)
        End If
    End Sub

    Protected Sub gridCase_DataBinding(sender As Object, e As EventArgs)
        If gridCase.DataSource Is Nothing AndAlso gridCase.IsCallback Then
            BindData()
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
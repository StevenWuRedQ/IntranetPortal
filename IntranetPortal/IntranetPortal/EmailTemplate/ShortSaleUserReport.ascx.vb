Imports DevExpress.XtraCharts.Native
Imports DevExpress.XtraCharts.Web
Imports DevExpress.XtraCharts
Imports System.IO

Public Class ShortSaleUserReport
    Inherits System.Web.UI.UserControl

    Public Property UserName As String
    Public Property Manager As String = "Manager"

    Public Property ActivityData As PortalReport.CaseActivityData

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub BindData(actData As PortalReport.CaseActivityData)
        ActivityData = actData
    End Sub
End Class
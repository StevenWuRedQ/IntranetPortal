Imports DevExpress.XtraCharts.Native
Imports DevExpress.XtraCharts.Web
Imports DevExpress.XtraCharts
Imports System.IO

Public Class ActivitySummary
    Inherits System.Web.UI.UserControl

    Public Property team As Team
    Public Property Manager As String = "Manager"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
    End Sub
End Class
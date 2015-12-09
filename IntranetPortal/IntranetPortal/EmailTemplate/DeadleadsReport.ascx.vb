Public Class DeadleadsReport
    Inherits EmailTemplateControl

    Public Property ActivityData As List(Of PortalReport.AgentActivityData)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)

        ActivityData = PortalReport.LoadDeadLeadsReport(DateTime.Today, DateTime.Today.AddDays(1))
    End Sub

End Class
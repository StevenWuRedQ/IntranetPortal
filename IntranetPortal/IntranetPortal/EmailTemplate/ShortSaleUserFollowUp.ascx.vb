Public Class ShortSaleUserFollowUp
    Inherits EmailTemplateControl

    Public Property ActivityData As PortalReport.CaseActivityData

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)

        Dim userName = params("Name")
        ActivityData = New PortalReport.CaseActivityData
        ActivityData.Name = userName
        ActivityData.Type = PortalReport.CaseActivityData.ActivityType.ShortSale
        PortalReport.BuildMissedFollowUpData(ActivityData, DateTime.Today.AddDays(1))

    End Sub

End Class
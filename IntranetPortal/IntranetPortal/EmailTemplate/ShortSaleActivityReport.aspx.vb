Imports DevExpress.XtraCharts
Imports DevExpress.XtraCharts.Native

Public Class ShortSaleActivityReport
    Inherits System.Web.UI.Page

    Public Property team As Team
    Public Property Manager As String = "Manager"
    Public Property TeamName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            TeamActivityData = PortalReport.LoadShortSaleActivityReport(DateTime.Today.AddDays(-1), DateTime.Today.AddDays(1))
            BindChart()
        End If
    End Sub

    Public Property TeamActivityData As List(Of PortalReport.AgentActivityData)

    Dim imgStr As String
    Public ReadOnly Property ChartImage As String
        Get
            Dim ms As New IO.MemoryStream
            CType(chartActivity, IChartContainer).Chart.ExportToImage(ms, System.Drawing.Imaging.ImageFormat.Png)
            Return "data:image/png;base64," & System.Convert.ToBase64String(ms.ToArray)
        End Get
    End Property

    Private Sub BindChart()
        chartActivity.DataSource = TeamActivityData
        chartActivity.BorderOptions.Visibility = DevExpress.Utils.DefaultBoolean.False

        Dim title = New ChartTitle()
        title.Text = String.Format("Short Sale Team Activity on {0:m}", DateTime.Today)
        chartActivity.Titles.Add(title)

        chartActivity.Legend.Direction = LegendDirection.LeftToRight
        chartActivity.Legend.AlignmentHorizontal = LegendAlignmentHorizontal.Center
        chartActivity.Legend.AlignmentVertical = LegendAlignmentVertical.BottomOutside


        Dim seriesCallOwner As New Series("CallOwner", ViewType.Bar)
        seriesCallOwner.LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
        seriesCallOwner.ArgumentDataMember = "Name"
        seriesCallOwner.ValueDataMembers.AddRange({"CallOwner"})
        chartActivity.Series.Add(seriesCallOwner)

        Dim seriesComments As New Series("Comments", ViewType.Bar) With
            {
                .LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
                }
        seriesComments.ArgumentDataMember = "Name"
        seriesComments.ValueDataMembers.AddRange({"Comments"})
        chartActivity.Series.Add(seriesComments)

        'Dim seriesDoorKnock As New Series("DoorKnock", ViewType.Bar) With
        '    {
        '        .LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
        '        }
        'seriesDoorKnock.ArgumentDataMember = "Name"
        'seriesDoorKnock.ValueDataMembers.AddRange({"DoorKnock"})
        'chartActivity.Series.Add(seriesDoorKnock)

        'Dim seriesFollowUp As New Series("FollowUp", ViewType.Bar)
        'seriesFollowUp.ArgumentDataMember = "Name"
        'seriesFollowUp.ValueDataMembers.AddRange({"FollowUp"})
        'chartActivity.Series.Add(seriesFollowUp)

        Dim seriesUniqueBBLE As New Series("UniqueBBLE", ViewType.Bar) With
            {
                .LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
                }
        seriesUniqueBBLE.ArgumentDataMember = "Name"
        seriesUniqueBBLE.ValueDataMembers.AddRange({"UniqueBBLE"})
        chartActivity.Series.Add(seriesUniqueBBLE)

        Dim diagram = CType(chartActivity.Diagram, XYDiagram)
        diagram.DefaultPane.BorderVisible = False


        chartActivity.DataBind()
    End Sub
End Class
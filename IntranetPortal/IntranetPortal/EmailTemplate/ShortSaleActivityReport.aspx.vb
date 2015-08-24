Imports DevExpress.XtraCharts
Imports DevExpress.XtraCharts.Native

Public Class ShortSaleActivityReport
    Inherits System.Web.UI.Page

    Public Property team As Team
    Public Property Manager As String = "Manager"
    Public Property TeamName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            TeamActivityData = PortalReport.LoadShortSaleActivityReport(DateTime.Today, DateTime.Today.AddDays(1))
            BindChart()
        End If
    End Sub

    Public Property TeamActivityData As List(Of PortalReport.CaseActivityData)

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


        Dim seriesFilesWithComments As New Series("FileWorkedWithComments", ViewType.Bar)
        seriesFilesWithComments.LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
        seriesFilesWithComments.ArgumentDataMember = "Name"
        seriesFilesWithComments.ValueDataMembers.AddRange({"FilesWithCmtCount"})
        chartActivity.Series.Add(seriesFilesWithComments)

        Dim seriesFilesWithoutComments As New Series("FilesWorkedWithoutComments", ViewType.Bar) With
            {
                .LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
                }
        seriesFilesWithoutComments.ArgumentDataMember = "Name"
        seriesFilesWithoutComments.ValueDataMembers.AddRange({"FilesWithoutCmtCount"})
        chartActivity.Series.Add(seriesFilesWithoutComments)

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

        Dim seriesFilesViewd As New Series("FilesViewedOnly", ViewType.Bar) With
            {
                .LabelsVisibility = DevExpress.Utils.DefaultBoolean.True
                }
        seriesFilesViewd.ArgumentDataMember = "Name"
        seriesFilesViewd.ValueDataMembers.AddRange({"FilesViewedCount"})
        chartActivity.Series.Add(seriesFilesViewd)

        Dim diagram = CType(chartActivity.Diagram, XYDiagram)
        diagram.DefaultPane.BorderVisible = False


        chartActivity.DataBind()
    End Sub
End Class
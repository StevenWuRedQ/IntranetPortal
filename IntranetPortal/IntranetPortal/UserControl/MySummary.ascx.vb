Imports DevExpress.Web

Public Class MySummary
    Inherits System.Web.UI.UserControl

    Private SummaryItems As New List(Of SummaryItemBase)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            For Each ctr In SummaryItems
                ctr.BindData()
            Next
        End If
    End Sub

    Protected Sub rptModules_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ascx = e.Item.DataItem

            Dim myControl = CType(Page.LoadControl("~/UserControl/SummaryItem/" & ascx), SummaryItemBase)
            myControl.ID = "Control" & e.Item.ItemIndex

            SummaryItems.Add(myControl)
            'myControl.BindData()

            Dim lt = CType(e.Item.FindControl("ltContainer"), HtmlControl)
            lt.Controls.Add(myControl)
        End If
    End Sub

    Private Sub MySummary_Init(sender As Object, e As EventArgs) Handles Me.Init
        Dim models = {"TaskItem.ascx", "AppointmentItem.ascx", "FollowUpItem.ascx", "CalendarItem.ascx"}
        rptModules.DataSource = models
        rptModules.DataBind()
    End Sub

End Class
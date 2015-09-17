Imports DevExpress.Web

Public Class MySummary
    Inherits System.Web.UI.UserControl


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim models = {"TaskItem.ascx", "AppointmentItem.ascx", "CalendarItem.ascx"}
        rptModules.DataSource = models
        rptModules.DataBind()
    End Sub

    Protected Sub rptModules_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ascx = e.Item.DataItem

            Dim myControl = CType(Page.LoadControl("~/UserControl/SummaryItem/" & ascx), SummaryItemBase)
            myControl.BindData()

            Dim lt = CType(e.Item.FindControl("ltContainer"), HtmlControl)
            lt.Controls.Add(myControl)
        End If
    End Sub
End Class
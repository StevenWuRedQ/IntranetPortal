Public Class ReportSummary
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindWorklistStatistic()
            BindProcInstSummary()
        End If
    End Sub

    Sub BindWorklistStatistic()
        gridWorklistStatistic.DataSource = MyIdealProp.Workflow.DBPersistence.Worklist.GetWorklistStatistic
        gridWorklistStatistic.DataBind()
    End Sub

    Sub BindProcInstSummary()
        ASPxGridView1.DataSource = MyIdealProp.Workflow.DBPersistence.ProcessInstance.GetProcInstStatistic
        ASPxGridView1.DataBind()
    End Sub

    Protected Sub gridWorklistStatistic_DataBinding(sender As Object, e As EventArgs)
        If gridWorklistStatistic.DataSource Is Nothing Then
            BindWorklistStatistic()
        End If
    End Sub

    Protected Sub ASPxGridView1_DataBinding(sender As Object, e As EventArgs)
        If ASPxGridView1.DataSource Is Nothing Then
            BindProcInstSummary()
        End If
    End Sub

    Protected Sub gridUser_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        CType(gridUser.FindFooterRowTemplateControl("hfUser"), HiddenField).Value = e.Parameters
        'hfUser.Value = e.Parameters
        lblUserName.Text = e.Parameters
        BindUserlist(e.Parameters)
    End Sub

    Protected Sub gridUser_DataBinding(sender As Object, e As EventArgs)
        If gridUser.DataSource Is Nothing Then
            Dim name = CType(gridUser.FindFooterRowTemplateControl("hfUser"), HiddenField).Value
            BindUserlist(name)
        End If
    End Sub

    Private Sub BindUserlist(userName As String)
        gridUser.DataSource = MyIdealProp.Workflow.DBPersistence.Worklist.GetUserWorklist(userName)
        gridUser.DataBind()
    End Sub
End Class
Public Class WorklistReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            GridWorklist.DataBind()
        End If
    End Sub

    Sub BindData()
        If String.IsNullOrEmpty(Request.QueryString("u")) Then
            GridWorklist.DataSource = MyIdealProp.Workflow.DBPersistence.Worklist.GetAllPendingWorklist()
            'GridWorklist.GroupBy(GridWorklist.Columns("DestinationUser"))
        Else
            Dim user = Request.QueryString("u").ToString
            lblUserName.Text = "Name: " & user
            GridWorklist.DataSource = MyIdealProp.Workflow.DBPersistence.Worklist.GetUserWorklist(user)
            GridWorklist.Columns("DestinationUser").Visible = False
        End If
    End Sub

    Protected Sub GridWorklist_DataBinding(sender As Object, e As EventArgs)
        If GridWorklist.DataSource Is Nothing Then
            BindData()
        End If
    End Sub
End Class
Imports MyIdealProp.Workflow.Client

Public Class TasklistControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindTask()
    End Sub

    Public Sub BindTask()
        Dim conn As New Connection("localhost")
        conn.UserName = Page.User.Identity.Name
        conn.Open()

        gridTasks.DataSource = conn.OpenMyWorklist()
        gridTasks.DataBind()

        gridTasks.GroupBy(gridTasks.Columns("ProcessName"))
    End Sub
End Class
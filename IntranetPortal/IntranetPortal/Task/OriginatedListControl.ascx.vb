Public Class OriginatedListControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindList()
    End Sub

    Private Sub BindList()
        gridProcess.DataSource = WorkflowService.GetMyOriginated(Page.User.Identity.Name)
        gridProcess.DataBind()

        If Not IsPostBack Then
            gridProcess.GroupBy(gridProcess.Columns("ProcessName"))
        End If
    End Sub

    Public Function GetViewLink(procName As String) As String
        If ProcessViewLinks.ContainsKey(procName) Then
            Return ProcessViewLinks(procName)
        End If

        Return ""
    End Function

    Private _processViewLinks As Dictionary(Of String, String)
    Public ReadOnly Property ProcessViewLinks As Dictionary(Of String, String)
        Get
            If _processViewLinks Is Nothing Then
                _processViewLinks = New Dictionary(Of String, String)
                _processViewLinks.Add("TaskProcess", "/ViewLeadsInfo.aspx?ProcInstId=")
                _processViewLinks.Add("TestProcess", "")
            End If

            Return _processViewLinks
        End Get
    End Property

End Class
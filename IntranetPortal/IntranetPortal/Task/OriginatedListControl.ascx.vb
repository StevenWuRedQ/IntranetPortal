Imports MyIdealProp.Workflow.DBPersistence

Public Class OriginatedListControl
    Inherits System.Web.UI.UserControl

    Public Property DisplayMode As ListMode = ListMode.Originated
    Public Property HeaderText As String = "Originated"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindList()
    End Sub

    Private Sub BindList()
        gridProcess.DataSource = GetDataSource()
        gridProcess.DataBind()

        If Not IsPostBack Then
            gridProcess.GroupBy(gridProcess.Columns("ProcessName"))
        End If
    End Sub

    Private Function GetDataSource() As List(Of ProcessInstance)
        If DisplayMode = ListMode.Originated Then
            Return WorkflowService.GetMyOriginated(Page.User.Identity.Name)
        End If

        Return WorkflowService.GetMyCompleted(Page.User.Identity.Name)
    End Function

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
                _processViewLinks.Add("ShortSaleTask", "/ShortSale/Shortsale.aspx?ProcInstId=")
            End If

            Return _processViewLinks
        End Get
    End Property

    Public Enum ListMode
        Originated
        Completed
    End Enum

End Class
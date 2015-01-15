Imports MyIdealProp.Workflow.DBPersistence

Public Class OriginatedListControl
    Inherits System.Web.UI.UserControl

    Public Property DisplayMode As ListMode = ListMode.Originated
    Public Property HeaderText As String = "Originated"
    Private sepatred As Boolean = True
    Private procInstStatus As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Request.QueryString("c") IsNot Nothing Then
                procInstStatus = CInt(Request.QueryString("c"))
            End If

            BindList()
        End If
    End Sub

    Private Sub BindList()
        gridProcess.DataSource = GetDataSource()
        gridProcess.DataBind()

        If Not IsPostBack Then
            gridProcess.GroupBy(gridProcess.Columns("ProcessSchemeDisplayName"))

            If procInstStatus = 3 Then
                gridProcess.Columns(0).Visible = True
            End If
        End If
    End Sub

    Protected Sub gridProcess_DataBinding(sender As Object, e As EventArgs)
        If gridProcess.DataSource Is Nothing Then
            gridProcess.DataSource = GetDataSource()
        End If
    End Sub

    Private Function GetDataSource() As List(Of ProcessInstance)
        If DisplayMode = ListMode.Originated Then
            Dim results = WorkflowService.GetMyOriginated(Page.User.Identity.Name)

            If Not String.IsNullOrEmpty(Request.QueryString("c")) Then
                Dim c = Request.QueryString("c")
                results = results.Where(Function(pInst) pInst.Status = c).ToList
            End If

            Return results
        End If

        Return WorkflowService.GetMyCompleted(Page.User.Identity.Name)
    End Function

    Public Function GetViewLink(procName As String) As String
        If ProcessViewLinks.ContainsKey(procName) Then
            Return ProcessViewLinks(procName)
        End If

        Return "/ViewLeadsInfo.aspx?ProcInstId="
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

    
    Protected Sub gridProcess_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        Dim id = CInt(e.Keys(0))
        WorkflowService.ArchivedProcInst(id)

        e.Cancel = True
    End Sub
End Class
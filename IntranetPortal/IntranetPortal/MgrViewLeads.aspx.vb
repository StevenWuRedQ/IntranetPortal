Imports DevExpress.Web

Public Class MgrViewLeads
    Inherits System.Web.UI.Page

    Dim CategoryName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("c")) Then
            CategoryName = Request.QueryString("c")

            ASPxSplitter1.ClientVisible = True
            ASPxSplitter1.GetPaneByName("leadPanel").Collapsed = False

            If Not String.IsNullOrEmpty(Request.QueryString("o")) Then
                LeadsList.LeadsListView = ControlView.OfficeView
                LeadsList.OfficeName = Request.QueryString("o")
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
                LeadsList.LeadsListView = ControlView.TeamView
                LeadsList.TeamMgr = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("team")) Then
                Dim teamId = Request.QueryString("team").ToString
                LeadsList.LeadsListView = ControlView.TeamView2
                LeadsList.TeamId = CInt(teamId)
            End If

            If Not Page.IsPostBack Then
                LeadsList.BindLeadsList(CategoryName)
                If CategoryName = "Search" Then
                    ASPxSplitter1.GetPaneByName("leadPanel").Size = "400"
                End If
            End If
        End If

        If Page.IsCallback Then
            'LeadsList.BindLeadsList(CategoryName)
        End If
    End Sub
End Class
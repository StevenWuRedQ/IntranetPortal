Imports System.IO

Public Class Test
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Response.Write(Roles.IsUserInRole("123", "OfficeManager-Bronx"))
        'If Not (String.IsNullOrEmpty(Request.QueryString("Name"))) Then
        '    TaskSummary.DestinationUser = Request.QueryString("Name").ToString
        'Else
        '    TaskSummary.DestinationUser = "Chris Yan"
        'End If

        If Not (String.IsNullOrEmpty(Request.QueryString("team"))) Then
            Dim objTeam = Team.GetTeam(Request.QueryString("team").ToString)
            Me.ActivitySummary.team = objTeam
            Me.ActivitySummary.Manager = "Manager"
        Else

        End If
    End Sub

    Public Shared Function LoadSummaryEmail(userName As String) As String
        Dim ts As New TaskSummary

        Using tPage As New Page
            ts = tPage.LoadControl("~/EmailTemplate/TaskSummary.ascx")
            ts.DestinationUser = userName
            ts.BindData()

            Dim sb As New StringBuilder
            Using tw As New StringWriter(sb)
                Using hw As New HtmlTextWriter(tw)
                    ts.RenderControl(hw)
                End Using
            End Using

            Return sb.ToString
        End Using
    End Function

    Sub ConectToOneDrive()

    End Sub


End Class
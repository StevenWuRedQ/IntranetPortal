Imports System.IO
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports HtmlAgilityPack
Imports System.Web.Services
Imports System.Web.Script.Services

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
            'Me.ActivitySummary.team = objTeam
            'Me.ActivitySummary.Manager = "Manager"
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


    Protected Sub Button1_Click(sender As Object, e As EventArgs)
        Dim cases = IntranetPortal.Data.LegalCase.GetAllCases
        For Each c In cases
            Dim data = JObject.Parse(c.CaseData)
            data("CaseName") = c.CaseName
            c.CaseData = data.ToJsonString
            c.SaveData(Page.User.Identity.Name)
        Next
        UpdateStauts.Text = "completed"
    End Sub


    Protected Sub CropGrid_DataBinding(sender As Object, e As EventArgs)
        'TestCrop_Click(Nothing, Nothing)
    End Sub

    Protected Sub TestCrop_Click(sender As Object, e As EventArgs)
        Dim CorpNotesList = JArray.Parse(CropNotes.Text)
        Dim Conps = Data.CorporationEntity.GetAllEntities
        Dim result = New List(Of String)
        For Each c In Conps

            Dim cNotes = CorpNotesList.Where(Function(n) n.Item("Corp_Name").ToString = c.CorpName).ToList()
            If (cNotes.Count > 0) Then

                Dim cNotesStr = cNotes.Where(Function(n) (If(c.Notes IsNot Nothing, Not c.Notes.Contains(n.Item("BBLE").ToString), True))).Select(Function(n) "BBLE: (" & n.Item("BBLE").ToString & ") " & n.Item("NUMBER").ToString & " " & n.Item("NEIGH_NAME").ToString & " " & If(n.Item("APT_NO") IsNot Nothing, n.Item("APT_NO").ToString, "") & " " & n.Item("BORO_NAME").ToString & ", " & n.Item("ZIP").ToString).ToList
                Dim Str = String.Join(Environment.NewLine, cNotesStr)
                If (Str IsNot Nothing) Then
                    Str = Environment.NewLine & Str
                End If
                c.Notes = If(c.Notes IsNot Nothing, c.Notes & Str, Str)
                c.Save()
                If (cNotes.Count > 1) Then
                    Dim a = 1
                End If
            End If



            'result.Add(If(c.Notes, c.Notes, "NULL"))
        Next

        CropGrid.DataSource = Conps.ToList.Select(Function(c) New With {.Name = c.CorpName, .Id = c.EntityId, .Notes = c.Notes}) 'JArray.Parse(Data.CorporationEntity.GetAllEntities.ToJsonString).ToList
        CropGrid.DataBind()

    End Sub




    Public Sub UpdateOwner()
        Dim Data = New Dictionary(Of String, Long) From {{"880 Lafayette Avenue", 3016090035}}

        For Each kvp As KeyValuePair(Of String, Long) In Data
            Dim caseName = kvp.Key.Trim
            Dim BBLE = kvp.Value
            IntranetPortal.Data.ConstructionCase.UpdateOwner(BBLE.ToString, "Jamie Ventura")
        Next

    End Sub

End Class


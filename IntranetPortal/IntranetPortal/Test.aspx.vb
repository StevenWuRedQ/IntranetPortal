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

    Public Sub onCaseUploadClick()
        Dim result = New StringBuilder
        Dim Data = New Dictionary(Of String, Long) From {
  {"52 Adrian Avenue", 1022150377},
  {"1083 Lafayatte Ave", 3016080043},
  {"123 Pulaski Street", 3017710048},
  {"125 Pulaski Street", 3017710047},
  {"169 Covert Street", 3034170051},
  {"169 Madison Street", 3018170079},
  {"178 Montauk Avenue", 3040070032},
  {"218 Quincy Street", 3018070032},
  {"282 Schaeffer Street", 3034310019},
  {"38 A Woodbine Street", 3033570031},
  {"433 Bainbridge Street", 3015050069},
  {"443/445 Montauk Ave", 3044560053},
  {"492 Warren Street", 3003990030},
  {"533 Quincy Street", 3016240074},
  {"62 Monroe Street", 3019870041},
  {"636 Chauncey Street", 3034500017},
  {"655 Greene Avenue", 3017950053},
  {"691 Monroe Street", 3016370063},
  {"71 Stewart Street", 3034730042},
  {"960 St. Marks Avenue", 3012300029},
  {"123 Halsey Street", 3018380075},
  {"236 Monroe Street", 3018180011},
  {"387 Grant Avenue", 3041750013},
  {"820 E 49 Street", 3047790018},
  {"155-06 116 Road", 4122250008},
  {"193-26 Woodhull Avenue", 4108170053},
  {"201-18 109 Avenue", 4109010008},
  {"57-28 57 Drive", 4026760013},
  {"74-18 85 Drive", 4088360037},
  {"92-08 78 Street", 4089520014},
  {"95-24 Woodhaven Court", 4090410102}
}
        For Each kvp As KeyValuePair(Of String, Long) In Data
            Dim caseName = kvp.Key.Trim
            Dim BBLE = kvp.Value
            Try
                IntranetPortal.ConstructionManage.StartConstruction(BBLE.ToString, caseName, "Melissa Ramlakhan", "Melissa Ramlakhan")

                result.Append(BBLE.ToString & ", " & caseName & " success \n")
            Catch ex As Exception
                result.Append(BBLE.ToString & ", " & caseName & " fails \n")
            End Try
        Next

    End Sub


    Public Sub UpdateOwner()
        Dim Data = New Dictionary(Of String, Long) From {{"114 Adelphi Street ", 3020440071},
  {"1066 Decatur Street", 3034330020},
  {"1108 Jefferson Avenue", 3033880016},
  {"1132 Decatur Street", 3034340017},
  {"1346 Prospect Place", 3013660031},
  {"227 14 Street", 3010340054},
  {"280 Hemlock Street", 3041470052},
  {"297 Quincy ", 3018030067},
  {"35 Bulwar Place", 3038840307},
  {"369 Tompkins ", 3018250001},
  {"39 Woodbine ", 3033480044},
  {"391 Montauk Ave", 3044560079},
  {"414 Halsey Street", 3016640014},
  {"431 Bainbridge Street", 3015050070},
  {"436 Jefferson Avenue", 3031770014},
  {"531 Pine Street ", 3042670016},
  {"571 Lafayette Ave", 3017830059},
  {"629A Madison Street", 3016410070},
  {"65 Van Buren Street", 3017910055},
  {"763 East 224 Street ", 2048380018},
  {"80-76 88 Ave", 4089160028},
  {"811 East 226 street ", 2048510034},
  {"85-40 76 Street ", 4088390025},
  {"880 Lafayette Avenue", 3016090035
}}

        For Each kvp As KeyValuePair(Of String, Long) In Data
            Dim caseName = kvp.Key.Trim
            Dim BBLE = kvp.Value
            IntranetPortal.Data.ConstructionCase.UpdateOwner(BBLE.ToString, "Jamie Ventura")
        Next

    End Sub
End Class


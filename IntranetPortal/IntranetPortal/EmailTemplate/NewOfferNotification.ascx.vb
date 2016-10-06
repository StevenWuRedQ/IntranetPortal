Imports Humanizer
Imports Humanizer.Localisation
Imports IntranetPortal.Data

Public Class NewOfferNotification1
    Inherits EmailTemplateControl


    Public Property TeamView As Boolean = False
    Public Property StartDate As DateTime
    Public Property EndDate As DateTime
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            OfferData = PropertyOfferManage.GetSSAcceptedOfferLastWeek("*", StartDate, EndDate)
        End If
    End Sub

    Public Function HumanizeTimeSpan(ts As TimeSpan?) As String
        If ts.HasValue Then
            Return ts.Value.Humanize(maxUnit:=TimeUnit.Day)
        End If

        Return Nothing
    End Function

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)
        If params.ContainsKey("team") Then
            Dim tm = params("team")
            OfferData = PropertyOfferManage.GetSSAcceptedOfferLastWeek(tm, StartDate, EndDate)
            TeamView = True
        End If
    End Sub

    Public Property Manager As String = "Manager"
    Public Property OfferData As PropertyOffer()
End Class
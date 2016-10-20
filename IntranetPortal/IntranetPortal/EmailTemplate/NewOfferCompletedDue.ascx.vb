Imports Humanizer
Imports Humanizer.Localisation
Imports IntranetPortal.Data

Public Class NewOfferCompletedDue
    Inherits EmailTemplateControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            OfferData = PropertyOfferManage.CompletedNewOfferDue("*", False)
        End If
    End Sub

    Public Function HumanizeTimeSpan(ts As TimeSpan?) As String
        If ts.HasValue Then
            Return ts.Value.Humanize()
        End If

        Return Nothing
    End Function

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)
        If params.ContainsKey("team") Then
            Dim tm = params("team")
            OfferData = PropertyOfferManage.CompletedNewOfferDue(tm, False)
        End If
    End Sub

    Public Property Manager As String = "Manager"
    Public Property OfferData As PropertyOffer()
End Class
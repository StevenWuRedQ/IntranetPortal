Imports DevExpress.XtraCharts
Imports DevExpress.XtraCharts.Native
Imports IntranetPortal.Data

Public Class NewOfferNotification
    Inherits System.Web.UI.Page

    Public Property team As Team
    Public Property Manager As String = "Manager"
    Public Property TeamName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            OfferData = PropertyOfferManage.GetAllSSAcceptedOfferLastWeek()
        End If
    End Sub

    Public Property OfferData As PropertyOffer()

End Class
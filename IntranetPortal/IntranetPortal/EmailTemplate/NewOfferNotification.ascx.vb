Imports IntranetPortal.Data

Public Class NewOfferNotification1
    Inherits EmailTemplateControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            OfferData = PropertyOfferManage.GetAllSSAcceptedOfferLastWeek()
        End If
    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)
        OfferData = PropertyOfferManage.GetAllSSAcceptedOfferLastWeek()
    End Sub

    Public Property Manager As String = "Manager"
    Public Property OfferData As PropertyOffer()
End Class
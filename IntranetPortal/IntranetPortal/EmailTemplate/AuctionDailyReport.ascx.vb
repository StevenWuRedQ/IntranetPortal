Imports IntranetPortal.Data

Public Class AuctionDailyReport
    Inherits EmailTemplateControl

    Public Property AuctionProperties As AuctionProperty()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)
        Dim days = 7

        If params IsNot Nothing AndAlso params.ContainsKey("Days") Then
            days = CInt(params("Days"))
        End If

        Dim startDate = DateTime.Today
        Dim endDate = startDate.AddDays(days)
        AuctionProperties = AuctionProperty.LoadNotifyProperties(startDate, endDate)
    End Sub

End Class
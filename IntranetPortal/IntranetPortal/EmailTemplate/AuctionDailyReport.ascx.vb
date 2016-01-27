Imports IntranetPortal.Data

Public Class AuctionDailyReport
    Inherits EmailTemplateControl

    Public Property AuctionProperties As AuctionProperty()
    Public Property IsWeekly As Boolean
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)
        Dim days = 1

        If params IsNot Nothing Then
            If params.ContainsKey("Days") Then
                days = CInt(params("Days"))
            End If

            If params.ContainsKey("IsWeekly") Then
                IsWeekly = CBool(params("IsWeekly"))

                If IsWeekly Then
                    days = 7
                End If
            End If
        End If

        Dim startDate = DateTime.Today
        Dim endDate = startDate.AddDays(days)
        AuctionProperties = AuctionProperty.LoadNotifyProperties(startDate, endDate)
    End Sub

End Class
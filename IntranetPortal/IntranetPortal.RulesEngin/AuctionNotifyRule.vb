Imports System.Runtime.Serialization
Imports System.Web.Security
Imports IntranetPortal.Data

<DataContract>
Public Class AuctionNotifyRule
    Inherits BaseRule

    Public Property IsWeekly As Boolean = False

    Public Overrides Sub Execute()
        Dim users = Roles.GetUsersInRole("Auction-Manager")
        Dim emails As New List(Of String)
        For Each name In users
            Dim emp = Employee.GetInstance(name)
            If emp IsNot Nothing And emp.Email IsNot Nothing Then
                emails.Add(emp.Email)
            End If
        Next

        Using client As New PortalService.CommonServiceClient
            Dim parms As New Dictionary(Of String, String)
            parms.Add("IsWeekly", IsWeekly)

            Dim subject = "Upcoming Properties Auction - " & DateTime.Today.ToShortDateString
            If IsWeekly Then
                subject = "The Properties Auction in the follow week"
            End If

            client.SendEmailByControl(String.Join(";", emails), subject, "AuctionDailyReport", parms)
        End Using
    End Sub

    Public Enum NotifyType
        Weekly
        Daily
    End Enum
End Class
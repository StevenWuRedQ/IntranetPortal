Imports System.Runtime.Serialization
Imports IntranetPortal.Data

<DataContract>
Public Class AuctionNotifyRule
    Inherits BaseRule

    Public Overrides Sub Execute()

        Dim users = IntranetPortal.Core.PortalSettings.GetValue("AuctionNotifyUsers")

        Dim emails As New List(Of String)
        For Each name In users.Split(";")
            Dim emp = Employee.GetInstance(name)
            If emp IsNot Nothing And emp.Email IsNot Nothing Then
                emails.Add(emp.Email)
            End If
        Next

        Using client As New PortalService.CommonServiceClient
            client.SendEmailByControl(String.Join(";", emails), "The coming Auction Properties - " & DateTime.Today.ToShortDateString, "AuctionDailyReport", Nothing)
        End Using
    End Sub

End Class
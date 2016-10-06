Imports System.Runtime.Serialization
Imports System.Web.Security
Imports IntranetPortal.Data


''' <summary>
''' The Rule to notify the New Offer Acceptance report last week.
''' The notification will send out at every Monday morning and includes
''' 1. send report to watch users that all teams' files accepted by ShortSale
''' 2. send report to team managers that their files were accepted by ShortSale
''' </summary>
<DataContract>
Public Class NewOfferNotifyRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        NotifyShortSale()
        NotifyTeamManager()
    End Sub

    Private Sub NotifyShortSale()
        Dim users = Roles.GetUsersInRole("NewOffer-Notify")
        Dim emails = Employee.GetEmpsEmails(users)

        If String.IsNullOrEmpty(emails) Then
            Log("Can't load new-offer notify emails")
            Return
        End If

        Using client As New PortalService.CommonServiceClient
            Dim subject = "ShortSale Acceptance Report - " & DateTime.Today.ToShortDateString
            Dim params As New Dictionary(Of String, String) From {
                    {"team", "*"}
                }

            client.SendEmailByControl(emails, subject, "NewOfferNotification", params)
            Threading.Thread.Sleep(1000)
        End Using
    End Sub

    Public Sub NotifyTeamManager()
        Dim teams = Core.PortalSettings.GetValue("ActiveTeams")
        Using client As New PortalService.CommonServiceClient
            For Each tm In teams.Split(";")
                Dim users = Roles.GetUsersInRole("OfficeManager-" & tm)
                Dim emails As String = Employee.GetEmpsEmails(users)

                Dim subject = String.Format("ShortSale Acceptance Report for {0} Last Week", tm)
                Dim params As New Dictionary(Of String, String) From {
                        {"team", tm}
                    }

                If String.IsNullOrEmpty(emails) Then
                    Log("Can't load team manager emails - Team: " & tm)
                    Continue For
                End If

                client.SendEmailByControl(emails, subject, "NewOfferNotification", params)
                Threading.Thread.Sleep(3000)
            Next
        End Using
    End Sub
End Class
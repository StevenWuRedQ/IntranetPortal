Imports System.Runtime.Serialization
Imports System.Web.Security
Imports IntranetPortal.Data

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
        End Using
    End Sub

    Public Sub NotifyTeamManager()
        Dim teams = Core.PortalSettings.GetValue("ActiveTeams")
        Using client As New PortalService.CommonServiceClient
            For Each tm In teams.Split(";")
                Dim users = Roles.GetUsersInRole("OfficeManager-" & tm)
                Dim emails As String = Employee.GetEmpsEmails(users)

                Dim subject = String.Format("ShortSale Acceptance Report for {0} - {1}", tm, DateTime.Today.ToShortDateString)
                Dim params As New Dictionary(Of String, String) From {
                        {"team", tm}
                    }

                If String.IsNullOrEmpty(emails) Then
                    Log("Can't load team manager emails - Team: " & tm)
                    Continue For
                End If

                client.SendEmailByControl(emails, subject, "NewOfferNotification", params)
                Threading.Thread.Sleep(1000)
            Next
        End Using
    End Sub
End Class
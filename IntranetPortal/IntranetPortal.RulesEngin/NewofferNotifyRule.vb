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

    Public Property IsWeekly As Boolean = True

    Public Overrides Sub Execute()
        If IsWeekly Then
            NotifyShortSale()
            NotifyTeamManager()
        Else
            NotifyNewOfferDue()
        End If
    End Sub

    ''' <summary>
    ''' Notify if any new offer is due
    ''' include completed and InProcess new offer
    ''' </summary>
    Public Sub NotifyNewOfferDue()
        Dim teams = Core.PortalSettings.GetValue("ActiveTeams")
        Using client As New PortalService.CommonServiceClient
            For Each tm In teams.Split(";")
                If PropertyOfferManage.HasCompletedNewOfferDue(tm) Then
                    Dim emails = LoadEmails(tm, "NewOffer-Notify2")
                    If Not String.IsNullOrEmpty(emails) Then
                        Dim subject = String.Format("Past Due of Completed NewOffer for {0}", tm)
                        Dim params As New Dictionary(Of String, String) From {
                                {"team", tm}
                            }

                        client.SendEmailByControl(emails, subject, "NewOfferCompletedDue", params)
                        Threading.Thread.Sleep(1000)
                    End If
                End If

                If PropertyOfferManage.HasInProcessNewOfferDue(tm) Then
                    Dim emails = LoadEmails(tm, "NewOffer-Notify3")
                    If Not String.IsNullOrEmpty(emails) Then
                        Dim subject = String.Format("Past Due of InProcess NewOffer for {0}", tm)
                        Dim params As New Dictionary(Of String, String) From {
                                {"team", tm}
                            }

                        client.SendEmailByControl(emails, subject, "NewOfferInProcessDue", params)
                        Threading.Thread.Sleep(1000)
                    End If
                End If

                If PropertyOfferManage.HasPendingNewOfferDue(tm) Then
                    Dim emails = LoadEmails(tm, "NewOffer-Notify4")
                    If Not String.IsNullOrEmpty(emails) Then
                        Dim subject = String.Format("Past Due of Pending NewOffer for {0}", tm)
                        Dim params As New Dictionary(Of String, String) From {
                            {"team", tm}
                        }

                        client.SendEmailByControl(emails, subject, "NewOfferPendingDue", params)
                        Threading.Thread.Sleep(1000)
                    End If
                End If
            Next
        End Using
    End Sub

    Private Function LoadEmails(tm As String, roleName As String) As String
        Dim mgr = Team.GetTeam(tm).Manager
        Dim users = Roles.GetUsersInRole(roleName)
        users = users.Concat({mgr}).ToArray
        Dim emails As String = Employee.GetEmpsEmails(users)

        If String.IsNullOrEmpty(emails) Then
            Log("Can't load team manager emails - Team: " & tm)
            Return Nothing
        End If

        Return emails
    End Function

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
                Dim users = Team.GetTeam(tm).Manager
                Dim emails As String = Employee.GetEmpsEmails(users)

                If String.IsNullOrEmpty(emails) Then
                    Log("Can't load team manager emails - Team: " & tm)
                    Continue For
                End If

                Dim subject = String.Format("ShortSale Acceptance Report for {0} Last Week", tm)
                Dim params As New Dictionary(Of String, String) From {
                        {"team", tm}
                    }

                client.SendEmailByControl(emails, subject, "NewOfferNotification", params)
                Threading.Thread.Sleep(3000)
            Next
        End Using
    End Sub
End Class
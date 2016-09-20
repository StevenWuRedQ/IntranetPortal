Imports System.Runtime.Serialization
Imports System.Web.Security
Imports IntranetPortal.Data

<DataContract>
Public Class NewOfferNotifyRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        Dim users = Roles.GetUsersInRole("NewOffer-Notify")
        Dim emails = Employee.GetEmpsEmails(users)

        If String.IsNullOrEmpty(emails) Then
            Log("Can't load new-offer notify emails")
            Return
        End If

        Using client As New PortalService.CommonServiceClient
            Dim subject = "ShortSale Acceptance Report - " & DateTime.Today.ToShortDateString
            client.SendEmailByControl(emails, subject, "NewOfferNotification", Nothing)
        End Using
    End Sub
End Class
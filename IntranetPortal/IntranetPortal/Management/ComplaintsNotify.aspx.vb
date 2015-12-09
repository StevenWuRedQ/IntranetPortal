Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Core
Public Class ComplaintsNotify
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub SendEmailBtn_Click(sender As Object, e As EventArgs)
        If (String.IsNullOrEmpty(JsonOwnedProperties.InnerText)) Then
            SendStatus.Text = "please fill properties owned data"
            Return
        End If

        Dim notifyLeads = JArray.Parse(JsonOwnedProperties.InnerText)

        For Each l In notifyLeads
            If (l.Item("Email") IsNot Nothing) Then
                Dim d = New Dictionary(Of String, String)
                d.Add("Address", l.Item("Address").ToString.Trim)
                d.Add("Status", l.Item("Status").ToString.Trim)
                d.Add("Partner", l.Item("Partner").ToString.Trim)
                d.Add("City", l.Item("City").ToString.Trim)
                d.Add("State", l.Item("State").ToString.Trim)
                d.Add("Zip", l.Item("Zip").ToString.Trim)
                EmailService.SendMail(l.Item("Email").ToString.Trim, l.Item("Email_2").ToString.Trim, "ComplaintsNotify", d)
            End If

        Next
        SendStatus.Text = "Send email finsihed"
    End Sub

End Class
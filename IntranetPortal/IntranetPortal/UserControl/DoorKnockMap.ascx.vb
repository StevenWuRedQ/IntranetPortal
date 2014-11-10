Public Class DoorKnockMap
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim originPoint = Employee.GetProfile(Page.User.Identity.Name).DoornockAddress
            If Not String.IsNullOrEmpty(originPoint) Then
                txtOriginPoint.Text = originPoint
            Else
                txtOriginPoint.Text = "191 Patchen Ave Brooklyn NY 11233"
            End If
        End If
    End Sub

    Protected Sub callbackGetAddress_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If e.Parameter.StartsWith("OriginPoint") Then
            Dim address = e.Parameter.Replace("OriginPoint|", "")
            Dim profile = Employee.GetProfile(Page.User.Identity.Name)
            profile.DoornockAddress = address
            Employee.SaveProfile(Page.User.Identity.Name, profile)
            Return
        End If

        Using Context As New Entities
            Dim addresses = Context.OwnerContacts.Where(Function(c) c.BBLE = e.Parameter And c.ContactType = OwnerContact.OwnerContactType.MailAddress And c.Status = OwnerContact.ContactStatus.DoorKnock).ToList
            If addresses IsNot Nothing AndAlso addresses.Count > 0 Then
                Dim result = addresses.Select(Function(a) a.Contact).ToArray
                For i = 0 To result.Length - 1
                    Dim tmp = result(i)
                    If tmp.IndexOf("(") > 0 Then
                        tmp = tmp.Remove(tmp.IndexOf("("))
                    End If

                    result(i) = tmp
                Next

                e.Result = String.Join("|", result)
                Return
            End If

            Dim lead = Context.LeadsInfoes.Where(Function(ld) ld.BBLE = e.Parameter).SingleOrDefault
            e.Result = lead.PropertyAddress
        End Using
    End Sub
End Class
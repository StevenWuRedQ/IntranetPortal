Public Class DoorKnockMap
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Request.Cookies("OriginPoint") IsNot Nothing Then
                txtOriginPoint.Text = Request.Cookies("OriginPoint").Value
            Else
                txtOriginPoint.Text = "914 Bedford Ave Brooklyn NY 11205"
            End If
        End If
    End Sub

    Protected Sub callbackGetAddress_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
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
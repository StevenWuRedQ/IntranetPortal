Public Class EditHomeOwner
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub popupEditHomeOwner_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        PopupContentHomeOwner.Visible = True
        If e.Parameter.StartsWith("Show") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim ownerName = e.Parameter.Split("|")(2)

            hfBBLE.Value = bble
            hfOwnerName.Value = ownerName

            Using Context As New Entities
                Dim homeOwner = Context.HomeOwners.Where(Function(h) h.BBLE = bble And h.Name = ownerName).FirstOrDefault
                If homeOwner IsNot Nothing Then
                    txtOwnerName.Value = homeOwner.Name

                    Dim TLOLocateReport = homeOwner.TLOLocateReport
                    If TLOLocateReport Is Nothing Then
                        TLOLocateReport = New DataAPI.TLOLocateReportOutput
                    End If

                    If TLOLocateReport.dateOfBirthField IsNot Nothing Then
                        txtAge.Value = TLOLocateReport.dateOfBirthField.currentAgeField
                    End If

                    If TLOLocateReport.dateOfDeathField IsNot Nothing Then
                        rblDeathIndicator.Text = "Death"
                    Else
                        rblDeathIndicator.Text = "Alive"
                    End If

                    If TLOLocateReport.numberOfBankruptciesField > 0 Then
                        rblBankruptcy.Text = "Yes"
                    Else
                        rblBankruptcy.Text = "No"
                    End If

                    txtDescription.InnerText = homeOwner.Description
                End If
            End Using
        End If

        If e.Parameter.StartsWith("Save") Then
            Dim bble = hfBBLE.Value
            Dim ownerName = hfOwnerName.Value

            Using Context As New Entities
                Dim li = Context.LeadsInfoes.Find(bble)
                If li IsNot Nothing Then
                    If li.Owner = ownerName Then
                        li.Owner = txtOwnerName.Value
                    End If

                    If li.CoOwner = ownerName Then
                        li.CoOwner = txtOwnerName.Value
                    End If
                End If

                Dim phones = Context.HomeOwnerPhones.Where(Function(ph) ph.BBLE = bble And ph.OwnerName = ownerName).ToList
                For Each phone In phones
                    phone.OwnerName = txtOwnerName.Value
                Next

                For Each address In Context.HomeOwnerAddresses.Where(Function(ad) ad.BBLE = bble And ad.OwnerName = ownerName).ToList
                    address.OwnerName = txtOwnerName.Value
                Next

                Dim homeOwner = Context.HomeOwners.Where(Function(h) h.BBLE = bble And h.Name = ownerName).FirstOrDefault
                If homeOwner Is Nothing Then
                    homeOwner = New HomeOwner
                    homeOwner.BBLE = bble
                    homeOwner.Name = txtOwnerName.Value
                    homeOwner.CreateBy = Page.User.Identity.Name
                    homeOwner.CreateDate = DateTime.Now
                    Context.HomeOwners.Add(homeOwner)
                End If

                If homeOwner IsNot Nothing Then
                    homeOwner.Name = txtOwnerName.Value

                    Dim TLOLocateReport = homeOwner.TLOLocateReport
                    If TLOLocateReport Is Nothing Then
                        TLOLocateReport = New DataAPI.TLOLocateReportOutput
                    End If

                    If TLOLocateReport.dateOfBirthField IsNot Nothing Then
                        TLOLocateReport.dateOfBirthField.currentAgeField = txtAge.Value
                    Else
                        TLOLocateReport.dateOfBirthField = New DataAPI.BasicDateOfBirthRecord
                        TLOLocateReport.dateOfBirthField.currentAgeField = txtAge.Value
                    End If

                    If rblDeathIndicator.Text = "Death" Then
                        TLOLocateReport.dateOfDeathField = New DataAPI.DateOfDeathRecord
                    Else
                        TLOLocateReport.dateOfDeathField = Nothing
                    End If

                    If rblBankruptcy.Text = "Yes" Then
                        TLOLocateReport.numberOfBankruptciesField = 1
                    Else
                        TLOLocateReport.numberOfBankruptciesField = 0
                    End If

                    homeOwner.TLOLocateReport = TLOLocateReport
                    homeOwner.Description = txtDescription.InnerText
                    homeOwner.UserModified = True
                End If

                Context.SaveChanges()
            End Using
        End If
    End Sub
End Class
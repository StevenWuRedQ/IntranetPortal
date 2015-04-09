Public Class EditHomeOwner
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub popupEditHomeOwner_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        PopupContentHomeOwner.Visible = True

        If e.Parameter.StartsWith("Load") Then
            Dim uniqueId = txtUniqueTLOID.Value
            Dim bble = hfBBLE.Value
            Dim owner = DataWCFService.GetOwnerInfoByTLOId(uniqueId, bble)
            txtOwnerName.Value = owner.Name
            txtDescription.Value = owner.FullAddress
            txtAge.Value = owner.AgeString
            rblDeathIndicator.Text = owner.DeathIndicator
            rblBankruptcy.Text = owner.BankruptcyString

            'owner.BBLE = hfBBLE.Value
            'hfOwnerName.Value = owner.Name
            hfOwnerData.Value = owner.ToJsonString

            Return
        End If

        If e.Parameter.StartsWith("Show") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim ownerName = e.Parameter.Split("|")(2)
            txtUniqueTLOID.Value = ""
            hfOwnerData.Value = ""
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
            If hfOwnerName.Value = IntranetPortal.HomeOwner.EMPTY_HOMEOWNER Then
                ownerName = ""
            End If

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

                If Not String.IsNullOrEmpty(hfOwnerData.Value) Then

                    Dim homeOwner = Newtonsoft.Json.JsonConvert.DeserializeObject(Of HomeOwner)(hfOwnerData.Value)
                    homeOwner.BBLE = bble
                    homeOwner.Name = txtOwnerName.Value
                    homeOwner.CreateBy = Page.User.Identity.Name
                    homeOwner.CreateDate = DateTime.Now
                    Context.HomeOwners.Add(homeOwner)

                    homeOwner.UserModified = True
                    'Load tlo report
                    homeOwner.TLOLocateReport = DataWCFService.GetLocateReport(1, bble, homeOwner.Name, homeOwner.Address1, homeOwner.Address2, homeOwner.City, homeOwner.State, homeOwner.Zip, "USA")

                Else

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
                        homeOwner.UserModified = True
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
                End If
                Context.SaveChanges()
            End Using
        End If
    End Sub
End Class
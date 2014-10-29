Public Class EditHomeOwner
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub popupEditHomeOwner_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        PopupContentHomeOwner.Visible = True
        If e.Parameter.StartsWith("Show") Then
            Dim bble = e.Parameter.Split("|")(0)
            Dim ownerName = e.Parameter.Split("|")(1)

            Using Context As New Entities
                Dim homeOwner = Context.HomeOwners.Where(Function(h) h.BBLE = bble And h.Name = ownerName).FirstOrDefault
                If homeOwner IsNot Nothing Then
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
            Dim bble = e.Parameter.Split("|")(0)
            Dim ownerName = e.Parameter.Split("|")(1)

            Using Context As New Entities
                Dim homeOwner = Context.HomeOwners.Where(Function(h) h.BBLE = bble And h.Name = ownerName).FirstOrDefault
                If homeOwner IsNot Nothing Then
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
                    Context.SaveChanges()
                End If
            End Using
        End If

    End Sub
End Class
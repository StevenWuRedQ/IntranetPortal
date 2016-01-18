Imports IntranetPortal.Data
Public Class FrmAuction
    Private Sub btnSelect_Click(sender As Object, e As EventArgs) Handles btnSelect.Click
        If openDialog.ShowDialog() = DialogResult.OK Then
            TxtFileName.Text = openDialog.FileName
        End If
    End Sub

    Private Sub btnImport_Click(sender As Object, e As EventArgs) Handles btnImport.Click
        Try
            Dim count = AuctionProperty.Import(TxtFileName.Text, "Auction Form")
            MessageBox.Show("Success. total: " & count & " records imported.")
        Catch ex As Exception
            MessageBox.Show("Error. Message: " & ex.Message)
        End Try
    End Sub
End Class
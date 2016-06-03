Imports System.IO
Imports System.Text
Imports iTextSharp.text.pdf

Public Class FrmFillPDF
    Private Sub btnReadFields_Click(sender As Object, e As EventArgs) Handles btnReadFields.Click
        Try
            Dim pdfTemplate = txtFileName.Text
            Me.Text += " - " & pdfTemplate

            Dim pdfReader As New PdfReader(pdfTemplate)

            Dim sb As New StringBuilder

            For Each de In pdfReader.AcroFields.Fields
                sb.Append(de.Key.ToString & Environment.NewLine)
                dgvFields.Rows.Add(de.Key, Nothing)
            Next

            txtResult.Text = sb.ToString
            txtResult.SelectionStart = 0
        Catch ex As Exception
            MessageBox.Show("Error. Message: " & ex.Message)
        End Try
    End Sub

    Private Sub btnBrowse_Click(sender As Object, e As EventArgs) Handles btnBrowse.Click
        If openDialog.ShowDialog() = DialogResult.OK Then
            txtFileName.Text = openDialog.FileName
        End If
    End Sub

    Private Sub btnTagFields_Click(sender As Object, e As EventArgs) Handles btnTagFields.Click
        If String.IsNullOrEmpty(txtFileName.Text) Then
            MessageBox.Show("Please select file.")
            Return
        End If

        Dim pdfTemplate = txtFileName.Text
        If SaveDialog.ShowDialog = DialogResult.OK Then
            Dim newFile = SaveDialog.FileName
            Dim pdfReader As New PdfReader(pdfTemplate)
            Dim pdfNewFile = New PdfStamper(pdfReader, New FileStream(newFile, FileMode.Create))

            Dim pdfFormFields = pdfNewFile.AcroFields

            For Each row As DataGridViewRow In dgvFields.Rows
                Dim result = row.Cells(1).Value
                If result = Nothing Then
                    result = ""
                End If

                pdfFormFields.SetField(row.Cells(0).Value.ToString, result)
            Next

            pdfNewFile.FormFlattening = False
            pdfNewFile.Close()

            MessageBox.Show("Generate Successed.")
        End If
    End Sub

    Private Sub btnLabelFields_Click(sender As Object, e As EventArgs) Handles btnLabelFields.Click
        If String.IsNullOrEmpty(txtFileName.Text) Then
            MessageBox.Show("Please select file.")
            Return
        End If

        Dim pdfTemplate = txtFileName.Text
        If SaveDialog.ShowDialog = DialogResult.OK Then
            Dim newFile = SaveDialog.FileName
            Dim pdfReader As New PdfReader(pdfTemplate)
            Dim pdfNewFile = New PdfStamper(pdfReader, New FileStream(newFile, FileMode.Create))

            Dim pdfFormFields = pdfNewFile.AcroFields

            For Each row In txtResult.Lines
                pdfFormFields.SetField(row, row)
            Next

            pdfNewFile.FormFlattening = False
            pdfNewFile.Close()

            MessageBox.Show("Generate Successed.")
        End If
    End Sub
End Class
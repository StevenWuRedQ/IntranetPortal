<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FrmAuction
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.btnSelect = New System.Windows.Forms.Button()
        Me.TxtFileName = New System.Windows.Forms.TextBox()
        Me.openDialog = New System.Windows.Forms.OpenFileDialog()
        Me.btnImport = New System.Windows.Forms.Button()
        Me.btnNotifyRule = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'btnSelect
        '
        Me.btnSelect.Location = New System.Drawing.Point(197, 12)
        Me.btnSelect.Name = "btnSelect"
        Me.btnSelect.Size = New System.Drawing.Size(75, 23)
        Me.btnSelect.TabIndex = 0
        Me.btnSelect.Text = "Select File"
        Me.btnSelect.UseVisualStyleBackColor = True
        '
        'TxtFileName
        '
        Me.TxtFileName.Location = New System.Drawing.Point(12, 14)
        Me.TxtFileName.Name = "TxtFileName"
        Me.TxtFileName.Size = New System.Drawing.Size(179, 20)
        Me.TxtFileName.TabIndex = 1
        '
        'openDialog
        '
        Me.openDialog.FileName = "OpenFileDialog1"
        '
        'btnImport
        '
        Me.btnImport.Location = New System.Drawing.Point(12, 40)
        Me.btnImport.Name = "btnImport"
        Me.btnImport.Size = New System.Drawing.Size(75, 23)
        Me.btnImport.TabIndex = 2
        Me.btnImport.Text = "Import"
        Me.btnImport.UseVisualStyleBackColor = True
        '
        'btnNotifyRule
        '
        Me.btnNotifyRule.Location = New System.Drawing.Point(13, 70)
        Me.btnNotifyRule.Name = "btnNotifyRule"
        Me.btnNotifyRule.Size = New System.Drawing.Size(133, 23)
        Me.btnNotifyRule.TabIndex = 3
        Me.btnNotifyRule.Text = "Execute Notify Rule"
        Me.btnNotifyRule.UseVisualStyleBackColor = True
        '
        'FrmAuction
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(295, 261)
        Me.Controls.Add(Me.btnNotifyRule)
        Me.Controls.Add(Me.btnImport)
        Me.Controls.Add(Me.TxtFileName)
        Me.Controls.Add(Me.btnSelect)
        Me.Name = "FrmAuction"
        Me.Text = "Auction"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents btnSelect As Button
    Friend WithEvents TxtFileName As TextBox
    Friend WithEvents openDialog As OpenFileDialog
    Friend WithEvents btnImport As Button
    Friend WithEvents btnNotifyRule As Button
End Class

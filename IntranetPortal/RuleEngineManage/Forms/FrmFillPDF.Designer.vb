<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FrmFillPDF
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
        Me.btnReadFields = New System.Windows.Forms.Button()
        Me.txtFileName = New System.Windows.Forms.TextBox()
        Me.btnBrowse = New System.Windows.Forms.Button()
        Me.txtResult = New System.Windows.Forms.TextBox()
        Me.openDialog = New System.Windows.Forms.OpenFileDialog()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.btnTagFields = New System.Windows.Forms.Button()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.dgvFields = New System.Windows.Forms.DataGridView()
        Me.colName = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.colValue = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.SaveDialog = New System.Windows.Forms.SaveFileDialog()
        Me.btnLabelFields = New System.Windows.Forms.Button()
        Me.Panel1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        CType(Me.dgvFields, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'btnReadFields
        '
        Me.btnReadFields.Location = New System.Drawing.Point(7, 39)
        Me.btnReadFields.Name = "btnReadFields"
        Me.btnReadFields.Size = New System.Drawing.Size(84, 23)
        Me.btnReadFields.TabIndex = 0
        Me.btnReadFields.Text = "Read Fields"
        Me.btnReadFields.UseVisualStyleBackColor = True
        '
        'txtFileName
        '
        Me.txtFileName.Location = New System.Drawing.Point(8, 13)
        Me.txtFileName.Name = "txtFileName"
        Me.txtFileName.Size = New System.Drawing.Size(209, 20)
        Me.txtFileName.TabIndex = 1
        '
        'btnBrowse
        '
        Me.btnBrowse.Location = New System.Drawing.Point(223, 11)
        Me.btnBrowse.Name = "btnBrowse"
        Me.btnBrowse.Size = New System.Drawing.Size(72, 23)
        Me.btnBrowse.TabIndex = 2
        Me.btnBrowse.Text = "Select File"
        Me.btnBrowse.UseVisualStyleBackColor = True
        '
        'txtResult
        '
        Me.txtResult.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtResult.Location = New System.Drawing.Point(3, 16)
        Me.txtResult.Multiline = True
        Me.txtResult.Name = "txtResult"
        Me.txtResult.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtResult.Size = New System.Drawing.Size(540, 205)
        Me.txtResult.TabIndex = 3
        '
        'openDialog
        '
        Me.openDialog.FileName = "OpenFileDialog1"
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.btnLabelFields)
        Me.Panel1.Controls.Add(Me.btnTagFields)
        Me.Panel1.Controls.Add(Me.txtFileName)
        Me.Panel1.Controls.Add(Me.btnReadFields)
        Me.Panel1.Controls.Add(Me.btnBrowse)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(546, 75)
        Me.Panel1.TabIndex = 4
        '
        'btnTagFields
        '
        Me.btnTagFields.Location = New System.Drawing.Point(97, 39)
        Me.btnTagFields.Name = "btnTagFields"
        Me.btnTagFields.Size = New System.Drawing.Size(88, 23)
        Me.btnTagFields.TabIndex = 3
        Me.btnTagFields.Text = "Custom Fields"
        Me.btnTagFields.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.dgvFields)
        Me.GroupBox1.Controls.Add(Me.txtResult)
        Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupBox1.Location = New System.Drawing.Point(0, 75)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(546, 224)
        Me.GroupBox1.TabIndex = 5
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Fields List"
        '
        'dgvFields
        '
        Me.dgvFields.AllowUserToAddRows = False
        Me.dgvFields.AllowUserToDeleteRows = False
        Me.dgvFields.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvFields.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.colName, Me.colValue})
        Me.dgvFields.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvFields.Location = New System.Drawing.Point(3, 16)
        Me.dgvFields.Name = "dgvFields"
        Me.dgvFields.Size = New System.Drawing.Size(540, 205)
        Me.dgvFields.TabIndex = 4
        '
        'colName
        '
        Me.colName.HeaderText = "Field Name"
        Me.colName.Name = "colName"
        Me.colName.ReadOnly = True
        '
        'colValue
        '
        Me.colValue.HeaderText = "Field Value"
        Me.colValue.Name = "colValue"
        '
        'SaveDialog
        '
        Me.SaveDialog.DefaultExt = "pdf"
        Me.SaveDialog.Filter = "PDF files|*.pdf|All Files|*.*"
        '
        'btnLabelFields
        '
        Me.btnLabelFields.Location = New System.Drawing.Point(191, 39)
        Me.btnLabelFields.Name = "btnLabelFields"
        Me.btnLabelFields.Size = New System.Drawing.Size(75, 23)
        Me.btnLabelFields.TabIndex = 4
        Me.btnLabelFields.Text = "Tag Fields"
        Me.btnLabelFields.UseVisualStyleBackColor = True
        '
        'FrmFillPDF
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(546, 299)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.Panel1)
        Me.Name = "FrmFillPDF"
        Me.Text = "Fill Up"
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        CType(Me.dgvFields, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents btnReadFields As Button
    Friend WithEvents txtFileName As TextBox
    Friend WithEvents btnBrowse As Button
    Friend WithEvents txtResult As TextBox
    Friend WithEvents openDialog As OpenFileDialog
    Friend WithEvents Panel1 As Panel
    Friend WithEvents GroupBox1 As GroupBox
    Friend WithEvents btnTagFields As Button
    Friend WithEvents SaveDialog As SaveFileDialog
    Friend WithEvents dgvFields As DataGridView
    Friend WithEvents colName As DataGridViewTextBoxColumn
    Friend WithEvents colValue As DataGridViewTextBoxColumn
    Friend WithEvents btnLabelFields As Button
End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FrmHomeowner
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
        Me.btnLoadOwner = New System.Windows.Forms.Button()
        Me.txtRunning = New System.Windows.Forms.TextBox()
        Me.txtTotal = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.ServiceController1 = New System.ServiceProcess.ServiceController()
        Me.btnStop = New System.Windows.Forms.Button()
        Me.btnLoadPhone = New System.Windows.Forms.Button()
        Me.btnSavePhone = New System.Windows.Forms.Button()
        Me.txtBBLEs = New System.Windows.Forms.TextBox()
        Me.chkBBLes = New System.Windows.Forms.CheckBox()
        Me.chkUseThreads = New System.Windows.Forms.CheckBox()
        Me.SuspendLayout()
        '
        'btnLoadOwner
        '
        Me.btnLoadOwner.Location = New System.Drawing.Point(12, 12)
        Me.btnLoadOwner.Name = "btnLoadOwner"
        Me.btnLoadOwner.Size = New System.Drawing.Size(82, 23)
        Me.btnLoadOwner.TabIndex = 0
        Me.btnLoadOwner.Text = "Load SSN"
        Me.btnLoadOwner.UseVisualStyleBackColor = True
        '
        'txtRunning
        '
        Me.txtRunning.Location = New System.Drawing.Point(100, 14)
        Me.txtRunning.Name = "txtRunning"
        Me.txtRunning.Size = New System.Drawing.Size(42, 20)
        Me.txtRunning.TabIndex = 1
        Me.txtRunning.Text = "0"
        '
        'txtTotal
        '
        Me.txtTotal.Location = New System.Drawing.Point(162, 14)
        Me.txtTotal.Name = "txtTotal"
        Me.txtTotal.Size = New System.Drawing.Size(81, 20)
        Me.txtTotal.TabIndex = 2
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(146, 17)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(12, 13)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "/"
        '
        'btnStop
        '
        Me.btnStop.Location = New System.Drawing.Point(188, 41)
        Me.btnStop.Name = "btnStop"
        Me.btnStop.Size = New System.Drawing.Size(82, 23)
        Me.btnStop.TabIndex = 4
        Me.btnStop.Text = "Stop"
        Me.btnStop.UseVisualStyleBackColor = True
        '
        'btnLoadPhone
        '
        Me.btnLoadPhone.Location = New System.Drawing.Point(12, 40)
        Me.btnLoadPhone.Name = "btnLoadPhone"
        Me.btnLoadPhone.Size = New System.Drawing.Size(82, 23)
        Me.btnLoadPhone.TabIndex = 5
        Me.btnLoadPhone.Text = "Load Phones"
        Me.btnLoadPhone.UseVisualStyleBackColor = True
        '
        'btnSavePhone
        '
        Me.btnSavePhone.Location = New System.Drawing.Point(100, 40)
        Me.btnSavePhone.Name = "btnSavePhone"
        Me.btnSavePhone.Size = New System.Drawing.Size(82, 23)
        Me.btnSavePhone.TabIndex = 6
        Me.btnSavePhone.Text = "Save Phones"
        Me.btnSavePhone.UseVisualStyleBackColor = True
        '
        'txtBBLEs
        '
        Me.txtBBLEs.Location = New System.Drawing.Point(100, 69)
        Me.txtBBLEs.Multiline = True
        Me.txtBBLEs.Name = "txtBBLEs"
        Me.txtBBLEs.Size = New System.Drawing.Size(257, 72)
        Me.txtBBLEs.TabIndex = 7
        Me.txtBBLEs.Text = "3041500060 "
        Me.txtBBLEs.Visible = False
        '
        'chkBBLes
        '
        Me.chkBBLes.AutoSize = True
        Me.chkBBLes.Location = New System.Drawing.Point(13, 70)
        Me.chkBBLes.Name = "chkBBLes"
        Me.chkBBLes.Size = New System.Drawing.Size(58, 17)
        Me.chkBBLes.TabIndex = 8
        Me.chkBBLes.Text = "BBLEs"
        Me.chkBBLes.UseVisualStyleBackColor = True
        '
        'chkUseThreads
        '
        Me.chkUseThreads.AutoSize = True
        Me.chkUseThreads.Location = New System.Drawing.Point(13, 93)
        Me.chkUseThreads.Name = "chkUseThreads"
        Me.chkUseThreads.Size = New System.Drawing.Size(87, 17)
        Me.chkUseThreads.TabIndex = 9
        Me.chkUseThreads.Text = "Use Threads"
        Me.chkUseThreads.UseVisualStyleBackColor = True
        '
        'FrmHomeowner
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(398, 155)
        Me.Controls.Add(Me.chkUseThreads)
        Me.Controls.Add(Me.chkBBLes)
        Me.Controls.Add(Me.txtBBLEs)
        Me.Controls.Add(Me.btnSavePhone)
        Me.Controls.Add(Me.btnLoadPhone)
        Me.Controls.Add(Me.btnStop)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.txtTotal)
        Me.Controls.Add(Me.txtRunning)
        Me.Controls.Add(Me.btnLoadOwner)
        Me.Name = "FrmHomeowner"
        Me.Text = "FrmHomeowner"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents btnLoadOwner As Button
    Friend WithEvents txtRunning As TextBox
    Friend WithEvents txtTotal As TextBox
    Friend WithEvents Label1 As Label
    Friend WithEvents ServiceController1 As ServiceProcess.ServiceController
    Friend WithEvents btnStop As Button
    Friend WithEvents btnLoadPhone As Button
    Friend WithEvents btnSavePhone As Button
    Friend WithEvents txtBBLEs As TextBox
    Friend WithEvents chkBBLes As CheckBox
    Friend WithEvents chkUseThreads As CheckBox
End Class

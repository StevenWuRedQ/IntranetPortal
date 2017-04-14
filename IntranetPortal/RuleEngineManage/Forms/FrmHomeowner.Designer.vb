<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class FrmHomeowner
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
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
    <System.Diagnostics.DebuggerStepThrough()>
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
        Me.chkSSN = New System.Windows.Forms.CheckBox()
        Me.chkPhone = New System.Windows.Forms.CheckBox()
        Me.BtnUpdateTLO = New System.Windows.Forms.Button()
        Me.ThreadCount = New System.Windows.Forms.TextBox()
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
        Me.btnSavePhone.Text = "Save Data"
        Me.btnSavePhone.UseVisualStyleBackColor = True
        '
        'txtBBLEs
        '
        Me.txtBBLEs.Location = New System.Drawing.Point(100, 69)
        Me.txtBBLEs.Multiline = True
        Me.txtBBLEs.Name = "txtBBLEs"
        Me.txtBBLEs.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtBBLEs.Size = New System.Drawing.Size(257, 72)
        Me.txtBBLEs.TabIndex = 7
        Me.txtBBLEs.Text = "BBLE/Owner Id"
        '
        'chkBBLes
        '
        Me.chkBBLes.AutoSize = True
        Me.chkBBLes.Location = New System.Drawing.Point(13, 70)
        Me.chkBBLes.Name = "chkBBLes"
        Me.chkBBLes.Size = New System.Drawing.Size(55, 17)
        Me.chkBBLes.TabIndex = 8
        Me.chkBBLes.Text = "Inputs"
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
        'chkSSN
        '
        Me.chkSSN.AutoSize = True
        Me.chkSSN.Location = New System.Drawing.Point(269, 14)
        Me.chkSSN.Name = "chkSSN"
        Me.chkSSN.Size = New System.Drawing.Size(48, 17)
        Me.chkSSN.TabIndex = 10
        Me.chkSSN.Text = "SSN"
        Me.chkSSN.UseVisualStyleBackColor = True
        '
        'chkPhone
        '
        Me.chkPhone.AutoSize = True
        Me.chkPhone.Location = New System.Drawing.Point(324, 14)
        Me.chkPhone.Name = "chkPhone"
        Me.chkPhone.Size = New System.Drawing.Size(57, 17)
        Me.chkPhone.TabIndex = 11
        Me.chkPhone.Text = "Phone"
        Me.chkPhone.UseVisualStyleBackColor = True
        '
        'BtnUpdateTLO
        '
        Me.BtnUpdateTLO.Location = New System.Drawing.Point(13, 163)
        Me.BtnUpdateTLO.Name = "BtnUpdateTLO"
        Me.BtnUpdateTLO.Size = New System.Drawing.Size(75, 23)
        Me.BtnUpdateTLO.TabIndex = 12
        Me.BtnUpdateTLO.Text = "UPdate TLO"
        Me.BtnUpdateTLO.UseVisualStyleBackColor = True
        '
        'ThreadCount
        '
        Me.ThreadCount.Location = New System.Drawing.Point(94, 165)
        Me.ThreadCount.Name = "ThreadCount"
        Me.ThreadCount.Size = New System.Drawing.Size(100, 20)
        Me.ThreadCount.TabIndex = 13
        Me.ThreadCount.Text = "3"
        '
        'FrmHomeowner
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(445, 255)
        Me.Controls.Add(Me.ThreadCount)
        Me.Controls.Add(Me.BtnUpdateTLO)
        Me.Controls.Add(Me.chkPhone)
        Me.Controls.Add(Me.chkSSN)
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
    Friend WithEvents chkSSN As CheckBox
    Friend WithEvents chkPhone As CheckBox
    Friend WithEvents BtnUpdateTLO As Button
    Friend WithEvents ThreadCount As TextBox
End Class

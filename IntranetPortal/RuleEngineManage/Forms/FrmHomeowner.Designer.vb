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
        Me.SuspendLayout()
        '
        'btnLoadOwner
        '
        Me.btnLoadOwner.Location = New System.Drawing.Point(12, 12)
        Me.btnLoadOwner.Name = "btnLoadOwner"
        Me.btnLoadOwner.Size = New System.Drawing.Size(75, 23)
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
        Me.btnStop.Location = New System.Drawing.Point(12, 41)
        Me.btnStop.Name = "btnStop"
        Me.btnStop.Size = New System.Drawing.Size(75, 23)
        Me.btnStop.TabIndex = 4
        Me.btnStop.Text = "Stop"
        Me.btnStop.UseVisualStyleBackColor = True
        '
        'FrmHomeowner
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(304, 155)
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
End Class

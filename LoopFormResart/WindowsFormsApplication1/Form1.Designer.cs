namespace DroneManage
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.ProcessGrid = new System.Windows.Forms.DataGridView();
            this.CheckLoop = new System.Windows.Forms.CheckBox();
            this.StartMonitoring = new System.Windows.Forms.Button();
            this.AutoSetTask = new System.Windows.Forms.Button();
            this.btnCloseDialog = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.openFIle = new System.Windows.Forms.Button();
            this.tbFilePath = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.ProcessGrid)).BeginInit();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(12, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(94, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "CheckStatus";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // ProcessGrid
            // 
            this.ProcessGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.ProcessGrid.Location = new System.Drawing.Point(0, 117);
            this.ProcessGrid.Name = "ProcessGrid";
            this.ProcessGrid.Size = new System.Drawing.Size(811, 150);
            this.ProcessGrid.TabIndex = 1;
            // 
            // CheckLoop
            // 
            this.CheckLoop.AutoSize = true;
            this.CheckLoop.Location = new System.Drawing.Point(131, 16);
            this.CheckLoop.Name = "CheckLoop";
            this.CheckLoop.Size = new System.Drawing.Size(92, 17);
            this.CheckLoop.TabIndex = 2;
            this.CheckLoop.Text = "Cheking Loop";
            this.CheckLoop.UseVisualStyleBackColor = true;
            this.CheckLoop.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // StartMonitoring
            // 
            this.StartMonitoring.Location = new System.Drawing.Point(12, 41);
            this.StartMonitoring.Name = "StartMonitoring";
            this.StartMonitoring.Size = new System.Drawing.Size(94, 23);
            this.StartMonitoring.TabIndex = 4;
            this.StartMonitoring.Text = "Start Monitoring";
            this.StartMonitoring.UseVisualStyleBackColor = true;
            this.StartMonitoring.Click += new System.EventHandler(this.Start_Click);
            // 
            // AutoSetTask
            // 
            this.AutoSetTask.Location = new System.Drawing.Point(131, 39);
            this.AutoSetTask.Name = "AutoSetTask";
            this.AutoSetTask.Size = new System.Drawing.Size(75, 23);
            this.AutoSetTask.TabIndex = 5;
            this.AutoSetTask.Text = "Auto Set Task 4 File";
            this.AutoSetTask.UseVisualStyleBackColor = true;
            this.AutoSetTask.Click += new System.EventHandler(this.AutoSetTask_Click);
            // 
            // btnCloseDialog
            // 
            this.btnCloseDialog.Location = new System.Drawing.Point(273, 39);
            this.btnCloseDialog.Name = "btnCloseDialog";
            this.btnCloseDialog.Size = new System.Drawing.Size(75, 23);
            this.btnCloseDialog.TabIndex = 6;
            this.btnCloseDialog.Text = "Close Dialog";
            this.btnCloseDialog.UseVisualStyleBackColor = true;
            this.btnCloseDialog.Click += new System.EventHandler(this.btnCloseDialog_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            this.openFileDialog1.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog1_FileOk);
            // 
            // openFIle
            // 
            this.openFIle.Location = new System.Drawing.Point(376, 41);
            this.openFIle.Name = "openFIle";
            this.openFIle.Size = new System.Drawing.Size(75, 23);
            this.openFIle.TabIndex = 7;
            this.openFIle.Text = "Open File";
            this.openFIle.UseVisualStyleBackColor = true;
            this.openFIle.Click += new System.EventHandler(this.openFIle_Click);
            // 
            // tbFilePath
            // 
            this.tbFilePath.Location = new System.Drawing.Point(107, 82);
            this.tbFilePath.Name = "tbFilePath";
            this.tbFilePath.Size = new System.Drawing.Size(366, 20);
            this.tbFilePath.TabIndex = 8;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(22, 85);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(79, 13);
            this.label1.TabIndex = 9;
            this.label1.Text = "Drone File path";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(811, 519);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.tbFilePath);
            this.Controls.Add(this.openFIle);
            this.Controls.Add(this.btnCloseDialog);
            this.Controls.Add(this.AutoSetTask);
            this.Controls.Add(this.StartMonitoring);
            this.Controls.Add(this.CheckLoop);
            this.Controls.Add(this.ProcessGrid);
            this.Controls.Add(this.button1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.ProcessGrid)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.DataGridView ProcessGrid;
        private System.Windows.Forms.CheckBox CheckLoop;
        private System.Windows.Forms.Button StartMonitoring;
        private System.Windows.Forms.Button AutoSetTask;
        private System.Windows.Forms.Button btnCloseDialog;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Button openFIle;
        private System.Windows.Forms.TextBox tbFilePath;
        private System.Windows.Forms.Label label1;
    }
}


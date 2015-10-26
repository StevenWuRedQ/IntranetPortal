namespace WindowsFormsApplication1
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
            this.Restart = new System.Windows.Forms.Button();
            this.Start = new System.Windows.Forms.Button();
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
            this.ProcessGrid.Location = new System.Drawing.Point(1, 84);
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
            // Restart
            // 
            this.Restart.Location = new System.Drawing.Point(242, 10);
            this.Restart.Name = "Restart";
            this.Restart.Size = new System.Drawing.Size(75, 23);
            this.Restart.TabIndex = 3;
            this.Restart.Text = "Restart";
            this.Restart.UseVisualStyleBackColor = true;
            this.Restart.Click += new System.EventHandler(this.Restart_Click);
            // 
            // Start
            // 
            this.Start.Location = new System.Drawing.Point(12, 41);
            this.Start.Name = "Start";
            this.Start.Size = new System.Drawing.Size(75, 23);
            this.Start.TabIndex = 4;
            this.Start.Text = "Start";
            this.Start.UseVisualStyleBackColor = true;
            this.Start.Click += new System.EventHandler(this.Start_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(811, 519);
            this.Controls.Add(this.Start);
            this.Controls.Add(this.Restart);
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
        private System.Windows.Forms.Button Restart;
        private System.Windows.Forms.Button Start;
    }
}


using log4net;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            log4net.Config.XmlConfigurator.Configure();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            showProcess();
        }
        private void showProcess()
        {

            ProcessGrid.DataSource = GetDroneMain().Select(clsProcess => new { Name = clsProcess.ProcessName, Responding = clsProcess.Responding });
        }
        private List<Process> GetDroneMain()
        {
            var name = "TestComponent_VB";
            var process_list = new List<Process>();
            foreach (Process clsProcess in Process.GetProcesses())
            {

                if (clsProcess.ProcessName.Contains(name))
                {


                    //if the process is found to be running then we
                    //return a true
                    process_list.Add(clsProcess);
                    //process_list.Add();

                }
            }
            return process_list;
        }
        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            CheckLoop.Text = CheckLoop.Checked ? "" : "";
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Restart_Click(object sender, EventArgs e)
        {
            using (var client = new WCFAPI.WCFMacrosClient())
            {

            }
        }
        private readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        public delegate void StatusChangeDelegate(String status);
        private StatusChangeDelegate statusChangeListener;
        private int DroneResponseCount = 0;
        private const string MAIN_DRONE_PATH = "C:\\VS2013 Development\\TestComponent_VB\\TestComponent_VB\\bin\\Debug\\TestComponent_VB.exe";
        private bool is_resarting = false;


        public void OnStart()
        {
            try
            {
                System.Timers.Timer timer = new System.Timers.Timer();
                int interval = ReadAppSettings();
                log.Debug("set timer interval is " + interval);
                timer.Interval = 1000 * 60 * interval;//*5*6; // 5 mintues 
                timer.Elapsed += new System.Timers.ElapsedEventHandler(this.ScanDroneMain);
                timer.Start();
            }catch(Exception e)
            {
                log.Debug(e);
            }
           

            //ChangeSatus("Start");
        }
        public static int ReadAppSettings()
        {
            try
            {
                // Get the AppSettings section.
                NameValueCollection appSettings =
                   ConfigurationManager.AppSettings;

                return Int32.Parse(appSettings.Get("TimerInterval"));
               
            }
            catch (ConfigurationErrorsException e)
            {
                throw e;
            }
        }
        public void ScanDroneMain(object sender, System.Timers.ElapsedEventArgs args)
        {

            try
            {
                log.Debug("====================Scan Start=======================");
                using (WCFAPI.WCFMacrosClient client = new WCFAPI.WCFMacrosClient())
                {
                    try
                    {

                        log.Debug("dorne waiting count : (" + client.Requests_Waiting() + ") Reset respose count = 0");
                        if (is_resarting)
                        {
                            is_resarting = false;
                            log.Debug("start Drone completed! mark is_resarting as false");
                        }
                        DroneResponseCount = 0;
                    }
                    catch
                    {
                        DroneResponseCount++;
                        log.Debug("increse Drone not Response Count to: (" + DroneResponseCount + ")");

                    }

                }

                if (DroneResponseCount >= 3 && !is_resarting)
                {
                    log.Debug("Server not response in 3 times starting resart it");

                    ResartDrone();

                }
                log.Debug("====================Scan End=======================");
            }
            catch (Exception ex)
            {
                log.Error(ex);
            }


        }

        private Process GetDroneMainProcess()
        {
            var drones = GetDroneMain();
            var mainDrone = drones.Count > 0 ? drones[0] : null;
            return mainDrone;
        }
        private void ResartDrone()
        {
            /* lock the restarting process*/
            if (is_resarting == true)
            {
                log.Debug("is resarting the main drone ingrone this time");
                return;
            }
            is_resarting = true;
            log.Debug("************start resart main drone***************");
            var drones = GetDroneMain();
            var mainDrone = drones.Count > 0 ? drones[0] : null;

            if (mainDrone == null)
            {
                log.Debug("Can not find drone run in system then run it!");
                mainDrone = Process.Start(MAIN_DRONE_PATH);
                mainDrone.WaitForInputIdle();
            }
            else
            {
                log.Debug("Start run drone process");
                
                mainDrone.Kill();
                mainDrone.WaitForExit();

                log.Debug("Closed main drone completed! Start resart drone process");
                mainDrone = Process.Start(MAIN_DRONE_PATH);
                mainDrone.WaitForInputIdle();
            }
            log.Debug("resart Drone Completed");
            log.Debug("***********end resart main drone****************");

        }

        public void SetStatusChangeListener(StatusChangeDelegate del)
        {
            statusChangeListener = del;
        }
        protected void OnStop()
        {
            log.Debug("On Stop");
            ChangeSatus("Stop");
        }

        private void ChangeSatus(String status)
        {
            if (statusChangeListener != null)
            {
                statusChangeListener(status);
            }

        }

        private void Start_Click(object sender, EventArgs e)
        {
            OnStart();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}


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
using Newtonsoft.Json.Linq;
using System.IO;
using System.Runtime.InteropServices;
using DroneManage;
using Newtonsoft.Json;


namespace DroneManage
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
            }
            catch (Exception e)
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
                    log.Debug("Server not response in 3 times starting resart it and send email to DEV team.");
                    using (var srv = new PortalService.CommonServiceClient())
                    {
                        srv.SendEmailByAddress("georgev@myidealprop.com;stevenw@myidealprop.com;chrisy@myidealprop.com", null,
                            "Drone is not response  restarting it ",
                            "Hi All,<br> <br> Drone on (" + System.Environment.MachineName + ") is not response the monitor program is restart it ! please notice !!");
                    }
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
        private JArray GetNeedRunBBlEs()
        {
            JArray BBLes = JArray.Parse(File.ReadAllText(@"BBlEs.json"));

            return BBLes;
        }
        public readonly static string DATAPATH = @"data.json";
        private Object ReadData(string key)
        {
            return JObject.Parse(File.ReadAllText(DATAPATH))[key];
        }
        void SetData(string key, string val)
        {
            var data = JObject.Parse(File.ReadAllText(DATAPATH));
            var property = data.Property(key);
            property.Value = val;
            File.WriteAllText(DATAPATH, data.ToString());
        }
        void SetData(string key, int val)
        {
            var data = JObject.Parse(File.ReadAllText(DATAPATH));
            var property = data.Property(key);
            property.Value = val;
            File.WriteAllText(DATAPATH, data.ToString());
        }
        private JArray NeedRunBBLEs;
        public void SendToDrone(object sender, System.Timers.ElapsedEventArgs args)
        {
            log.Debug("======================start send bble to drone======================================");
            if (is_resarting)
            {
                log.Debug("server is restaring please check drone give up this time !");
                return;
            }
            try
            {
                if (NeedRunBBLEs == null)
                {
                    NeedRunBBLEs = GetNeedRunBBlEs();
                    if (NeedRunBBLEs == null)
                    {
                        log.Debug("can not find bbles in file BBlEs.json please check.");
                    }

                }



                //Loop 
                using (var client = new WCFAPI.WCFMacrosClient())
                {

                    var waitingCount = -1;
                    try
                    {
                         waitingCount = client.Requests_Waiting();
                    }
                    catch
                    {
                        log.Debug("Some time error Requests_Waiting if want know detail please use break point!");
                        waitingCount = -1;
                    }
                  
                    var needAdd = 20 - waitingCount;
                    if (needAdd > 0 && waitingCount>=0)
                    {


                        int RanCount = Convert.ToInt32(ReadData("RanCount"));

                        for (var i = 0; i < needAdd; i++)
                        {

                            RanCount++;
                            if (RanCount < NeedRunBBLEs.Count())
                            {
                                int apiOrder = (new Random()).Next(1000, 2000);
                                var bble = NeedRunBBLEs.ToList()[RanCount].ToString();
                                client.GetPropdata(bble, apiOrder, true, true, true, true, true, false);
                                client.Get_Servicer(apiOrder, bble);
                                log.Debug(String.Format("Request BBLE: {0} in ({1}/{2})  waiting request is ({3})", bble, RanCount, NeedRunBBLEs.Count, waitingCount));
                                SetData("RanCount", RanCount);
                            }
                            else
                            {
                                log.Debug("***********end of Send request loop***********");
                            }
                        }
                        
                    }
                    else
                    {
                        log.Debug("Loop has (" + waitingCount.ToString() + ") waitingCount is busy now");
                    }

                }
            }
            catch (Exception ex)
            {
                log.Debug(ex);
            }
            log.Debug("======================end send bble to drone======================================");
        }
        private void AutoSetTask_Click(object sender, EventArgs e)
        {

            System.Timers.Timer timer = new System.Timers.Timer();
            timer.Interval = 1000 * 60 * 1;//*5*6; // 5 mintues 
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.SendToDrone);
            timer.Start();

        }


        private void btnCloseDialog_Click(object sender, EventArgs e)
        {
           
            var main = GetDroneMainProcess();
            List<SubWindows> wnds = 
            User32.FindWindowInProcess(main, (messagetext) =>
                    messagetext.Length > 0
                    );

            log.Debug("==========Scaned sub window=============");
            log.Debug("hWnds                Text      ");
            foreach(var w in wnds)
            {
                log.Debug(String.Format("{0,-15} {1,-50}",w.hWnd,w.Text));
                //User32.CloseMessage(w.hWnd);
            }
            log.Debug("==========Scaned sub window=============");
           

        }

       
    }
    
}


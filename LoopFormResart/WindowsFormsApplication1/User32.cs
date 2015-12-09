using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace DroneManage
{
    public class SubWindows
    {
        public IntPtr hWnd;
        public string Text;
    }
    class User32
    {
        // Delegate to filter which windows to include 
        public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
        [DllImport("user32", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private extern static bool EnumThreadWindows(int threadId, EnumWindowsProc callback, IntPtr lParam);

        [DllImport("user32", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool EnumChildWindows(IntPtr hwndParent, EnumWindowsProc lpEnumFunc, IntPtr lParam);

        [DllImport("user32", SetLastError = true, CharSet = CharSet.Auto)]
        private extern static int GetWindowText(IntPtr hWnd, StringBuilder text, int maxCount);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);

        const UInt32 WM_CLOSE = 0x0010;
        public static List<SubWindows> FindWindowInProcess(Process process, Func<string, bool> compareTitle)
        {
            IntPtr windowHandle = IntPtr.Zero;
            List<SubWindows> wds = new List<SubWindows>();
            foreach (ProcessThread t in process.Threads)
            {
                wds.AddRange(FindWindowInThread(t.Id, compareTitle));
                //if (windowHandle != IntPtr.Zero)
                //{
                //    break;
                //}
            }

            return wds;
        }
        public static IntPtr CloseMessage(IntPtr hWnd)
        {
            return SendMessage(hWnd, WM_CLOSE, IntPtr.Zero, IntPtr.Zero);
        }
        private static List<SubWindows> FindWindowInThread(int threadId, Func<string, bool> compareTitle)
        {
            IntPtr windowHandle = IntPtr.Zero;
            List<SubWindows> wds = new List<SubWindows>();
            EnumThreadWindows(threadId, (hWnd, lParam) =>
            {
                StringBuilder text = new StringBuilder(200);
                GetWindowText(hWnd, text, 200);
                SubWindows sw = new SubWindows();
                sw.hWnd = hWnd;
                sw.Text = text.ToString();
                wds.Add(sw);
                return true;
            }, IntPtr.Zero);

            return wds;
        }

    }
}

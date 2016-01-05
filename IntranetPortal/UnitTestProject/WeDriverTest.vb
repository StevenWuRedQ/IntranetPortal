Imports System.Runtime.CompilerServices
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports OpenQA.Selenium
Imports OpenQA.Selenium.Chrome
Imports OpenQA.Selenium.Support.UI

<TestClass()> Public Class WeDriverTest

    Dim chrome As ChromeDriver

    <TestMethod()> Public Sub PortalLoginInTest()
        chrome = New ChromeDriver("C:\Program Files (x86)\Google\Chrome\Application")
        chrome.Navigate().GoToUrl("http://portal.myidealprop.com")
        chrome.Manage().Window.Maximize()
        System.Threading.Thread.Sleep(5000)
        Dim username = chrome.FindElement(By.Id("username"))
        username.SendKeys("Chris Yan")
        Dim password = chrome.FindElement(By.Id("password"))
        password.SendKeys("P@ssw0rd")
        Dim btn = chrome.FindElementById("sign-in-button")
        btn.Click()
        System.Threading.Thread.Sleep(3000)
        Assert.AreEqual("Agent Portal (beta) - My Ideal Property", chrome.Title)
        '//*[@id="mCSB_1_container"]/ul/li[4]/a

        Dim myLeadslink = chrome.FindElement(By.XPath("//*[@id=""mCSB_1_container""]/ul/li[2]/a"), 3)
        myLeadslink.Click()
        Dim newLeadsLink = chrome.FindElement(By.XPath("//*[@id=""mCSB_1_container""]/ul/li[2]/ul/li[1]/a[2]"), 3)
        newLeadsLink.Click()

    End Sub

    Public Sub CheckPageIsReady()
        Dim js = CType(chrome, IJavaScriptExecutor)
        If js.ExecuteScript("return document.readyState").ToString().Equals("complete") Then
            Return
        End If

        Dim i = 0
        While i < 10
            Try
                Threading.Thread.Sleep(1000)
            Catch ex As Exception

            End Try

            If js.ExecuteScript("return document.readyState").ToString().Equals("complete") Then
                Return
            End If
        End While
    End Sub

End Class

Public Module WebDriverExtensions
    <Extension()>
    Public Function FindElement(ByVal driver As IWebDriver, by As By, timeoutInSec As Integer)
        If timeoutInSec > 0 Then
            Dim wait = New WebDriverWait(driver, TimeSpan.FromSeconds(timeoutInSec))
            Return wait.Until(Of IWebDriver)(Function(drv) drv.FindElement(by))
        End If

        Return driver.FindElement(by)
    End Function

End Module
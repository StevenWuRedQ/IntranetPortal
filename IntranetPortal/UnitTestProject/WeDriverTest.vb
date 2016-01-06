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
        'Threading.Thread.Sleep(3000)
        Dim username = chrome.FindElement(By.Id("username"), 5)
        username.SendKeys("Chris Yan")
        Dim password = chrome.FindElement(By.Id("password"), 5)
        password.SendKeys("P@ssw0rd")
        Dim btn = chrome.FindElementById("sign-in-button")
        btn.Click()
        System.Threading.Thread.Sleep(3000)
        Assert.AreEqual("Agent Portal (beta) - My Ideal Property", chrome.Title)

    End Sub

    <TestMethod()> Public Sub NewLeadsLinkTest()
        If chrome Is Nothing Then
            PortalLoginInTest()
        End If

        Dim myLeadslink = chrome.FindElement(By.XPath("//*[@id=""mCSB_1_container""]/ul/li[2]/a"), 3)
        myLeadslink.Click()
        Dim newLeadsLink = chrome.FindElement(By.XPath("//*[@id=""mCSB_1_container""]/ul/li[2]/ul/li[1]/a[2]"), 3)
        newLeadsLink.Click()
    End Sub

    <TestMethod()> Public Sub SearchBoxTest()
        If chrome Is Nothing Then
            PortalLoginInTest()
        End If

        Dim searchbox = chrome.FindElement(By.Id("ctl00_txtSearchKey_I"), 3)
        searchbox.SendKeys("3019870041")
        searchbox.SendKeys(Keys.Enter)

        Dim result = chrome.FindElement(By.XPath("//*[@id=""ctl00_pcMain_gridSearch_tccell0_0""]/div/div"), 5)
        result.Click()
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
    Public Function FindElement(ByVal driver As IWebDriver, by As By, timeoutInSec As Integer) As IWebElement
        If timeoutInSec > 0 Then
            Dim wait = New WebDriverWait(driver, TimeSpan.FromSeconds(timeoutInSec))
            Return wait.Until(Of IWebElement)(ExpectedConditions.ElementIsVisible(by))
        End If

        Return driver.FindElement(by)
    End Function

End Module
Imports System.Text.RegularExpressions
Imports System.Threading
Imports OpenQA.Selenium
Imports HtmlAgilityPack
Imports SimpleBrowser.WebDriver

Public Class WebGrabber

    Public Shared Function GetDOBViolations(Borough As String, Block As Integer, Lot As Integer) As DOBViolation
        Dim sleepCount = 0
        Dim baseuri = "http://a810-bisweb.nyc.gov/bisweb/"
        Dim uri = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" & Borough & "&block=" & Block & "&lot=" & Lot

        Dim result = New DOBViolation
        Dim webGet = New HtmlWeb

        Dim doc = webGet.Load(uri)
        Dim dobViolationRow = doc.DocumentNode.SelectSingleNode("//tr[./td/b/a/text()='Violations-DOB']|//tr[./td/b/text()='Violations-DOB']")
        While dobViolationRow Is Nothing
            Thread.Sleep(5000)  'DOB need 5secs to refresh the page!!
            doc = webGet.Load(uri)
            dobViolationRow = doc.DocumentNode.SelectSingleNode("//tr[./td/b/a/text()='Violations-DOB']|//tr[./td/b/text()='Violations-DOB']")
            sleepCount = sleepCount + 1
            If sleepCount > 20 Then
                Return Nothing
            End If
        End While
        result.DOB_TotalDOBViolation = dobViolationRow.SelectSingleNode("./td[2]").InnerHtml.Trim
        result.DOB_TotalOpenViolations = dobViolationRow.SelectSingleNode("./td[3]").InnerHtml.Trim
        If CType(result.DOB_TotalOpenViolations, Integer) > 0 Then
            Dim violations = New List(Of DOBViolationDetail)
            Dim dboViolationsSummaryLinkQuery = dobViolationRow.SelectSingleNode("./td/b/a").GetAttributeValue("href", "")
            Dim dobViolationsSummaryLink = baseuri & dboViolationsSummaryLinkQuery
            Dim dboViolationsSummaryPage = webGet.Load(dobViolationsSummaryLink)
            Dim violationLinks = dboViolationsSummaryPage.DocumentNode.SelectNodes("//tr[./td/b/a]")
            While violationLinks Is Nothing
                Thread.Sleep(5000)
                dboViolationsSummaryPage = webGet.Load(dobViolationsSummaryLink)
                violationLinks = dboViolationsSummaryPage.DocumentNode.SelectNodes("//tr[./td/b/a]")
                sleepCount = sleepCount + 1
                If sleepCount > 20 Then
                    Return Nothing
                End If
            End While
            For Each link In violationLinks
                Dim detail = New DOBViolationDetail
                detail.DOBViolationNum = cleanStatus(link.SelectSingleNode("./td[1]/b/a").InnerHtml.Trim)
                detail.FiledDate = link.SelectSingleNode("./td[4]").InnerHtml.Trim
                Dim detailPageSubLink = link.SelectSingleNode("./td/b/a").GetAttributeValue("href", "")
                Dim detailPageLink = baseuri & detailPageSubLink
                Dim detailPage = webGet.Load(detailPageLink)
                While detailPage.DocumentNode.SelectNodes("//td[text()='ECB No.:']") Is Nothing
                    Thread.Sleep(5000)
                    detailPage = webGet.Load(detailPageLink)
                    sleepCount = sleepCount + 1
                    If sleepCount > 20 Then
                        Return Nothing
                    End If
                End While
                detail.ECBViolationNumber = getLinkContent(detailPage.DocumentNode.SelectSingleNode("//td[text()='ECB No.:']/following::td").InnerHtml.Trim)
                detail.ViolationStatus = cleanStatus(detailPage.DocumentNode.SelectSingleNode("//td[text()='Violation Category:']/following::td").InnerHtml.Trim)
                detail.TypeOfViolations = detailPage.DocumentNode.SelectSingleNode("//td[text()='Violation Type:']/following::td").InnerHtml.Trim
                detail.Description = detailPage.DocumentNode.SelectSingleNode("//td[text()='Description:']/following::td").InnerHtml.Trim
                violations.Add(detail)
            Next
            result.violations = violations.ToArray
        End If

        Return result
    End Function

    Public Shared Function GetECBViolations(Borough As String, Block As Integer, Lot As Integer) As ECBViolation
        Dim sleepCount = 0
        Dim baseuri = "http://a810-bisweb.nyc.gov/bisweb/"
        Dim uri = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" & Borough & "&block=" & Block & "&lot=" & Lot

        Dim result = New ECBViolation
        Dim webGet = New HtmlWeb

        Dim doc = webGet.Load(uri)
        Dim ecbViolationRow = doc.DocumentNode.SelectSingleNode("//tr[./td/b/a/text()='Violations-ECB (DOB)']|//tr[./td/b/text()='Violations-ECB (DOB)']")
        While ecbViolationRow Is Nothing
            Thread.Sleep(5000)  'DOB need 5secs to refresh the page!!
            doc = webGet.Load(uri)
            ecbViolationRow = doc.DocumentNode.SelectSingleNode("//tr[./td/b/a/text()='Violations-ECB (DOB)']|//tr[./td/b/text()='Violations-ECB (DOB)']")
            sleepCount = sleepCount + 1
            If sleepCount > 20 Then
                Return Nothing
            End If
        End While
        result.ECP_TotalViolation = ecbViolationRow.SelectSingleNode("./td[2]").InnerHtml.Trim
        result.ECP_TotalOpenViolations = ecbViolationRow.SelectSingleNode("./td[3]").InnerHtml.Trim
        If CType(result.ECP_TotalOpenViolations, Integer) > 0 Then
            Dim violations = New List(Of ECBViolationDetail)
            Dim ecbViolationsSummaryLinkQuery = ecbViolationRow.SelectSingleNode("./td/b/a").GetAttributeValue("href", "")
            Dim ecbViolationsSummaryLink = baseuri & ecbViolationsSummaryLinkQuery
            Dim ecbViolationsSummaryPage = webGet.Load(ecbViolationsSummaryLink)
            Dim violationRows = ecbViolationsSummaryPage.DocumentNode.SelectNodes("//tr[./td/a/b]")
            While violationRows Is Nothing
                Thread.Sleep(5000)
                ecbViolationsSummaryPage = webGet.Load(ecbViolationsSummaryLink)
                violationRows = ecbViolationsSummaryPage.DocumentNode.SelectNodes("//tr[./td/a/b]")
                sleepCount = sleepCount + 1
                If sleepCount > 20 Then
                    Return Nothing
                End If
            End While
            For Each violationRow In violationRows
                Dim detail = New ECBViolationDetail
                detail.ECBViolationNum = cleanNbsp(violationRow.SelectSingleNode("./td[1]/a/b").InnerHtml.Trim)
                detail.DOBViolationStatus = cleanNbsp(violationRow.SelectSingleNode("./td[2]").InnerHtml.Trim)
                detail.Respondent = cleanNbsp(violationRow.SelectSingleNode("./td[3]").InnerHtml.Trim)
                detail.HearingStatus = cleanNbsp(violationRow.SelectSingleNode("./td[4]").InnerHtml.Trim)
                detail.FiledDate = cleanNbsp(violationRow.SelectSingleNode("./td[5]").InnerHtml.Trim)
                detail.infractionCodes = cleanNbsp(violationRow.SelectSingleNode("./td[6]").InnerHtml.Trim)
                detail.Severity = replaceB(cleanNbsp(violationRow.SelectSingleNode("./following::tr/td[2]").InnerHtml.Trim))
                detail.violationType = cleanNbsp(violationRow.SelectSingleNode("./following::tr/td[4]").InnerHtml.Trim)
                violations.Add(detail)
            Next
            result.violations = violations.ToArray
        End If

        Return result
    End Function

    Public Shared Function cleanStatus(dirty As String) As String
        Dim patten = "^V(\*|%)?(\\r|\\n|\\t|\s|-)*"
        Return Regex.Replace(dirty, patten, "")
    End Function

    Public Shared Function cleanNbsp(dirty As String) As String
        Dim nbsp = "&nbsp;"
        Return Regex.Replace(dirty, nbsp, "")
    End Function

    Public Shared Function getLinkContent(link As String) As String
        Dim patten = "<a[^>]*>(\w+)</a>"
        Dim match = Regex.Matches(link, patten)
        If (match.Count > 0) Then
            Return match.Item(0).Groups(1).Value
        Else
            Return ""
        End If
    End Function

    Public Shared Function replaceB(content As String) As String
        Return Regex.Replace(content, "<b>Severity:</b>", "")
    End Function

    Public Shared Sub GetHPDInfo()
        Try
            Dim driver = New SimpleBrowserDriver()
            driver.Navigate.GoToUrl("https://hpdonline.hpdnyc.org/HPDonline/provide_address.aspx")
            driver.FindElement(By.Id("RadioStrOrBlk_1")).Click()
            Console.WriteLine(driver.FindElement(By.Id("mymaintable_lblDate")).Text)
            Dim radiowait = New Support.UI.WebDriverWait(driver, New TimeSpan(0, 0, 15))
            radiowait.Until(Support.UI.ExpectedConditions.ElementExists(By.Id("txtBlockNo")))
            Dim boroSelect = New Support.UI.SelectElement(By.Id("ddlBoro"))
            boroSelect.SelectByValue("3")
            driver.FindElement(By.Id("txtBlockNo")).SendKeys("1386")
            driver.FindElement(By.Id("txtLotNo")).SendKeys("29")
            driver.FindElement(By.Id("btnSearch")).Click()
            driver.Close()
        Catch ex As Exception

        End Try
    End Sub

    Class DOBViolation
        Public DOB_TotalDOBViolation As String
        Public DOB_TotalOpenViolations As String
        Public violations As DOBViolationDetail()
    End Class

    Class DOBViolationDetail
        Public DOBViolationNum As String
        Public ECBViolationNumber As String
        Public FiledDate As String
        Public ViolationStatus As String
        Public TypeOfViolations As String
        Public Description As String

    End Class

    Class ECBViolation
        Public ECP_TotalViolation As String
        Public ECP_TotalOpenViolations As String
        Public violations As ECBViolationDetail()
    End Class

    Class ECBViolationDetail
        Public ECBViolationNum As String
        Public DOBViolationStatus As String
        Public Respondent As String
        Public HearingStatus As String
        Public FiledDate As String
        Public infractionCodes As String
        Public Severity As String
        Public violationType As String
    End Class

    Class HPDViolation

    End Class

End Class



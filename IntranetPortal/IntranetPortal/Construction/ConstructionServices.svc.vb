Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports HtmlAgilityPack
Imports System.Threading

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class ConstructionServices

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml"
    <OperationContract()>
    Public Sub DoWork()
        ' Add your operation implementation here
    End Sub

    ' Add more operations here and mark them with <OperationContract()>
    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetDOBViolations(bble As String) As String
        Dim sleepCount = 0
        Dim baseuri = "http://a810-bisweb.nyc.gov/bisweb/"
        Dim ld = LeadsInfo.GetInstance(bble)
        Dim uri = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + ld.Borough + "&block=" + ld.Block + "&lot=" + ld.Lot

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
                Return ""
            End If
        End While
        result.DOB_TotalDOBViolation = dobViolationRow.SelectSingleNode("./td[2]").InnerHtml.Trim
        result.DOB_TotalOpenViolations = dobViolationRow.SelectSingleNode("./td[3]").InnerHtml.Trim
        If CType(result.DOB_TotalOpenViolations, Integer) > 0 Then
            result.violations = New ArrayList
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
                    Return ""
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
                        Return ""
                    End If
                End While
                detail.ECBViolationNumber = getLinkContent(detailPage.DocumentNode.SelectSingleNode("//td[text()='ECB No.:']/following::td").InnerHtml.Trim)
                detail.ViolationStatus = cleanStatus(detailPage.DocumentNode.SelectSingleNode("//td[text()='Violation Category:']/following::td").InnerHtml.Trim)
                detail.TypeOfViolations = detailPage.DocumentNode.SelectSingleNode("//td[text()='Violation Type:']/following::td").InnerHtml.Trim
                detail.Description = detailPage.DocumentNode.SelectSingleNode("//td[text()='Description:']/following::td").InnerHtml.Trim
                result.violations.Add(detail)
            Next

        End If

        Return result.ToJsonString
    End Function

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetECBViolations(bble As String) As String
        Dim sleepCount = 0
        Dim baseuri = "http://a810-bisweb.nyc.gov/bisweb/"
        Dim ld = LeadsInfo.GetInstance(bble)
        Dim uri = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + ld.Borough + "&block=" + ld.Block + "&lot=" + ld.Lot

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
                Return ""
            End If
        End While
        result.ECP_TotalViolation = ecbViolationRow.SelectSingleNode("./td[2]").InnerHtml.Trim
        result.ECP_TotalOpenViolations = ecbViolationRow.SelectSingleNode("./td[3]").InnerHtml.Trim
        If CType(result.ECP_TotalOpenViolations, Integer) > 0 Then
            result.violations = New ArrayList
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
                    Return ""
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
                result.violations.Add(detail)
            Next

        End If

        Return result.ToJsonString
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
End Class


Class DOBViolation
    Public Property DOB_TotalDOBViolation As String
    Public Property DOB_TotalOpenViolations As String
    Public Property violations As ArrayList
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
    Public Property ECP_TotalViolation As String
    Public Property ECP_TotalOpenViolations As String
    Public Property violations As ArrayList
End Class

Class ECBViolationDetail
    Public Property ECBViolationNum
    Public Property DOBViolationStatus
    Public Property Respondent
    Public Property HearingStatus
    Public Property FiledDate
    Public Property infractionCodes
    Public Property Severity
    Public Property violationType
End Class


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
    <OperationContract()> _
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetDOBViolations(bble As String) As String
        Dim baseuri = "http://a810-bisweb.nyc.gov/bisweb/"
        Dim ld = LeadsInfo.GetInstance(bble)
        Dim uri = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + ld.Borough + "&block=" + ld.Block + "&lot=" + ld.Lot

        Dim result = New DOBViolation
        Dim webGet = New HtmlWeb

        Dim doc = webGet.Load(uri)
        Dim dobViolationRow = doc.DocumentNode.SelectSingleNode("//tr[./td/b/a/text()='Violations-DOB']")
        While dobViolationRow Is Nothing
            Thread.Sleep(5000)  'DOB need 5secs to refresh the page!!
            doc = webGet.Load(uri)
            dobViolationRow = doc.DocumentNode.SelectSingleNode("//tr[./td/b/a/text()='Violations-DOB']")
        End While
        result.totalViolations = dobViolationRow.SelectSingleNode("./td[2]").InnerHtml.Trim
        result.totalOpenViolations = dobViolationRow.SelectSingleNode("./td[3]").InnerHtml.Trim
        If CType(result.totalOpenViolations, Integer) > 0 Then
            result.violations = New ArrayList
            Dim dboViolationsSummaryLinkQuery = dobViolationRow.SelectSingleNode("./td/b/a").GetAttributeValue("href", "")
            Dim dobViolationsSummaryLink = baseuri & dboViolationsSummaryLinkQuery
            Dim dboViolationsSummaryPage = webGet.Load(dobViolationsSummaryLink)
            Dim violationLinks = dboViolationsSummaryPage.DocumentNode.SelectNodes("//tr[./td/b/a]")
            While violationLinks Is Nothing
                Thread.Sleep(5000)
                dboViolationsSummaryPage = webGet.Load(dobViolationsSummaryLink)
                violationLinks = dboViolationsSummaryPage.DocumentNode.SelectNodes("//tr[./td/b/a]")
            End While
            For Each link In violationLinks
                Dim detail = New DOBViolationDetail
                detail.dobViolationNum = link.SelectSingleNode("./td[1]/b/a").InnerHtml.Trim
                detail.filedDate = link.SelectSingleNode("./td[4]").InnerHtml.Trim
                Dim detailPageSubLink = link.SelectSingleNode("./td/b/a").GetAttributeValue("href", "")
                Dim detailPageLink = baseuri & detailPageSubLink
                Dim detailPage = webGet.Load(detailPageLink)
                While detailPage.DocumentNode.SelectNodes("//td[text()='ECB No.:']") Is Nothing
                    Thread.Sleep(5000)
                    detailPage = webGet.Load(detailPageLink)
                End While
                detail.ecbViolationNum = detailPage.DocumentNode.SelectSingleNode("//td[text()='ECB No.:']/following::td").InnerHtml.Trim
                detail.violationStatus = DOBViolationDetail.cleanStatus(detailPage.DocumentNode.SelectSingleNode("//td[text()='Violation Category:']/following::td").InnerHtml.Trim)
                detail.typeOfViolation = detailPage.DocumentNode.SelectSingleNode("//td[text()='Violation Type:']/following::td").InnerHtml.Trim
                detail.description = detailPage.DocumentNode.SelectSingleNode("//td[text()='Description:']/following::td").InnerHtml.Trim
                result.violations.Add(detail)
            Next

        End If

        Return result.ToJsonString
    End Function
End Class


Class DOBViolation
    Public Property totalViolations As String
    Public Property totalOpenViolations As String
    Public Property violations As ArrayList
End Class

Class DOBViolationDetail
    Public dobViolationNum As String
    Public ecbViolationNum As String
    Public filedDate As String
    Public violationStatus As String
    Public typeOfViolation As String
    Public description As String

    Public Shared Function cleanStatus(dirty As String) As String
        Dim patten = "^V\*?(\\r|\\n|\\t|\s|-)*"
        Return Regex.Replace(dirty, patten, "")
    End Function
End Class

Class ECBViolation
    Public Property totalViolations As String
    Public Property totalOpenViolations As String
    Public Property violations As ArrayList
End Class


Imports RestSharp
Imports System.Configuration
Imports System.Net
Imports System.IO
Imports System.Net.Http
Imports System.Runtime.CompilerServices

''' <summary>
''' The Ecourt service object
''' </summary>
Public Class EcourtService

    Private Shared SericeUrl As String = ConfigurationManager.AppSettings("EcourtServiceUrl")
    Private Shared apiKey As String = "6F43717752E839FD9034B6C426770488A7BA624E9E6D018E26D52451C7A4BCFE56338E92D621F826AC8B8228DDFEC4D7628AAC4917A06F3AE6CD56C978A691CA"

    ''' <summary>
    ''' The ecourt cases list of property
    ''' </summary>
    ''' <param name="bble">The Property BBLE</param>
    ''' <returns></returns>
    Public Function GetCases(bble As String) As List(Of EcourtCase)
        Dim request = GetRequest("api/cases/mortgageforeclosures/{bble}", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)

        Return Execute(Of List(Of EcourtCase))(request)
    End Function

    ''' <summary>
    ''' Get case detail data
    ''' </summary>
    ''' <param name="countyId">The County Id</param>
    ''' <param name="indexNumber">The Case Index Number</param>
    ''' <returns></returns>
    Public Function GetCaseDetail(countyId As String, indexNumber As String) As CaseDetail
        Dim request = GetRequest("api/cases/{countyId}/{indexNumber}", Method.GET)
        request.AddUrlSegment("countyId", countyId)
        request.AddUrlSegment("indexNumber", indexNumber)

        Return Execute(Of CaseDetail)(request)
    End Function

    ''' <summary>
    ''' Get cases that the status changed during the certian time range
    ''' </summary>
    ''' <param name="startDate">The start date</param>
    ''' <param name="endDate">The end date</param>
    ''' <returns></returns>
    Public Function GetStatusChanges(startDate As DateTime, endDate As DateTime) As List(Of EcourtCaseChange)
        Dim request = GetRequest("api/cases/columnvaluechanges/{columnName}/{startDate}/{endDate}", Method.GET)
        request.AddUrlSegment("columnName", "CaseStatus")
        request.AddUrlSegment("startDate", startDate.ToString("yyyyMMdd"))
        request.AddUrlSegment("endDate", endDate.ToString("yyyyMMdd"))

        Return Execute(Of List(Of EcourtCaseChange))(request)
    End Function

    ''' <summary>
    ''' Get new cases during the time range
    ''' </summary>
    ''' <param name="startDate">The start date</param>
    ''' <param name="endDate">The end date</param>
    ''' <returns></returns>
    Public Function GetNewCases(startDate As DateTime, endDate As DateTime) As List(Of EcourtCase)
        Dim request = GetRequest("api/cases/newmortgageforeclosures/{startDate}/{endDate}", Method.GET)
        request.AddUrlSegment("startDate", startDate.ToString("yyyyMMdd"))
        request.AddUrlSegment("endDate", endDate.ToString("yyyyMMdd"))

        Dim cases = Execute(Of List(Of EcourtCase))(request)
        Return cases.Select(Function(c)
                                c.BBLE = c.BBL
                                Return c
                            End Function).ToList
    End Function

    Private Function Execute(Of T As New)(request As RestRequest) As T
        Dim result = client.Execute(Of T)(request)

        If result.IsSuccessful Then
            Return result.Data
        Else
            Throw New Exception(HandleErrorResponse(request, result))
        End If
    End Function

    Private Function HandleErrorResponse(request As IRestRequest, response As IRestResponse) As String
        Dim statusString As String = String.Format("{0} {1} - {2}", CInt(response.StatusCode), response.StatusCode, response.StatusDescription)
        Dim errorString As String = Convert.ToString("Response status: ") & statusString

        Dim resultMessage As String = ""
        If Not response.StatusCode.IsSuccessStatusCode() Then
            If String.IsNullOrWhiteSpace(resultMessage) Then
                resultMessage = "An error occurred while processing the request: " + response.StatusDescription
            End If
        End If
        If response.ErrorException IsNot Nothing Then
            If String.IsNullOrWhiteSpace(resultMessage) Then
                resultMessage = "An exception occurred while processing the request: " + response.ErrorException.Message
            End If
            errorString = errorString & ", Exception: " & response.ErrorException.Message
        End If

        Return resultMessage
    End Function


    Private client As RestClient

    Private Sub New()
        client = New RestClient(SericeUrl)
        System.Net.WebRequest.DefaultWebProxy = Nothing
        client.Proxy = Nothing
    End Sub

    Private Shared _service As EcourtService = Nothing
    ''' <summary>
    ''' Return Ecourt service instance
    ''' </summary>
    ''' <returns></returns>
    Public Shared ReadOnly Property Instance As EcourtService
        Get
            If _service Is Nothing Then
                _service = New EcourtService
            End If

            Return _service
        End Get
    End Property

    Private Function GetRequest(url As String, method As RestSharp.Method) As RestRequest
        Dim request As New RestRequest(url, method)
        request.AddHeader("apiKey", apiKey)
        Return request
    End Function

End Class

Public Module RestSharpExtensionMethods
    <Extension()>
    Public Function IsSuccessful(ByVal response As IRestResponse) As Boolean
        Return response.StatusCode.IsSuccessStatusCode() AndAlso response.ResponseStatus = ResponseStatus.Completed
    End Function

    <Extension()>
    Public Function IsSuccessStatusCode(ByVal responseCode As HttpStatusCode) As Boolean
        Return responseCode >= 200 AndAlso responseCode <= 399
    End Function
End Module

Public Class CaseDetail
    Public Property CountyId As String
    Public Property CaseIndexNumber As String
    Public Property CaseIndexNumberExternal As String
    Public Property SeqNumber As String
    Public Property CourtType As String
    Public Property CaseStatus As String
    Public Property PostDispositionIndicator As Object
    Public Property CourtCalendarNumber As String
    Public Property PremliminaryConferenceIndicator As String
    Public Property NumberOfComments As Integer
    Public Property PreIASJHOId As String
    Public Property PreIASJHOName As Object
    Public Property PreIASTAPId As String
    Public Property PreIASTAPName As Object
    Public Property PlaintiffName As String
    Public Property DefendantName As String
    Public Property MunicipalityInvolvement As String
    Public Property CaseComplexity As String
    Public Property RJIDispositionDeadlineDate As Date
    Public Property RJIPreNOIDeadlineDate As Date
    Public Property PostNOIDispositionDeadlineDate As Object
    Public Property DateRJIFiled As Date
    Public Property DateNOIFiled As Object
    Public Property TimeStampNOIEntered As Object
    Public Property DateIssueJoined As Object
    Public Property JuryStatus1 As String
    Public Property JuryStatusRequestDate1 As Date
    Public Property JuryStatus2 As String
    Public Property JuryStatusRequestDate2 As Object
    Public Property JuryStatus3 As String
    Public Property JuryStatusRequestDate3 As Object
    Public Property ActionOrCaseTypeId As String
    Public Property ActionOrCaseType As String
    Public Property ActionOrCaseTypeDescription As String
    Public Property DamagesSought As String
    Public Property GeneralPreference As String
    Public Property SpecialPreference As String
    Public Property CaseDispositionDate As Object
    Public Property JoinedCasePreviousIndex As String
    Public Property JoinedCaseNextIndex As String
    Public Property RJITypeCode As String
    Public Property TypeOfRJI As String
    Public Property DateOfRJI As Date
    Public Property RJICourtPartId As String
    Public Property RJICourtPart As String
    Public Property CommentForOtherRJIType As String
    Public Property EstimatedTrialTime As Integer
    Public Property ActualTrialTime As Integer
    Public Property PropertySection As String
    Public Property PropertyBlock As String
    Public Property PropertyLot As String
    Public Property PropertySchoolDistrict As String
    Public Property AssessmentAmount As Single
    Public Property AmountAwarded As Single
    Public Property LandUse As String
    Public Property PreliminaryCalendarNumber As String
    Public Property IASCategoryId As String
    Public Property IASCategory As String
    Public Property IASJudgeId As String
    Public Property IASJudgeName As String
    Public Property IASAssignmentDate As Date
    Public Property TimeStampLastIASInformationEntered As Date
    Public Property PostDispositionActionJudgeId As String
    Public Property PostDispositionActionJudgeName As Object
    Public Property PROSEIndicator As String
    Public Property AmountSuedFor As Integer
    Public Property BillOfParticularServed As String
    Public Property NumberOfTitleRecords As Integer
    Public Property NumberOfAttorneyRecords As Integer
    Public Property NumberOfCarrierRecords As Integer
    Public Property DateRJIEntered As Date
    Public Property DateCertOfReadinessFiled As Object
    Public Property CertOfReadinessDueDate As Object
    Public Property NOIDueDate As Object
    Public Property LatestStatusConferenceSchdDate As Object
    Public Property LatestStatusConferenceHeldDate As Date
    Public Property LatestPreTrialConfSchdDate As Object
    Public Property LatestPreTrialConferenceHeldDate As Object
    Public Property LatestPreliminaryConferenceReqDate As Object
    Public Property LatestPreliminaryConferenceSchdDate As Object
    Public Property PreliminaryConferenceHeldDate As Date
    Public Property ComplianceConferenceSchdDate As Object
    Public Property ComplianceConferenceHeldDate As Object
    Public Property LastComplianceConferenceDate As Object
    Public Property PrivateCaseIndicator As String
    Public Property IsEfiled As String
    Public Property DateOfGoodService As Object
    Public Property DateForeclosureSettelementConfScheduled As Object
    Public Property DateForeclosureSettelementConfHeld As Object
    Public Property Comment As String
End Class

''' <summary>
''' The ecourt case 
''' </summary>
Partial Public Class EcourtCase

    Public Property BBL As String

    ''' <summary>
    ''' Update the leads ecourt case data
    ''' </summary>
    ''' <param name="bble">The Property BBLE</param>
    ''' <param name="items">The latest ecourt data</param>
    ''' <returns>return if data has changed</returns>
    Public Shared Function Update(bble As String, items As List(Of EcourtCase)) As Boolean
        Using ctx As New PortalEntities
            If items Is Nothing OrElse items.Count = 0 Then
                Return False
            End If

            Dim cases = ctx.EcourtCases.Where(Function(a) a.BBLE = bble).ToArray
            Dim hasChange = items.Any(Function(a) (Not cases.Any(Function(b) a.CountyId = b.CountyId AndAlso
                                                                             a.CaseIndexNumber = b.CaseIndexNumber)) OrElse
                                                  cases.Any(Function(b) b.CountyId = a.CountyId AndAlso
                                                                        b.CaseIndexNumber = a.CaseIndexNumber AndAlso
                                                                        b.CaseStatus <> a.CaseStatus))

            If hasChange Then
                ctx.EcourtCases.RemoveRange(cases)

                If items.Count > 0 Then
                    ctx.EcourtCases.AddRange(items.Select(Function(a)
                                                              a.BBLE = bble
                                                              Return a
                                                          End Function).ToArray)
                End If
                ctx.SaveChanges()
            End If

            Return hasChange
        End Using
    End Function

    Public Shared Function GetCase(countyId As Integer, indexNumber As String) As EcourtCase
        Using ctx As New PortalEntities
            Return ctx.EcourtCases.Where(Function(a) a.CountyId = countyId AndAlso a.CaseIndexNumber = indexNumber).FirstOrDefault
        End Using
    End Function
End Class

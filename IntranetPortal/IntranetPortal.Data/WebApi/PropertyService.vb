
Imports RestSharp

''' <summary>
''' The property service object, provide the general information, owner and address.
''' </summary>
Public Class PropertyService
    Inherits RedqService
    Implements IDisposable

    ''' <summary>
    ''' Intialize the property service instance
    ''' </summary>
    Public Sub New()
        MyBase.New
    End Sub

    ''' <summary>
    ''' Return property general information
    ''' </summary>
    ''' <param name="bble">Propety BBLE</param>
    ''' <returns></returns>
    Public Function GetGeneralInformation(bble As String) As GeneralPropertyInformation
        Dim request = GetRequest("api/physicaldata/nyc/{bble}/GeneralInformation/", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        Try
            Return Execute(Of GeneralPropertyInformation)(request, True)
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    ''' <summary>
    ''' Return property general information
    ''' </summary>
    ''' <param name="streetNumber">Propety BBLE</param>
    ''' <returns></returns>
    Public Function GetGeneralInformation(streetNumber As String, streetName As String, borough As String) As GeneralPropertyInformation
        Dim request = GetRequest("api/physicaldata/nyc/{streetNumber}/{streetName}/{borough}/GeneralInformation/", Method.GET)
        request.AddUrlSegment("streetNumber", streetNumber)
        request.AddUrlSegment("streetName", streetName)
        request.AddUrlSegment("borough", borough)

        Return Execute(Of GeneralPropertyInformation)(request)
    End Function

    ''' <summary>
    ''' Return the property's mortgage data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function GetMortgages(bble As String) As List(Of DeedDocument)
        Dim request = GetRequest("api/mortgagesdeeds/{bble}/unsatisfiedMortgages/", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        Return Execute(Of List(Of DeedDocument))(request, True)
    End Function

    ''' <summary>
    '''     Return property related bills
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="refId">Reference Id</param>
    ''' <returns></returns>
    Public Function GetBills(bble As String, refId As Integer) As PropertyBills
        Dim request = GetRequest("api/bills/{bble}?externalReferenceId={externalReferenceId}&needTaxBill={needTaxBill}", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        request.AddUrlSegment("externalReferenceId", refId)
        request.AddUrlSegment("needTaxBill", "Y")

        Return Execute(Of PropertyBills)(request)
    End Function

    ''' <summary>
    '''     Return property violations
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="refId">Reference Id</param>
    ''' <returns></returns>
    Public Function GetViolations(bble As String, refId As Integer) As PropertyViolations
        Dim request = GetRequest("api/violations/{bble}?externalReferenceId={externalReferenceId}", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        request.AddUrlSegment("externalReferenceId", refId)

        Return Execute(Of PropertyViolations)(request)
    End Function

    ''' <summary>
    '''     Return mortgage servicer data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="refId">Reference Id</param>
    ''' <returns>The servicer object</returns>
    Public Function GetServicer(bble As String, refId As Integer) As MortgageServicer
        Dim request = GetRequest("api/mortgagesdeeds/{bble}/mortgageservicer?externalReferenceId={externalReferenceId}", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        request.AddUrlSegment("externalReferenceId", refId)

        Return Execute(Of MortgageServicer)(request)
    End Function

    ''' <summary>
    '''     Return the property lis pendens data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="effectiveDate">Effective Date</param>
    ''' <returns></returns>
    Public Function GetLpLiens(bble As String, Optional effectiveDate As DateTime? = Nothing) As List(Of LPCase)
        Dim request = GetRequest("api/cases/mortgageforeclosurelps/{bble}", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        If effectiveDate.HasValue Then
            ' request.AddUrlSegment("effectiveDate", String.Format("{0:YYYYMMDD}", effectiveDate))
        End If

        Return Execute(Of List(Of LPCase))(request, True)
    End Function

    ''' <summary>
    '''     Return property zillow estimate value
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <param name="refId">Reference Id</param>
    ''' <returns>The zillow property object</returns>
    Public Function GetZestimate(bble As String, refId As Integer) As ZillowProperty
        Dim request = GetRequest("api/zillow/{bble}?externalReferenceId={externalReferenceId}", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)
        request.AddUrlSegment("externalReferenceId", refId)

        Return Execute(Of ZillowProperty)(request, True)
    End Function

    ''' <summary>
    '''     Return the details about the latest deed for the given property
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Function GetLatestDeed(bble As String) As PropertyDeed
        Dim request = GetRequest("api/mortgagesdeeds/{bble}/latestdeed", Method.GET)
        request.AddUrlSegment("bble", bble.Trim)

        Return Execute(Of PropertyDeed)(request, True)
    End Function

    ''' <summary>
    '''     Return BBLE of the given address
    ''' </summary>
    ''' <param name="num">Street Number</param>
    ''' <param name="strName">Street Name</param>
    ''' <param name="borough">Borough</param>
    ''' <returns></returns>
    Public Function GetBBLEByAddress(num As String, strName As String, borough As String) As String
        Dim request = GetRequest("api/physicaldata/nyc/{streetNumber}/{streetName}/{borough}/bbl", Method.GET)
        request.AddUrlSegment("streetNumber", num)
        request.AddUrlSegment("streetName", strName)
        request.AddUrlSegment("borough", borough)

        Return Execute(request, True)
    End Function

    ''' <summary>
    '''     Return BBLE of the given address
    ''' </summary>
    ''' <param name="num">Street Number</param>
    ''' <param name="strName">Street Name</param>
    ''' <param name="borough">Borough</param>
    ''' <returns></returns>
    Public Function GetPropByAddress(num As String, strName As String, borough As String) As PhysicalData
        Dim request = GetRequest("api/physicaldata/nyc/{streetNumber}/{streetName}/{borough}", Method.GET)
        request.AddUrlSegment("streetNumber", num)
        request.AddUrlSegment("streetName", strName)
        request.AddUrlSegment("borough", borough)

        Return Execute(Of PhysicalData)(request, True)
    End Function

#Region "IDisposable Support"
    Private disposedValue As Boolean ' To detect redundant calls

    ' IDisposable
    Protected Overridable Sub Dispose(disposing As Boolean)
        If Not disposedValue Then
            If disposing Then
                ' TODO: dispose managed state (managed objects).
            End If

            ' TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
            ' TODO: set large fields to null.
        End If
        disposedValue = True
    End Sub

    ' TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
    'Protected Overrides Sub Finalize()
    '    ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
    '    Dispose(False)
    '    MyBase.Finalize()
    'End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        Dispose(True)
        ' TODO: uncomment the following line if Finalize() is overridden above.
        ' GC.SuppressFinalize(Me)
    End Sub
#End Region

End Class

Public Class DeedDocument
    Public Property RowNo As Integer
    Public Property BBLE As String
    Public Property UniqueKey As String
    Public Property CRFN As String
    Public Property PropertyType As String
    Public Property DocumentType As String
    Public Property DocumentTypeDescription As String
    Public Property DocumentClassCodeDescription As String
    Public Property DocumentDate As Date
    Public Property DocumentAmount As Decimal
    Public Property PercentageOfTransaction As Single
    Public Property DateRecorded As Date
    Public Property DateModified As Date
    Public Property RecordedBorough As String
    Public Property Remarks As String
    Public Property DateLastUpdated As Date
    Public Property URL As String
    Public Property ReelYear As String
    Public Property ReelNumber As String
    Public Property ReelPage As String
End Class

Public Class GeneralPropertyInformation
    Public Property address As GeneralAddress
    Public Property owners As List(Of DeedParty)
    Public Property propertyInformation As PhysicalPropertyInformation
    Public Property errors As String
End Class

Public Class GeneralAddress
    Public Property addressLine1 As String
    Public Property addressLine2 As String
    Public Property city As String
    Public Property state As String
    Public Property zip As String

    Public ReadOnly Property FormatAddress As String
        Get
            If String.IsNullOrEmpty(addressLine1) AndAlso String.IsNullOrEmpty(addressLine2) Then
                Return ""
            End If

            Dim result = String.Format("{0},", addressLine1)

            If Not String.IsNullOrEmpty(addressLine2) Then
                result = result + " " + addressLine2 + ", "
            End If

            If String.IsNullOrEmpty(city) AndAlso String.IsNullOrEmpty(state) Then
                Return result
            End If

            result = result & city & "," & state & " " & zip

            Return result.TrimStart.TrimEnd
        End Get
    End Property
End Class

Public Class PhysicalPropertyInformation

    Public ReadOnly Property BuildingDem As String
        Get
            If BuildingFrontage = 0 OrElse BuildingDepth = 0 Then
                Return Nothing
            End If

            Return String.Format("{0}x{1}", BuildingFrontage, BuildingDepth)
        End Get
    End Property

    Public ReadOnly Property LotDem As String
        Get
            If LotFrontage = 0 OrElse LotDepth = 0 Then
                Return Nothing
            End If

            Return String.Format("{0}x{1}", LotFrontage, LotDepth)
        End Get
    End Property

    Public ReadOnly Property UnbuiltSqft As Double?
        Get
            If LotArea = 0 Then
                Return Nothing
            End If

            Return LotArea * MaxResidentialFAR - BuildingGrossArea
        End Get
    End Property

    Public Property BBLE As String
    Public Property TaxClass As String
    Public Property LotFrontage As Single
    Public Property LotDepth As Single
    Public Property LotArea As Integer
    Public Property BuildingClassCode As String
    Public Property BuildingClass As String
    Public Property BuildingFrontage As Single
    Public Property BuildingDepth As Single
    Public Property Stories As Single
    Public Property NumberOfBuildingsOnLot As Single
    Public Property BuildingGrossArea As Integer
    Public Property BuiltFAR As Single
    Public Property MaxResidentialFAR As Single
    Public Property YearBuilt As Integer
    Public Property Borough As String
    Public Property Block As Integer
    Public Property Lot As Integer
    Public Property StreetNumber As String
    Public Property StreetName As String
    Public Property ZipCode As String
    Public Property NTA As String
    Public Property Zoning As String
    Public Property UnitNumber As String
    Public Property East As Integer
    Public Property North As Integer
    Public Property Longitude As Single
    Public Property Latitude As Single
End Class

Public Class DeedParty
    Public Property UniqueKey As String
    Public Property PartyType As String
    Public Property Name As String
    Public Property PartyTypeCode As String
    Public Property Address1 As String
    Public Property Address2 As String
    Public Property City As String
    Public Property State As String
    Public Property Zip As String
    Public Property Country As String
End Class

Public Class PropertyBills
    Public Property waterBill As Waterbill
    Public Property taxBill As Taxbill
End Class

Public Class Waterbill
    Public Property requestId As Integer
    Public Property externalReferenceId As String
    Public Property status As String
    Public Property BBL As String
    Public Property billAmount As Decimal?
End Class

Public Class Taxbill
    Public Property requestId As Integer
    Public Property externalReferenceId As String
    Public Property status As String
    Public Property BBL As String
    Public Property billAmount As Decimal?
End Class


Public Class PropertyViolations
    Public Property dobPenaltiesAndViolations As Dobpenaltiesandviolations
End Class

Public Class Dobpenaltiesandviolations
    Public Property requestId As Integer
    Public Property externalReferenceId As String
    Public Property status As String
    Public Property BBL As String
    Public Property civilPenaltyAmount As Decimal?
    Public Property violationAmount As Decimal?

    Public ReadOnly Property DOBViolationAmount As Decimal?
        Get
            If civilPenaltyAmount.HasValue OrElse violationAmount.HasValue Then
                Return civilPenaltyAmount + violationAmount
            End If

            Return Nothing
        End Get
    End Property


End Class

Public Class MortgageServicer
    Public Property requestId As Integer
    Public Property externalReferenceId As String
    Public Property status As String
    Public Property BBL As String
    Public Property servicerName As String
End Class

Public Class LPCase
    Public Property BBL As String
    Public Property CountyId As String
    Public Property KeyValue As String
    Public Property Seq As String
    Public Property LisPendensType As String
    Public Property JDLSCaseIndexNumber As String
    Public Property Debtor As String
    Public Property Creditor As String
    Public Property DataEntryDateTime As Date
    Public Property EffectiveDateTime As Date
    Public Property ExpirationDate As Date
    Public Property SatisfactionDate As Date
    Public Property SatisfactionType As String
    Public Property Remarks As String
    Public Property CountyName As String
    Public Property CCISCaseIndexNumber As String
    Public Property CaseFound As String
    Public Property NameMatch As String
    Public Property CaseStatus As String
    Public Property CaseDispositionDate As Date
    Public Property CaseType As String
    Public Property Comment As String
End Class

Public Class ZillowProperty
    Public Property requestId As Integer
    Public Property externalReferenceId As String
    Public Property status As String
    Public Property BBL As String
    Public Property zEstimate As Decimal?
End Class

Public Class PropertyDeed
    Public Property deedDocument As LatestDeedDocument
    Public Property owners As List(Of DeedParty)
End Class

Public Class LatestDeedDocument
    Public Property BBLE As String
    Public Property DeedUniqueKey As String
    Public Property PropertyType As String
    Public Property DocumentType As String
    Public Property DocumentTypeDescription As String
    Public Property DocumentClassCodeDescription As String
    Public Property DocumentDate As Date
    Public Property DocumentAmount As Single
    Public Property PercentageOfTransaction As Single
    Public Property DateRecorded As Date
    Public Property DateModified As Date
    Public Property BoroughOfRecord As String
    Public Property Remarks As String
    Public Property URL As String
    Public Property LastUpdatedDate As Date
    Public Property DateProcessed As Date
End Class

Public Class ExternalData
    Public Property taxbill As Taxbill
    Public Property waterbill As Waterbill
    Public Property mortgageServicer As MortgageServicer
    Public Property dobPenaltiesAndViolationsSummary As Dobpenaltiesandviolations
    Public Property zillowProperty As ZillowProperty

End Class


Public Class PhysicalData
    Public Property address As NYCAddress
End Class

Public Class NYCAddress
    Public Property assemblyDistrict As String
    Public Property bbl As String
    Public Property bblBoroughCode As String
    Public Property bblTaxBlock As String
    Public Property bblTaxLot As String
    Public Property boardOfElectionsPreferredLgc As String
    Public Property boePreferredStreetName As String
    Public Property boePreferredstreetCode As String
    Public Property boroughCode1In As String
    Public Property buildingIdentificationNumber As String
    Public Property censusBlock2000 As String
    Public Property censusBlock2010 As String
    Public Property censusTract1990 As String
    Public Property censusTract2000 As String
    Public Property censusTract2010 As String
    Public Property cityCouncilDistrict As String
    Public Property civilCourtDistrict As String
    Public Property coincidentSegmentCount As String
    Public Property communityDistrict As String
    Public Property communityDistrictBoroughCode As String
    Public Property communityDistrictNumber As String
    Public Property communitySchoolDistrict As String
    Public Property condominiumBillingBbl As String
    Public Property congressionalDistrict As String
    Public Property cooperativeIdNumber As String
    Public Property crossStreetNamesFlagIn As String
    Public Property curveFlag As String
    Public Property dcpPreferredLgc As String
    Public Property dotStreetLightContractorArea As String
    Public Property dynamicBlock As String
    Public Property electionDistrict As String
    Public Property fireBattalion As String
    Public Property fireCompanyNumber As String
    Public Property fireCompanyType As String
    Public Property fireDivision As String
    Public Property firstBoroughName As String
    Public Property firstStreetCode As String
    Public Property firstStreetNameNormalized As String
    Public Property fromLionNodeId As String
    Public Property fromPreferredLgcsFirstSetOf5 As String
    Public Property genericId As String
    Public Property geosupportFunctionCode As String
    Public Property geosupportReturnCode As String
    Public Property geosupportReturnCode2 As String
    Public Property gi5DigitStreetCode1 As String
    Public Property giBoroughCode1 As String
    Public Property giBuildingIdentificationNumber1 As String
    Public Property giDcpPreferredLgc1 As String
    Public Property giHighHouseNumber1 As String
    Public Property giLowHouseNumber1 As String
    Public Property giSideOfStreetIndicator1 As String
    Public Property giStreetCode1 As String
    Public Property giStreetName1 As String
    Public Property healthArea As String
    Public Property healthCenterDistrict As String
    Public Property highBblOfThisBuildingsCondominiumUnits As String
    Public Property highCrossStreetB5SC1 As String
    Public Property highCrossStreetCode1 As String
    Public Property highCrossStreetName1 As String
    Public Property highHouseNumberOfBlockfaceSortFormat As String
    Public Property houseNumber As String
    Public Property houseNumberIn As String
    Public Property houseNumberSortFormat As String
    Public Property hurricaneEvacuationZone As String
    Public Property instructionalRegion As String
    Public Property interimAssistanceEligibilityIndicator As String
    Public Property internalLabelXCoordinate As String
    Public Property internalLabelYCoordinate As String
    Public Property latitude As Single
    Public Property latitudeInternalLabel As Single
    Public Property legacySegmentId As String
    Public Property lionBoroughCode As String
    Public Property lionBoroughCodeForVanityAddress As String
    Public Property lionFaceCode As String
    Public Property lionFaceCodeForVanityAddress As String
    Public Property lionKey As String
    Public Property lionKeyForVanityAddress As String
    Public Property lionSequenceNumber As String
    Public Property lionSequenceNumberForVanityAddress As String
    Public Property listOf4Lgcs As String
    Public Property longitude As Single
    Public Property longitudeInternalLabel As Single
    Public Property lowBblOfThisBuildingsCondominiumUnits As String
    Public Property lowCrossStreetB5SC1 As String
    Public Property lowCrossStreetCode1 As String
    Public Property lowCrossStreetName1 As String
    Public Property lowHouseNumberOfBlockfaceSortFormat As String
    Public Property lowHouseNumberOfDefiningAddressRange As String
    Public Property message2 As String
    Public Property nta As String
    Public Property ntaName As String
    Public Property numberOfCrossStreetB5SCsHighAddressEnd As String
    Public Property numberOfCrossStreetB5SCsLowAddressEnd As String
    Public Property numberOfCrossStreetsHighAddressEnd As String
    Public Property numberOfCrossStreetsLowAddressEnd As String
    Public Property numberOfEntriesInListOfGeographicIdentifiers As String
    Public Property numberOfExistingStructuresOnLot As String
    Public Property numberOfStreetFrontagesOfLot As String
    Public Property physicalId As String
    Public Property policePatrolBoroughCommand As String
    Public Property policePrecinct As String
    Public Property radiusOfCircle As String
    Public Property reasonCode1a As String
    Public Property reasonCode2 As String
    Public Property returnCode1a As String
    Public Property returnCode1e As String
    Public Property roadwayType As String
    Public Property rpadBuildingClassificationCode As String
    Public Property rpadSelfCheckCodeForBbl As String
    Public Property sanbornBoroughCode As String
    Public Property sanbornPageNumber As String
    Public Property sanbornVolumeNumber As String
    Public Property sanitationCollectionSchedulingSectionAndSubsection As String
    Public Property sanitationDistrict As String
    Public Property sanitationRecyclingCollectionSchedule As String
    Public Property sanitationRegularCollectionSchedule As String
    Public Property sanitationSnowPriorityCode As String
    Public Property secantLocationRelatedToCurve As String
    Public Property segmentAzimuth As String
    Public Property segmentIdentifier As String
    Public Property segmentLengthInFeet As String
    Public Property segmentOrientation As String
    Public Property segmentTypeCode As String
    Public Property sideOfStreetIndicator As String
    Public Property sideOfStreetOfVanityAddress As String
    Public Property splitLowHouseNumber As String
    Public Property stateSenatorialDistrict As String
    Public Property streetName1In As String
    Public Property streetStatus As String
    Public Property streetWidth As String
    Public Property taxMapNumberSectionAndVolume As String
    Public Property toLionNodeId As String
    Public Property toPreferredLgcsFirstSetOf5 As String
    Public Property trafficDirection As String
    Public Property underlyingStreetCode As String
    Public Property uspsPreferredCityName As String
    Public Property workAreaFormatIndicatorIn As String
    Public Property xCoordinate As String
    Public Property xCoordinateHighAddressEnd As String
    Public Property xCoordinateLowAddressEnd As String
    Public Property xCoordinateOfCenterofCurvature As String
    Public Property yCoordinate As String
    Public Property yCoordinateHighAddressEnd As String
    Public Property yCoordinateLowAddressEnd As String
    Public Property yCoordinateOfCenterofCurvature As String
    Public Property zipCode As String
End Class

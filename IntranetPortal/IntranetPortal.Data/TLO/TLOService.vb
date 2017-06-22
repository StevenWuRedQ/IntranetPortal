Imports IntranetPortal.Data.TLOApi
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Serialization

''' <summary>
''' Data services related to TLO
''' </summary>
Public Class TLOService

    Const TloUser As String = "prodapi.myidealprop"
    Const TloPassword As String = "gc5Wyz-MStb?_!CRFkmQD"

    ''' <summary>
    ''' Return person data
    ''' </summary>
    ''' <param name="APIorderNum"></param>
    ''' <param name="FullName"></param>
    ''' <param name="Name"></param>
    ''' <param name="UseExactFirstNameMatch"></param>
    ''' <param name="UsePhoneticLastNameMatch"></param>
    ''' <param name="Address"></param>
    ''' <param name="SSN"></param>
    ''' <param name="DateOfBirth"></param>
    ''' <param name="MinimumAge"></param>
    ''' <param name="MaximumAge"></param>
    ''' <param name="Phone"></param>
    ''' <param name="DriversLicenseNumber"></param>
    ''' <param name="EmailAddress"></param>
    ''' <param name="IPAddress"></param>
    ''' <param name="Domain"></param>
    ''' <returns></returns>
    Public Shared Function GetTLOPerson(APIorderNum As String, FullName As String, Name As NameBase, UseExactFirstNameMatch As Boolean, UsePhoneticLastNameMatch As Boolean,
                            Address As AddressBase, SSN As String, DateOfBirth As Date, MinimumAge As String, MaximumAge As String, Phone As String, DriversLicenseNumber As String, EmailAddress As String,
                            IPAddress As String, Domain As String) As TLOPersonSearchOutput
        Dim searchInput As New TLOApi.TLOGenericSearchInput
        searchInput.Username = TloUser
        searchInput.Password = TloPassword

        ' set as appropriate and as permitted
        searchInput.GLBPurpose = "7" 'To protect against or prevent actual or potential fraud, unauthorized transactions, claims, or other liability.
        searchInput.DPPAPurpose = "2" 'Use in the normal course of business by a legitimate business or its agents

        searchInput.StartingRecord = 1
        searchInput.NumberOfRecords = 10
        Dim MyDoB As New TLOApi.Date

        With searchInput
            .CaseNumber = APIorderNum
            .FullName = RTrim(FullName)
            .Phone = RTrim(Phone)
            .Name = Name
            .UseExactFirstNameMatch = UseExactFirstNameMatch
            .UsePhoneticLastNameMatch = UsePhoneticLastNameMatch
            .Address = Address
            .SSN = SSN

            If Not DateOfBirth = Date.MinValue Then
                With MyDoB
                    .Day = DateOfBirth.Day.ToString
                    .Month = DateOfBirth.Month.ToString
                    .Year = DateOfBirth.Year.ToString
                End With

                .DateOfBirth = MyDoB
            Else
                .MinimumAge = MinimumAge
                .MaximumAge = MaximumAge
            End If

            .Phone = Phone
            .DriversLicenseNumber = DriversLicenseNumber
            .EmailAddress = EmailAddress
            .IPAddress = IPAddress
            .Domain = Domain
            .MaximumAddresses = 25
            .DoNotModifySearch = "No"
        End With

        Dim searchOutput As TLOPersonSearchOutput = Nothing
        Using service As New TLOApi.TLOWebServiceSoapClient
            For retryCount As Integer = 0 To 2  ' Retry any errors on TLO's end (or network end) 
                'Try
                searchOutput = service.PersonSearch(searchInput)

                If searchOutput.ErrorCode = 0 Then
                    ' No error, display result
                    With searchOutput
                        If .NumberOfRecordsFound = 0 Then
                            Return Nothing
                        End If


                        Return searchOutput

                    End With
                End If

                If searchOutput.ErrorCode < 1000 Then
                    ' errors less than 1000 indicate an error on our end.  Don't retry

                    Exit For
                End If
            Next
        End Using

        Return Nothing
    End Function

    ''' <summary>
    ''' Return TLO LocateReport
    ''' </summary>
    ''' <param name="PersonName"></param>
    ''' <param name="PersonAddress1"></param>
    ''' <param name="PersonAddress2"></param>
    ''' <param name="PersonCity"></param>
    ''' <param name="PersonState"></param>
    ''' <param name="PersonZip"></param>
    ''' <param name="PersonCountry"></param>
    ''' <param name="Subject_Type"></param>
    ''' <param name="PersonPhone"></param>
    ''' <returns></returns>
    Public Shared Function GetLocateReport(PersonName As String, PersonAddress1 As String, PersonAddress2 As String, PersonCity As String, PersonState As String, PersonZip As String, PersonCountry As String, Subject_Type As String, PersonPhone As String) As DataAPI.TLOLocateReportOutput
        Dim searchInput As New TLOApi.TLOGenericSearchInput
        searchInput.Username = TloUser
        searchInput.Password = TloPassword

        ' set as appropriate and as permitted
        searchInput.GLBPurpose = "7" 'To protect against or prevent actual or potential fraud, unauthorized transactions, claims, or other liability.
        searchInput.DPPAPurpose = "2" 'Use in the normal course of business by a legitimate business or its agents

        searchInput.StartingRecord = 1
        searchInput.NumberOfRecords = 10

        With searchInput
            .CaseNumber = ""
            .FullName = RTrim(PersonName)
            .Phone = RTrim(PersonPhone)
            .Address = New TLOApi.AddressBase With {
                    .Line1 = RTrim(PersonAddress1),
                    .Line2 = RTrim(PersonAddress2),
                    .City = RTrim(PersonCity),
                    .State = RTrim(PersonState),
                    .Zip = RTrim(PersonZip)
                    }
        End With

        Using service As New TLOApi.TLOWebServiceSoapClient
            Dim reportToken = Nothing
            Dim searchOutput = service.PersonSearch(searchInput)
            If searchOutput.ErrorCode = 0 Then
                With searchOutput
                    If .NumberOfRecordsFound = 0 Then
                        Return Nothing
                    End If

                    reportToken = .PersonSearchOutputRecords(0).ReportToken  'Record The uniqe person ID called "ReportToken"
                End With

                If Len(reportToken) > 0 Then   'If person search was done and was found , perform a SuperPhoneReport search based on the returned 'ReportToken'
                    Dim locateReportInput As New TLOApi.TLOLocateReportInput
                    With locateReportInput
                        .Username = TloUser
                        .Password = TloPassword
                        .GLBPurpose = "7"
                        .DPPAPurpose = "2"

                        .StartingRecord = 1
                        .NumberOfRecords = 10
                        .Version = "27" 'A value of 27 will cause the API to provide all data elements
                        .CaseNumber = "None"

                        .ReportToken = reportToken

                        .ShowAddresses = "Yes"
                        .ShowEmailAddresses = "Yes"
                        .ShowCommercialPhones = "Yes"
                        .ShowResidentialPhones = "Yes"
                        .ShowCurrentMotorVehicles = "Yes"
                        .ShowPastMotorVehicles = "Yes"

                        .ShowPastProperties = "Yes"
                        .ShowJudgments = "Yes"
                        .ShowLiens = "Yes"
                        .ShowEmployers = "Yes"
                        .ShowTLOBusinessAssociations = "Yes"
                        .ShowCorporateFilings = "Yes"
                        .ShowLikelyAssociates = "Yes"
                        .ShowPossibleAssociates = "Yes"
                        .ShowRelatives1stDegree = "Yes"
                        .ShowRelatives2ndDegree = "Yes"
                        .ShowRelatives3rdDegree = "Yes"
                        .ShowNeighbors = "Yes"
                        .ShowCommercialPhones = "Yes"
                        .ShowResidentialPhones = "Yes"
                    End With

                    Dim ret = service.LocateReport(locateReportInput)
                    Dim settings = New JsonSerializerSettings()
                    settings.ContractResolver = New CustomContractResolver()
                    Dim retJson = JsonConvert.SerializeObject(ret, settings)

                    Dim deSettings = New JsonSerializerSettings
                    deSettings.ContractResolver = New RequireObjectPropertiesContractResolver
                    deSettings.Error = New EventHandler(Of ErrorEventArgs)(Sub(sender, args)
                                                                               args.ErrorContext.Handled = True
                                                                           End Sub)

                    Dim report = JsonConvert.DeserializeObject(Of DataAPI.TLOLocateReportOutput)(retJson, deSettings)
                    Return report
                End If
            End If
        End Using

        Return Nothing
    End Function

End Class

Public Class RequireObjectPropertiesContractResolver
    Inherits DefaultContractResolver

    Protected Overrides Function CreateObjectContract(objectType As Type) As JsonObjectContract
        Dim contract = MyBase.CreateObjectContract(objectType)
        contract.ItemRequired = Required.Default
        Return contract
    End Function

End Class


Public Class CustomContractResolver
    Inherits DefaultContractResolver

    Public Sub New()

    End Sub

    Protected Overrides Function ResolvePropertyName(propertyName As String) As String
        'Dim resolvedName As String = Nothing
        'Dim resolved = Me.PropertyMappings.TryGetValue(propertyName, resolvedName)
        'Return If((resolved), resolvedName, MyBase.ResolvePropertyName(propertyName))
        Return Char.ToLowerInvariant(propertyName(0)) + propertyName.Substring(1) + "Field"
    End Function
End Class
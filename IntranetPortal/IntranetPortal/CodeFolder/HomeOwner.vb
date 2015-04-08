Imports System.Xml.Serialization
Imports System.Xml
Imports System.IO
Imports System.Runtime.Serialization.Formatters.Binary

Partial Public Class HomeOwner
    Private objLocateReport As DataAPI.TLOLocateReportOutput
    Public Shared EMPTY_HOMEOWNER As String = "Please Edit Owner"
    Public Property TLOLocateReport As DataAPI.TLOLocateReportOutput
        Get
            If objLocateReport Is Nothing And LocateReport IsNot Nothing AndAlso LocateReport.Length > 0 Then
                Dim serializer As New BinaryFormatter
                Dim writer As New MemoryStream(LocateReport)
                Dim o As DataAPI.TLOLocateReportOutput = serializer.Deserialize(writer)
                objLocateReport = o
            End If

            Return objLocateReport
        End Get
        Set(value As DataAPI.TLOLocateReportOutput)
            If value IsNot Nothing Then
                objLocateReport = value
                ReportToken = value.reportTokenField
                'save phone no to database
                SavePhoneField(value)

                Using myWriter As New StringWriter
                    Dim serializer As New BinaryFormatter
                    Dim writer As New MemoryStream()
                    serializer.Serialize(writer, value)
                    writer.Flush()
                    LocateReport = writer.ToArray
                End Using
            End If
        End Set
    End Property

    Public Shared Function GetHomeOwenrs(bble As String) As List(Of HomeOwner)
        Using ctx As New Entities
            Return ctx.HomeOwners.Where(Function(h) h.BBLE = bble).ToList
        End Using

    End Function

    Public Shared Function LoadOwner(ownerId As Integer) As HomeOwner
        Using ctx As New Entities
            Return ctx.HomeOwners.Find(ownerId)
        End Using

    End Function

    Private _bestPhoneNo As List(Of HomeOwnerPhone)
    Public ReadOnly Property BestPhoneNo As List(Of HomeOwnerPhone)
        Get
            If _bestPhoneNo Is Nothing Then
                Using context As New Entities
                    Dim list = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = Name And p.Source = PhoneSource.UserAdded).ToList
                    'list.Sort(Function(x, y) x.Stuats < y.Stuats)
                    _bestPhoneNo = list
                End Using
            End If

            Return _bestPhoneNo
        End Get
    End Property


    Private _bestEmail As List(Of HomeOwnerEmail)
    Public ReadOnly Property BestEmail As List(Of HomeOwnerEmail)
        Get
            If _bestEmail Is Nothing Then
                Using context As New Entities
                    Dim list = context.HomeOwnerEmails.Where(Function(e) e.BBLE = BBLE And e.OwnerName = Name And e.Source = PhoneSource.UserAdded).ToList
                    _bestEmail = list
                End Using
            End If

            Return _bestEmail
        End Get
    End Property

    Private _bestAddress As List(Of HomeOwnerAddress)
    Public ReadOnly Property BestAddress As List(Of HomeOwnerAddress)
        Get
            If _bestAddress Is Nothing Then
                Using context As New Entities
                    _bestAddress = context.HomeOwnerAddresses.Where(Function(add) add.BBLE = BBLE And add.OwnerName = Name And add.Source = AddressSource.UserAdded).ToList
                End Using
            End If

            Return _bestAddress
        End Get
    End Property

    Public Sub AddPhones(phone As String)
        Using context As New Entities
            Dim p = context.HomeOwnerPhones.Where(Function(ph) ph.BBLE = BBLE And ph.OwnerName = Name And ph.Phone = phone).SingleOrDefault

            If p Is Nothing Then
                p = New HomeOwnerPhone
                p.BBLE = BBLE
                p.OwnerName = Name
                p.Phone = phone
                p.Source = PhoneSource.UserAdded

                context.HomeOwnerPhones.Add(p)
                context.SaveChanges()
            End If
        End Using
    End Sub

    Public Sub SavePhoneField(ownerInfo As DataAPI.TLOLocateReportOutput)
        Using context As New Entities

            If ownerInfo.phonesField IsNot Nothing Then
                'Owner phones info
                For Each item In ownerInfo.phonesField
                    Dim phone = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = Name And p.Phone = item.phoneField).FirstOrDefault

                    If phone Is Nothing Then

                        phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = Name And p.Phone = item.phoneField).FirstOrDefault

                        If phone Is Nothing Then
                            phone = GetOwnerPhone(BBLE, Name, item)
                            context.HomeOwnerPhones.Add(phone)
                        End If
                    End If
                Next
            End If

            'Owner first relatives info
            If ownerInfo.relatives1stDegreeField IsNot Nothing Then
                For Each relative In ownerInfo.relatives1stDegreeField
                    Dim name = String.Format("{0} {1}{2}", relative.nameField.firstNameField, relative.nameField.middleNameField & " ", relative.nameField.lastNameField)

                    For Each item In relative.phonesField
                        Dim phone = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).FirstOrDefault

                        If phone Is Nothing Then
                            phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).FirstOrDefault

                            If phone Is Nothing Then
                                phone = GetOwnerPhone(BBLE, name, item)
                                context.HomeOwnerPhones.Add(phone)
                            End If
                        End If
                    Next
                Next
            End If

            'Owner Second relatives info
            If ownerInfo.relatives2ndDegreeField IsNot Nothing Then
                For Each relative In ownerInfo.relatives2ndDegreeField
                    Dim name = String.Format("{0} {1}{2}", relative.nameField.firstNameField, relative.nameField.middleNameField & " ", relative.nameField.lastNameField)

                    For Each item In relative.phonesField
                        Dim phone = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).FirstOrDefault

                        If phone Is Nothing Then
                            phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).FirstOrDefault

                            If phone Is Nothing Then
                                phone = GetOwnerPhone(BBLE, name, item)
                                context.HomeOwnerPhones.Add(phone)
                            End If
                        End If
                    Next
                Next
            End If

            'Owner third relatives info
            If ownerInfo.relatives3rdDegreeField IsNot Nothing Then
                For Each relative In ownerInfo.relatives3rdDegreeField
                    Dim name = String.Format("{0} {1}{2}", relative.nameField.firstNameField, relative.nameField.middleNameField & " ", relative.nameField.lastNameField)

                    For Each item In relative.phonesField
                        Dim phone = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).FirstOrDefault

                        phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).FirstOrDefault

                        If phone Is Nothing Then
                            phone = GetOwnerPhone(BBLE, name, item)
                            context.HomeOwnerPhones.Add(phone)
                        End If
                    Next
                Next
            End If

            context.SaveChanges()
        End Using
    End Sub

    Function GetOwnerPhone(bble As String, ownerName As String, item As DataAPI.BasicPhoneListing) As HomeOwnerPhone
        Dim phone = New HomeOwnerPhone
        phone.BBLE = bble
        phone.OwnerName = Name
        phone.Phone = item.phoneField
        phone.Type = item.phoneTypeField.ToString
        phone.Source = PhoneSource.TLOLocateReport
        Return phone
    End Function

    Public Shared Function CheckLocateReportObject(reportToken As String)
        Using ctx As New Entities
            Dim owners = ctx.HomeOwners.Where(Function(h) h.ReportToken = reportToken).ToList

            For Each owner In owners
                Dim obj = owner.TLOLocateReport

            Next
            Return True
        End Using
    End Function

    Public Shared Sub InitalOwnerToken()
        Using ctx As New Entities
            Dim owners = ctx.HomeOwners.Where(Function(h) String.IsNullOrEmpty(h.ReportToken) And h.LocateReport IsNot Nothing).Take(200).ToList

            For Each owner In owners
                If Not String.IsNullOrEmpty(owner.TLOLocateReport.reportTokenField) Then
                    owner.ReportToken = owner.TLOLocateReport.reportTokenField
                End If
            Next

            ctx.SaveChanges()
        End Using
    End Sub

    Public ReadOnly Property FirstName As String
        Get
            Return TLOLocateReport.namesField(0).firstNameField
        End Get
    End Property

    Public ReadOnly Property LastName As String
        Get
            Return TLOLocateReport.namesField(0).lastNameField
        End Get
    End Property

    Public ReadOnly Property FullAddress As String
        Get
            Return String.Format("{0} {1}, {2},{3} {4}", Me.Address1, Me.Address2, Me.City, Me.State, Me.Zip)
        End Get
    End Property

    Dim hoInfo As New HomeOwnerInfo

    Public ReadOnly Property PhoneNumbers As String
        Get

            Dim result = New List(Of String)
            For Each phone In TLOLocateReport.phonesField
                result.Add(String.Format("{0}-({1}-{2}-{3})", hoInfo.FormatPhoneNumber(phone.phoneField), phone.timeZoneField, phone.phoneTypeField.ToString, phone.scoreField) & Environment.NewLine)
            Next

            Return String.Join(" ", result.ToArray)
        End Get
    End Property

    Public ReadOnly Property PhoneCount As Integer
        Get
            Return TLOLocateReport.phonesField.Length
        End Get
    End Property

    Public ReadOnly Property AddressHistory As String
        Get
            Dim result = New List(Of String)
            For Each address In TLOLocateReport.addressesField
                result.Add(String.Format("{0} ({1}-{2})", hoInfo.FormatAddress(address.addressField), hoInfo.BuilderDate(address.dateFirstSeenField), hoInfo.BuilderDate(address.dateLastSeenField)) & Environment.NewLine)
            Next

            Return String.Join(" ", result.ToArray)
        End Get
    End Property

    Public ReadOnly Property Alive As Boolean
        Get
            Return TLOLocateReport.dateOfDeathField Is Nothing
        End Get
    End Property

    Public ReadOnly Property Age As String
        Get
            If TLOLocateReport.dateOfBirthField IsNot Nothing Then
                Return TLOLocateReport.dateOfBirthField.currentAgeField
            End If
            Return "Unknow"
        End Get
    End Property

    Public ReadOnly Property Bankruptcy As Boolean
        Get
            Return TLOLocateReport.numberOfBankruptciesField > 0
        End Get
    End Property

    Public ReadOnly Property Relatives1stNamePhone As String
        Get
            Dim result = New List(Of String)
            For Each relative In TLOLocateReport.relatives1stDegreeField
                result.Add(String.Format("{0} {2} ({1})",
                                         relative.nameField.firstNameField & If(relative.nameField.middleNameField IsNot Nothing, " " & relative.nameField.middleNameField, " ") & " " & relative.nameField.lastNameField, GetPhonesString(relative.phonesField), Environment.NewLine) & Environment.NewLine)
            Next

            Return String.Join(" ", result.ToArray)
        End Get
    End Property

    Public ReadOnly Property Relatives2ndNamePhone As String
        Get
            Dim result = New List(Of String)
            For Each relative In TLOLocateReport.relatives2ndDegreeField
                result.Add(String.Format("{0} {2} ({1})",
                                         relative.nameField.firstNameField & If(relative.nameField.middleNameField IsNot Nothing, " " & relative.nameField.middleNameField, " ") & " " & relative.nameField.lastNameField, GetPhonesString(relative.phonesField), Environment.NewLine) & Environment.NewLine)
            Next

            Return String.Join(" ", result.ToArray)
        End Get
    End Property

    Public ReadOnly Property Relatives3rdNamePhone As String
        Get
            Dim result = New List(Of String)
            For Each relative In TLOLocateReport.relatives3rdDegreeField
                result.Add(String.Format("{0} {2} ({1})",
                                         relative.nameField.firstNameField & If(relative.nameField.middleNameField IsNot Nothing, " " & relative.nameField.middleNameField, " ") & " " & relative.nameField.lastNameField, GetPhonesString(relative.phonesField), Environment.NewLine) & Environment.NewLine)
            Next

            Return String.Join(" ", result.ToArray)
        End Get
    End Property

    Private Function GetPhonesString(phones As DataAPI.PhoneListing()) As String
        Dim result = New List(Of String)
        For Each phone In phones
            result.Add(String.Format("{0}-({1}-{2}-{3})", hoInfo.FormatPhoneNumber(phone.phoneField), phone.timeZoneField, phone.phoneTypeField.ToString, phone.scoreField) & Environment.NewLine)
        Next

        Return String.Join(" ", result.ToArray)
    End Function

End Class

Enum PhoneSource
    TLOLocateReport
    UserAdded
End Enum

Enum AddressSource
    TLOLocateReport
    UserAdded
End Enum
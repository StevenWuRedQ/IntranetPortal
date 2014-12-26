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

    Public ReadOnly Property BestPhoneNo As List(Of HomeOwnerPhone)
        Get
            Using context As New Entities
                Dim list = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = Name And p.Source = PhoneSource.UserAdded).ToList
                'list.Sort(Function(x, y) x.Stuats < y.Stuats)
                Return list
            End Using
        End Get
    End Property

    Public ReadOnly Property BestEmail As List(Of HomeOwnerEmail)
        Get
            Using context As New Entities
                Dim list = context.HomeOwnerEmails.Where(Function(e) e.BBLE = BBLE And e.OwnerName = Name And e.Source = PhoneSource.UserAdded).ToList
                Return list
            End Using
        End Get
    End Property
    Public ReadOnly Property BestAddress As List(Of HomeOwnerAddress)
        Get
            Using context As New Entities
                Return context.HomeOwnerAddresses.Where(Function(add) add.BBLE = BBLE And add.OwnerName = Name And add.Source = AddressSource.UserAdded).ToList
            End Using
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

                        phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = Name And p.Phone = item.phoneField).SingleOrDefault

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
                            phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).SingleOrDefault

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
                            phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).SingleOrDefault

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
                        Dim phone = context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).SingleOrDefault

                        phone = context.HomeOwnerPhones.Local.Where(Function(p) p.BBLE = BBLE And p.OwnerName = name And p.Phone = item.phoneField).SingleOrDefault

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
End Class

Enum PhoneSource
    TLOLocateReport
    UserAdded
End Enum

Enum AddressSource
    TLOLocateReport
    UserAdded
End Enum
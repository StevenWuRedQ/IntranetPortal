Public Class HomeOwnerInfo
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Property OwnerName As String
    Public Property BBLE As String
    Public Property TLOLocateReport As DataAPI.TLOLocateReportOutput
    Public Property BestNums As List(Of HomeOwnerPhone)
    Public Property BestAddress As List(Of HomeOwnerAddress)

    Private _contacts As List(Of OwnerContact)
    Public ReadOnly Property Contacts As List(Of OwnerContact)
        Get
            If _contacts IsNot Nothing Then
                Return _contacts
            Else
                Using Context As New Entities
                    _contacts = Context.OwnerContacts.Where(Function(c) c.BBLE = BBLE).ToList
                    Return _contacts
                End Using
            End If
        End Get
    End Property

    Public Function IsWrongAddress(address As String) As Boolean
        Return Contacts.Where(Function(c) c.Contact = address And c.Status = OwnerContact.ContactStatus.Wrong And c.ContactType = OwnerContact.OwnerContactType.MailAddress).Count > 0
    End Function

    Public Function CssStyle(contact As String)
        Dim ct = Contacts.Where(Function(c) c.Contact.Contains(contact)).FirstOrDefault
        If ct IsNot Nothing Then
            If ct.Status = OwnerContact.ContactStatus.Wrong Then
                Return "style='color:red;text-decoration:line-through;'"
            End If

            If ct.Status = OwnerContact.ContactStatus.Right Then
                Return "style='color:green;text-decoration:none;'"
            End If
        End If
        Return ""
    End Function

    Public Sub BindData(bble As String)
        Using Context As New Entities
            Dim homeOwner = Context.HomeOwners.Where(Function(h) h.BBLE = bble And h.Name = OwnerName).FirstOrDefault
            If homeOwner IsNot Nothing Then
                TLOLocateReport = homeOwner.TLOLocateReport
                If TLOLocateReport Is Nothing Then
                    TLOLocateReport = New DataAPI.TLOLocateReportOutput
                End If
                BestNums = homeOwner.BestPhoneNo
                BestAddress = homeOwner.BestAddress
            End If
        End Using
    End Sub

    Public Function BuilderPhone(phone As DataAPI.BasicPhoneListing) As String
        Return String.Format("{0} ({1}) {2} ({3}%)", FormatPhoneNumber(phone.phoneField), phone.timeZoneField, phone.phoneTypeField, phone.scoreField)
    End Function

    Public Function BuilderAddress(add As DataAPI.BasicAddressRecord) As String
        Dim address = add.addressField
        Dim result = String.Format("{0} ({1} to {2})", FormatAddress(address), BuilderDate(add.dateFirstSeenField), BuilderDate(add.dateLastSeenField))
        If Not String.IsNullOrEmpty(address.buildingNameField) Then
            result = address.buildingNameField & " " & result
        End If
        Return result
    End Function

    Public Function FormatAddress(address As DataAPI.BasicAddress) As String
        Dim result = New StringBuilder() 'String.Format("{0}, {1}, {2} {3}", address.line1Field, address.cityField, address.stateField, address.zipField)
        If Not String.IsNullOrEmpty(address.buildingNameField) Then
            result.Append(address.buildingNameField & " ")
        End If

        If Not String.IsNullOrEmpty(address.line1Field) Then
            result.Append(address.line1Field & ", ")
        End If

        If Not String.IsNullOrEmpty(address.line2Field) Then
            result.Append(address.line2Field & ", ")
        End If

        If Not String.IsNullOrEmpty(address.cityField) Then
            result.Append(address.cityField & ", ")
        Else
            If Not String.IsNullOrEmpty(address.countyField) Then
                result.Append(address.countyField & ", ")
            End If
        End If

        If Not String.IsNullOrEmpty(address.stateField) Then
            result.Append(address.stateField & " ")
        End If

        If Not String.IsNullOrEmpty(address.zipField) Then
            result.Append(address.zipField)
        End If

        Return result.ToString
    End Function

    Public Function BuilderDate(dt As DataAPI.Date) As String
        Return String.Format("{0}/{1}/{2}", dt.monthField, dt.dayField, dt.yearField)
    End Function

    Function BuilderRelativeName(relative As DataAPI.TLOPhoneBookEntry) As String
        Dim name = String.Format("{0} {1}{2}", relative.nameField.firstNameField, relative.nameField.middleNameField & " ", relative.nameField.lastNameField)
        If relative.dateOfBirthField IsNot Nothing Then
            Return String.Format("{0} - Age: {1}", name, relative.dateOfBirthField.currentAgeField)
        End If

        Return name
    End Function

    Function FormatPhoneNumber(ByVal myNumber As String)
        Dim mynewNumber As String
        mynewNumber = ""
        myNumber = myNumber.Replace("(", "").Replace(")", "").Replace("-", "")
        If myNumber.Length < 10 Then
            mynewNumber = myNumber
        ElseIf myNumber.Length = 10 Then
            mynewNumber = "(" & myNumber.Substring(0, 3) & ") " &
                    myNumber.Substring(3, 3) & "-" & myNumber.Substring(6, 4)
        ElseIf myNumber.Length > 10 Then
            mynewNumber = "(" & myNumber.Substring(0, 3) & ") " &
                    myNumber.Substring(3, 3) & "-" & myNumber.Substring(6, 4) & " " &
                    myNumber.Substring(10)
        End If
        Return mynewNumber
    End Function
End Class

Namespace DataAPI
    Partial Public Class TLOLocateReportOutput
        Public Property BestPhones As String()
    End Class
End Namespace




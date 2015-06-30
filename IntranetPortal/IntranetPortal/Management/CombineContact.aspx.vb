Imports IntranetPortal.ShortSale
Imports Newtonsoft.Json.Linq

Public Class CombineContact
    Inherits System.Web.UI.Page
    Public ssCase = ""

    Dim NeedCheckList As String() = New String() {"Referral", "ListingAgent", "Buyer", "SellerAttorney", "BuyerAttorney", "TitleCompany", "Processor", "ShortSaleDept", "Processor", "Negotiator", "Closer", "Supervisor", "LenderContactId", "LenderAttorney", "EstateAttorneyId", "ContactId"}
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub



    Public Function SameNameContactList(c As ShortSaleCase) As List(Of String)
        'Dim o = New Object
        'Dim a = ""
        Dim duplicateContacts = New List(Of String)

        AddRangeDuplicate(duplicateContacts, IterateProperties(c), "Case")
        AddRangeDuplicate(duplicateContacts, IterateProperties(c.PropertyInfo), "Case PropertyInfo")
       
        For Each o In c.Mortgages
            AddRangeDuplicate(duplicateContacts, IterateProperties(o), "Case Mortgages")
        Next
        For Each o In c.PropertyInfo.Owners
            AddRangeDuplicate(duplicateContacts, IterateProperties(o), "Case PropertyInfo Owners")
        Next
        AddRangeDuplicate(duplicateContacts, IterateProperties(c.BuyerTitle), "Case BuygerTitle")
        AddRangeDuplicate(duplicateContacts, IterateProperties(c.SellerTitle), "Case SellerTitle")
        If (duplicateContacts.Count > 0) Then
            If (SaveChnage.Checked) Then
                c.SaveChanges()
            End If
            Return duplicateContacts
        End If
       

        Return Nothing
    End Function
    Sub AddRangeDuplicate(l As List(Of String), addList As List(Of String), title As String)
        If (addList IsNot Nothing) Then

            l.AddRange(addList.Select(Function(s) title & " " & s))
        End If
    End Sub
    Sub AddRangeDuplicate(l As List(Of String), addList As List(Of String))
        If (addList IsNot Nothing) Then
            l.AddRange(addList)
        End If
    End Sub
    Function IterateProperties(o As Object) As List(Of String)
        Dim type As Type = o.[GetType]()
        Dim properties = type.GetProperties()

        Dim haveMoreName = New List(Of String)
        For Each p In properties
            If (NeedCheckList.Contains(p.Name)) Then
                Dim contactId = p.GetValue(o, Nothing)
                If (contactId IsNot Nothing) Then
                    Dim cId = CInt(FindConatctId.Text)
                    If (cId = contactId) Then
                        p.SetValue(o, CInt(RepaceContactID.Text))
                        haveMoreName.Add(p.Name & " has more than one in contact Id = " & contactId & " to " & RepaceContactID.Text)
                    End If
                End If
                'If (p.PropertyType Is GetType(ShortSale.PartyContact)) Then
                '    Dim contact As ShortSale.PartyContact = TryCast(p.GetValue(o, Nothing), ShortSale.PartyContact)
                '    If (contact IsNot Nothing) Then
                '        Dim cList = ShortSale.PartyContact.GetContactListByName(contact.Name)
                '        If (cList.Count > 1) Then
                '            haveMoreName.Add(p.Name & " has more than one in contact Id = " & contact.ContactId & " Name = " & contact.Name)
                '        End If
                '    End If
                'End If
            End If
        Next
        If (haveMoreName.Count > 0) Then
            Return haveMoreName
        End If
        Return Nothing
    End Function

    Protected Sub LoadBtn_Click(sender As Object, e As EventArgs)
        'Dim summary = New List(Of String)
        Dim c = ShortSaleCase.GetCaseByBBLE("4065270013")
        ssCase = c.ToJsonString
        'Dim dl = SameNameContactList(c)
        'If (dl IsNot Nothing AndAlso dl.Count > 0) Then
        '    AddRangeDuplicate(summary, dl.Select(Function(s) "BBLE : " & c.BBLE & s).ToList)
        'End If

        'Dim cases = ShortSaleCase.GetAllCase()
        'For Each c In cases
        '    Dim dl = SameNameContactList(c)
        '    If (dl IsNot Nothing AndAlso dl.Count > 0) Then
        '        'AddRangeDuplicate(summary, dl.Select(Function(s) "BBLE : " & c.BBLE & s).ToList)
        '    End If

        'Next
        'gridDuplicateCase.DataSource = summary
        'gridDuplicateCase.DataBind()
    End Sub

    

    Protected Sub submitReplace_Click(sender As Object, e As EventArgs)
        Dim summary = New List(Of String)
        If (String.IsNullOrEmpty(FindConatctId.Text) Or String.IsNullOrEmpty(RepaceContactID.Text)) Then
            Throw New Exception("Need input FindConatctId or RepaceContactID")
        End If
        Dim cases = ShortSaleCase.GetAllCase()
        For Each c In cases
            Dim dl = SameNameContactList(c)
            If (dl IsNot Nothing AndAlso dl.Count > 0) Then
                AddRangeDuplicate(summary, dl.Select(Function(s) "BBLE : " & c.BBLE & s).ToList)
            End If

        Next
        gridDuplicateCase.DataSource = summary
        gridDuplicateCase.DataBind()

    End Sub
End Class
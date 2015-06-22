Imports IntranetPortal.ShortSale

Public Class ShortSaleManage
    Public Shared Sub MoveLeadsToShortSale(bble As String, createBy As String)
        Dim li = LeadsInfo.GetInstance(bble)

        If li IsNot Nothing Then
            Dim propBase = SaveProp(li, createBy)

            Dim ssCase = New ShortSaleCase(propBase)
            ssCase.BBLE = bble
            ssCase.CaseName = li.LeadsName
            ssCase.Status = ShortSale.CaseStatus.Active
            ssCase.Owner = GetIntaker()

            Dim processor = PartyContact.GetContactByName(ssCase.Owner)
            If processor IsNot Nothing Then
                ssCase.Processor = processor.ContactId
            End If

            ssCase.CreateBy = createBy
            ssCase.CreateDate = DateTime.Now

            ssCase = SetReferral(ssCase)
            ssCase.Save()

            If ssCase.CaseId > 0 Then
                If ssCase.Mortgages.Count = 0 Then
                    Dim mort As New PropertyMortgage
                    mort.CaseId = ssCase.CaseId
                    mort.Status = "Intake - New File"
                    mort.Save()
                End If
            End If
        End If
    End Sub

    Public Shared Sub UpdateReferral()
        Dim ssCases = ShortSaleCase.GetAllCase().Where(Function(ss) ss.Referral Is Nothing).ToList

        For Each ss In ssCases
            If ss.Referral Is Nothing Then
                ss = SetReferral(ss)
                ss.Save()
            End If
        Next
    End Sub

    Private Shared Function SetReferral(ssCase As ShortSaleCase)
        Dim ld = Lead.GetInstance(ssCase.BBLE)
        If ld IsNot Nothing Then
            Dim referral = ShortSale.PartyContact.GetContactByName(ld.EmployeeName)
            If referral IsNot Nothing Then
                ssCase.Referral = referral.ContactId
            End If
        End If

        Return ssCase
    End Function

    Public Shared Function GetShortSaleCasesByUsers(users As String()) As List(Of ShortSaleCase)
        Using ctx As New Entities
            Dim bbles = ctx.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso users.Contains(l.EmployeeName)).Select(Function(l) l.BBLE).ToList
            If Utility.IsAny(bbles) Then
                Return ShortSale.ShortSaleCase.GetCaseByBBLEs(bbles)
            End If
        End Using

        Return New List(Of ShortSaleCase)
    End Function

    Public Shared Function GetEvictionCasesByUsers(users As String()) As List(Of EvictionCas)
        Using ctx As New Entities
            Dim bbles = ctx.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso users.Contains(l.EmployeeName)).Select(Function(l) l.BBLE).ToList

            If Utility.IsAny(bbles) Then
                Return ShortSale.EvictionCas.GetCaseByBBLEs(bbles)
            End If
        End Using

        Return New List(Of EvictionCas)
    End Function

    Public Shared Function SaveProp(li As LeadsInfo, createBy As String) As IntranetPortal.ShortSale.PropertyBaseInfo
        Dim propBase = IntranetPortal.ShortSale.PropertyBaseInfo.GetInstance(li.BBLE)

        If propBase Is Nothing Then
            propBase = New IntranetPortal.ShortSale.PropertyBaseInfo
            propBase.BBLE = li.BBLE
            propBase.Borough = li.Borough
            propBase.Block = li.Block
            propBase.Lot = li.Lot
            propBase.Number = li.Number
            propBase.StreetName = li.StreetName
            propBase.City = li.NeighName
            propBase.State = li.State
            propBase.Zipcode = li.ZipCode
            propBase.TaxClass = li.TaxClass
            propBase.NumOfStories = li.NumFloors
            propBase.CreateDate = DateTime.Now
            propBase.CreateBy = createBy
            propBase.Save()
        End If

        Return propBase
    End Function

    Private Shared Function GetIntaker() As String
        Dim users = Roles.GetUsersInRole("ShortSale-Intake")
        If users.Length > 0 Then
            Return users(0)
        End If

        Return ""
        'Return System.Configuration.ConfigurationManager.AppSettings("ShortSaleIntake").ToString
    End Function
End Class

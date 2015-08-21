Imports System.Text.RegularExpressions
Imports System.Text
Imports Newtonsoft.Json

Partial Public Class ShortSaleCase

#Region "Constructor"

    Public Sub New(propBaseinfo As PropertyBaseInfo)
        _propInfo = propBaseinfo
    End Sub

    Public Sub New()

    End Sub

#End Region

#Region "Properties"

    Private _statuStr As String

    Public ReadOnly Property StatuStr As String
        Get
            If _statuStr Is Nothing Then
                Try
                    Dim caseStatusE = CType(Status, CaseStatus)
                    _statuStr = caseStatusE.ToString()
                Catch ex As Exception

                End Try

            End If
            Return _statuStr
        End Get
    End Property

    Private _propInfo As PropertyBaseInfo
    Public Property PropertyInfo As PropertyBaseInfo
        Get
            If _propInfo Is Nothing Then
                _propInfo = PropertyBaseInfo.GetInstance(BBLE)
                '_propInfo.StreetName
                If _propInfo Is Nothing Then
                    _propInfo = New PropertyBaseInfo With
                                {
                                    .BBLE = BBLE
                                    }
                End If
            End If

            Return _propInfo
        End Get
        Set(value As PropertyBaseInfo)
            _propInfo = value
        End Set
    End Property

    Private _judgementInfo As TitleJudgementSearch
    Public ReadOnly Property JudgementInfo
        Get
            If _judgementInfo Is Nothing Then
                _judgementInfo = TitleJudgementSearch.GetInstance(CaseId)

                If _judgementInfo Is Nothing Then
                    _judgementInfo = New TitleJudgementSearch
                    _judgementInfo.CaseId = CaseId
                End If
            End If

            Return _judgementInfo
        End Get
    End Property

    Private _mortgages As PropertyMortgage()
    Public Property Mortgages As PropertyMortgage()
        Get
            If _mortgages Is Nothing Then
                Using context As New ShortSaleEntities
                    _mortgages = context.PropertyMortgages.Where(Function(mg) mg.CaseId = CaseId).ToArray

                    If (_mortgages.Count = 0) Then
                        _mortgages = {New PropertyMortgage}
                    End If
                End Using
            End If

            Return _mortgages
        End Get
        Set(value As PropertyMortgage())
            _mortgages = value
        End Set
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property FirstMortgage As PropertyMortgage
        Get
            If Mortgages IsNot Nothing AndAlso Mortgages.Count > 0 Then
                Return Mortgages(0)
            End If

            Return New PropertyMortgage
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property SecondMortgage As PropertyMortgage
        Get
            If Mortgages IsNot Nothing AndAlso Mortgages.Count > 1 Then
                Return Mortgages(1)
            End If

            Return New PropertyMortgage
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property ValuationData As PropertyValueInfo
        Get
            If ValueInfoes IsNot Nothing AndAlso ValueInfoes.Count > 0 Then
                Return ValueInfoes(0)
            End If

            Return New PropertyValueInfo
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property OfferData As ShortSaleOffer
        Get
            If ShortSaleOffers IsNot Nothing AndAlso ShortSaleOffers.Count > 0 Then
                Return ShortSaleOffers(0)
            End If

            Return New ShortSaleOffer
        End Get
    End Property

    Public Property PropertyOwner As PropertyOwner
    Public Property LastActivity As ShortSaleActivityLog
    Public Property PipeLine As ShortSaleActivityLog
    Public Property MortgageStatus As String
    Public Property ReferralName As String
    Public Property ReferralManager As String
    Public Property LastFileOverview As ShortSaleOverview
    'Public Property MortgageCategory As String

    Private _sellerTitle As PropertyTitle
    Public ReadOnly Property SellerTitle As PropertyTitle
        Get
            If _sellerTitle Is Nothing Then
                _sellerTitle = PropertyTitle.GetTitle(CaseId, PropertyTitle.TitleType.Seller)
            End If

            Return _sellerTitle
        End Get
    End Property

    Private _buyerTitle As PropertyTitle
    Public ReadOnly Property BuyerTitle As PropertyTitle
        Get
            If _buyerTitle Is Nothing Then
                _buyerTitle = PropertyTitle.GetTitle(CaseId, PropertyTitle.TitleType.Buyer)
            End If

            Return _buyerTitle
        End Get
    End Property

    Private _clearences As List(Of TitleClearence)
    Public ReadOnly Property Clearences As List(Of TitleClearence)
        Get
            Return TitleClearence.GetCaseClearences(CaseId)
        End Get
    End Property

    Private _processorContact As PartyContact
    Public ReadOnly Property ProcessorContact As PartyContact
        Get
            If _processorContact Is Nothing AndAlso Processor.HasValue Then
                _processorContact = PartyContact.GetContact(Processor)
            End If

            Return _processorContact
        End Get
    End Property

    Private _comments As List(Of ShortSaleCaseComment)
    Public ReadOnly Property Comments As List(Of ShortSaleCaseComment)
        Get
            If _comments Is Nothing Then
                _comments = ShortSaleCaseComment.GetCaseComments(CaseId)
            End If

            Return _comments
        End Get
    End Property

    Private _upComingDate As DateTime
    Public Property UpComingBPODate As DateTime?
        Get
            If Mortgages IsNot Nothing AndAlso Mortgages.Count > 0 Then
                Return Mortgages(0).UpcomingBPODate
            End If

            Return Nothing
        End Get
        Set(value As DateTime?)
            If value IsNot Nothing Then
                _upComingDate = value
            End If
        End Set
    End Property

    Private _valueInfos As PropertyValueInfo()
    Public Property ValueInfoes As PropertyValueInfo()
        Get
            If _valueInfos Is Nothing Then
                _valueInfos = PropertyValueInfo.GetValueInfos(BBLE).ToArray
            End If

            Return _valueInfos
        End Get
        Set(value As PropertyValueInfo())
            _valueInfos = value
        End Set
    End Property

    Private _offers As ShortSaleOffer()
    Public Property ShortSaleOffers As ShortSaleOffer()
        Get
            If _offers Is Nothing Then
                _offers = ShortSaleOffer.GetOffers(BBLE).ToArray
            End If

            Return _offers
        End Get
        Set(value As ShortSaleOffer())
            _offers = value
        End Set
    End Property

    Private _buyerEntity As ShortSaleBuyer
    Public Property BuyerEntity As ShortSaleBuyer
        Get
            If _buyerEntity Is Nothing Then
                _buyerEntity = ShortSaleBuyer.Instance(BBLE)
            End If

            Return _buyerEntity
        End Get
        Set(value As ShortSaleBuyer)
            If String.IsNullOrEmpty(value.BBLE) Then
                value.BBLE = BBLE
            End If

            _buyerEntity = value
        End Set
    End Property

    Public Property DocumentRequestDetails As String

    Public ReadOnly Property AssignedProcessor As PartyContact
        Get
            If Processor.HasValue Then
                Return PartyContact.GetContact(Processor)
            Else
                Return New PartyContact()
            End If
        End Get
    End Property

    Public ReadOnly Property ReferralContact As PartyContact
        Get
            If Referral.HasValue Then
                Return PartyContact.GetContact(Referral)
            Else
                Return New PartyContact
            End If
        End Get
    End Property

    Public ReadOnly Property ListingAgentContact As PartyContact
        Get
            If ListingAgent.HasValue Then
                Return PartyContact.GetContact(ListingAgent)
            Else
                Return New PartyContact
            End If
        End Get
    End Property

    Public ReadOnly Property Manager As String
        Get
            Return ""
        End Get
    End Property

    Public ReadOnly Property BuyerContact As PartyContact
        Get
            If Buyer.HasValue Then
                Return PartyContact.GetContact(Buyer)
            Else
                Return New PartyContact
            End If
        End Get
    End Property

    Public ReadOnly Property FristMortageProgress As String
        Get
            Return GetMortageStauts(0)

        End Get
    End Property

    Public ReadOnly Property OwnerLastName As String
        Get
            If PropertyInfo IsNot Nothing AndAlso PropertyInfo.Owners IsNot Nothing AndAlso PropertyInfo.Owners.Count > 0 Then
                Return PropertyInfo.Owners(0).LastName
            End If
            Return ""
        End Get
    End Property

    Public ReadOnly Property OwnerFirstName As String
        Get
            If PropertyInfo IsNot Nothing AndAlso PropertyInfo.Owners IsNot Nothing AndAlso PropertyInfo.Owners.Count > 0 Then
                Return PropertyInfo.Owners(0).FirstName
            End If
            Return ""
        End Get
    End Property

    Public ReadOnly Property OwnerFullName As String
        Get
            If PropertyInfo IsNot Nothing AndAlso PropertyInfo.Owners IsNot Nothing AndAlso PropertyInfo.Owners.Count > 0 Then
                Dim owner = PropertyInfo.Owners(0)
                Return owner.FirstName & " " & owner.LastName
            End If

            Return ""
        End Get
    End Property

    Public Property EvictionOwner As String

#Region "Mortgages"

    Public ReadOnly Property Investor As String
        Get
            Return GetMortageType(0)
        End Get
    End Property

    Function GetMortageStauts(ByVal index As Integer) As String
        If (Mortgages IsNot Nothing AndAlso Mortgages.Count > index) Then

            Return Mortgages.OrderBy(Function(mort) mort.MortgageId).ToList(index).Status
        End If
        Return Nothing
    End Function

    Function GetMortageType(ByVal index As Integer) As String
        If (Mortgages IsNot Nothing AndAlso Mortgages.Count > index) Then

            Return Mortgages.OrderBy(Function(mort) mort.MortgageId).ToList(index).Type
        End If
        Return Nothing
    End Function

    Public ReadOnly Property FristMortageLender()
        Get
            Return GetMortageLonder(0)
        End Get
    End Property
    Public ReadOnly Property SencondMortageLender()
        Get
            Return GetMortageLonder(1)
        End Get
    End Property

    Function GetMortageLonder(ByVal index As Integer) As String
        If (Mortgages IsNot Nothing AndAlso Mortgages.Count > index) Then

            Dim mtg = Mortgages.OrderBy(Function(mort) mort.MortgageId).ToList(index)

            If Not String.IsNullOrEmpty(mtg.Lender) Then
                Return mtg.Lender
            Else
                If mtg.LenderId.HasValue Then
                    Dim party = PartyContact.GetContact(mtg.LenderId)
                    If party IsNot Nothing Then
                        Return party.Name
                    End If
                End If
            End If
        End If
        Return Nothing
    End Function

    Public ReadOnly Property SencondMortageProgress As String
        Get
            Return GetMortageStauts(1)
        End Get
    End Property

    Private _mortgageCategory As String
    Public Property MortgageCategory As String
        Get
            If String.IsNullOrEmpty(_mortgageCategory) Then
                If Mortgages IsNot Nothing AndAlso Mortgages.Count > 0 Then
                    _mortgageCategory = Mortgages.OrderBy(Function(m) m.MortgageId).ToList(0).Category
                End If
            End If

            Return _mortgageCategory
        End Get
        Set(value As String)
            _mortgageCategory = value
        End Set
    End Property

#End Region

    Public ReadOnly Property SellerAttorneyContact As PartyContact
        Get
            If SellerAttorney.HasValue Then
                Return PartyContact.GetContact(SellerAttorney)
            Else
                Return New PartyContact
            End If
        End Get
    End Property

    Public ReadOnly Property BuyerAttorneyContact As PartyContact
        Get
            If BuyerAttorney.HasValue Then
                Return PartyContact.GetContact(BuyerAttorney)
            Else
                Return New PartyContact
            End If
        End Get
    End Property

    Public ReadOnly Property TitleCompanyContact As PartyContact
        Get
            If TitleCompany.HasValue Then
                Return PartyContact.GetContact(TitleCompany)
            Else
                Return New PartyContact
            End If
        End Get
    End Property

    Private _occupants As List(Of PropertyOccupant)
    Public Property Occupants As List(Of PropertyOccupant)
        Get
            If _occupants Is Nothing Then
                _occupants = PropertyOccupant.GetOccupantsByCase(CaseId)
            End If

            Return _occupants
        End Get
        Set(value As List(Of PropertyOccupant))
            _occupants = value
        End Set
    End Property

    Public ReadOnly Property LastComments As String
        Get
            Return ""
        End Get
    End Property

    Public ReadOnly Property Duration As String
        Get
            If CreateDate.HasValue Then
                Dim ts = (DateTime.Now - CreateDate)
                If ts.HasValue AndAlso ts.Value.Days > 0 Then
                    Return ts.Value.Days & " days"
                End If
            End If

            Return ""
        End Get
    End Property


#Region "Report Properties"

    <JsonIgnoreAttribute>
    Public ReadOnly Property ReportDetails As String
        Get
            Dim sb As New StringBuilder
            sb.Append("Investor: " & GetMortageType(0) & Environment.NewLine)

            If ValueInfoes IsNot Nothing AndAlso ValueInfoes.Count > 0 Then
                Dim val = ValueInfoes(0)
                sb.Append("Date of Valuation: " & String.Format("{0:d}", val.DateOfValue) & Environment.NewLine)
                sb.Append("Expiration Date of Value: " & String.Format("{0:d}", val.ExpiredOn) & Environment.NewLine)
                sb.Append("Value: " & String.Format("{0:C}", val.BankValue) & Environment.NewLine)
            End If

            sb.Append("Date Offer Submitted: " & String.Format("{0:d}", OfferDate) & Environment.NewLine)
            sb.Append("Offer: " & String.Format("{0:C}", OfferSubmited) & Environment.NewLine)
            sb.Append("Lender Counter: " & LenderCounter & Environment.NewLine)
            sb.Append("Counter Submitted: " & String.Format("{0:d}", CounterSubmited) & Environment.NewLine)
            sb.Append("Current Status: " & FristMortageProgress & Environment.NewLine)
            sb.Append("Documents Missing: " & If(DocumentMissing.HasValue, If(DocumentMissing, "Yes", "No"), "N/A") & Environment.NewLine)

            If DocumentMissing.HasValue AndAlso DocumentMissing Then
                sb.Append(MissingDocDescription & Environment.NewLine)
            End If

            sb.Append("Start Intake: " & If(StartIntake, "Yes", "No") & Environment.NewLine)

            If PipeLine IsNot Nothing Then
                sb.Append("Update/Notes: " & ShortSaleUtility.StripTagsCharArray(PipeLine.Description))
            End If

            Return sb.ToString
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property RptPropertyInfo As String
        Get
            Dim sb As New StringBuilder
            sb.Append(NewLine("Address", PropertyInfo.PropertyAddress))

            If PropertyOwner IsNot Nothing Then
                sb.Append(NewLine("First Name", PropertyOwner.FirstName))
                sb.Append(NewLine("Last Name", PropertyOwner.LastName))
            End If

            sb.Append(NewLine("Occupancy", PropertyInfo.Occupancy))
            Return sb.ToString
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property RptMortgageInfo As String
        Get
            Dim sb As New StringBuilder
            sb.Append(NewLine("Investor", GetMortageType(0)))
            sb.Append(NewLine("1st Mortgage", FristMortageLender))
            sb.Append(NewLine("2nd Mortgage", SencondMortageLender))

            Return sb.ToString
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property RptValuation As String
        Get
            If ValueInfoes IsNot Nothing AndAlso ValueInfoes.Count > 0 Then
                Dim valueData = ValueInfoes.Last
                Dim sb As New StringBuilder
                sb.Append(NewLine("Type of Value", valueData.Method))
                sb.Append(NewLine("Date of Value", String.Format("{0:d}", valueData.DateOfValue)))
                sb.Append(NewLine("Value", String.Format("{0:c}", valueData.BankValue)))
                sb.Append(NewLine("Expiration", String.Format("{0:d}", valueData.ExpiredOn)))

                Return sb.ToString
            End If

            Return Nothing
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property RptOffer As String
        Get
            If ShortSaleOffers IsNot Nothing AndAlso ShortSaleOffers.Count > 0 Then
                Dim offer = ShortSaleOffers.Last
                Dim sb As New StringBuilder
                sb.Append(NewLine("Type", offer.OfferType))
                sb.Append(NewLine("Amount", String.Format("{0:c}", offer.OfferAmount)))
                sb.Append(NewLine("Date offer submitted", String.Format("{0:d}", offer.DateSubmited)))
                'sb.Append(NewLine("Buyer's Counter", ShortSaleOffers(0).BuyerEntity))
                Return sb.ToString
            End If

            Return Nothing
        End Get
    End Property

    Private Function NewLine(title As String, text As String) As String
        Return String.Format("{0}: {1}", title, text) & Environment.NewLine
    End Function

#End Region

#End Region

#Region "Methods"

    Public Sub RefreshReportFields()

        'Init Occupancy Data
        Me.OccupiedBy = If(_propInfo IsNot Nothing, _propInfo.Occupancy, Nothing)

        'Sale Date
        If FirstMortgage IsNot Nothing Then
            If FirstMortgage.HasAuctionDate Then
                SaleDate = FirstMortgage.DateOfSale
            End If
        End If
    End Sub

    Public Sub Save(Optional userName As String = Nothing)
        Using context As New ShortSaleEntities
            RefreshReportFields()

            If CaseId = 0 Then
                If Not String.IsNullOrEmpty(BBLE) Then
                    Dim tmpCase = context.ShortSaleCases.Where(Function(ss) ss.BBLE = BBLE).FirstOrDefault
                    If tmpCase IsNot Nothing Then
                        CaseId = tmpCase.CaseId
                    End If
                Else
                    Return
                End If
            End If

            If CaseId = 0 Then
                CreateDate = DateTime.Now
                CreateBy = userName
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.ShortSaleCases.Find(CaseId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
                If userName IsNot Nothing Then
                    obj.UpdateBy = userName
                End If

                obj.UpdateDate = DateTime.Now
                context.SaveChanges()
            End If

            context.SaveChanges()

            'Save mortgages
            If _mortgages IsNot Nothing Then
                For Each mg In _mortgages
                    If mg.CaseId = 0 Then
                        mg.CaseId = CaseId
                    End If

                    mg.Save(userName)
                Next
            End If

            'save offers
            If _offers IsNot Nothing Then
                For Each offer In _offers
                    If String.IsNullOrEmpty(offer.BBLE) Then
                        offer.BBLE = BBLE
                    End If
                    offer.Save(userName)
                Next
            End If

            Dim oldOffers = context.ShortSaleOffers.Where(Function(so) so.BBLE = BBLE).ToList
            If oldOffers.Count > _offers.Count Then
                For Each offer In oldOffers
                    If Not _offers.Any(Function(so) so.OfferId = offer.OfferId) Then
                        context.ShortSaleOffers.Remove(offer)
                    End If
                Next

                context.SaveChanges()
            End If

            'Save value info
            If _valueInfos IsNot Nothing Then
                For Each info In _valueInfos
                    If String.IsNullOrEmpty(info.BBLE) Then
                        info.BBLE = BBLE
                    End If

                    info.Save()
                Next
            End If

            Dim oldInfoes = context.PropertyValueInfoes.Where(Function(pv) pv.BBLE = BBLE).ToList
            If oldInfoes.Count > _valueInfos.Count Then
                For Each info In oldInfoes
                    If Not _valueInfos.Any(Function(vi) vi.ValueId = info.ValueId) Then
                        context.PropertyValueInfoes.Remove(info)
                    End If
                Next

                context.SaveChanges()
            End If

            If _propInfo IsNot Nothing Then
                _propInfo.Save()
            End If

            If _judgementInfo IsNot Nothing Then
                _judgementInfo.Save()
            End If

            If _sellerTitle IsNot Nothing Then
                _sellerTitle.CaseId = CaseId
                _sellerTitle.Type = PropertyTitle.TitleType.Seller
                _sellerTitle.Save()
            End If

            If _buyerTitle IsNot Nothing Then
                _buyerTitle.CaseId = CaseId
                _buyerTitle.Type = PropertyTitle.TitleType.Buyer
                _buyerTitle.Save()
            End If

            If _occupants IsNot Nothing Then
                For Each opt In _occupants
                    If Not opt.CaseId.HasValue Then
                        opt.CaseId = CaseId
                    End If
                    opt.Save()
                Next
            End If

            If _buyerEntity IsNot Nothing Then
                If String.IsNullOrEmpty(_buyerEntity.BBLE) Then
                    _buyerEntity.BBLE = BBLE
                End If

                _buyerEntity.Save()
            End If

        End Using
    End Sub

    Public Sub UpdateMortgageStatus(mortgageIndex As Integer, category As String, status As String, updateBy As String)
        If Mortgages.Count > mortgageIndex Then
            Dim obj = Mortgages(mortgageIndex)
            If obj IsNot Nothing Then
                obj.Status = status
                obj.Category = category
                obj.Save(updateBy)

                RefreshStatus()
            End If
        End If
    End Sub

    Public Sub RefreshStatus()
        If Me.Mortgages.Where(Function(mt) mt.Status <> "").Count > 0 Then
            If Mortgages.Where(Function(mt) mt.Status = "Closed").Count = Mortgages.Count Then
                'SaveStatus(CaseStatus.Closed)
            Else
                If Status = CaseStatus.NewFile Then
                    SaveStatus(CaseStatus.Active)
                End If
            End If
        End If
    End Sub

    Public Sub SaveStatus(status As CaseStatus)
        Me.Status = status
        Save()
    End Sub

    Public Sub SaveFollowUp(dt As DateTime)
        Me.Status = CaseStatus.FollowUp
        Me.CallbackDate = dt
        Save()
    End Sub

    Public Sub SaveChanges()
        Save()
        'If CaseId > 0 Then
        '    Using context As New ShortSaleEntities
        '        Dim origCase = context.ShortSaleCases.Find(CaseId)
        '        origCase = Utility.SaveChangesObj(origCase, Me)
        '        context.SaveChanges()
        '    End Using
        'End If
    End Sub


    Public Shared Sub ReassignOwner(caseId As Integer, owner As String)
        Dim ssCase = GetCase(caseId)
        If ssCase Is Nothing Then
            Throw New Exception("Can't find short sale case. Case Id is " & caseId)
        End If

        ssCase.ReassignOwner(owner)
    End Sub

    Public Shared Sub ReassignOwner(bble As String, owner As String)
        Dim ssCase = GetCaseByBBLE(bble)
        If ssCase Is Nothing Then
            Throw New Exception("Can't find short sale case. BBLE is " & bble)
        End If

        ssCase.ReassignOwner(owner)
    End Sub

    Private Sub ReAssignOwner(owner As String)
        Me.Owner = owner
        'Me.Status = CaseStatus.Active

        Dim party = PartyContact.GetContactByName(owner)

        If party IsNot Nothing Then
            Me.Processor = party.ContactId
            Me.ProcessorName = owner
        End If

        Me.UpdateDate = DateTime.Now

        Save()
    End Sub

    Public Shared Function SaveCase(ssCase As ShortSaleCase) As Boolean
        Try
            ssCase.Save()
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Sub SaveEntity()
        Using ctx As New ShortSaleEntities

            ctx.Entry(Me).State = Entity.EntityState.Modified
            ctx.SaveChanges()
        End Using
    End Sub


    Public Shared Function DeleteCase(caseId As Integer) As Boolean
        Return True
    End Function

    Public Shared Function GetCase(caseId As Integer) As ShortSaleCase
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Find(caseId)
        End Using
    End Function

    Public Shared Function GetCaseByBBLE(bble As String) As ShortSaleCase
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Where(Function(ss) ss.BBLE = bble).SingleOrDefault
        End Using
    End Function

    Public Shared Function GetAllCase() As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.ToList
        End Using
    End Function

    Public Shared Function GetCaseByStatus(status As CaseStatus) As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            If status = CaseStatus.Eviction Then
                Return GetEvictionCases()
            Else

                If status = CaseStatus.Archived Then
                    Return GetArchivedCases()
                End If

                Return context.ShortSaleCases.Where(Function(ss) ss.Status = status).ToList
            End If
        End Using
    End Function

    Public Shared Function GetCaseByOwner(owner As String) As List(Of ShortSaleCase)
        Using Context As New ShortSaleEntities
            Return Context.ShortSaleCases.Where(Function(ss) ss.Owner = owner).ToList
        End Using
    End Function

    Public Shared Function GetCaseByStatus(status As CaseStatus, owner As String) As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return GetCaseByStatus(status).Where(Function(ss) ss.Owner = owner Or owner = Nothing).ToList
            'Return context.ShortSaleCases.Where(Function(ss) ss.Status = status AndAlso ss.Owner = owner).ToList
        End Using
    End Function

    Public Shared Function GetArchivedCases() As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim allCases = (From ss In ctx.ShortSaleCases
                         Join mort In ctx.PropertyMortgages On ss.CaseId Equals mort.CaseId
                        Where ss.Status = CaseStatus.Archived
                         Select ss, mort).Distinct.ToList.Select(Function(s)
                                                                     s.ss.MortgageCategory = s.mort.Category
                                                                     Return s.ss
                                                                 End Function).Distinct.ToList()

            Return allCases
        End Using
    End Function

    Public Shared Function GetCaseByCategory(category As String, Optional owner As String = Nothing) As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim nonActiveStatus = {CaseStatus.Archived, CaseStatus.NewFile}
            If category = "All" Then
                Dim allCases = (From ss In ctx.ShortSaleCases Where Not nonActiveStatus.Contains(ss.Status) AndAlso (ss.Owner = owner Or owner = Nothing)
                                From mort In ctx.PropertyMortgages.Where(Function(m) m.CaseId = ss.CaseId).Take(1).DefaultIfEmpty
                                Select ss, mort).Distinct.ToList.Select(Function(s)
                                                                            If s.mort IsNot Nothing Then
                                                                                s.ss.MortgageStatus = s.mort.Status
                                                                                s.ss.MortgageCategory = If(String.IsNullOrEmpty(s.mort.Category), Nothing, s.mort.Category)
                                                                            End If

                                                                            Return s.ss
                                                                        End Function).Distinct.ToList()

                Return allCases
            End If

            If category = "Upcoming" Then
                Dim allcases = (From ss In ctx.ShortSaleCases Where Not nonActiveStatus.Contains(ss.Status) And ss.SaleDate IsNot Nothing AndAlso (ss.Owner = owner Or owner = Nothing)
                                From mort In ctx.PropertyMortgages.Where(Function(m) m.CaseId = ss.CaseId).Take(1).DefaultIfEmpty
                                Select ss, mort).Distinct.ToList.Select(Function(s)
                                                                            If s.mort IsNot Nothing Then
                                                                                s.ss.MortgageStatus = s.mort.Status
                                                                            End If

                                                                            Return s.ss
                                                                        End Function).Distinct.ToList()

                Return allcases
            End If

            'Dim result = (From ss In ctx.ShortSaleCases
            '                 Join mort In ctx.PropertyMortgages On ss.CaseId Equals mort.CaseId
            '                Where mort.Category = category And (ss.Owner = owner Or owner = Nothing) And Not nonActiveStatus.Contains(ss.Status)
            '                 Select ss, mort.Status).Distinct.ToList

            Dim result = (From ss In ctx.ShortSaleCases
                          From mort In ctx.PropertyMortgages.Where(Function(m) m.CaseId = ss.CaseId).Take(1).DefaultIfEmpty
                            Where mort.Category = category And (ss.Owner = owner Or owner = Nothing) And Not nonActiveStatus.Contains(ss.Status)
                             Select ss, mort.Status).Distinct.ToList

            Dim ssCases = result.Select(Function(s)
                                            s.ss.MortgageStatus = s.Status
                                            Return s.ss
                                        End Function).ToList

            If category = "Assign" Then
                'ssCases.AddRange(GetCaseByStatus(CaseStatus.NewFile, owner).Select(Function(s)
                '                                                                       s.MortgageStatus = "Others"
                '                                                                       Return s
                '                                                                   End Function).ToList)

                ssCases = ssCases.GroupBy(Function(ss) ss.BBLE).Select(Function(ss) ss.First).ToList
            End If

            Return ssCases
        End Using
    End Function

    Public Shared Function GetIntakeNewFile(userName As String) As List(Of ShortSaleCase)
        Dim status = {"Intake - New File", "Intake - Rescrub File"}
        Return GetCaseByMortgageStatus(status)
    End Function

    Public Shared Function GetCaseByMortgageStatus(mortStatus As String()) As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim result = (From ss In ctx.ShortSaleCases
                        Join mort In ctx.PropertyMortgages On ss.CaseId Equals mort.CaseId
                        Where mortStatus.Contains(mort.Status)
                        Select ss).Distinct.ToList

            Return result
        End Using
    End Function

    Public Shared Function GetCaseCount(status As CaseStatus, owner As String) As Integer
        Return GetCaseByStatus(status, owner).Count
    End Function

    Public Shared Function GetCaseCount(status As CaseStatus) As Integer
        Return GetCaseByStatus(status).Count
    End Function
    Public Shared Function GetCaseByBBLEs(bbles As List(Of String)) As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim result = (From ss In ctx.ShortSaleCases.Where(Function(s) bbles.Contains(s.BBLE))
                         From mort In ctx.PropertyMortgages.Where(Function(m) m.CaseId = ss.CaseId).Take(1).DefaultIfEmpty
                          Select ss, mort).Distinct.ToList.Select(Function(s)
                                                                      If s.mort IsNot Nothing Then
                                                                          s.ss.MortgageStatus = s.mort.Status
                                                                      End If
                                                                      Return s.ss
                                                                  End Function).OrderByDescending(Function(s) s.UpdateDate).Distinct.ToList()

            Return result
            'Return context.ShortSaleCases.Where(Function(ss) bbles.Contains(ss.BBLE)).ToList
        End Using
    End Function

    Public Shared Function GetEvictionCases() As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities

            Dim result = (From evi In ctx.EvictionCases
                         Join ss In ctx.ShortSaleCases On ss.BBLE Equals evi.BBLE
                         Select New With {.case = ss, .Name = evi.Owner}).ToList.Select(Function(s) ShortsaleCaseWithEvictionOwner(s.case, s.Name)).ToList

            Return result
        End Using
    End Function

    Private Shared Function ShortsaleCaseWithEvictionOwner(ss As ShortSaleCase, owner As String) As ShortSaleCase
        ss.EvictionOwner = owner
        Return ss
    End Function

    Public Shared Function InShortSale(bble As String) As Boolean
        Return GetCaseByBBLE(bble) IsNot Nothing
    End Function

    Public Shared Sub Remove(bble As String)
        Using ctx As New ShortSaleEntities
            Dim ssCase = ctx.ShortSaleCases.Where(Function(ss) ss.BBLE = bble).FirstOrDefault
            'If ssCase IsNot Nothing Then
            '    Dim mortgages = ctx.PropertyMortgages.Where(Function(pm) pm.CaseId = ssCase.CaseId)
            '    ctx.PropertyMortgages.RemoveRange(mortgages)

            '    Dim propBaseInfo = ctx.PropertyBaseInfoes.Where(Function(pb) pb.BBLE = bble)
            '    ctx.ShortSaleCases.Remove(ssCase)
            'End If
            ctx.ShortSaleCases.Remove(ssCase)
            ctx.SaveChanges()
        End Using
    End Sub

#End Region

#Region "Report"

    Public Shared Function CaseReport() As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim data = From ss In ctx.ShortSaleCases
                       Join pi In ctx.PropertyBaseInfoes On pi.BBLE Equals ss.BBLE
                       Let owner = ctx.PropertyOwners.FirstOrDefault(Function(po) po.BBLE = ss.BBLE)
                       Let morts = ctx.PropertyMortgages.Where(Function(pm) pm.CaseId = ss.CaseId)
                       Let values = ctx.PropertyValueInfoes.Where(Function(pv) pv.BBLE = ss.BBLE)
                       Select New With {.CaseId = ss.CaseId,
                                        .ShortSale = ss,
                                        .PropertyInfo = pi,
                                        .Owner = owner,
                                        .Mortgages = morts,
                                        .ValueInfo = values}

            'LastActivity = ctx.ShortSaleActivityLogs.Where(Function(sa) sa.BBLE = ss.BBLE).OrderByDescending(Function(sa) sa.ActivityDate).FirstOrDefault
            'PipeLine = ctx.ShortSaleActivityLogs.Where(Function(sa) sa.BBLE = ss.BBLE And sa.ActivityType = "PipeLine").OrderByDescending(Function(sa) sa.ActivityDate).FirstOrDefault

            Dim logs = (From sl In ctx.ShortSaleActivityLogs
                       From logId In ctx.ShortSaleActivityLogs.GroupBy(Function(lg) lg.BBLE).Select(Function(sg) sg.Max(Function(sd) sd.ActivityDate))
                       From pipeId In ctx.ShortSaleActivityLogs.GroupBy(Function(lg) lg.BBLE And lg.ActivityType = "Pipeline").Select(Function(sg) sg.Max(Function(sd) sd.ActivityDate))
                       Where sl.ActivityDate = logId Or sl.ActivityDate = pipeId
                       Select sl).Distinct
            Dim logsData = logs.ToList
            Dim result = New List(Of ShortSaleCase)
            For Each item In data.ToList
                Dim logData = logsData.Where(Function(sl) sl.BBLE.StartsWith(item.ShortSale.BBLE)).ToList

                item.ShortSale.PropertyInfo = item.PropertyInfo
                item.ShortSale.Mortgages = item.Mortgages.ToArray
                item.ShortSale.PropertyOwner = item.Owner
                item.ShortSale.ValueInfoes = item.ValueInfo.ToArray
                item.ShortSale.LastActivity = logData.OrderByDescending(Function(sa) sa.ActivityDate).FirstOrDefault
                item.ShortSale.PipeLine = logData.Where(Function(Sa) Sa.ActivityType = "Pipeline").OrderByDescending(Function(sa) sa.ActivityDate).FirstOrDefault

                result.Add(item.ShortSale)
            Next

            Return result
        End Using
    End Function

    Public Shared Function CaseReport2() As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim data = From ss In ctx.ShortSaleCases.Where(Function(sc) sc.Status <> CaseStatus.Archived)
                       Join pi In ctx.PropertyBaseInfoes On pi.BBLE Equals ss.BBLE
                       Let owner = ctx.PropertyOwners.FirstOrDefault(Function(po) po.BBLE = ss.BBLE)
                       Let morts = ctx.PropertyMortgages.Where(Function(pm) pm.CaseId = ss.CaseId).OrderBy(Function(m) m.MortgageId)
                       Let values = ctx.PropertyValueInfoes.Where(Function(pv) pv.BBLE = ss.BBLE)
                       Let fileOverview = ctx.ShortSaleOverviews.Where(Function(pv) pv.BBLE = ss.BBLE).OrderByDescending(Function(pv) pv.ActivityDate).FirstOrDefault
                       Select New With {.CaseId = ss.CaseId,
                                        .ShortSale = ss,
                                        .PropertyInfo = pi,
                                        .Owner = owner,
                                        .Mortgages = morts,
                                        .ValueInfo = values,
                                        .Overview = fileOverview}


            Return data.ToList.Select(Function(item)
                                          item.ShortSale.PropertyInfo = item.PropertyInfo
                                          item.ShortSale.Mortgages = item.Mortgages.ToArray
                                          item.ShortSale.PropertyOwner = item.Owner
                                          item.ShortSale.ValueInfoes = item.ValueInfo.ToArray
                                          item.ShortSale.LastFileOverview = item.Overview

                                          Return item.ShortSale
                                      End Function).ToList
        End Using
    End Function

#End Region

    'Public Overrides Function Equals(obj As Object) As Boolean
    '    If obj Is Nothing Then
    '        Return False
    '    End If

    '    Dim ss = CType(obj, ShortSaleCase)
    '    Return CaseId = obj.CaseId
    'End Function

End Class

Public Enum CaseStatus
    NewFile = 0
    FollowUp = 1
    Active = 2
    Eviction = 3
    OnHold = 4
    Closed = 5
    Archived = 6
End Enum

Public Enum ModelStatus
    Original = 0
    Added = 1
    Modified = 2
    Deleted = 3
End Enum

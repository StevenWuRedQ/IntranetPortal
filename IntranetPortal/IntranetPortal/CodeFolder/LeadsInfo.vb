Public Class LeadsInfo
    Public Enum LeadsType
        All = 11
        DevelopmentOpportunity = 0
        Foreclosure = 1
        HasEquity = 2
        TaxLien = 3
        VacantLand = 4
        WaterLien = 5
        UnbuiltProperty = 6
        VacantHouse = 7
        StalledProject = 8
        AEP = 9
        ShortSale = 10
        CoOpConversion = 12
    End Enum

    Public ReadOnly Property IsApartment() As Boolean
        Get
            If Not String.IsNullOrEmpty(BBLE) Then
                Return BBLE.StartsWith("A")
            End If
            Return False
        End Get
    End Property

    Public ReadOnly Property AptBBLE As String
        Get
            If IsApartment Then
                Return String.Format("{0}#{1}", BuildingBBLE, UnitNum)
            End If

            Return BBLE
        End Get
    End Property

    Public ReadOnly Property AptBuildingInfo As ApartmentBuilding
        Get
            If IsApartment Then
                Using ctx As New Entities
                    Dim buildingId = CInt(BBLE.Substring(1, 5))
                    Return ctx.ApartmentBuildings.Find(buildingId)
                End Using
            End If

            Return Nothing
        End Get
    End Property

    Public ReadOnly Property Address1 As String
        Get
            Return String.Format("{2} {0} {1}", Number, StreetName, UnitNum).Trim
        End Get
    End Property

    'Get assign leads type
    Public Function GetLeadsType(type As String) As LeadsType
        Dim retType = Nothing
        If [Enum].TryParse(Of LeadsType)(type.Replace(" ", ""), retType) Then
            Return retType
        End If

        Return Nothing
    End Function

    Private _listPens As List(Of PortalLisPen)
    Public ReadOnly Property LisPens As List(Of PortalLisPen)
        Get
            If _listPens Is Nothing Then
                Using context As New Entities
                    _listPens = context.PortalLisPens.Where(Function(li) li.BBLE = BBLE).ToList
                End Using
            End If

            Return _listPens
        End Get
    End Property

    Public ReadOnly Property LastComment As String
        Get
            Using ctx As New Entities
                Return ctx.LeadsActivityLogs.Where(Function(l) l.BBLE = BBLE).Select(Function(l) l.Comments).FirstOrDefault
            End Using
        End Get
    End Property

    Public ReadOnly Property LastLP As String
        Get

            Dim lp = LisPens.FirstOrDefault()
            If (lp IsNot Nothing) Then
                Return lp.Docket_Number & "/" & lp.FileDate.Year
            End If
            Return Nothing
        End Get
    End Property

    Public ReadOnly Property BoroughName() As String
        Get
            Return Utility.Borough2BoroughName(Borough)
        End Get
    End Property

    Public ReadOnly Property UserComments As List(Of LeadsComment)
        Get
            Using context As New Entities
                Return context.LeadsComments.Where(Function(li) li.BBLE = BBLE).OrderBy(Function(li) li.OrderIndex).ToList
            End Using
        End Get
    End Property

    Public ReadOnly Property OwnerPhoneNo As String
        Get
            Using context As New Entities
                Dim phones = context.OwnerContacts.Where(Function(hp) hp.BBLE = BBLE And hp.ContactType = OwnerContact.OwnerContactType.Phone And hp.Status = OwnerContact.ContactStatus.Right).Select(Function(hp) hp.Contact).ToList
                phones.AddRange(context.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE And p.Source = PhoneSource.UserAdded).Select(Function(p) p.Phone).ToList)
                If phones.Count > 0 Then
                    Return String.Join(",", phones.ToArray)
                End If
            End Using

            Return ""
        End Get
    End Property

    Public ReadOnly Property OwnerAddress As List(Of String)
        Get
            Using context As New Entities
                Dim adds = context.OwnerContacts.Where(Function(hp) hp.BBLE = BBLE And hp.ContactType = OwnerContact.OwnerContactType.MailAddress And hp.Status = OwnerContact.ContactStatus.DoorKnock).Select(Function(hp) hp.Contact).ToList
                adds.AddRange(context.HomeOwnerAddresses.Where(Function(p) p.BBLE = BBLE And p.Source = PhoneSource.UserAdded).Select(Function(p) p.Address).ToList)
                If adds.Count > 0 Then
                    Return adds
                End If
            End Using
            Return Nothing
        End Get
    End Property

    Public Shared Function GetLeadsInfoByStreet(strNum As String, strName As String) As LeadsInfo
        Using ctx As New Entities
            Try
                strName = strName.Replace("Avenue", "Ave").Replace("Street", "Str")
                Return ctx.LeadsInfoes.Where(Function(li) li.Number = strNum AndAlso li.StreetName.Contains(strName)).SingleOrDefault
            Catch ex As Exception
                Throw New Exception(String.Format("Str No: {0}, strName: {1}. Exception: {2}", strNum, strName, ex.Message))
            End Try
        End Using
    End Function

    Public Function GetHomeOwner(ownerName As String) As HomeOwner
        Using ctx As New Entities
            Return ctx.HomeOwners.Where(Function(ho) ho.BBLE = BBLE And ho.Name = ownerName And ho.Active = True).FirstOrDefault
        End Using
    End Function

    Public Function GetOwnerAge(ownerName As String) As String
        Dim owner = GetHomeOwner(ownerName)
        If owner IsNot Nothing Then
            Dim tlo = owner.TLOLocateReport

            If tlo IsNot Nothing Then
                If tlo.dateOfBirthField IsNot Nothing Then
                    Return tlo.dateOfBirthField.currentAgeField
                End If
            End If
        End If

        Return ""
    End Function

    Public Function GetBestPhones() As String()
        Dim tlo = GetHomeOwner(Owner).TLOLocateReport

        If tlo IsNot Nothing Then
            Return tlo.BestPhones
        End If

        Return Nothing
    End Function

    Public ReadOnly Property ReferrelName As String
        Get
            Return Referrel.ReferrelName
        End Get
    End Property

    Private _referrel As PropertyReferrel
    Public ReadOnly Property Referrel As PropertyReferrel
        Get
            If _referrel Is Nothing Then
                Using context As New Entities
                    Dim tmpRef = context.PropertyReferrels.Find(BBLE)

                    If tmpRef Is Nothing Then
                        _referrel = New PropertyReferrel

                        Dim ld = context.Leads.Find(BBLE)
                        If ld IsNot Nothing Then
                            _referrel.ReferrelName = ld.AssignBy
                        End If
                    Else
                        _referrel = tmpRef
                    End If
                End Using
            End If

            Return _referrel
        End Get
    End Property

    Private _mortgageData As LeadsMortgageData
    Public ReadOnly Property MortgageData As LeadsMortgageData
        Get
            If _mortgageData Is Nothing Then
                Using context As New Entities
                    Dim tmpMort = context.LeadsMortgageDatas.Find(BBLE)

                    If tmpMort IsNot Nothing Then
                        _mortgageData = tmpMort
                    Else
                        _mortgageData = New LeadsMortgageData
                    End If
                End Using
            End If

            Return _mortgageData
        End Get
    End Property

    Public Property HomeOwners As List(Of HomeOwner)
    Public ReadOnly Property LeadsName As String
        Get
            Return Utility.GetLeadsName(Me)
        End Get
    End Property

    Public ReadOnly Property StreetNameWithNo
        Get
            Dim strName = String.Format("{0} {1}", Number, StreetName)
            strName = strName.TrimStart(" ")
            Return strName
        End Get
    End Property

    'Leadsinfo status
    Public ReadOnly Property Status As String
        Get
            If Lead.Status.HasValue Then
                Return CType(Lead.Status.Value, LeadStatus).ToString
            End If

            Return ""
        End Get
    End Property

    'the finder name or agent name of this leadsinfo
    Public ReadOnly Property AgentName As String
        Get
            If Lead IsNot Nothing Then
                Return Lead.EmployeeName
            End If

            Return ""
        End Get
    End Property

    Public ReadOnly Property CallAttemps As Integer
        Get
            Using context As New Entities
                Return context.LeadsActivityLogs.Where(Function(log) log.BBLE = BBLE And (log.ActionType.HasValue AndAlso log.ActionType = 0)).Count
            End Using

            'Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType.HasValue AndAlso log.ActionType = LeadsActivityLog.EnumActionType.CallOwner).Count
        End Get
    End Property

    Public ReadOnly Property DoorKnockAttemps As Integer
        Get
            Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.DoorKnock).Count
        End Get
    End Property

    Public ReadOnly Property FollowupAttemps As Integer
        Get
            Return Lead.LeadsActivityLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.FollowUp).Count
        End Get
    End Property

    Public ReadOnly Property HasOwnerInfo As Boolean
        Get
            Using context As New Entities
                Return context.HomeOwners.Where(Function(ho) ho.BBLE = BBLE And ho.Active = True And ho.LocateReport IsNot Nothing And ho.Name = Owner).Count > 0
            End Using
        End Get
    End Property

    Private _taxLiensInfo As LeadsTaxLien
    Public ReadOnly Property TaxLiensInfo As LeadsTaxLien
        Get
            If _taxLiensInfo Is Nothing Then
                Using ctx As New Entities
                    _taxLiensInfo = ctx.LeadsTaxLiens.Where(Function(lt) lt.BBLE = BBLE).FirstOrDefault
                End Using
            End If
            Return _taxLiensInfo
        End Get
    End Property

    Private _taxLiens As List(Of LeadsTaxLien)
    Public ReadOnly Property TaxLiens As List(Of LeadsTaxLien)
        Get
            If _taxLiens Is Nothing Then
                Using ctx As New Entities
                    _taxLiens = ctx.LeadsTaxLiens.Where(Function(lt) lt.BBLE = BBLE).ToList
                End Using
            End If

            Return _taxLiens
        End Get
    End Property

    Public ReadOnly Property TotalTaxLienAmount As Decimal?
        Get
            If TaxLiens IsNot Nothing AndAlso TaxLiens.Count > 0 Then
                Return TaxLiens.Sum(Function(a) a.Amount)
            End If

            Return Nothing
        End Get
    End Property

    Public ReadOnly Property TaxLiensDateText As String
        Get
            If TaxLiensInfo IsNot Nothing Then
                Return TaxLiensInfo.TaxLiensYear
            End If

            Return ""
        End Get
    End Property

    Public ReadOnly Property TaxLiensAmount As String
        Get
            If TaxLiensInfo IsNot Nothing Then
                If TaxLiensInfo.Amount > 0 Then
                    Return TaxLiensInfo.Amount
                Else
                    Return "Not Avaiable"
                End If
            End If

            Return ""
        End Get
    End Property

    Public ReadOnly Property PropertyClassCode As String
        Get
            Using context As New Entities
                Dim bc = context.BuildingCodes.Find(PropertyClass)
                If bc IsNot Nothing Then
                    Return String.Format("{0}-{1}", bc.Code, bc.Description)
                End If

                Return PropertyClass
            End Using
        End Get
    End Property

    Public ReadOnly Property Neighborhood As String
        Get
            Return NeighName
        End Get
    End Property

    Public ReadOnly Property LastUpdate2 As DateTime
        Get
            Return Lead.LastUpdate2
        End Get
    End Property

    Public ReadOnly Property LastIssuedOn As String
        Get
            If CreateDate.HasValue Then
                Return String.Format("Last Issued On: {0:g}", CreateDate)
            Else
                Return ""
            End If
        End Get
    End Property
    Public ReadOnly Property EstimatedMortageDefault As Decimal
        Get
            'Return 1234564.123486456
            Dim EMD As Decimal
            If (LisPens IsNot Nothing AndAlso LisPens.Count > 0) Then
                Dim ListPensYear = LisPens.Select(Function(f) f.FileDate.Year).ToList

                Dim oldestYear = ListPensYear.Min()
                EMD = MortgageCombo * Math.Pow((1.0 + 0.085), (Date.Now.Year - oldestYear))
            Else
                Return MortgageCombo
            End If

            Return EMD
        End Get
    End Property
    Public ReadOnly Property MortgageCombo As Decimal
        Get
            Dim debt As Decimal

            If C1stMotgrAmt.HasValue Then
                debt += C1stMotgrAmt
            End If

            If C2ndMotgrAmt.HasValue Then
                debt += C2ndMotgrAmt
            End If

            If C3rdMortgrAmt.HasValue Then
                debt += C3rdMortgrAmt
            End If

            Return debt
        End Get
    End Property

    Public ReadOnly Property TotalDebt As Double
        Get
            Dim debt = 0

            If C1stMotgrAmt.HasValue Then
                debt += C1stMotgrAmt
            End If

            If C2ndMotgrAmt.HasValue Then
                debt += C2ndMotgrAmt
            End If

            If C3rdMortgrAmt.HasValue Then
                debt += C3rdMortgrAmt
            End If

            If TaxesAmt.HasValue Then
                debt += TaxesAmt
            End If

            If WaterAmt.HasValue Then
                debt += WaterAmt
            End If

            If ViolationAmount > 0 Then
                debt += ViolationAmount
            End If

            If TaxLiensInfo IsNot Nothing Then
                debt += TaxLiensInfo.Amount
            End If

            Return debt
        End Get
    End Property

    Public ReadOnly Property IsHighLiens As Boolean
        Get
            If EstValue.HasValue And EstValue > 0 Then
                Return TotalDebt > EstValue
            Else
                Return False
            End If
        End Get
    End Property

    Public ReadOnly Property IndicatorOfWater As String
        Get
            If Me.WaterAmt.HasValue AndAlso WaterAmt > 1000 Then
                Return "HasWaterLiens"
            End If

            Return ""
        End Get
    End Property

    Public ReadOnly Property IsUpdating As Boolean
        Get
            Using context As New Entities

                If context.APIOrders.Where(Function(order) order.BBLE = BBLE And order.Status <> APIOrder.OrderStatus.Complete).Count > 0 Then
                    Return True
                End If

                If Core.DataLoopRule.IsInUpdate(BBLE) Then
                    Return True
                End If

                Return False
            End Using
        End Get
    End Property


    Public Property IsRecycled As Boolean

    Public ReadOnly Property UpdateInfo As String
        Get
            Using context As New Entities

                If context.APIOrders.Where(Function(order) order.BBLE = BBLE And order.Status <> APIOrder.OrderStatus.Complete).Count > 0 Then
                    Return "<span style=""color:red"">Lead is waiting to update. It will complete in few minuties.</span>"
                Else
                    If LastUpdate Is Nothing Then
                        Return ""
                    Else
                        Return String.Format("Last Update: {0:g}", Me.LastUpdate.Value)
                    End If
                End If
            End Using
        End Get
    End Property

    Private _otherProperties As List(Of LeadsInfo)
    Public ReadOnly Property OtherProperties As List(Of LeadsInfo)
        Get
            If _otherProperties Is Nothing Then

                If Not String.IsNullOrEmpty(Owner) Then
                    Dim specialName = {"NOT ON FILE"}

                    If specialName.Contains(Owner) Then
                        _otherProperties = New List(Of LeadsInfo)
                        Return _otherProperties
                    End If

                    Using context As New Entities
                        Dim ownerToken = context.HomeOwners.Where(Function(h) h.BBLE = BBLE And (h.Name = Owner Or h.Name = CoOwner) And h.ReportToken IsNot Nothing).Select(Function(h) h.ReportToken).ToArray
                        If ownerToken IsNot Nothing AndAlso ownerToken.Count > 0 Then
                            Dim result = (From li In context.LeadsInfoes.Where(Function(li) li.BBLE <> BBLE)
                                               Join ho In context.HomeOwners.Where(Function(h) ownerToken.Contains(h.ReportToken)) On ho.BBLE Equals li.BBLE
                                               Select li).Distinct.ToList

                            If IsCompany(Owner) Then
                                _otherProperties = New List(Of LeadsInfo)

                                For Each li In result
                                    If Utility.IsSimilarName(Owner, li.Owner) Then
                                        _otherProperties.Add(li)
                                    End If
                                Next
                            Else
                                _otherProperties = result
                            End If
                        End If
                    End Using
                End If
            End If

            Return _otherProperties
        End Get
    End Property

    Private Function IsCompany(name As String) As Boolean
        Dim suffixs = {"LLC", "LLC.", "CORP.", "CORP", "INC", "INC.", "L.P.", "CO.L.P."}

        Dim lastSubstring = name.Trim.Split(" ").Last.ToUpper
        For Each suffix In suffixs
            If lastSubstring = suffix Then
                Return True
            End If
        Next

        Return False
    End Function

   

    Public Shared Function GetInstance(bble As String) As LeadsInfo
        Using context As New Entities
            Return context.LeadsInfoes.Where(Function(b) b.BBLE = bble).SingleOrDefault
        End Using
    End Function

    Public Shared Function GetNewLeads() As String()
        Using ctx As New Entities
            Return ctx.LeadsInfoes.Where(Function(ld) String.IsNullOrEmpty(ld.PropertyAddress)).Select(Function(li) li.BBLE).ToArray
        End Using
    End Function

    Public Sub AddComments(comments As String, userName As String)
        Using Context As New Entities
            Dim lc As New LeadsComment
            lc.Comments = comments
            lc.CreateBy = userName
            lc.CreateTime = DateTime.Now
            lc.BBLE = BBLE

            Context.LeadsComments.Add(lc)
            Context.SaveChanges()
        End Using
    End Sub

    Public ReadOnly Property Violation As String
        Get
            If ECBViolationsAmt.HasValue AndAlso ECBViolationsAmt.Value > 0 Then
                Return "ECB"
            End If

            If DOBViolationsAmt.HasValue AndAlso DOBViolationsAmt.Value > 0 Then
                Return "DOB"
            End If

            Return ""
        End Get
    End Property

    Public ReadOnly Property ViolationAmount As Double
        Get
            If ECBViolationsAmt.HasValue AndAlso ECBViolationsAmt.Value > 0 Then
                Return ECBViolationsAmt.Value
            End If

            If DOBViolationsAmt.HasValue AndAlso DOBViolationsAmt.Value > 0 Then
                Return DOBViolationsAmt.Value
            End If

            Return Nothing
        End Get
    End Property

    Public Sub AssignTo(empName As String, assignBy As String, Optional override As Boolean = True)
        Using ctx As New Entities
            Dim emp = Employee.GetInstance(empName)
            If emp IsNot Nothing Then
                Dim newlead = ctx.Leads.Find(BBLE)
                If newlead Is Nothing Then
                    newlead = New Lead() With {
                                      .BBLE = BBLE,
                                      .LeadsName = LeadsName,
                                      .Neighborhood = NeighName,
                                      .EmployeeID = emp.EmployeeID,
                                      .EmployeeName = emp.Name,
                                      .Status = LeadStatus.NewLead,
                                      .AssignDate = DateTime.Now,
                                      .AssignBy = assignBy
                                      }
                    ctx.Leads.Add(newlead)
                    LeadsStatusLog.AddNewEntity(BBLE, LeadsStatusLog.LogType.NewLeads, emp.Name, assignBy, Nothing, ctx)
                Else
                    If override Then
                        Dim orgName = newlead.EmployeeName
                        newlead.LeadsName = LeadsName
                        newlead.Neighborhood = NeighName
                        newlead.EmployeeID = emp.EmployeeID
                        newlead.EmployeeName = emp.Name
                        newlead.Status = LeadStatus.NewLead
                        newlead.AssignDate = DateTime.Now
                        newlead.AssignBy = assignBy

                        LeadsStatusLog.AddNewEntity(BBLE, LeadsStatusLog.LogType.NewLeads, emp.Name, assignBy, orgName, ctx)
                    End If
                End If

                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Public Shared Sub AddIndicator(name As String, li As LeadsInfo)
        Indicators.Where(Function(indi) indi.Name = name).FirstOrDefault.AddIndicator(li)
    End Sub

    Public Shared Sub AddIndicator(name As String, li As LeadsInfo, userName As String)
        Indicators.Where(Function(indi) indi.Name = name).FirstOrDefault.AddIndicator(li, userName)
    End Sub

    Public Shared ReadOnly Property Indicators As List(Of Indicator)
        Get
            Dim str As New List(Of Indicator)
            str.Add(New Indicator("Mortgage", "Liens higher than Value", Function(li)
                                                                             Return li.IsHighLiens
                                                                         End Function))

            str.Add(New Indicator("Water", "Water Lien is High - Possible Tenant Issues", Function(li)
                                                                                              If li.WaterAmt.HasValue AndAlso li.WaterAmt > 1000 Then
                                                                                                  Return True
                                                                                              End If

                                                                                              Return False
                                                                                          End Function))
            str.Add(New Indicator("LeadsType", "Leads type: ", Function(li)
                                                                   If li.Type.HasValue Then
                                                                       Return True
                                                                   End If

                                                                   Return False
                                                               End Function))

            str.Add(New Indicator("UnderBuilt", "This property is only built to 50% or less of its total allowable Sqft", Function(li)
                                                                                                                              If li.UnbuiltSqft.HasValue And li.NYCSqft.HasValue Then
                                                                                                                                  Return li.UnbuiltSqft / li.NYCSqft >= 0.5
                                                                                                                              End If

                                                                                                                              Return False
                                                                                                                          End Function))
            str.Add(New Indicator("TaxLiens", "This property has tas liens.", Function(li)
                                                                                  Return Not String.IsNullOrEmpty(li.TaxLiensAmount)
                                                                              End Function))

            str.Add(New Indicator("LPDefandant", "Lien is in different name than Deed Holder. Check Acris to ensure this is a good lead.", Function(li)
                                                                                                                                               If li.LisPens IsNot Nothing AndAlso li.LisPens.Count > 0 AndAlso Not String.IsNullOrEmpty(li.Owner) Then
                                                                                                                                                   Return Not Utility.IsSimilarName(li.LisPens(0).Defendant, li.Owner)
                                                                                                                                               End If

                                                                                                                                               Return False
                                                                                                                                           End Function))

            Return str
        End Get
    End Property

    Public Class Indicator
        Public Property Name As String
        Public Property Message As String
        Public Property Formular As IndicatorFormular

        Public Delegate Function IndicatorFormular(li As LeadsInfo) As Boolean

        Public Sub New(indicatorName As String, indicatorMessage As String, visible As IndicatorFormular)
            Name = indicatorName
            Message = indicatorMessage
            Formular = visible
        End Sub

        Public Sub AddIndicator(leadsData As LeadsInfo)
            If Formular(leadsData) Then
                If leadsData.UserComments.Where(Function(um) um.Comments = Message And um.BBLE = leadsData.BBLE).Count = 0 Then
                    leadsData.AddComments(Message, HttpContext.Current.User.Identity.Name)
                End If
            End If
        End Sub

        Public Sub AddIndicator(leadsData As LeadsInfo, name As String)
            If Formular(leadsData) Then
                If leadsData.UserComments.Where(Function(um) um.Comments = Message And um.BBLE = leadsData.BBLE).Count = 0 Then
                    leadsData.AddComments(Message, name)
                End If
            End If
        End Sub
    End Class



End Class

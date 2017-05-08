Imports System.Threading.Tasks
Imports IntranetPortal.Data

''' <summary>
''' The data service integration object
''' </summary>
Public Class DataWCFService

#Region "Service provider"
    Private Shared ReadOnly Property provider As IPropertyServiceProvider
        Get
            Return New PropertyServiceProvider
        End Get
    End Property
#End Region

#Region "TLO Related"
    Public Shared Function GetLocateReport(apiOrderNum As Integer, bble As String, owner As HomeOwner) As DataAPI.TLOLocateReportOutput
        If String.IsNullOrEmpty(owner.Address1) AndAlso String.IsNullOrEmpty(owner.Address2) AndAlso String.IsNullOrEmpty(owner.City) Then
            Return Nothing
        End If

        Using client As New DataAPI.WCFMacrosClient
            Dim result = GetLocateReport(apiOrderNum, bble, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country)

            If result Is Nothing Then
                Dim propOwners = client.NYC_NameAndAddress(bble)
                If propOwners IsNot Nothing And propOwners.Count > 0 Then
                    Dim newAds = propOwners(0)
                    If newAds.Owner1.Trim = owner.Name Or newAds.Owner2.Trim = owner.Name Then
                        Dim add1 = String.Format("{0} {1}", newAds.Mail_Num.Trim, newAds.Mail_ST1.Trim).TrimStart.TrimEnd
                        result = GetLocateReport(apiOrderNum, bble, owner.Name, add1, newAds.Mail_ST2, newAds.Mail_City, newAds.Mail_State, newAds.Mail_Zip, "US")
                    End If
                End If
            End If

            Return result
        End Using
    End Function
    Public Shared Function GetLocateReport2(apiOrderNum As Integer, bble As String, owner As HomeOwner) As DataAPI.TLOLocateReportOutput
        If String.IsNullOrEmpty(owner.Address1) AndAlso String.IsNullOrEmpty(owner.Address2) AndAlso String.IsNullOrEmpty(owner.City) Then
            Return Nothing
        End If

        Using client As New DataAPI.WCFMacrosClient
            Dim result = GetLocateReport(apiOrderNum, bble, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country)



            Return result
        End Using
    End Function

    Public Shared Function GetOwnerInfoByTLOId(tloId As String, bble As String) As HomeOwner

        'If Not Core.TLOApiLog.IsServiceOn Then
        '    Throw New Exception("HomeOwner Service is temporary closed. Please try later.")
        'End If

        'If Core.TLOApiLog.LimiteIsExceed Then
        '    Throw New Exception("HomeOwner Load Limit is reached. Please contact Admin!")
        'End If

        Using client As New DataAPI.WCFMacrosClient
            Dim orderId = 1

            Using ctx As New Entities
                Dim order As New APIOrder
                order.BBLE = bble
                order.Orderby = GetCurrentIdentityName()
                order.OrderTime = DateTime.Now
                order.Status = APIOrder.OrderStatus.Complete
                ctx.APIOrders.Add(order)
                ctx.SaveChanges()

                orderId = order.ApiOrderID
            End Using

            Dim result = client.Get_TLO_Person(orderId, Nothing, Nothing, False, False, Nothing, tloId, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing)

            If result Is Nothing Then
                Throw New Exception("Can't find the user. Please check.")
            End If

            'LogTloApiCall



            If result.numberOfRecordsFoundField > 0 Then
                Dim person = result.personSearchOutputRecordsField(0)


                'relative.nameField.firstNameField & If(relative.nameField.middleNameField isnot Nothing,relative.nameField.middleNameField, " ") &" "& relative.nameField.lastNameField 
                If person IsNot Nothing AndAlso person.namesField IsNot Nothing AndAlso person.namesField.Length > 0 Then
                    Dim owner As New HomeOwner
                    Dim name = person.namesField(0)
                    owner.Name = name.firstNameField & If(name.middleNameField IsNot Nothing, " " & name.middleNameField & " ", " ") & name.lastNameField
                    owner.Address1 = person.addressesField(0).addressField.line1Field
                    owner.Address2 = person.addressesField(0).addressField.line2Field
                    owner.City = person.addressesField(0).addressField.cityField
                    owner.Country = person.addressesField(0).addressField.countryNameField
                    owner.State = person.addressesField(0).addressField.stateField
                    owner.Zip = person.addressesField(0).addressField.zipField
                    If person.datesOfBirthField IsNot Nothing AndAlso person.datesOfBirthField.Length > 0 Then
                        owner.AgeString = person.datesOfBirthField(0).currentAgeField
                    End If

                    If person.datesOfDeathField IsNot Nothing Then
                        owner.DeathIndicator = If(person.datesOfDeathField.Length > 0, "Death", "Alive")
                    End If

                    If Not String.IsNullOrEmpty(person.numberOfBankruptciesField) Then
                        owner.BankruptcyString = If(CInt(person.numberOfBankruptciesField) > 0, "Yes", "No")
                    End If

                    'tlo log
                    Core.TLOApiLog.Log(bble, owner.Name, "UniqueId:" & tloId, Nothing, Nothing, Nothing, Nothing, Nothing, True, GetCurrentIdentityName)

                    Return owner
                End If
            End If

            Core.TLOApiLog.Log(bble, Nothing, "UniqueId:" & tloId, Nothing, Nothing, Nothing, Nothing, Nothing, False, GetCurrentIdentityName)

            Return Nothing
        End Using
    End Function

    Public Shared Function GetLocateReport(orderNum As Integer, bble As String, name As String, address1 As String, address2 As String, city As String, state As String, zip As String, country As String, Optional checkTLO As Boolean = True) As DataAPI.TLOLocateReportOutput

        If Not Core.TLOApiLog.IsServiceOn Then
            Throw New Exception("HomeOwner Service is temporary closed. Please try later.")
        End If

        If checkTLO Then
            If Core.TLOApiLog.LimiteIsExceed Then
                Throw New Exception("HomeOwner Load Limit is reached. Please contact Admin!")
            End If
        End If

        Using client As New DataAPI.WCFMacrosClient

            Dim result = client.Get_LocateReport(orderNum, bble, name, address1, address2, city, state, zip, country, "", "")

            'LogTloApiCall
            Core.TLOApiLog.Log(bble, name, address1, address2, city, state, zip, country, result IsNot Nothing, GetCurrentIdentityName)
            Return result
        End Using
    End Function

    Private Shared Sub UpdateHomeOwnerApi(orderId As Integer, Optional result As String = "Done")
        APIOrder.UpdateOrderInfo(orderId, "TLO", result)
    End Sub

#End Region

#Region "Leads Info"

    ''' <summary>
    '''     Update general property info and lispendas data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function UpdateAssessInfo(bble As String) As LeadsInfo
        Return provider.UpdateLeadsGeneralData(bble)
    End Function

    ''' <summary>
    '''     Get property lispends data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function GetLiensInfo(bble As String) As List(Of PortalLisPen)
        Return provider.GetLiensInfo(bble)
    End Function

    ''' <summary>
    '''     Get All liens data
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function GetAllLiens(bble As String) As AllLiens
        Return provider.GetAllLiens(bble)
    End Function

    ''' <summary>
    '''     Return BBLEs by address data
    ''' </summary>
    ''' <param name="num">Street Number</param>
    ''' <param name="streetName">The Street Name</param>
    ''' <param name="borough">Borough</param>
    ''' <returns>The list of BBLE</returns>
    Public Shared Function GetBBLEByAddress(num As String, streetName As String, borough As String) As String()
        Using client As New DataAPI.WCFMacrosClient
            Dim strName = streetName.Trim
            num = num.Trim.Replace(" ", "")

            Dim result = client.NYC_Address_Search(borough, num, strName)

            If result.Length = 0 Then
                strName = strName.ToLower.Replace("street", "ST").Replace("avenue", "Ave")
                If strName.EndsWith(".") Then
                    strName = strName.Remove(strName.Length - 1, 1)
                End If
                result = client.NYC_Address_Search(borough, num.Trim, strName)
            End If

            If result.Length = 0 Then
                strName = strName.Replace("th", "").Replace("rd", "").Replace("nd", "")
                result = client.NYC_Address_Search(borough, num.Trim, strName)
            End If

            If result.Length = 0 Then
                strName = strName.Replace("east", "E")
                result = client.NYC_Address_Search(borough, num.Trim, strName)
            End If

            Return result.Select(Function(r) r.BBLE).ToArray
        End Using
    End Function

    ''' <summary>
    '''     Update the apartment homeowner data from TLO
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function UpdateApartmentHomeOwner(bble As String) As Boolean
        Using context As New Entities
            Dim li = context.LeadsInfoes.Find(bble)

            Using client As New DataAPI.WCFMacrosClient
                For Each owner In context.HomeOwners.Where(Function(ho) ho.BBLE = bble).ToList
                    Dim apiOrderNum = New Random().Next(1, 100)
                    Dim result = client.Get_LocateReport(apiOrderNum, li.BuildingBBLE, owner.Name, owner.Address1, owner.Address2, owner.City, owner.State, owner.Zip, owner.Country, "", "")
                    If result IsNot Nothing Then
                        owner.TLOLocateReport = result
                        owner.UserModified = False
                    End If
                Next
            End Using

            context.SaveChanges()
            Return True
        End Using
    End Function

    ''' <summary>
    '''     Return property information base on given borough, block and lot
    ''' </summary>
    ''' <param name="borough">Borough</param>
    ''' <param name="block">Block</param>
    ''' <param name="lot">Lot</param>
    ''' <returns></returns>
    Public Shared Function AddressSearch(borough As Integer, block As Integer, lot As Integer) As GeneralPropertyInformation()
        Dim bble = String.Format("{0}{1:D5}{2:D4}", borough, block, lot)
        Return AddressSearch(bble)
    End Function

    ''' <summary>
    '''     Return property information base on street number, street name and borough
    ''' </summary>
    ''' <param name="num">Street Number</param>
    ''' <param name="strName">Street Name</param>
    ''' <param name="borough">Borough</param>
    ''' <returns></returns>
    Public Shared Function AddressSearch(num As String, strName As String, borough As String) As GeneralPropertyInformation()
        Dim data = provider.GetPropbyAddress(num, strName, borough)
        If data IsNot Nothing AndAlso data.address IsNot Nothing Then
            Return AddressSearch(data.address.bbl)
        End If
        Return Nothing
    End Function

    ''' <summary>
    '''     Return property information base on BBLE
    ''' </summary>
    ''' <param name="bble">Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function AddressSearch(bble As String) As GeneralPropertyInformation()
        If String.IsNullOrEmpty(bble) Then
            Return {}
        End If

        Dim gData = provider.GetPropGeneralInfo(bble)
        Return {gData}
    End Function

#End Region

#Region "Update mortgages, water, tax"

    Public Shared Function UpdateLeadInfo(bble As String,
                                          Optional assessment As Boolean = False,
                                          Optional acris As Boolean = True,
                                          Optional taxBill As Boolean = True,
                                          Optional EcbViolation As Boolean = True,
                                          Optional waterBill As Boolean = True,
                                          Optional zillow As Boolean = True,
                                          Optional TLO As Boolean = True) As Boolean

        If bble.StartsWith("A") Then
            If assessment Then
                UpdateAssessInfo(bble)
            End If

            If TLO Then
                UpdateApartmentHomeOwner(bble)
            End If

            Return True
        End If

        Dim order = APIOrder.NewOrder(bble, acris, taxBill, EcbViolation, waterBill, zillow, TLO, GetCurrentIdentityName())

        Dim result = provider.UpdateLeadInfo(bble, assessment, order)

        If TLO Then
            LoadHomeOwner(bble, order)
        End If

        Return result
    End Function

    Public Shared Sub UpdateServicer(bble As String)
        provider.UpdateServicer(bble)
    End Sub

    ''' <summary>
    '''     Update the external data into Portal
    ''' </summary>
    ''' <param name="externalData">External Data</param>
    ''' <returns></returns>
    Public Shared Function UpdateExternalData(externalData As ExternalData) As Boolean
        Return provider.UpdateExternalData(externalData)
    End Function

#End Region

#Region "Zillow Value"

    Public Shared Function GetZillowValue(bble As String) As Boolean

        Try
            Dim li = provider.UpdateZillowValue(bble)
            LeadsInfo.AddIndicator("Mortgage", li)
            Return True
        Catch ex As Exception
            Throw New Exception("Exception Occured in GetZillowValue. Exception: " & ex.Message)
        End Try

        Return False
    End Function

#End Region

#Region "Get latest homeowner info"

    Private Shared Function LoadHomeOwner(bble As String, apiOrder As APIOrder) As Boolean

        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing AndAlso Not String.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) Then
            Dim stateObj = New With {
                  .BBLE = bble,
                  .OrderId = apiOrder.ApiOrderID,
                  .Context = HttpContext.Current
                  }
            Dim userName = HttpContext.Current.User.Identity.Name

            Dim callBack = Sub(state)
                               HttpContext.Current = state.Context
                               Try
                                   UpdateHomeOwner(bble, state.OrderId)
                                   UpdateHomeOwnerApi(state.OrderId)
                                   'UserMessage.AddNewMessage(GetCurrentIdentityName, "Refresh", "HomeOwner info is ready. BBLE: " & state.BBLE, state.BBLE)
                               Catch ex As Exception
                                   UserMessage.AddNewMessage(userName, "Error", "Error happened on refresh. Message: " & ex.Message, state.BBLE, DateTime.Now, userName, Nothing)
                                   UpdateHomeOwnerApi(state.OrderId, "Error")
                               End Try
                           End Sub

            System.Threading.ThreadPool.QueueUserWorkItem(callBack, stateObj)
            Return True
        Else
            'Sent by Data loop service
            Dim result = UpdateHomeOwner(bble, apiOrder.ApiOrderID)
            UpdateHomeOwnerApi(apiOrder.ApiOrderID)
            Return result
        End If
    End Function

    Public Shared Sub GetLatestSalesInfo(bble As String)
        Try
            GetAcrisLatestOwner(bble)
        Catch ex As Exception
            Throw New Exception("Erron occure in Get Latest Sales Info: " + ex.Message)
        End Try

        Return
    End Sub

    Private Shared Sub GetAcrisLatestOwner(bble As String)
        provider.LoadLatestOwner(bble)
    End Sub

    Public Shared Function UpdateHomeOwner(bble As String, orderid As Integer) As Boolean
        GetLatestSalesInfo(bble)

        Using context As New Entities
            Dim li = context.LeadsInfoes.Find(bble)
            'GetLatestSalesInfo(bble)
            If String.IsNullOrEmpty(li.Owner) Then
                GetLatestSalesInfo(bble)
            End If

            If Not String.IsNullOrEmpty(li.Owner) AndAlso Not String.IsNullOrEmpty(li.CoOwner) Then
                If li.Owner.Trim = li.CoOwner.Trim Then
                    li.Owner = li.Owner.Trim
                    li.CoOwner = Nothing
                    context.SaveChanges()
                End If
            End If

            Dim owners = context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True And ho.Name = li.Owner).ToList
            If owners Is Nothing Or owners.Count = 0 Then
                GetLatestSalesInfo(bble)
                'Return False
            End If

            'Used to check if homeowner is refreshed before
            Dim homeOwnerRefreshInternal As Integer = CInt(Core.PortalSettings.GetValue("TLOCallInterval"))

            Dim loaded = False
            For Each owner In context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True And (ho.Name = li.Owner Or ho.Name = li.CoOwner)).ToList
                If Not String.IsNullOrEmpty(owner.LocateReportContent) Then
                    If Not owner.LastUpdate.HasValue Then
                        owner.LastUpdate = DateTime.Now
                        loaded = True
                        Continue For
                    Else
                        If owner.LastUpdate.Value.AddDays(homeOwnerRefreshInternal) > DateTime.Now Then
                            loaded = True
                            'if homeowner is refreshed in 3 month. don't refresh again.
                            Continue For
                        End If
                    End If
                End If

                Dim result = GetLocateReport(orderid, bble, owner)
                If result IsNot Nothing Then
                    loaded = True
                    owner.TLOLocateReport = result
                    owner.UserModified = False
                    owner.LastUpdate = DateTime.Now
                End If
            Next

            'Reload latest sales owner info and try again
            If Not loaded Then
                GetLatestSalesInfo(bble)
                For Each owner In context.HomeOwners.Where(Function(ho) ho.BBLE = bble And ho.Active = True).ToList
                    If Not String.IsNullOrEmpty(owner.LocateReportContent) Then
                        If Not owner.LastUpdate.HasValue Then
                            owner.LastUpdate = DateTime.Now
                            loaded = True
                            Continue For
                        Else
                            If owner.LastUpdate.Value.AddDays(homeOwnerRefreshInternal) > DateTime.Now Then
                                loaded = True
                                'if homeowner is refreshed in 3 month. don't refresh again.
                                Continue For
                            End If
                        End If
                    End If

                    Dim result = GetLocateReport(orderid, bble, owner)
                    If result IsNot Nothing Then
                        loaded = True
                        owner.TLOLocateReport = result
                        owner.UserModified = False
                    End If
                Next
            End If

            Dim contextError = context.GetValidationErrors()
            If contextError.Count = 0 Then
                context.SaveChanges()
            Else
                Throw New Exception(contextError(0).ValidationErrors(0).ErrorMessage)
            End If

            Return loaded
        End Using
    End Function

#End Region

#Region "Server status"

    Public Shared Function IsServerBusy(Optional serverAddress As String = Nothing) As Boolean
        Using client As New DataAPI.WCFMacrosClient()
            If Not String.IsNullOrEmpty(serverAddress) Then
                client.Endpoint.Address = New ServiceModel.EndpointAddress(serverAddress)
            End If

            Try
                Dim waitingRequest = client.Requests_Waiting
                Return waitingRequest > 50
            Catch ex As TimeoutException
                'Throw New Exception("Check Server is busy. Time out exception: " & ex.Message)
                Return True
            Catch ex As Exception
                'Throw New Exception("Check Server is busy. exception: " & ex.Message)
                Return True
            End Try
        End Using
    End Function

#End Region

#Region "Private method"

    Private Shared Function GetCurrentIdentityName() As String
        Try
            If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing AndAlso Not String.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) Then
                Return HttpContext.Current.User.Identity.Name
            Else
                Return "Dataloop"
            End If
        Catch ex As Exception
            Throw New Exception("Get Current Identity Name: " & ex.Message)
        End Try
    End Function

    Private Shared Function TrimString(Str As String) As String
        If String.IsNullOrEmpty(Str) Then
            Return Str
        End If

        Return Str.Trim
    End Function
#End Region

#Region "others"
    Public Shared Sub UpdateTaxLiens(bble As String)
        UpdateTaxLiens2(bble)
        Return
    End Sub

    Public Shared Sub UpdateTaxLiens2(bble As String)
        Using client As New DataAPI.WCFMacrosClient

            Dim taxLiens = client.Get_NYC_TaxLien(bble, "")

            If taxLiens IsNot Nothing AndAlso taxLiens.Length > 0 Then
                Using ctx As New Entities
                    Dim liens = ctx.LeadsTaxLiens.Where(Function(lt) lt.BBLE = bble)
                    ctx.LeadsTaxLiens.RemoveRange(liens)

                    For Each lien In taxLiens
                        Dim newLien As New LeadsTaxLien
                        newLien.BBLE = bble

                        If lien.Year > 0 Then
                            newLien.TaxLiensYear = lien.Year
                        End If

                        If lien.LienTotal.HasValue Then
                            newLien.Amount = lien.LienTotal
                        End If
                        ctx.LeadsTaxLiens.Add(newLien)
                    Next

                    ctx.SaveChanges()
                End Using
            End If
        End Using
    End Sub

    Public Shared Function GeoCode(address As String) As String
        Using client As New DataAPI.WCFMacrosClient

            Dim result = client.DCPGeododerBySingleLine(address)
            Return result
        End Using
    End Function
#End Region

End Class

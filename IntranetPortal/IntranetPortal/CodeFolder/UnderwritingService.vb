Imports System.IO
Imports System.Net
Imports IntranetPortal.Data
Imports Microsoft.AspNet.SignalR.Client
Imports Newtonsoft.Json.Linq

Public Class UnderwritingService
    Shared HubURL As String


    Shared Sub New()
        Dim ConfigJson = JObject.Parse(File.ReadAllText(HttpRuntime.AppDomainAppPath + "\Webconfig.json"))
        HubURL = ConfigJson("UnderwritingServiceServer").ToString & "/signalr"
        ServicePointManager.DefaultConnectionLimit = 10
    End Sub

    Public Shared Function GetPropertiesList() As IEnumerable(Of Object)
        Using ctx As New PortalEntities
            Dim HubURL = ConfigurationManager.AppSettings("UnderwritingServiceServer").ToString()
            Dim Connection As HubConnection = New HubConnection(HubURL)
            Dim UnderwritingHub As IHubProxy = Connection.CreateHubProxy("UnderwritingServiceHub")
            Connection.Start().Wait()
            Dim UnderwritingBBLEs = UnderwritingHub.Invoke(Of String())("GetUnderwritingBBLEs").Result.ToList()
            Connection.Dispose()
            Connection.Start().Wait()
            Dim Underwritings = UnderwritingHub.Invoke(Of UnderwritingResponse())("GetUnderwritingListInfo").Result.ToList()
            Connection.Dispose()
            Dim SearchBBLES = ctx.LeadInfoDocumentSearches.Select(Function(s) s.BBLE).ToList()
            UnderwritingBBLEs = UnderwritingBBLEs.Select(Function(b) b.Trim()).ToList()
            SearchBBLES = SearchBBLES.Select(Function(b) b.Trim()).ToList()
            Dim CommonBBLEs = UnderwritingBBLEs.Union(SearchBBLES).Distinct().ToList()
            If CommonBBLEs.Count = 0 Then
                Return Nothing
            End If
            Dim steps1 = From bble In CommonBBLEs Group Join u In Underwritings On bble.Trim Equals u.BBLE.Trim Into Group1 = Group
                         From g1 In Group1.DefaultIfEmpty() Select New With {
                                                      .BBLE = bble,
                                                      .UnderwritingStatus = If(g1 Is Nothing, -1, g1.UnderwritingStatus),
                                                      .UnderwritingCreateBy = If(g1 Is Nothing, String.Empty, g1.UnderwritingCreateBy),
                                                      .UnderwritingCreateDate = If(g1 Is Nothing, Nothing, g1.UnderwritingCreateDate),
                                                      .UnderwritingUpdateDate = If(g1 Is Nothing, Nothing, g1.UnderwritingUpdateDate)}
            Dim steps2 = From s1 In steps1 Group Join s In ctx.LeadInfoDocumentSearches On s1.BBLE.Trim Equals s.BBLE.Trim Into Group2 = Group
                         From g2 In Group2.DefaultIfEmpty() Select New With {
                                                      .BBLE = s1.BBLE,
                                                      .UnderwritingStatus = s1.UnderwritingStatus,
                                                      .UnderwritingCreateBy = s1.UnderwritingCreateBy,
                                                      .UnderwritingCreateDate = s1.UnderwritingCreateDate,
                                                      .UnderwritingUpdateDate = s1.UnderwritingUpdateDate,
                                                      .SearchStatus = If(g2 Is Nothing, -1, g2.Status),
                                                      .SearchCompletedBy = If(g2 Is Nothing, String.Empty, g2.CompletedBy),
                                                      .SearchCompletedOn = If(g2 Is Nothing, Nothing, g2.CompletedOn),
                                                      .SearchUpdateDate = If(g2 Is Nothing, Nothing, g2.UpdateDate)}
            Dim steps3 = From s2 In steps2.ToList() Group Join l In ctx.SSLeads On s2.BBLE.Trim Equals l.BBLE.Trim Into Group3 = Group
                         From g3 In Group3.DefaultIfEmpty() Select New With {
                                                      .BBLE = s2.BBLE,
                                                      .UnderwritingStatus = s2.UnderwritingStatus,
                                                      .UnderwritingCreateBy = s2.UnderwritingCreateBy,
                                                      .UnderwritingCreateDate = s2.UnderwritingCreateDate,
                                                      .UnderwritingUpdateDate = s2.UnderwritingUpdateDate,
                                                      .SearchStatus = s2.SearchStatus,
                                                      .SearchCompletedBy = s2.SearchCompletedBy,
                                                      .SearchCompletedOn = s2.SearchCompletedOn,
                                                      .SearchUpdateDate = s2.SearchUpdateDate,
                                                      .CaseName = If(g3 Is Nothing, String.Empty, g3.LeadsName),
                                                      .EmployeeName = If(g3 Is Nothing, String.Empty, g3.EmployeeName)}
            Dim steps4 = From s3 In steps3.ToList() Group Join o In ctx.PropertyOffers On s3.BBLE.Trim Equals o.BBLE.Trim Into Group4 = Group
                         From g4 In Group4.DefaultIfEmpty() Select New With {
                                                      .BBLE = s3.BBLE,
                                                      .UnderwritingStatus = s3.UnderwritingStatus,
                                                      .UnderwritingCreateBy = s3.UnderwritingCreateBy,
                                                      .UnderwritingCreateDate = s3.UnderwritingCreateDate,
                                                      .UnderwritingUpdateDate = s3.UnderwritingUpdateDate,
                                                      .SearchStatus = s3.SearchStatus,
                                                      .SearchCompletedBy = s3.SearchCompletedBy,
                                                      .SearchCompletedOn = s3.SearchCompletedOn,
                                                      .SearchUpdateDate = s3.SearchUpdateDate,
                                                      .CaseName = s3.CaseName,
                                                      .EmployeeName = s3.EmployeeName,
                                                      .NewOfferStatus = If(g4 Is Nothing, -1, g4.Status)}
            Return steps4.ToList()

        End Using
    End Function

    Friend Shared Function GetUnderwritingServiceLogs(objectName As String, recordId As String) As IEnumerable(Of AuditLog)
        Dim Connection As HubConnection = New HubConnection(HubURL)
        Dim UnderwritingHub As IHubProxy = Connection.CreateHubProxy("UnderwritingServiceHub")
        Connection.Start().Wait()
        Dim Logs = UnderwritingHub.Invoke(Of AuditLog())("GetAuditLogs", objectName, recordId).Result.ToList()
        Connection.Dispose()
        Return Logs
    End Function

    Public Shared Function GetUnderwritingByStatus(status As Integer) As IEnumerable(Of Object)
        Dim Connection As HubConnection = New HubConnection(HubURL)
        Dim UnderwritingHub As IHubProxy = Connection.CreateHubProxy("UnderwritingServiceHub")
        Connection.Start().Wait()
        Dim Underwritings = UnderwritingHub.Invoke(Of UnderwritingResponse())("GetUnderwritingListInfoByStatus", status).Result.ToList()
        Connection.Dispose()
        Return Underwritings.OrderByDescending(Function(s) s.UnderwritingUpdateDate).Take(10)
    End Function

    Public Shared Sub SyncToUnderwritingService()
        Dim Connection As HubConnection = New HubConnection(HubURL)
        Dim UnderwritingHub As IHubProxy = Connection.CreateHubProxy("UnderwritingServiceHub")
        Using ctx As New PortalEntities
            Dim SearchBBLES = ctx.LeadInfoDocumentSearches.Select(Function(s) s.BBLE).ToList()
            For Each BBLE In SearchBBLES
                Dim underwriting = BuildUnderwritingData(BBLE)
                If underwriting IsNot Nothing Then
                    Connection.Start().Wait()
                    Dim Underwritings = UnderwritingHub.Invoke(Of JObject)("TryCreate", underwriting).Result
                    Core.SystemLog.Log("Underwriting Sync Result", underwriting.ToString, Core.SystemLog.LogCategory.Operation, underwriting("BBLE").ToString, "System")
                    Connection.Dispose()
                End If
            Next
        End Using
    End Sub

    Shared Function BuildUnderwritingData(BBLE As String) As JObject
        Dim result As JObject = New JObject()
        result("BBLE") = BBLE
        result("PropertyInfo") = New JObject()
        result("LienInfo") = New JObject()
        result("LienCosts") = New JObject()
        result("PropertyInfo") = New JObject()
        Try

            Using ctx As New PortalEntities
                Dim search = ctx.LeadInfoDocumentSearches.FirstOrDefault(Function(s) s.BBLE = BBLE)
                If search IsNot Nothing Then
                    result("CreateDate") = search.CreateDate
                    result("CreateBy") = search.CreateBy
                    Select Case search.UnderwriteStatus
                        Case LeadInfoDocumentSearch.UnderWriterStatus.PendingSearch
                            result("Status") = 1
                        Case LeadInfoDocumentSearch.UnderWriterStatus.PendingUnderwriting
                            result("Status") = 2
                        Case LeadInfoDocumentSearch.UnderWriterStatus.CompletedUnderwriting
                            result("Status") = 3
                        Case LeadInfoDocumentSearch.UnderWriterStatus.RejectUnderwriting
                            result("Status") = 4
                        Case Else
                            result("Status") = 1
                    End Select

                    Dim searchJson = JObject.Parse(search.LeadResearch)
                    If searchJson("docSearch") IsNot Nothing AndAlso searchJson("docSearch")("LeadResearch") IsNot Nothing Then
                        Dim leadResearch = searchJson("docSearch")("LeadResearch")
                        result("PropertyInfo")("PropertyTaxYear") = If(leadResearch("leadsProperty_Taxes_per_YR_Property_Taxes_Due") Is Nothing, 0.0, leadResearch("leadsProperty_Taxes_per_YR_Property_Taxes_Due"))
                        result("LienInfo")("FirstMortgage") = If(leadResearch("mortgageAmount") Is Nothing, 0.0, leadResearch("mortgageAmount"))
                        result("LienInfo")("SecondMortgage") = If(leadResearch("secondMortgageAmount") Is Nothing, 0.0, leadResearch("secondMortgageAmount"))
                        result("LienInfo")("COSRecorded") = If(leadResearch("Has_COS_Recorded") Is Nothing, False, leadResearch("Has_COS_Recorded"))
                        result("LienInfo")("DeedRecorded") = If(leadResearch("Has_Deed_Recorded") Is Nothing, False, leadResearch("Has_Deed_Recorded"))
                        result("LienInfo")("FHA") = If(leadResearch("fha") Is Nothing, False, leadResearch("fha"))
                        result("LienInfo")("FannieMae") = If(leadResearch("fannie") Is Nothing, False, leadResearch("fannie"))
                        result("LienInfo")("FreddieMac") = If(leadResearch("Freddie_Mac_") Is Nothing, False, leadResearch("Freddie_Mac_"))
                        result("LienInfo")("Servicer") = If(leadResearch("servicer") Is Nothing, "", leadResearch("servicer"))
                        result("LienInfo")("ForeclosureIndexNum") = If(leadResearch("LP_Index___Num_LP_Index___Num") Is Nothing, "", leadResearch("LP_Index___Num_LP_Index___Num"))
                        result("LienInfo")("ForeclosureNote") = If(leadResearch("notes_LP_Index___Num") Is Nothing, "", leadResearch("notes_LP_Index___Num"))
                        If (leadResearch("TaxLienCertificate") IsNot Nothing) Then
                            Dim total = 0.0
                            Dim taxLienCertificates = JArray.FromObject(leadResearch("TaxLienCertificate"))
                            For Each Token In taxLienCertificates
                                total += Double.Parse(Token("Amount").ToString)
                            Next
                            result("LienCosts")("TaxLienCertificate") = total
                        End If
                        result("LienCosts")("PropertyTaxes") = If(leadResearch("propertyTaxes") Is Nothing, 0.0, leadResearch("propertyTaxes"))
                        result("LienCosts")("WaterCharges") = If(leadResearch("waterCharges") Is Nothing, 0.0, leadResearch("waterCharges"))
                        result("LienCosts")("HPDCharges") = If(leadResearch("Open_Amount_HPD_Charges_Not_Paid_Transferred") Is Nothing, 0.0, leadResearch("Open_Amount_HPD_Charges_Not_Paid_Transferred"))
                        result("LienCosts")("ECBCityPay") = If(leadResearch("Amount_ECB_Tickets") Is Nothing, 0.0, leadResearch("Amount_ECB_Tickets"))
                        result("LienCosts")("DOBCivilPenalty") = If(leadResearch("DOBCivilPenalty") Is Nothing, 0.0, leadResearch("DOBCivilPenalty"))
                        result("LienCosts")("PersonalJudgements") = If(leadResearch("Amount_Personal_Judgments") Is Nothing, 0.0, leadResearch("Amount_Personal_Judgments"))
                        result("LienCosts")("HPDJudgements") = If(leadResearch("HPDjudgementAmount") Is Nothing, 0.0, leadResearch("HPDjudgementAmount"))
                        result("LienCosts")("NYSTaxWarrants") = If(leadResearch("Amount_NYS_Tax_Lien") Is Nothing, 0.0, leadResearch("Amount_NYS_Tax_Lien"))
                        result("LienCosts")("FederalTaxLien") = If(leadResearch("irsTaxLien") Is Nothing, 0.0, leadResearch("irsTaxLien"))
                        result("LienCosts")("VacateOrder") = If(leadResearch("has_Vacate_Order_Vacate_Order") Is Nothing, False, leadResearch("has_Vacate_Order_Vacate_Order"))
                        If leadResearch("has_Vacate_Order_Vacate_Order") IsNot Nothing AndAlso Boolean.Parse(leadResearch("has_Vacate_Order_Vacate_Order").ToString) = True Then
                            result("LienCosts")("RelocationLien") = If(leadResearch("Amount_Vacate_Order") Is Nothing, 0.0, leadResearch("Amount_Vacate_Order"))
                        End If
                    End If

                End If
                Dim leadsInfo = ctx.ShortSaleLeadsInfoes.FirstOrDefault(Function(s) s.BBLE = BBLE)
                If leadsInfo IsNot Nothing Then
                    result("PropertyInfo")("PropertyAddress") = leadsInfo.PropertyAddress.Trim
                    result("PropertyInfo")("CurrentOwner") = leadsInfo.Owner.Trim
                    result("PropertyInfo")("TaxClass") = leadsInfo.TaxClass.Trim
                    result("PropertyInfo")("LotSize") = leadsInfo.LotDem.Trim
                    result("PropertyInfo")("BuildingDimension") = leadsInfo.BuildingDem.Trim
                    result("PropertyInfo")("Zoning") = leadsInfo.Zoning.Trim
                    result("PropertyInfo")("FARActual") = leadsInfo.ActualFar.Trim
                    result("PropertyInfo")("FARMax") = leadsInfo.MaxFar.Trim
                End If
                Return result
            End Using
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Class UnderwritingResponse
        Public BBLE As String
        Public UnderwritingStatus As Integer
        Public UnderwritingCreateBy As String
        Public UnderwritingCreateDate As DateTime?
        Public UnderwritingUpdateDate As DateTime?
    End Class
End Class

Imports System.Net
Imports DevExpress.XtraSpreadsheet.Utils
Imports IntranetPortal.Data
Imports Microsoft.AspNet.SignalR.Client

Public Class UnderwritingService
    Public Shared Connection As HubConnection
    Public Shared UnderwritingHub As IHubProxy


    Public Sub New()
    End Sub

    Shared Function Connect()
        Connection.Start().Wait()
    End Function

    Public Shared Function GetPropertiesList() As IEnumerable(Of Object)
        Dim HubURL = ConfigurationManager.AppSettings("UnderwritingServiceServer").ToString()
        Connection = New HubConnection(HubURL)
        UnderwritingHub = Connection.CreateHubProxy("UnderwritingServiceHub")
        ServicePointManager.DefaultConnectionLimit = 10
        AddHandler Connection.Reconnecting, AddressOf Connect
        Using ctx As New PortalEntities
            Connection.Start().Wait()
            Dim UnderwritingBBLEs = UnderwritingHub.Invoke(Of String())("GetUnderwritingBBLEs").Result.ToList()
            Connection.Dispose()
            Connection.Start().Wait()
            Dim Underwritings = UnderwritingHub.Invoke(Of UnderwritingResponse())("GetUnderwritingListInfo").Result.ToList()
            Dim SearchBBLES = ctx.LeadInfoDocumentSearches.Select(Function(s) s.BBLE).ToList()
            Dim CommonBBLEs = UnderwritingBBLEs.Union(SearchBBLES).ToList()
            If CommonBBLEs.Count = 0 Then
                Return Nothing
            End If
            Dim steps1 = From bble In CommonBBLEs Group Join u In Underwritings On bble Equals u.BBLE Into Group1 = Group
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
                                                      .SearchCompletedOn = If(g2 Is Nothing, Nothing, g2.CompletedOn)}
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
                                                      .CaseName = s3.CaseName,
                                                      .EmployeeName = s3.EmployeeName,
                                                      .NewOfferStatus = If(g4 Is Nothing, -1, g4.Status)}
            Return steps4.ToList()

        End Using
    End Function

    Class UnderwritingResponse
        Public BBLE As String
        Public UnderwritingStatus As Integer
        Public UnderwritingCreateBy As String
        Public UnderwritingCreateDate As DateTime?
        Public UnderwritingUpdateDate As DateTime?
    End Class
End Class

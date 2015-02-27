Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports IntranetPortal.Core

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IMapDataService" in both code and config file together.
<ServiceContract()>
Public Interface IMapDataService

    <OperationContract()>
     <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="BlockData/{neLat},{neLng},{swLat},{swLng}")>
    Function LoadBlockData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="ZipCount/{zip}")>
    Function GetZipCountInfo(zip As String) As Channels.Message

    '<OperationContract()>
    ' <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="TestData")>
    'Function TestData() As Channels.Message

End Interface

Partial Public Class MapDataService
    Implements IMapDataService

    Public Function LoadBlockData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message Implements IMapDataService.LoadBlockData
        Dim dataSvr As New MapService
        Dim result = New With {
            .type = "FeatureCollection",
            .features = dataSvr.LoadBlockLayers(neLat, neLng, swLat, swLng)
            }
        Return result.ToJson()
    End Function
    Public Function GetZipCountInfo(zip As String) As Channels.Message Implements IMapDataService.GetZipCountInfo

        Using ctx As New Entities
            Dim LeadsInportal = New MapDataSet
            LeadsInportal.TypeName = "Leads In Portal"
            LeadsInportal.KeyCode = zip
            LeadsInportal.Count = ctx.Leads_with_last_log.Where(Function(f) f.ZipCode = zip).Count
            Dim cList = New List(Of MapDataSet)

            cList.Add(LeadsInportal)
            cList.AddRange(ctx.MapDataSets.Where(Function(m) m.KeyCode = zip AndAlso m.Count <> 0).ToList())

            Dim ListArrayDepatment As New List(Of String) From {"AITeam", "Core Staff", "ddd", "IT", "GalleriaTeam"}
            Dim TeamLeadsCount = ctx.Leads_with_last_log.Where(Function(m) m.ZipCode = zip AndAlso m.Department IsNot Nothing AndAlso Not ListArrayDepatment.Contains(m.Department)).GroupBy(Function(l) l.Department).Select(Function(l) New With {.Count = l.Count, .Deparemt = l.Key}).ToList()
            For Each tc In TeamLeadsCount
                Dim teamCountZip = New MapDataSet
                Dim department = tc.Deparemt
                If (department.Contains("Team")) Then
                    department = department.Replace("Team", " Team")
                Else
                    department = department + " Team"
                End If
                teamCountZip.TypeName = department
                teamCountZip.KeyCode = zip
                teamCountZip.Count = tc.Count
                cList.Add(teamCountZip)
            Next

            Return cList.ToJson
        End Using

    End Function
End Class
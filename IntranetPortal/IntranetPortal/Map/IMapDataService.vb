Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports IntranetPortal.Core

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IMapDataService" in both code and config file together.
<ServiceContract()>
Public Interface IMapDataService

    <OperationContract()>
     <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAllTeamColor")>
    Function LoadAllTeamColor() As Channels.Message

    <OperationContract()>
     <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="BlockData/{neLat},{neLng},{swLat},{swLng}")>
    Function LoadBlockData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message
    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadLotData/{neLat},{neLng},{swLat},{swLng}")>
    Function LoadLotData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="ZipCount/{zip}")>
    Function GetZipCountInfo(zip As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadLotByBBLE/{bble}")>
    Function LoadLotByBBLE(BBLE As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadLotByTeam/{team}")>
    Function LoadLotByTeam(Team As String) As Channels.Message
    '<OperationContract()>
    ' <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="TestData")>
    'Function TestData() As Channels.Message

End Interface

Partial Public Class MapDataService
    Implements IMapDataService

    Public Function LoadBlockData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message Implements IMapDataService.LoadBlockData
        Try
            Dim dataSvr As New MapService
            Dim result = New With {
                .type = "FeatureCollection",
                .features = dataSvr.LoadBlockLayers(neLat, neLng, swLat, swLng)
                }
            Return result.ToJson()
        Catch ex As Exception
            Return ex.InnerException.ToJson
        End Try
    End Function
    Public Function LoadLotByTeam(Team As String) As Channels.Message Implements IMapDataService.LoadLotByTeam
        Try
            Dim dataSvr As New MapService

            Dim result = New With {
                .type = "FeatureCollection",
                .features = dataSvr.LoadLotByTeam(Team)
                }
            Return result.ToJson()
        Catch ex As Exception
            Return ex.InnerException.ToJson
        End Try
    End Function
    Public Function LoadLotData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message Implements IMapDataService.LoadLotData
        Try
            Dim dataSvr As New MapService

            Dim result = New With {
                .type = "FeatureCollection",
                .features = dataSvr.LoadLotLayers(neLat, neLng, swLat, swLng)
                }
            Return result.ToJson()
        Catch ex As Exception
            Return ex.InnerException.ToJson
        End Try
    End Function
    Public Function LoadLotByBBLE(BBLE As String) As Channels.Message Implements IMapDataService.LoadLotByBBLE
        Try
            Dim dataSvr As New MapService

            Dim result = New With {
                .type = "FeatureCollection",
                .features = dataSvr.LoadLotByBBLE(BBLE)
                }
            Return result.ToJson()
        Catch ex As Exception
            Return ex.InnerException.ToJson
        End Try

    End Function
    Public Function LoadAllTeamColor() As Channels.Message Implements IMapDataService.LoadAllTeamColor
        Try
            Dim dataSvr As New MapService

            Dim result = dataSvr.LoadALLTeamColor

            Return result.ToJson()
        Catch ex As Exception
            Return ex.InnerException.ToJson
        End Try
    End Function
    Public Shared Function GetAllZipCountInfoList() As List(Of Object)
        Dim cList = New List(Of Object)
        Using ctx As New Entities
            Dim Zips = ctx.MapDataSets.Select(Function(l) l.KeyCode).Distinct.ToList

            For Each zip In Zips
                cList.AddRange(GetZipCountInfoList(zip))
            Next
        End Using

        Return cList
    End Function

    Shared Function CoventMapDataSet(map As MapDataSet) As Object
        Return New With
               {
                   .TypeName = map.TypeName,
                   .KeyCode = map.KeyCode,
                   .Count = map.Count.ToString
                   }
    End Function
    Public Shared Function GetZipCountInfoList(zip As String) As List(Of Object)
        Dim SHOW_PERCENT = True
        Using ctx As New Entities
            Dim LeadsInportal = New MapDataSet
            LeadsInportal.TypeName = "Leads In Portal"
            LeadsInportal.KeyCode = zip
            LeadsInportal.Count = ctx.Leads_with_last_log.Where(Function(f) f.ZipCode = zip).Count

            Dim cList = New List(Of Object)

            cList.Add(CoventMapDataSet(LeadsInportal))



            If (SHOW_PERCENT) Then
                Dim mapDataList = ctx.MapDataSets.Where(Function(m) m.KeyCode = zip AndAlso m.Count <> 0 AndAlso m.PercentWDB IsNot Nothing).ToList
                '.Select(
                '    Function(l) New With {
                '                        .TypeName = l.TypeName,
                '                        .KeyCode = l.KeyCode,
                '                        .Count = CDec(l.PercentWDB).ToString("p")}
                ').ToList()
                Dim CovertList = New List(Of Object)

                For Each m In mapDataList
                    Dim l = New With {.TypeName = m.TypeName,
                    .KeyCode = m.KeyCode,
                    .Count = "0%"
                        }

                    Dim d = CDec(m.PercentWDB) '0.0123
                    'm.PercentWDB
                    Dim CountStr = d.ToString("p")
                    l.Count = CountStr
                    CovertList.Add(l)
                Next

                cList.AddRange(CovertList)
            Else
                cList.AddRange(ctx.MapDataSets.Where(Function(m) m.KeyCode = zip AndAlso m.Count <> 0).ToList())
            End If


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

                cList.Add(CoventMapDataSet(teamCountZip))



            Next

            Return cList
        End Using
    End Function
    Public Function GetZipCountInfo(zip As String) As Channels.Message Implements IMapDataService.GetZipCountInfo

        Return GetZipCountInfoList(zip).ToJson
   
    End Function
End Class
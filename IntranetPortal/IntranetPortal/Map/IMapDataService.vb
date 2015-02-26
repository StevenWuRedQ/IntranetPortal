Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports IntranetPortal.Core

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IMapDataService" in both code and config file together.
<ServiceContract()>
Public Interface IMapDataService

    <OperationContract()>
     <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="BlockData/{neLat},{neLng},{swLat},{swLng}")>
    Function LoadBlockData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message

    '<OperationContract()>
    ' <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="TestData")>
    'Function TestData() As Channels.Message

End Interface

Partial Public Class MapDataService
    Implements IMapDataService

    Public Function LoadBlockData(neLat As String, neLng As String, swLat As String, swLng As String) As Channels.Message Implements IMapDataService.LoadBlockData
        Dim dataSvr As New MapService
        Return dataSvr.LoadBlockLayers(neLat, neLng, swLat, swLng).ToJson()
    End Function
End Class
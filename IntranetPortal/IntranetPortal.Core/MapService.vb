Imports System.Data.Entity.Spatial
Imports GeoJSON.Net.Feature
Imports Microsoft.SqlServer.Types
Imports System.Data.SqlTypes

Public Class MapService
    Private Const SRID As Integer = 4326

    Public Function LoadBlockLayers(neLat As Double, neLng As Double, swLat As Double, swLng As Double) As List(Of Feature)
        Dim mapBound = GetPolygon(neLat, neLng, swLat, swLng)

        Dim result As New List(Of Feature)
        Using ctx As New MapDataEntitiesContainer
            Dim blocks = ctx.dtm_0814_tax_block_polygon.Where(Function(b) mapBound.Contains(b.ogr_geometry))
            For Each block In blocks.ToList
                Dim featureProperties As New Dictionary(Of String, Object)
                featureProperties.Add("block", block.block)
                featureProperties.Add("Boro", block.boro)

                Dim polygon = SqlGeometry.Parse(New SqlString(block.ogr_geometry.WellKnownValue.WellKnownText))
                Dim obj = GeoJSON.Net.MsSqlSpatial.MsSqlSpatialConvert.ToGeoJSONGeometry(polygon)
                Dim model = New Feature(obj, featureProperties, block.ogr_fid.ToString)
                result.Add(model)
            Next
        End Using

        Return result
    End Function

    Private Function GetPolygon(neLat As Double, neLng As Double, swLat As Double, swLng As Double) As System.Data.Entity.Spatial.DbGeometry
        'POLYGON ((-73.942977127655283 40.673832266685181, -73.941917175757922 40.67377313791129, -73.941986092333892 40.673075188355796, -73.944474022185275 40.673213961502164, -73.944415311436742 40.673912480287413, -73.942977127655283 40.673832266685181))
        Dim polygonText = String.Format("POLYGON(({0},{1},{2},{3},{0}))", New MapPoint(neLng, neLat), New MapPoint(neLng, swLat), New MapPoint(swLng, swLat), New MapPoint(swLng, neLat))
        Return DbGeometry.PolygonFromText(polygonText, SRID)
    End Function

    Function GetZipCountInfo(zip As String) As Object
        Throw New NotImplementedException
    End Function

End Class

Public Class MapPoint
    Public Property Lng As Double
    Public Property Lat As Double

    Public Sub New(lng As Double, lat As Double)
        Me.Lng = lng
        Me.Lat = lat
    End Sub

    Public Overrides Function ToString() As String
        Return String.Format("{0} {1}", Lng, Lat)
    End Function
End Class
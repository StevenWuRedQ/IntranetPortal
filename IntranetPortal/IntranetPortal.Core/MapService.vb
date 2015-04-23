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

    Public Function LoadLotLayers(neLat As Double, neLng As Double, swLat As Double, swLng As Double) As List(Of Feature)
        Dim mapBound = GetPolygon(neLat, neLng, swLat, swLng)


        Dim result As New List(Of Feature)
        Using ctx As New MapDataEntitiesContainer

            Dim lots = ctx.PortalLotInfoes.Where(Function(b) mapBound.Contains(b.ogr_geometry))

            For Each lot In lots.ToList
                
                result.Add(buildLotGeoJson(lot))
            Next
        End Using

        Return result
    End Function

    Public Function LoadLotByBBLE(BBLE As String) As List(Of Feature)


        Dim result As New List(Of Feature)
        Using ctx As New MapDataEntitiesContainer

            Dim lots = ctx.PortalLotInfoes.Where(Function(b) b.BBLE IsNot Nothing And b.BBLE > BBLE).OrderBy(Function(b) b.BBLE) '.Take(100)

            For Each lot In lots.ToList
                result.Add(buildLotGeoJson(lot))
            Next
        End Using

        Return result
    End Function

    Function LoadLotByTeam(Team As String) As List(Of Feature)
        Dim result As New List(Of Feature)
        Using ctx As New MapDataEntitiesContainer

            Dim lots = ctx.PortalLotInfoes.Where(Function(b) b.BBLE IsNot Nothing And b.Team = Team).OrderBy(Function(b) b.BBLE)

            For Each lot In lots.ToList
                result.Add(buildLotGeoJson(lot))
            Next
        End Using

        Return result
    End Function
    Function buildLotGeoJson(lot As PortalLotInfo) As Feature
        Dim featureProperties As New Dictionary(Of String, Object)

        featureProperties.Add("title", lot.BBLE)
        featureProperties.Add("BBLE", lot.bbl)

        featureProperties.Add("description", lot.LeadsName)
        featureProperties.Add("Team", lot.Team)
        featureProperties.Add("color", lot.Color)
        featureProperties.Add("LPBBLE", lot.LPBBLE)
        featureProperties.Add("Unbuild_SQFT", lot.Unbuild_SQFT)
        Dim polygon = SqlGeometry.Parse(New SqlString(lot.ogr_geometry.WellKnownValue.WellKnownText))
        Dim obj = GeoJSON.Net.MsSqlSpatial.MsSqlSpatialConvert.ToGeoJSONGeometry(polygon)
        Dim model = New Feature(obj, featureProperties, lot.ogr_fid.ToString)
        Return model
    End Function

    Private Function GetPolygon(neLat As Double, neLng As Double, swLat As Double, swLng As Double) As System.Data.Entity.Spatial.DbGeometry
        'POLYGON ((-73.942977127655283 40.673832266685181, -73.941917175757922 40.67377313791129, -73.941986092333892 40.673075188355796, -73.944474022185275 40.673213961502164, -73.944415311436742 40.673912480287413, -73.942977127655283 40.673832266685181))
        Dim polygonText = String.Format("POLYGON(({0},{1},{2},{3},{0}))", New MapPoint(neLng, neLat), New MapPoint(neLng, swLat), New MapPoint(swLng, swLat), New MapPoint(swLng, neLat))
        Return DbGeometry.PolygonFromText(polygonText, SRID)
    End Function

    

    Function LoadALLTeamColor() As List(Of Dictionary(Of String, String))
        Dim colors = New List(Of Dictionary(Of String, String))
        Using ctx As New MapDataEntitiesContainer
            For Each c In ctx.PortalLotInfoes.Where(Function(l) l.Team IsNot Nothing).Select(Function(l) New With {.Team = l.Team, .Color = l.Color}).Distinct.ToList()
                Dim tc = New Dictionary(Of String, String)
                tc.Add("Team", c.Team)
                tc.Add("Color", c.Color)
                colors.Add(tc)
            Next
            Return colors
        End Using
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
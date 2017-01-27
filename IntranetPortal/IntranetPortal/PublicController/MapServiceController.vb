Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Core

Namespace PublicController

    ''' <summary>
    '''     Map Service Controller to provide block and lot map
    ''' </summary>
    Public Class MapServiceController
        Inherits ApiController

        Private service As New MapService

        ' GET api/<controller>
        <Route("api/mapservice/lot/{bble}")>
        Public Function GetLotMap(bble As String) As IHttpActionResult

            Try
                Dim result = service.LoadLotData(bble)

                If result Is Nothing Then
                    Return NotFound()
                End If

                Return Ok(result)
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        ' GET api/<controller>
        <Route("api/mapservice/{bble}/sameblock/lots")>
        Public Function GetSameBlockLotMap(bble As String) As IHttpActionResult

            Try
                Dim result = service.LoadSameBlockData(bble)

                If result Is Nothing Then
                    Return NotFound()
                End If

                Return Ok(New With {
                .type = "FeatureCollection",
                .features = result
                })
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        <Route("api/mapservice/{bble}/sameblock/footprints")>
        Public Function GetSameBlockFootPrintMap(bble As String) As IHttpActionResult

            Try
                Dim result = service.LoadSameBlockFootPrintData(bble)

                If result Is Nothing Then
                    Return NotFound()
                End If

                Return Ok(New With {
                .type = "FeatureCollection",
                .features = result
                })
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace



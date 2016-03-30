Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class PreSignController
        Inherits ApiController

        Public Function GetPreSignRecord(id As Integer) As IHttpActionResult
            Dim record = PreSignRecord.GetInstance(id)
            If IsNothing(record) Then
                Return NotFound()
            End If

            Return Ok(record)

        End Function

        Public Function PutNewPreSign(id As Integer, record As PreSignRecord) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = record.Id Then
                Return BadRequest()
            End If

            Try
                record.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        Public Function PostNewPreSign(record As PreSignRecord) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                record.Create(HttpContext.Current.User.Identity.Name)

                If record.NeedSearch Then
                    Dim docController As New LeadInfoDocumentSearchesController
                    docController.PostLeadInfoDocumentSearch(New LeadInfoDocumentSearch With {.BBLE = record.BBLE})
                End If

            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(record)
        End Function

    End Class
End Namespace
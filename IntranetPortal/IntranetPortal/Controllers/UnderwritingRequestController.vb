Imports System.Net
Imports System.Web.Http

Imports IntranetPortal.Data

Namespace Controllers
    Public Class UnderwritingRequestController
        Inherits ApiController

        ' GET: api/UnderwritingRequest
        Public Function GetValues() As IEnumerable(Of String)
            Return New String() {"value1", "value2"}
        End Function

        ' GET: api/UnderwritingRequest/5
        Public Function GetValue(ByVal id As String) As IHttpActionResult
            Dim ur = IntranetPortal.Data.UnderwritingRequest.GetInstance(id)
            If ur Is Nothing Then
                Return StatusCode(HttpStatusCode.NoContent)
            End If

            Return Ok(ur)
        End Function

        ' POST: api/UnderwritingRequest
        Public Function PostValue(ByVal value As IntranetPortal.Data.UnderwritingRequest) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If String.IsNullOrEmpty(value.BBLE) Then
                Return BadRequest("BBLE cann't be empty.")
            End If

            value.Save(HttpContext.Current.User.Identity.Name)
            Return Ok(value)
        End Function

        ' PUT: api/UnderwritingRequest/5
        Public Function PutValue(ByVal id As Integer, ByVal record As IntranetPortal.Data.UnderwritingRequest) As IHttpActionResult
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

            Return Ok(record)
        End Function

        ' DELETE: api/UnderwritingRequest/5
        Public Sub DeleteValue(ByVal id As Integer)

        End Sub

        <HttpGet>
        <Route("api/UnderwritingRequest/GetAdditionalInfo/{BBLE}")>
        Public Function GetAdditionalInfo(BBLE As String) As IHttpActionResult
            If Not String.IsNullOrEmpty(BBLE) Then
                Dim l = Lead.GetInstance(BBLE)
                If Nothing Is l Then
                    Return BadRequest(String.Format("Property With {0} Cannot Be Found.", BBLE))
                Else
                    Dim addr = l.LeadsInfo.PropertyAddress
                    Using ctx As New PortalEntities
                        Dim r = From c In ctx.LeadInfoDocumentSearches
                                Where c.BBLE = BBLE

                        Dim status
                        Dim completedDate = Nothing
                        If r.Count > 0 Then
                            status = 1
                            completedDate = r.FirstOrDefault.CompletedOn
                        Else
                            status = 0
                        End If

                        Return Ok(New With {
                                        .Status = status,
                                        .Address = addr,
                                        .CompletedDate = completedDate
                        })
                    End Using
                End If
            End If
            Return BadRequest("BBLE cannot be empty")
        End Function
    End Class
End Namespace
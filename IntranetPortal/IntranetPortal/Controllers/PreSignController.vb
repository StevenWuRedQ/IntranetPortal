Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class PreSignController
        Inherits ApiController

        ''' <summary>
        ''' Get PreSign Records by user permission
        ''' </summary>
        ''' <returns></returns>
        <ResponseType(GetType(PreSignRecord()))>
        <Route("api/PreSign/records")>
        Public Function GetPreSignRecordByUser() As IHttpActionResult
            Dim name = HttpContext.Current.User.Identity.Name

            If Employee.IsAdmin(name) Then
                name = "*"
            End If

            Dim records = PreSignRecord.GetRecords(name)
            Return Ok(records)
        End Function

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

                If record.NeedCheck Then
                    Dim svr As New CommonService
                    Dim params = New Dictionary(Of String, String)

                    Dim finMgr = Roles.GetUsersInRole("Accounting-Manager")
                    If finMgr.Count > 0 Then
                        params.Add("RecordId", record.Id)
                        params.Add("UserName", finMgr(0))

                        Dim emails = Employee.GetEmpsEmails(finMgr.ToArray)
                        If Not String.IsNullOrEmpty(emails) Then
                            svr.SendEmailByControlWithCC(emails, Employee.GetInstance(record.CreateBy).Email, "Checks Request from " & record.CreateBy, "PreSignNotify", params)
                        End If
                    End If
                End If

            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(record)
        End Function

    End Class
End Namespace
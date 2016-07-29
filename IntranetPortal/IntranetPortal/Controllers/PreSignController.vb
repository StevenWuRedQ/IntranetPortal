Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class PreSignController
        Inherits ApiController
        '' Restful api desgin suggestion 
        '' Get api should use plural instand. like
        '' /api/PreSigns to get list and can revice an query object
        '' That client side can query use parameters

        ''' <summary>
        ''' Get PreSign Records by user permission Restful api for not use single 
        ''' </summary>
        ''' <returns></returns>
        <ResponseType(GetType(PreSignRecord()))>
        Public Function GetPreSigns() As IHttpActionResult
            Return GetPreSignRecordByUser()
        End Function

        ''' <summary>
        ''' Get PreSign Records by user permission
        ''' </summary>
        ''' <returns></returns>
        <ResponseType(GetType(PreSignRecord()))>
        <Route("api/PreSign/records")>
        Public Function GetPreSignRecordByUser() As IHttpActionResult
            Dim name = HttpContext.Current.User.Identity.Name

            If Employee.IsAdmin(name) OrElse User.IsInRole("NewOffer-Viewer") Then
                name = "*"
            End If

            Dim records = PreSignRecord.GetRecords(name)
            Return Ok(records)
        End Function

        ''' <summary>
        ''' Get all check request in  
        ''' by steven api design I should not need call this function 
        ''' in client side or move this to client side model
        ''' </summary>
        ''' <returns></returns>
        <ResponseType(GetType(CheckRequest()))>
        <Route("api/PreSign/CheckRequests")>
        Public Function GetAllCheckRequest() As IHttpActionResult

            Try
                Dim records = CheckRequest.GetRequests
                Return Ok(records)
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        <Route("api/PreSign/{Id}/AddCheck/{needCheck}")>
        Public Function PostAddCheck(Id As Integer, needCheck As String, check As BusinessCheck) As IHttpActionResult
            Try
                Dim preSign = PreSignRecord.GetInstance(Id)

                If (preSign Is Nothing) Then
                    Return BadRequest()
                End If

                Dim isNeedCheck = Boolean.Parse(needCheck)

                Dim addedCheck = preSign.AddCheck(isNeedCheck, check, HttpContext.Current.User.Identity.Name)
                Return Ok(preSign)
            Catch ex As Exception
                Throw ex
            End Try

        End Function
        Public Function GetPreSignRecord(id As Integer) As IHttpActionResult
            Dim record = PreSignRecord.GetInstance(id)
            If IsNothing(record) Then
                Return NotFound()
            End If

            Return Ok(record)
        End Function

        ''' <summary>
        ''' Resfult style API
        ''' </summary>
        ''' <param name="bble"></param>
        ''' <returns></returns>
        <Route("api/PreSign/BBLE/{bble}")>
        Public Function GetPreSignRecordByBBLE(bble As String) As IHttpActionResult
            Dim record = PreSignRecord.GetInstanceByBBLE(bble)
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

                If record.NeedSearch Then
                    'Dim docController As New LeadInfoDocumentSearchesController
                    'Dim docSearch = LeadInfoDocumentSearch.GetInstance(record.BBLE)
                    'If docSearch IsNot Nothing Then
                    '    If docSearch.Status = LeadInfoDocumentSearch.SearchStauts.NewSearch Then
                    '        docSearch.ExpectedSigningDate = record.ExpectedDate
                    '        docController.PutLeadInfoDocumentSearch(docSearch.BBLE, docSearch)
                    '    End If
                    'Else
                    '    docController.PostLeadInfoDocumentSearch(New LeadInfoDocumentSearch With {.BBLE = record.BBLE, .ExpectedSigningDate = record.ExpectedDate})
                    'End If
                End If

                SendNotification(record, True)

            Catch ex As Exception
                Throw ex
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        Public Function PostNewPreSign(record As PreSignRecord) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If String.IsNullOrEmpty(record.BBLE) Then
                Return BadRequest("BBLE cann't be empty.")
            End If

            record.Create(HttpContext.Current.User.Identity.Name)

            If record.NeedSearch Then
                'Dim docController As New LeadInfoDocumentSearchesController
                'Dim docSearch = LeadInfoDocumentSearch.GetInstance(record.BBLE)
                'If docSearch IsNot Nothing Then
                '    If docSearch.Status = LeadInfoDocumentSearch.SearchStauts.NewSearch Then
                '        docSearch.ExpectedSigningDate = record.ExpectedDate
                '        docController.PutLeadInfoDocumentSearch(docSearch.BBLE, docSearch)
                '    End If
                'Else
                '    docController.PostLeadInfoDocumentSearch(New LeadInfoDocumentSearch With {.BBLE = record.BBLE, .ExpectedSigningDate = record.ExpectedDate})
                'End If
            End If

            SendNotification(record)

            If record.NeedCheck Then
                'Dim svr As New CommonService
                'Dim params = New Dictionary(Of String, String)

                'Dim finMgr = Roles.GetUsersInRole("Accounting-Manager")
                'If finMgr.Count > 0 Then
                '    params.Add("RecordId", record.Id)
                '    params.Add("UserName", finMgr(0))

                '    Dim emails = Employee.GetEmpsEmails(finMgr.ToArray)
                '    If Not String.IsNullOrEmpty(emails) Then
                '        svr.SendEmailByControlWithCC(emails, Employee.GetInstance(record.CreateBy).Email, "Checks Request from " & record.CreateBy, "PreSignNotify", params)
                '    End If
                'End If
            End If

            Return Ok(record)
        End Function

        Private Sub SendNotification(record As PreSignRecord, Optional isUpdate As Boolean = False)

            Dim notify = Sub()
                             Dim svr As New CommonService
                             Dim params = New Dictionary(Of String, String)

                             Dim finMgr = Roles.GetUsersInRole("Accounting-Manager")
                             If finMgr.Count > 0 Then
                                 params.Add("RecordId", record.Id)
                                 params.Add("UserName", finMgr(0))
                                 params.Add("IsUpdate", isUpdate)

                                 Dim emails = Employee.GetEmpsEmails(finMgr.ToArray)
                                 If Not String.IsNullOrEmpty(emails) Then
                                     svr.SendEmailByControlWithCC(emails, Employee.GetEmpsEmails(record.CreateBy), "HOI Request from " & record.CreateBy & " about " & record.Title, "PreSignNotify", params)
                                 End If
                             End If
                         End Sub

            Threading.ThreadPool.QueueUserWorkItem(notify)
        End Sub

    End Class
End Namespace
Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class BusinessCheckController
        Inherits ApiController

        <Authorize(Roles:="Admin,Accounting-*")>
        Public Function GetBusinessCheck(id As Integer) As IHttpActionResult
            Dim record = BusinessCheck.GetInstance(id)

            If IsNothing(record) Then
                Return NotFound()
            End If

            Return Ok(record)
        End Function

        Public Function PutBusinessCheck(id As Integer, check As BusinessCheck) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = check.CheckId Then
                Return BadRequest()
            End If

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        <Route("api/BusinessCheck/{id}/Process")>
        <Authorize(Roles:="Admin,Accounting-*")>
        Public Function PostCompleted(id As Integer, check As BusinessCheck) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = check.CheckId Then
                Return BadRequest()
            End If

            If Not check.ConfirmedAmount.HasValue Then
                Return BadRequest("Check Amount can't be empty.")
            End If

            Try
                Dim chk = BusinessCheck.GetInstance(id)
                chk.Complete(check.ConfirmedAmount, check.CheckNo, HttpContext.Current.User.Identity.Name)
                NotifyCheckIsProcessed(chk)
                Return Ok(chk)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function PostBusinessCheck(check As BusinessCheck) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(check)
        End Function

        Public Function DeleteBusinessCheck(ByVal id As String, <FromBody> comments As String) As IHttpActionResult
            Dim check = BusinessCheck.GetInstance(id)
            If IsNothing(check) Then
                Return NotFound()
            End If

            check.Status = BusinessCheck.CheckStatus.Canceled
            check.Comments = comments

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(check)
        End Function

        Private Sub NotifyCheckIsProcessed(check As BusinessCheck)
            Dim notify = Sub()
                             Dim params = New Dictionary(Of String, String)
                             Dim cfo = Roles.GetUsersInRole("Accounting-CFO")
                             Dim users = Roles.GetUsersInRole("Accounting-Manager")

                             Dim userName = "All"
                             If cfo IsNot Nothing AndAlso cfo.Count > 0 Then
                                 userName = cfo(0)
                                 users = users.Concat(cfo).Distinct.ToArray
                             End If

                             Dim notifyUsers = Roles.GetUsersInRole("CheckProcess-Notify")
                             If notifyUsers IsNot Nothing AndAlso notifyUsers.Count > 0 Then
                                 users = users.Concat(notifyUsers).Distinct.ToArray
                             End If

                             If users.Count > 0 Then
                                 Dim cr = CheckRequest.GetInstance(check.RequestId)
                                 params.Add("UserName", check.ProcessedBy)
                                 params.Add("Address", cr.PropertyAddress)
                                 params.Add("Requestor", check.CreateBy)
                                 params.Add("PayableTo", check.PaybleTo)
                                 params.Add("ConfirmedAmount", String.Format("{0:c}", check.ConfirmedAmount))
                                 params.Add("CheckNo", check.CheckNo)
                                 params.Add("Description", check.Description)

                                 Dim emails = Employee.GetEmpsEmails(users.ToArray)
                                 Core.EmailService.SendMail(Employee.GetEmpsEmails(check.CreateBy), emails, "CheckProcessedNotify", params)
                                 'If Not String.IsNullOrEmpty(emails) Then
                                 '    svr.SendEmailByControlWithCC(Employee.GetEmpsEmails(check.CreateBy), emails, "HOI Request from " & record.CreateBy & " about " & record.Title, "PreSignNotify", params)
                                 'End If
                             End If
                         End Sub

            Threading.ThreadPool.QueueUserWorkItem(notify)
        End Sub

    End Class
End Namespace
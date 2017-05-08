Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data
Imports IntranetPortal.LeadsActivityLog

Namespace Controllers

    Public Class LeadInfoDocumentSearchesController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/LeadInfoDocumentSearches
        Function GetLeadInfoDocumentSearches() As IHttpActionResult
            Dim status = HttpContext.Current.Request.QueryString("status")
            If Not String.IsNullOrEmpty(status) Then
                Dim view As LeadInfoDocumentSearch.SearchStatus
                If Integer.TryParse(status, view) Then
                    Dim result = LeadInfoDocumentSearch.GetDocumentSearchs
                    Dim completedlist = result.Where(Function(ls) ls.Status = view) _
                                              .OrderByDescending(Function(a) a.CompletedOn) _
                                              .ThenBy(Function(a) a.CreateDate).ToList
                    Return Ok(completedlist)
                End If

                Return Ok()
            Else
                Dim searchs = LeadInfoDocumentSearch.GetDocumentSearchs()
                searchs.ForEach(Function(s) s.Team = Employee.GetEmpTeam(s.Owner))
                Return Ok(searchs)
            End If
        End Function

        ' GET: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function GetLeadInfoDocumentSearch(ByVal id As String) As IHttpActionResult
            Dim leadInfoDocumentSearch As LeadInfoDocumentSearch = db.LeadInfoDocumentSearches.Find(id)
            If IsNothing(leadInfoDocumentSearch) Then
                Dim c = New With {.Message = "Please make sure you submit a search first!"}
                Dim result = Content(HttpStatusCode.NonAuthoritativeInformation, c)
                Return result
            End If

            Return Ok(leadInfoDocumentSearch)
        End Function

        ' PUT: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(Void))>
        Function PutLeadInfoDocumentSearch(ByVal id As String, ByVal leadInfoDocumentSearch As LeadInfoDocumentSearch) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id.Trim = leadInfoDocumentSearch.BBLE.Trim Then
                Return BadRequest()
            End If

            db.Entry(leadInfoDocumentSearch).State = EntityState.Modified

            Dim docSearch = leadInfoDocumentSearch
            docSearch.Update(HttpContext.Current.User.Identity.Name)

            If (docSearch.isNeedNotifyWhenSaving()) Then
                Dim mailData = docSearch.buildEmailMessge()
                Dim l = LeadsInfo.GetInstance(leadInfoDocumentSearch.BBLE)
                mailData.Add("Address", l.PropertyAddress)
                Dim users = Employee.GetRoleUsers(LeadInfoDocumentSearch.NOTIFY_ROLE_WHEN_UPDATING)

                mailData.Add("UserName", String.Join(", ", users))
                Core.EmailService.SendMail(
                                           Employee.GetRoleUserEmails(LeadInfoDocumentSearch.NOTIFY_ROLE_WHEN_UPDATING),
                                           Nothing, LeadInfoDocumentSearch.EMAIL_TEMPLATE_UPADATING,
                                           mailData)
            End If

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (LeadInfoDocumentSearchExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        <Route("api/LeadInfoDocumentSearches/{bble}/Completed")>
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function PostCompleted(ByVal bble As String, ByVal search As LeadInfoDocumentSearch) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not bble.Trim = search.BBLE.Trim Then
                Return BadRequest()
            End If

            Dim userName = HttpContext.Current.User.Identity.Name
            search.Complete(userName)

            If (Not String.IsNullOrEmpty(search.ResultContent)) Then
                Threading.ThreadPool.QueueUserWorkItem(AddressOf SendCompleteNotify, search)
            Else
                IntranetPortal.Core.SystemLog.LogError("LeadsDocumentSearchContentError", New Exception("The content is null"), search.ToJsonString, search.CompletedBy, search.BBLE)
            End If

            Return Ok(search)
        End Function

        Private Sub SendCompleteNotify(leadInfoDocumentSearch As LeadInfoDocumentSearch)
            Try
                Dim l = LeadsInfo.GetInstance(leadInfoDocumentSearch.BBLE)
                Dim maildata As New Dictionary(Of String, String)

                If l IsNot Nothing Then
                    maildata.Add("Address", l.PropertyAddress)
                Else
                    maildata.Add("Address", leadInfoDocumentSearch.BBLE)
                End If

                maildata.Add("UserName", leadInfoDocumentSearch.CreateBy)
                maildata.Add("ResutContent", leadInfoDocumentSearch.ResultContent)

                If Not String.IsNullOrEmpty(leadInfoDocumentSearch.CreateBy) Then
                    Dim attachment As Mail.Attachment
                    Dim judgeDoc = leadInfoDocumentSearch.LoadJudgesearchDoc

                    Dim ccEmail = Employee.GetEmpsEmails(Employee.CEO.Name)
                    ccEmail = ccEmail & ";" & IntranetPortal.Core.PortalSettings.GetValue("DocSearchEmail")

                    If judgeDoc IsNot Nothing Then
                        attachment = New Mail.Attachment(New IO.MemoryStream(CType(judgeDoc.Data, Byte())), judgeDoc.Name.ToString)
                        Core.EmailService.SendMail(ccEmail,
                                                    Nothing,
                                                   "DocSearchCompleted", maildata, {attachment})
                    Else
                        Core.EmailService.SendMail(ccEmail,
                                               Nothing, "DocSearchCompleted", maildata)
                    End If
                End If
            Catch ex As Exception
                IntranetPortal.Core.SystemLog.LogError("SendCompleteNotify", ex, Nothing, leadInfoDocumentSearch.CompletedBy, leadInfoDocumentSearch.BBLE)
            End Try
        End Sub

        ' POST: api/LeadInfoDocumentSearches
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function PostLeadInfoDocumentSearch(ByVal leadInfoDocumentSearch As LeadInfoDocumentSearch) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If String.IsNullOrEmpty(leadInfoDocumentSearch.BBLE) Then
                Return BadRequest("can't find bble")
            End If

            Dim user = HttpContext.Current.User.Identity.Name

            If leadInfoDocumentSearch.Create(user) Then
                LeadsActivityLog.AddActivityLog(DateTime.Now(), "Create a search request to doc Search Agent ", leadInfoDocumentSearch.BBLE, LogCategory.SalesAgent.ToString)
                Threading.ThreadPool.QueueUserWorkItem(AddressOf SendNewSearchNotify, leadInfoDocumentSearch)
            End If

            Return CreatedAtRoute("DefaultApi", New With {.id = leadInfoDocumentSearch.BBLE}, leadInfoDocumentSearch)
        End Function

        Private Sub SendNewSearchNotify(leadInfoDocumentSearch As LeadInfoDocumentSearch)
            Try
                Dim EntityMananger = Roles.GetUsersInRole("Entity-Manager")(0)
                Dim searchEmail = IntranetPortal.Core.PortalSettings.GetValue("DocSearchEmail")

                If (Not String.IsNullOrEmpty(EntityMananger)) Then
                    Dim LeadInfoSearchUser = Employee.GetInstance(EntityMananger)
                    Dim empl = Employee.GetInstance(leadInfoDocumentSearch.CreateBy)
                    Dim mLead = LeadsInfo.GetInstance(leadInfoDocumentSearch.BBLE)

                    ' notify the doc search user
                    If (LeadInfoSearchUser IsNot Nothing AndAlso mLead IsNot Nothing) Then
                        Core.EmailService.SendMail(Employee.GetEmpsEmails(LeadInfoSearchUser) & ";" & searchEmail, Nothing,
                                               "DocSearchNotify",
                                                New Dictionary(Of String, String) From
                                                {
                                                    {"SubmitUser", empl.Name},
                                                    {"Address", mLead.PropertyAddress},
                                                    {"DocUser", LeadInfoSearchUser.Name},
                                                    {"BBLE", leadInfoDocumentSearch.BBLE},
                                                    {"ExpectedDate", IIf(leadInfoDocumentSearch.ExpectedSigningDate.HasValue, String.Format("{0:d}", leadInfoDocumentSearch.ExpectedSigningDate), "None")}
                                                })
                    End If

                    ' notify the requestor
                    If (LeadInfoSearchUser IsNot Nothing AndAlso mLead IsNot Nothing) Then
                        Core.EmailService.SendMail(empl.Email, Nothing,
                                               "DocSearchNotifyForAgent",
                                                New Dictionary(Of String, String) From
                                                {
                                                    {"UserName", empl.Name},
                                                    {"Address", mLead.PropertyAddress}
                                                })
                    End If
                End If
            Catch ex As Exception
                IntranetPortal.Core.SystemLog.LogError("SendNewSearchNotify", ex, Nothing, leadInfoDocumentSearch.CreateBy, leadInfoDocumentSearch.BBLE)
            End Try
        End Sub

        ' DELETE: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function DeleteLeadInfoDocumentSearch(ByVal id As String) As IHttpActionResult
            Dim leadInfoDocumentSearch As LeadInfoDocumentSearch = db.LeadInfoDocumentSearches.Find(id)
            If IsNothing(leadInfoDocumentSearch) Then
                Return NotFound()
            End If

            db.LeadInfoDocumentSearches.Remove(leadInfoDocumentSearch)
            db.SaveChanges()

            Return Ok(leadInfoDocumentSearch)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function LeadInfoDocumentSearchExists(ByVal id As String) As Boolean
            Return db.LeadInfoDocumentSearches.Count(Function(e) e.BBLE = id) > 0
        End Function

        <Route("api/LeadInfoDocumentSearches/MarkCompleted"), HttpPost>
        Public Function MarkUnderWritingCompleted(<FromBody> data As Object) As IHttpActionResult
            Dim user = HttpContext.Current.User.Identity.Name
            Dim bble As String
            Dim status As Integer
            Dim note As String
            Try
                If Not data Is Nothing Then
                    bble = data("bble").ToString
                    status = CInt(data("status").ToString)
                    note = data("note").ToString

                    If Not String.IsNullOrEmpty(bble) Then
                        Dim search = LeadInfoDocumentSearch.MarkCompletedUnderwriting(bble, user, status, note)
                        If Nothing IsNot search Then
                            Return Ok(search)
                        Else
                            Return BadRequest(String.Format("Doc Search With {0} Cannot Be Found!", bble))
                        End If
                    End If
                Else
                    Return BadRequest()
                End If
            Catch ex As Exception
                Return BadRequest()
            End Try
        End Function


        ''' <summary>
        ''' Deprecated.
        ''' </summary>
        ''' <param name="status"></param>
        ''' <returns></returns>
        <Route("api/LeadInfoDocumentSearches/UnderWritingStatus/{status}"), HttpGet>
        Public Function GetSearchByUnderWritingStatus(status As Integer) As IHttpActionResult

            Try
                Dim underWritingStatus = CType(status, LeadInfoDocumentSearch.UnderWriterStatus)
                Dim searches = LeadInfoDocumentSearch.GetByUnerWritingStatus(underWritingStatus)
                If (searches Is Nothing) Then
                    Throw New Exception("Empty request by searches" & status)
                End If

                Dim data = New With {
                    .data = searches.OrderByDescending(Function(s) s.UpdateDate).Take(10),
                    .count = searches.Count()
                }
                Return Ok(data)
            Catch ex As Exception
                Return BadRequest(ex.Message)
            End Try
        End Function

        <Route("api/LeadInfoDocumentSearches/Status/{status}")>
        Public Function GetSearchByStatus(status As Integer) As IhttpActionResult
            Try
                Dim searchStatus = CType(status, LeadInfoDocumentSearch.SearchStatus)
                Dim searches = LeadInfoDocumentSearch.GetSearchByStatus(searchStatus)
                If (searches Is Nothing) Then
                    Throw New Exception("Empty request by searches" & status)
                End If

                Dim data = New With {
                    .data = searches.OrderByDescending(Function(s) s.UpdateDate).Take(10),
                    .count = searches.Count()
                }
                Return Ok(data)
            Catch ex As Exception
                Return BadRequest(ex.Message)
            End Try
        End Function
    End Class
End Namespace
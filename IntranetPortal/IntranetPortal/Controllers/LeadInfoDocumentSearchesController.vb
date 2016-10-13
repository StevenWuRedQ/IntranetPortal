Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports System.Web.Http.Results
Imports System.Web.Mail
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
            End If
            Return Ok(LeadInfoDocumentSearch.GetDocumentSearchs())
        End Function

        ' GET: api/LeadInfoDocumentSearches/5
        <ResponseType(GetType(LeadInfoDocumentSearch))>
        Function GetLeadInfoDocumentSearch(ByVal id As String) As IHttpActionResult
            Dim leadInfoDocumentSearch As LeadInfoDocumentSearch = db.LeadInfoDocumentSearches.Find(id)
            If IsNothing(leadInfoDocumentSearch) Then
                Throw New Exception("Please make sure you submit a search first!")
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

            'leadInfoDocumentSearch.LeadResearch
            'If (leadInfoDocumentSearch.ResutContent IsNot Nothing) Then
            '    If Not leadInfoDocumentSearch.IsSave Then
            '        Dim l = LeadsInfo.GetInstance(leadInfoDocumentSearch.BBLE)
            '        Dim maildata As New Dictionary(Of String, String)
            '        maildata.Add("Address", l.PropertyAddress)
            '        maildata.Add("UserName", leadInfoDocumentSearch.CreateBy)
            '        maildata.Add("ResutContent", leadInfoDocumentSearch.ResutContent)

            '        If Not String.IsNullOrEmpty(leadInfoDocumentSearch.CreateBy) Then

            '            Core.EmailService.SendMail(Employee.GetEmpsEmails(leadInfoDocumentSearch.CreateBy),
            '                                       Employee.GetEmpsEmails(leadInfoDocumentSearch.UpdateBy, Employee.CEO.Name),
            '                                       "DocSearchCompleted", maildata)
            '        End If
            '    End If
            'End If

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

            search.Status = LeadInfoDocumentSearch.SearchStatus.Completed
            search.CompletedBy = HttpContext.Current.User.Identity.Name
            search.CompletedOn = Date.Now
            search.UpdateBy = HttpContext.Current.User.Identity.Name
            search.UpdateDate = Date.Now
            search.UnderwriteStatus = 0

            Try
                search.Save()
            Catch ex As Exception
                Throw ex
            End Try

            If (Not String.IsNullOrEmpty(search.ResutContent)) Then
                Threading.ThreadPool.QueueUserWorkItem(AddressOf SendCompleteNotify, search)
            Else
                IntranetPortal.Core.SystemLog.LogError("LeadsDocumentSearchContentError", New Exception("The content is null"), search.ToJsonString, search.CompletedBy, search.BBLE)
            End If

            Return Ok(search)
            'PostLeadInfoDocumentSearch(leadInfoDocumentSearch)
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
                maildata.Add("ResutContent", leadInfoDocumentSearch.ResutContent)

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
            Dim findSearch = db.LeadInfoDocumentSearches.Find(leadInfoDocumentSearch.BBLE)

            If (findSearch Is Nothing) Then
                db.LeadInfoDocumentSearches.Add(leadInfoDocumentSearch)
                leadInfoDocumentSearch.SubmitSearch(HttpContext.Current.User.Identity.Name)
                'leadInfoDocumentSearch.CreateDate = Date.Now

                Try
                    db.SaveChanges()
                Catch ex As DbUpdateException
                    Throw
                End Try

                LeadsActivityLog.AddActivityLog(Date.Now(), "Create a search request to doc Search Agent ", leadInfoDocumentSearch.BBLE, LogCategory.SalesAgent.ToString)

                Threading.ThreadPool.QueueUserWorkItem(AddressOf SendNewSearchNotify, leadInfoDocumentSearch)
                'SendNewSearchNotify(leadInfoDocumentSearch)
            End If

            'leadInfoDocumentSearch.UpdateBy = HttpContext.Current.User.Identity.Name
            'leadInfoDocumentSearch.UpdateDate = Date.Now

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
        <HttpPost>
        <Route("api/LeadInfoDocumentSearches/MarkCompleted")>
        Public Function MarkUnderWritingCompleted(<FromBody> data As Object) As IHttpActionResult
            Dim USER = HttpContext.Current.User.Identity.Name
            Dim BBLE As String
            Dim Status As Integer
            Dim Note As String
            Try
                If Not data Is Nothing Then
                    BBLE = data("bble").ToString
                    Status = CInt(data("status").ToString)
                    Note = data("note").ToString

                    If Not String.IsNullOrEmpty(BBLE) Then
                        Dim search = LeadInfoDocumentSearch.MarkCompletedUnderwriting(BBLE, USER, Status, Note)
                        If Nothing IsNot search Then
                            Return Ok(search)
                        Else
                            Return BadRequest(String.Format("Doc Search With {0} Cannot Be Found!", BBLE))
                        End If
                    End If
                Else
                    Return BadRequest()
                End If
            Catch ex As Exception
                Return BadRequest()
            End Try


        End Function
        <HttpGet>
        <Route("api/LeadInfoDocumentSearches/UnderWritingStatus/{status}")>
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

    End Class
End Namespace
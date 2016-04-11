Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class CorporationEntitiesController
        Inherits System.Web.Http.ApiController

        Private db As New PortalEntities

        ' GET: api/CorporationEntities
        Function GetCorporationEntities() As IQueryable(Of CorporationEntity)
            Return db.CorporationEntities.Where(Function(c) c.AppId = Employee.CurrentAppId)
        End Function

        ' GET /api/CorporationEntities/DeedCorpsByTeam?team=GukasyanTeam
        <Route("api/CorporationEntities/DeedCorpsByTeam")>
        Function GetDeedCorpsByTeam(team As String) As IHttpActionResult
            Dim corps = DeedCorp.GetTeamDeedCorps(team)

            If corps Is Nothing OrElse corps.Count = 0 Then
                Return NotFound()
            End If
            Dim rand As New Random
            Return Ok(corps(rand.Next(corps.Count)))
        End Function

        ' POST /api/CorporationEntities/AssignDeedCorp?bble=4025010109 
        <Route("api/CorporationEntities/AssignDeedCorp")>
        Function PostAssignDeedCorp(bble As String, corp As DeedCorp) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If corp.EntityId = 0 Then
                Return BadRequest()
            End If

            Dim corps = DeedCorp.GetDeedCorp(corp.EntityId)

            If corps Is Nothing Then
                Return BadRequest("The deed corp isnot valid")
            End If

            Try
                corps.AssignProperty(bble, HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' GET /api/CorporationEntities/ByBBLE?BBLE=3041250022
        <ResponseType(GetType(CorporationEntity))>
        <Route("api/CorporationEntities/ByBBLE")>
        Function GetCorporationEntityByBBLE(ByVal BBLE As String) As IHttpActionResult
            Dim corporationentity As CorporationEntity = db.CorporationEntities.Where(Function(c) c.BBLE = BBLE).FirstOrDefault
            If IsNothing(corporationentity) Then
                Throw New Exception("Can't find BBLE " & BBLE & "Please make sure you submit a search first")
            End If
            Return Ok(corporationentity)
        End Function

        ' GET /api/CorporationEntities/AvailableCorpBySigner?team=RonTeam&signer=Magda Brillite
        <ResponseType(GetType(CorporationEntity))>
        <Route("api/CorporationEntities/AvailableCorpBySigner")>
        Function GetAvailableCorpBySigner(ByVal team As String, signer As String) As IHttpActionResult

            Dim corp = CorporationEntity.GetAvailableCorpBySigner(team, signer)

            If corp IsNot Nothing Then
                Return Ok(corp)
            End If

            Return NotFound()
        End Function

        ' GET /api/CorporationEntities/AvailableCorp?team=RonTeam&wellsfargo=false
        <ResponseType(GetType(CorporationEntity))>
        <Route("api/CorporationEntities/AvailableCorp")>
        Function GetAvailableCorpToSign(ByVal team As String, wellsfargo As String) As IHttpActionResult
            Dim isWellsfargo = False

            If Boolean.TryParse(wellsfargo, isWellsfargo) Then

            End If

            Dim corp = CorporationEntity.GetAvailableCorp(team, isWellsfargo)

            If corp IsNot Nothing Then
                Return Ok(corp)
            End If

            Return NotFound()
        End Function

        ' GET /api/CorporationEntities/CorpSigners?team=RonTeam
        <ResponseType(GetType(String()))>
        <Route("api/CorporationEntities/CorpSigners")>
        Function GetTeamCorpSigners(ByVal team As String) As IHttpActionResult
            Dim corp = CorporationEntity.GetTeamAvailableCorps(team)

            If corp IsNot Nothing Then
                Return Ok(corp.Select(Function(c) c.Signer).Distinct.ToArray)
            End If

            Return NotFound()
        End Function

        ' GET /api/CorporationEntities/Assign/?id=1
        <Route("api/CorporationEntities/Assign/")>
        Function PostAssignCorp(bble As String, corp As CorporationEntity) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If corp.EntityId = 0 Then
                Return BadRequest()
            End If

            Try
                CorpManage.AssignCorp(bble, corp.EntityId)
            Catch ex As Exception

                Throw


            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' GET /api/CorporationEntities/Teams
        <ResponseType(GetType(String()))>
        <Route("api/CorporationEntities/Teams")>
        Function GetCorpEntryTeams() As IHttpActionResult
            Dim teams = db.CorporationEntities.Where(Function(c) c.Office IsNot Nothing).Select(Function(c) c.Office).Distinct.ToArray

            If teams IsNot Nothing AndAlso teams.Count > 0 Then
                Return Ok(teams)
            End If

            Return NotFound()
        End Function

        ' GET: api/CorporationEntities/5
        <ResponseType(GetType(CorporationEntity))>
        Function GetCorporationEntity(ByVal id As Integer) As IHttpActionResult
            Dim corporationEntity As CorporationEntity = db.CorporationEntities.Find(id)
            If IsNothing(corporationEntity) Then
                Return NotFound()
            End If

            Return Ok(corporationEntity)
        End Function

        ' PUT: api/CorporationEntities/5
        <ResponseType(GetType(Void))>
        Function PutCorporationEntity(ByVal id As Integer, ByVal corporationEntity As CorporationEntity) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = corporationEntity.EntityId Then
                Return BadRequest()
            End If

            db.Entry(corporationEntity).State = EntityState.Modified

            Try
                db.SaveChanges()
            Catch ex As DbUpdateConcurrencyException
                If Not (CorporationEntityExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/CorporationEntities
        <ResponseType(GetType(CorporationEntity))>
        Function PostCorporationEntity(ByVal corporationEntity As CorporationEntity) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If
            corporationEntity.AppId = Employee.CurrentAppId
            db.CorporationEntities.Add(corporationEntity)

            Try
                db.SaveChanges()
            Catch ex As DbUpdateException
                If (CorporationEntityExists(corporationEntity.EntityId)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = corporationEntity.EntityId}, corporationEntity)
        End Function

        ' DELETE: api/CorporationEntities/5
        <ResponseType(GetType(CorporationEntity))>
        Function DeleteCorporationEntity(ByVal id As Integer) As IHttpActionResult
            Dim corporationEntity As CorporationEntity = db.CorporationEntities.Find(id)
            If IsNothing(corporationEntity) Then
                Throw New Exception("Can't find id: " & id & "Please make sure you submit a search first")
            End If

            db.CorporationEntities.Remove(corporationEntity)
            db.SaveChanges()

            Return Ok(corporationEntity)
        End Function

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing) Then
                db.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Function CorporationEntityExists(ByVal id As Integer) As Boolean
            Return db.CorporationEntities.Count(Function(e) e.EntityId = id) > 0
        End Function
    End Class
End Namespace
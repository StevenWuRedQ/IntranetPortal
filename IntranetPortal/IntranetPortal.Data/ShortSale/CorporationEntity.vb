''' <summary>
''' The Model of Corporation Entity
''' </summary>
Public Class CorporationEntity

    Private Shared ReadOnly DocumentLibrary = "CorporationEntity"

    Public Shared Function GetCorpByBBLE(bble As String) As CorporationEntity
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Where(Function(c) c.BBLE = bble).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetEntitiesByStatus(status As String()) As List(Of CorporationEntity)
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Where(Function(s) status.Contains(s.Status)).ToList
        End Using
    End Function

    Public Shared Function GetEntitiesByStatus(name As String, status As String) As List(Of CorporationEntity)
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Where(Function(s) status = s.Status AndAlso s.CorpName.Contains(name)).ToList
        End Using
    End Function

    Public Shared Function GetAllEntities(appId As Integer) As List(Of CorporationEntity)
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Where(Function(c) c.AppId = appId).ToList
        End Using
    End Function

    Public Shared Function GetEntity(entityId As Integer) As CorporationEntity
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Find(entityId)
        End Using
    End Function

    ''' <summary>
    ''' Get team's available corp to sign
    ''' </summary>
    ''' <param name="team">The team name</param>
    ''' <param name="isWellsfargo">Is the wells fargo servicer</param>
    ''' <returns>The available corp</returns>
    Public Shared Function GetAvailableCorp(team As String, isWellsfargo As Boolean) As CorporationEntity

        If isWellsfargo Then
            Throw New NotImplementedException()
        Else
            Dim corps = GetTeamAvailableCorps(team)

            If corps IsNot Nothing AndAlso corps.Count > 0 Then
                Dim rand As New Random
                Return corps(rand.Next(corps.Count))
            End If
        End If

        Return Nothing
    End Function

    ''' <summary>
    ''' Get team's available corp by signer
    ''' </summary>
    ''' <param name="team">The team name</param>
    ''' <param name="signer">Signer</param>
    ''' <returns>The available corp</returns>
    Public Shared Function GetAvailableCorpBySigner(team As String, signer As String) As CorporationEntity

        Dim corps = GetTeamAvailableCorps(team).Where(Function(a) a.Signer = signer).ToList

        If corps IsNot Nothing AndAlso corps.Count > 0 Then
            Dim rand As New Random
            Return corps(rand.Next(corps.Count))
        End If

        Return Nothing
    End Function

    ''' <summary>
    ''' Return Team's Available Corps
    ''' </summary>
    ''' <param name="team">The Team Name</param>
    ''' <returns>List of Corporation Entity</returns>
    Public Shared Function GetTeamAvailableCorps(team As String) As List(Of CorporationEntity)
        Using db As New PortalEntities
            Dim corps = db.CorporationEntities.Where(Function(c) c.Office = team AndAlso c.Status = "Available").ToList
            Return corps
        End Using
    End Function

    ''' <summary>
    ''' Assign Corp to property
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <param name="address">The property address</param>
    ''' <returns>The assigned Corp Object</returns>
    Public Function AssignCorp(bble As String, address As String, assignBy As String) As CorporationEntity

        Using db As New PortalEntities
            If db.CorporationEntities.Any(Function(a) a.BBLE = bble AndAlso a.Status <> "Available") Then
                Throw New Exception("Property was already assigned.")
            End If

            If Status <> "Available" Then
                Throw New Exception("Corp is not available")
            End If

            Try
                Me.BBLE = bble
                Me.PropertyAssigned = address
                Me.Status = "Assigned Out"
                Me.AssignOn = DateTime.Now
                Me.UpdateTime = DateTime.Now
                Me.UpdateBy = assignBy
                db.Entry(Me).State = Entity.EntityState.Modified
                db.Entry(Me).OriginalValues.SetValues(db.Entry(Me).GetDatabaseValues)
                db.SaveChanges(assignBy)
            Catch ex As Exception
                Throw
            End Try
        End Using

        Return Me
    End Function

    Public Shared Function GetAvailableCorpAmount(team As String) As Integer
        Using db As New PortalEntities
            Dim count = db.CorporationEntities.Where(Function(c) c.Office = team AndAlso c.Status = "Available").Count

            Return count
        End Using
    End Function

    ''' <summary>
    ''' The Days count since corp assigned out
    ''' </summary>
    ''' <returns></returns>
    Public ReadOnly Property AssignedOutDays As Integer
        Get
            If Status = "Assigned Out" AndAlso AssignOn.HasValue Then
                Return CInt((AssignOn.Value - DateTime.Now).TotalDays) + 1
            End If

            Return 0
        End Get
    End Property

    Private Sub NotifyEntityManager()

        'IntranetPortal.Core.EmailService.SendMail(String.Join(";", toAdds.ToArray), "", templateName, emailData)
    End Sub

    Public Shared Function UploadFile(entityId As Integer, fileName As String, fileBytes As Byte(), uploadBy As String) As String
        Dim corp = CorporationEntity.GetEntity(entityId)

        Dim fileUrl = String.Format("/{0}/{1}/{2}", DocumentLibrary, corp.CorpName.Trim, fileName)
        Core.DocumentService.CreateFolder(DocumentLibrary, corp.CorpName.Trim)
        Return Core.DocumentService.UploadFile(fileUrl, fileBytes, uploadBy)
    End Function

    Public Shared Function GetEntityByCorpName(CorpName As String) As CorporationEntity
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Where(Function(c) c.CorpName = CorpName).FirstOrDefault
        End Using

    End Function

    Public Sub Save(saveby As String)
        Using context As New PortalEntities

            If Not context.CorporationEntities.Any(Function(c) c.EntityId = EntityId) Then
                CreateTime = DateTime.Now
                CreateBy = saveby
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                If Status = "Available" Then
                    BBLE = Nothing
                    PropertyAssigned = Nothing
                    AssignOn = Nothing
                End If
                UpdateBy = saveby
                UpdateTime = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Modified
                context.Entry(Me).OriginalValues.SetValues(context.Entry(Me).GetDatabaseValues)
            End If

            context.SaveChanges(saveby)
        End Using
    End Sub

    Public Sub Delete()
        Using ctx As New PortalEntities
            Dim obj = ctx.CorporationEntities.Find(EntityId)
            ctx.CorporationEntities.Remove(obj)
            ctx.SaveChanges()
        End Using
    End Sub

    Private Function CorporationEntityExists(ByVal id As Integer) As Boolean
        Using ctx As New PortalEntities
            Return ctx.CorporationEntities.Count(Function(e) e.EntityId = id) > 0
        End Using
    End Function
End Class

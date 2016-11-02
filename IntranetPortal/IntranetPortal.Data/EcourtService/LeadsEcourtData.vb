﻿''' <summary>
''' The leads ecourt object
''' include the last update date
''' </summary>
Public Class LeadsEcourtData

    Private Const UPDATE_LOG_TITLE = "EcourtCasesUpdate"

    ''' <summary>
    ''' Indicate if the data was updated recently
    ''' </summary>
    ''' <returns></returns>
    Public ReadOnly Property IsNewUpdate As Boolean
        Get
            If LastUpdate.HasValue Then
                Return LastUpdate.Value.AddDays(30) > DateTime.Today
            End If

            Return False
        End Get
    End Property

    ''' <summary>
    ''' Indicate if lead has active cases
    ''' </summary>
    ''' <returns></returns>
    Public ReadOnly Property Active As Boolean
        Get
            Return ActiveCases.Count > 0
        End Get
    End Property

    ''' <summary>
    ''' Return the active cases of the property
    ''' </summary>
    ''' <returns></returns>
    Public ReadOnly Property ActiveCases As List(Of EcourtCase)
        Get
            If Cases IsNot Nothing Then
                Return Cases.Where(Function(a) a.CaseStatus = "Active" OrElse a.CaseStatus = "Restored").ToList
            End If

            Return New List(Of EcourtCase)
        End Get
    End Property

    ''' <summary>
    ''' Return the list of active cases number
    ''' </summary>
    ''' <returns></returns>
    Public ReadOnly Property ActiveCaseNumbers As String()
        Get
            Return ActiveCases.Select(Function(a) a.FormattedCaseIndexNumber).ToArray
        End Get
    End Property

    ''' <summary>
    ''' The Ecourt Cases for this property
    ''' </summary>
    ''' <returns></returns>
    Public Property Cases As List(Of EcourtCase)

    ''' <summary>
    ''' Return leads ecourt data object
    ''' </summary>
    ''' <param name="bble"></param>
    ''' <returns></returns>
    Public Shared Function GetData(bble As String) As LeadsEcourtData
        Using ctx As New PortalEntities
            Dim data = ctx.LeadsEcourtDatas.Find(bble)

            If data IsNot Nothing Then
                data.Cases = ctx.EcourtCases.Where(Function(a) a.BBLE = data.BBLE).ToList
            End If

            Return data
        End Using
    End Function

    ''' <summary>
    ''' Update data base on the latest data
    ''' </summary>
    ''' <param name="bble">The given property</param>
    ''' <param name="updateBy"></param>
    Public Shared Sub Update(bble As String, updateBy As String)
        Dim cases = EcourtService.Instance.GetCases(bble)
        Dim hasChange = EcourtCase.Update(bble, cases)
        If hasChange Then
            Dim data = New LeadsEcourtData
            data.BBLE = bble
            data.LastUpdate = DateTime.Now
            data.UpdateBy = updateBy
            data.Save()
        End If
    End Sub

    ''' <summary>
    ''' Update EcourtCase by CountyId and IndexNumber
    ''' </summary>
    ''' <param name="countyId">The CountyId</param>
    ''' <param name="indexNumber">The IndexNumber</param>
    ''' <param name="updateBy"></param>
    Public Shared Sub Update(countyId As Integer, indexNumber As String, updateBy As String)
        Dim cas = EcourtCase.GetCase(countyId, indexNumber)
        If cas IsNot Nothing Then
            Update(cas.BBLE, updateBy)
        End If
    End Sub

    Public Shared Sub SyncNewLeads()
        For Each bbl In GetUnSyncLeads()
            Update(bbl, "System")
        Next
    End Sub

    Public Shared Function GetUnSyncLeads() As String()
        Using ctx As New PortalEntities
            Dim bbles = From ld In ctx.SSLeads
                        From cas In ctx.LeadsEcourtDatas.Where(Function(le) le.BBLE = ld.BBLE).DefaultIfEmpty
                        Where cas Is Nothing
                        Select ld.BBLE

            Return bbles.ToArray
        End Using
    End Function

    ''' <summary>
    ''' Update the ecourt cases on the given date range
    ''' </summary>
    ''' <param name="startDate">The Start Date</param>
    ''' <param name="endDate">The End Date</param>
    ''' <param name="updateBy">User to perform the update</param>
    Public Shared Sub UpdateByChanges(startDate As DateTime, endDate As DateTime, updateBy As String)
        Dim changes = EcourtService.Instance.GetStatusChanges(startDate, endDate)
        If changes IsNot Nothing AndAlso changes.Count > 0 Then
            SaveNewChanges(changes, updateBy)
        End If
    End Sub

    ''' <summary>
    ''' Save changes data to database and update the records
    ''' </summary>
    ''' <param name="changes"></param>
    ''' <param name="updateby"></param>
    Public Shared Sub SaveNewChanges(changes As List(Of EcourtCaseChange), updateby As String)
        Using ctx As New PortalEntities
            Dim result = ctx.EcourtCaseChanges
            ctx.EcourtCaseChanges.RemoveRange(result)
            ctx.EcourtCaseChanges.AddRange(changes)
            ctx.SaveChanges()

            ctx.UpdateEcourtCases(updateby)
        End Using
    End Sub

    ''' <summary>
    ''' Run the daily update on the leads case base on ecourt data changes
    ''' The update will base on the change since last update
    ''' </summary>
    Public Shared Sub DailyUpdate()
        Dim lastUpdateLog = Core.SystemLog.GetLastLogs(UPDATE_LOG_TITLE, DateTime.Now, Nothing)

        Dim dtStart = DateTime.Today
        If lastUpdateLog IsNot Nothing Then
            dtStart = lastUpdateLog.CreateDate
        End If

        UpdateByChanges(dtStart, DateTime.Now, "System")
        Core.SystemLog.Log(UPDATE_LOG_TITLE, "UpdateCompleted", Core.SystemLog.LogCategory.Operation, Nothing, "DailyUpdate")
    End Sub

    Public Shared Sub AddNewCases(dtStart As DateTime, dtEnd As DateTime)
        Dim cases = EcourtService.Instance.GetNewCases(dtStart, dtEnd)

        Using ctx As New PortalEntities
            For Each cas In cases
                If Not ctx.EcourtCases.Any(Function(a) a.BBLE = cas.BBLE AndAlso a.CountyId = cas.CountyId AndAlso a.CaseIndexNumber = cas.CaseIndexNumber) Then
                    ctx.EcourtCases.Add(cas)

                    If ctx.LeadsEcourtDatas.Any(Function(a) a.BBLE = cas.BBLE) Then
                        Dim data = New LeadsEcourtData
                        data.BBLE = cas.BBLE
                        data.LastUpdate = DateTime.Now
                        data.UpdateBy = "Ecourt"
                        ctx.LeadsEcourtDatas.Add(data)
                    End If
                End If
            Next

            ctx.SaveChanges()
        End Using

    End Sub

    ''' <summary>
    ''' Save the data
    ''' </summary>
    Public Sub Save()
        Using ctx As New PortalEntities
            Dim data = ctx.LeadsEcourtDatas.Find(BBLE)
            If data IsNot Nothing Then
                data.LastUpdate = Me.LastUpdate
                data.UpdateBy = Me.UpdateBy
            Else
                ctx.LeadsEcourtDatas.Add(Me)
            End If
            ctx.SaveChanges()
        End Using
    End Sub
End Class

Imports IntranetPortal.Core
Imports Newtonsoft.Json

Partial Public Class CheckingComplain

    Public Const LogTitleRefreshComplain As String = "RefreshPropertyComplaints"

    Public Shared Function GetAllComplains() As List(Of CheckingComplain)
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.ToList
        End Using
    End Function

    Public Shared Function Instance(bble As String) As CheckingComplain
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.Find(bble)
        End Using
    End Function

    Public Shared Function GetResultFromServices(Optional bble As String = "") As DataAPI.SP_DOB_Complaints_By_BBLE_Result()

        Using client As New DataAPI.WCFMacrosClient
            Try
                Return client.Get_DBO_Complaints_List(bble, String.IsNullOrEmpty(bble))
            Catch ex As Exception
                Core.SystemLog.LogError("Error in GetComplainsResult", ex, bble, "portal", bble)
                Core.SystemLog.Log("Error in GetComplainsResult", ex.ToJsonString, SystemLog.LogCategory.Error, bble, "portal")

                Return {}
            End Try
        End Using

    End Function

    Public Shared Function GetComplainsResult(Optional bble As String = "") As DataAPI.SP_DOB_Complaints_By_BBLE_Result()

        Dim result As New List(Of DataAPI.SP_DOB_Complaints_By_BBLE_Result)

        For Each cp In GetAllComplains()

            If Not String.IsNullOrEmpty(cp.LastComplaintsResult) Then
                For Each item In cp.ComplaintsResult
                    If Not result.Any(Function(r) r.BBLE = item.BBLE AndAlso r.ComplaintNumber = item.ComplaintNumber) Then
                        result.Add(item)
                    End If
                Next
            End If
        Next

        Return result.ToArray

        'Using client As New DataAPI.WCFMacrosClient
        '    Try
        '        Return client.Get_DBO_Complaints_List(bble, String.IsNullOrEmpty(bble))
        '    Catch ex As Exception
        '        Core.SystemLog.LogError("Error in GetComplainsResult", ex, bble, "portal", bble)
        '        Core.SystemLog.Log("Error in GetComplainsResult", ex.ToJsonString, SystemLog.LogCategory.Error, bble, "portal")

        '        Return {}
        '    End Try
        'End Using
    End Function

    Public Shared Function GetComplaintsHistory(bble As String) As DataAPI.SP_DOB_Complaints_History_By_BBLE_Result()
        Using client As New DataAPI.WCFMacrosClient
            Return client.Get_DBO_Complaints_History_List(bble)
        End Using
    End Function

    Public Shared Function Remove(bble As String) As CheckingComplain
        Try
            Using client As New DataAPI.WCFMacrosClient

                If client.DOB_Complaints_Delete(bble) Then
                    Using ctx As New ConstructionEntities
                        Dim item = ctx.CheckingComplains.Find(bble)
                        ctx.CheckingComplains.Remove(item)
                        ctx.SaveChanges()

                        Return item
                    End Using
                Else
                    Throw New Exception("Failed to remove from data service")
                End If
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Sub Save(saveBy As String)
        Using ctx As New ConstructionEntities

            If Not ctx.CheckingComplains.Any(Function(c) c.BBLE = BBLE) Then
                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now
                ctx.CheckingComplains.Add(Me)
            Else
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub RefreshComplains(refreshBy As String)
        Me.LastExecute = DateTime.Now
        Me.ExecuteBy = refreshBy

        Try
            If refreshBy = "RuleEngine" Then
                RequestComplaints(refreshBy)
            Else
                System.Threading.ThreadPool.QueueUserWorkItem(AddressOf RequestComplaints, refreshBy)
            End If

            Me.Save(refreshBy)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub UpdateComplaintsResult(Optional jsonResult As String = Nothing)
        Dim result As DataAPI.SP_DOB_Complaints_By_BBLE_Result()

        'If String.IsNullOrEmpty(jsonResult) Then
        '    result = GetResultFromServices(BBLE)
        'Else
        '    result = JsonConvert.DeserializeObject(Of DataAPI.SP_DOB_Complaints_By_BBLE_Result())(jsonResult)
        'End If
        result = GetResultFromServices(BBLE)

        If result IsNot Nothing AndAlso result.Length > 0 Then
            If result.Any(Function(r) r.Status.Trim = "ACT") Then
                If DataIsChange(result) Then
                    NotifyAction(result)
                End If
            End If

            Me.LastDataEntered = result.OrderByDescending(Function(r) r.DateEntered).FirstOrDefault.DateEntered
            Me.ComplaintsResult = result
            Me.LastResultUpdate = DateTime.Now
            Me.Save("")
        End If
    End Sub

    Private Sub RequestComplaints(requestBy As String)
        Try
            Using client As New DataAPI.WCFMacrosClient
                Dim data As New DataAPI.DOB_Complaints_In
                data.BBLE = BBLE
                data.DOB_PenOnly = True
                data.APIorderNum = (New Random()).Next(1000)
                data.SecurityCode = "DS543&8"

                client.DOB_Complaints_Get(data)

                Core.SystemLog.Log(LogTitleRefreshComplain, "RefreshComplaints", Core.SystemLog.LogCategory.Operation, BBLE, requestBy)
            End Using
        Catch ex As Exception
            Core.SystemLog.LogError("DOBComplaintsGet", ex, "", requestBy, BBLE)
        End Try
    End Sub

    Private Function DataIsChange(results As DataAPI.SP_DOB_Complaints_By_BBLE_Result()) As Boolean
        For Each result In results
            If result.Status = "ACT" Then
                Dim lastReulst = ComplaintsResult.Where(Function(r) r.BBLE = result.BBLE AndAlso r.ComplaintNumber = result.ComplaintNumber).FirstOrDefault

                'New complaints
                If lastReulst Is Nothing Then
                    Return True
                End If

                'Changed Complaints
                If result.DateEntered.HasValue AndAlso result.DateEntered > lastReulst.DateEntered Then
                    Return True
                End If
            End If
        Next

        Return False
    End Function

    Private _complaintsResult As DataAPI.SP_DOB_Complaints_By_BBLE_Result()
    Public Property ComplaintsResult As DataAPI.SP_DOB_Complaints_By_BBLE_Result()
        Get
            If _complaintsResult Is Nothing AndAlso Not String.IsNullOrEmpty(Me.LastComplaintsResult) Then
                _complaintsResult = JsonConvert.DeserializeObject(Of DataAPI.SP_DOB_Complaints_By_BBLE_Result())(Me.LastComplaintsResult)
            End If
            Return _complaintsResult
        End Get
        Set(value As DataAPI.SP_DOB_Complaints_By_BBLE_Result())
            _complaintsResult = value
            Me.LastComplaintsResult = value.ToJsonString
        End Set
    End Property

    Public Sub NotifyAction(result As DataAPI.SP_DOB_Complaints_By_BBLE_Result())

        If Not String.IsNullOrEmpty(NotifyUsers) Then

            Dim users = NotifyUsers.Split(";")

            For Each user In users

                Dim party = PartyContact.GetContactByName(user)
                If party IsNot Nothing Then
                    Dim mailData As New Dictionary(Of String, String)
                    mailData.Add("UserName", party.Name)
                    mailData.Add("Address", Address)
                    mailData.Add("BBLE", BBLE)

                    Core.EmailService.SendMail(party.Email, "", "ComplaintsNotify2", mailData)
                End If
            Next
        End If
    End Sub

    Public Enum RunningStatus
        InRefresh
        Ready
    End Enum

End Class

Namespace DataAPI
    Partial Class SP_DOB_Complaints_History_By_BBLE_Result
        Public ReadOnly Property ResultId As String
            Get
                Return Me.ComplaintNumber & Me.LastUpdated.ToString
            End Get
        End Property
    End Class

End Namespace
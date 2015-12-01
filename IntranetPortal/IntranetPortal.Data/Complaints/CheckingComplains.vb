Imports System.Runtime.Serialization
Imports IntranetPortal.Core
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Partial Public Class CheckingComplain

    Public Event OnComplaintsUpdated As ComplaintsUpdated
    Public Delegate Sub ComplaintsUpdated(complaint As CheckingComplain)

    Public Const LogTitleRefreshComplain As String = "RefreshPropertyComplaints"

    Public Shared Function GetAllComplains(Optional bble As String = "", Optional userName As String = "") As List(Of CheckingComplain)
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.Where(Function(c) (c.BBLE = bble Or bble = "") And (c.NotifyUsers.Contains(userName) Or userName = "")).ToList
        End Using
    End Function

    Public Shared Function GetComplaints(address As String) As CheckingComplain
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.Where(Function(c) c.Address.StartsWith(address)).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetLightAllComplains(Optional userName As String = "") As List(Of CheckingComplain)
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.Where(Function(c) c.NotifyUsers.Contains(userName) Or userName = "").Select(Function(c) New With {c.BBLE, c.Address, c.TotalComplaints, c.ActiveComplaints, c.NotifyUsers, c.LastExecute, c.CreateBy, c.Status}).ToList.Select(Function(c) New CheckingComplain With {
                                                    .BBLE = c.BBLE,
                                                    .Address = c.Address,
                                                    .TotalComplaints = c.TotalComplaints,
                                                    .ActiveComplaints = c.ActiveComplaints,
                                                    .NotifyUsers = c.NotifyUsers,
                                                    .LastExecute = c.LastExecute,
                                                    .Status = c.Status,
                                                    .CreateBy = c.CreateBy}).ToList()
        End Using
    End Function

    Public Shared Function Instance(bble As String) As CheckingComplain
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.Find(bble)
        End Using
    End Function


    'Public Shared Function GetResultFromServices2(Optional bble As String = "") As DataAPI.SP_DOB_Complaints_By_BBLE_Result()

    '    Using client As New DataAPI.WCFMacrosClient
    '        Try
    '            Dim result = client.Get_DBO_Complaints_Complete(bble, String.IsNullOrEmpty(bble))

    '            If result.Has_Disposition_History Then
    '                Dim history = result.DOB_Complaint_Disposition_History
    '            End If

    '            Return result.DOB_Complaint
    '        Catch ex As Exception
    '            Core.SystemLog.LogError("Error in GetComplainsResult", ex, bble, "portal", bble)
    '            Core.SystemLog.Log("Error in GetComplainsResult", ex.ToJsonString, SystemLog.LogCategory.Error, bble, "portal")

    '            Return {}
    '        End Try
    '    End Using

    'End Function

    Public Shared Function GetResultFromServices(Optional bble As String = "") As DataAPI.SP_DOB_Complaints_By_BBLE_Result()

        Using client As New DataAPI.WCFMacrosClient()
            Try
                Dim result = client.Get_DBO_Complaints_List(bble, String.IsNullOrEmpty(bble))

                Return result
            Catch ex As Exception
                Core.SystemLog.LogError("Error in GetComplainsResult", ex, bble, "portal", bble)
                Core.SystemLog.Log("Error in GetComplainsResult", ex.ToJsonString, SystemLog.LogCategory.Error, bble, "portal")

                Return {}
            End Try
        End Using

    End Function

    Public Shared Function GetComplainsResultString(Optional bble As String = "") As String()

        Dim result As New List(Of DataAPI.SP_DOB_Complaints_By_BBLE_Result)

        Using ctx As New ConstructionEntities

            Return ctx.CheckingComplains.Select(Function(c) c.LastComplaintsResult).ToArray
        End Using

    End Function

    Public Shared Function GetComplainsResult(Optional bble As String = "", Optional userName As String = "") As DataAPI.SP_DOB_Complaints_By_BBLE_Result()

        Dim result As New List(Of DataAPI.SP_DOB_Complaints_By_BBLE_Result)

        For Each cp In GetAllComplains(bble, userName)

            If Not String.IsNullOrEmpty(cp.LastComplaintsResult) Then
                For Each item In cp.ComplaintsResult
                    If Not result.Any(Function(r) r.BBLE = item.BBLE AndAlso r.ComplaintNumber = item.ComplaintNumber) AndAlso item.Status.ToLower <> "none" Then
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

    Public Sub RefreshComplains(refreshBy As String, Optional serverAddress As String = Nothing)
        Me.LastExecute = DateTime.Now
        Me.ExecuteBy = refreshBy
        Me.Status = RunningStatus.InRefresh
        Try
            If refreshBy = "RuleEngine" Then
                RequestComplaints(refreshBy, serverAddress)
            Else
                System.Threading.ThreadPool.QueueUserWorkItem(AddressOf RequestComplaints, refreshBy)
            End If

            Me.Save(refreshBy)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub UpdateComplaintsResult(Optional jsonResult As String = Nothing)

        Dim res As DataAPI.DOB_Complaints_out = Nothing
        Dim result As DataAPI.SP_DOB_Complaints_By_BBLE_Result() = Nothing

        Try
            res = JsonConvert.DeserializeObject(Of DataAPI.DOB_Complaints_out)(jsonResult)
        Catch ex As Exception
            Core.SystemLog.LogError("Error UpdateComplaintsResult", ex, jsonResult, Nothing, BBLE)
        End Try

        If res IsNot Nothing Then
            Try
                Dim complaintList = res.Complaints_List.ToJsonString
                result = JsonConvert.DeserializeObject(Of DataAPI.SP_DOB_Complaints_By_BBLE_Result())(complaintList)

            Catch ex As Exception
                Core.SystemLog.LogError("Error on Deserialize Complaints List", ex, jsonResult, Nothing, BBLE)
            End Try
        End If

        If result Is Nothing Then
            result = GetResultFromServices(BBLE)
        End If

        If result IsNot Nothing AndAlso result.Length > 0 Then
            Dim dataChanged = False
            If result.Any(Function(r) r.Status.Trim = "ACT") Then
                If DataIsChange(result) Then
                    dataChanged = True
                    Core.SystemLog.Log("ComplaintsHasUpdated", Me.LastComplaintsResult, SystemLog.LogCategory.Operation, BBLE, Nothing)
                    'NotifyAction(result)
                End If
            End If

            Me.LastDataEntered = result.OrderByDescending(Function(r) r.DateEntered).FirstOrDefault.DateEntered
            Me.ComplaintsResult = result
            Me.TotalComplaints = result.Length
            Me.ActiveComplaints = result.Where(Function(a) a.Status = "ACT").Count
            Me.LastResultUpdate = DateTime.Now
            Me.Status = RunningStatus.Ready
            Me.Save("")

            If dataChanged Then
                RaiseEvent OnComplaintsUpdated(Me)
            End If
        End If
    End Sub

    Private Sub RequestComplaints(requestBy As String, Optional serverAddress As String = Nothing)
        Try
            Using client As New DataAPI.WCFMacrosClient()
                If Not String.IsNullOrEmpty(serverAddress) Then
                    client.Endpoint.Address = New ServiceModel.EndpointAddress(serverAddress)
                End If

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

    Public Function DataIsChange(results As DataAPI.SP_DOB_Complaints_By_BBLE_Result()) As Boolean
        For Each result In results
            If result.Status = "ACT" Then
                If ComplaintsResult Is Nothing Then
                    Return True
                End If

                Dim lastResult = ComplaintsResult.Where(Function(r) r.BBLE = result.BBLE AndAlso r.ComplaintNumber = result.ComplaintNumber).FirstOrDefault

                'New complaints
                If lastResult Is Nothing Then
                    Return True
                End If

                'Changed Complaints
                If result.DateEntered.HasValue AndAlso result.DateEntered > lastResult.DateEntered Then
                    Return True
                End If

                If lastResult.LastInspection <> result.LastInspection Then
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

        Dim usersEmails As New List(Of String)

        If Not String.IsNullOrEmpty(NotifyUsers) Then
            For Each user In NotifyUsers.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
                Dim party = PartyContact.GetContactByName(user)
                If party IsNot Nothing Then
                    usersEmails.Add(party.Email)
                End If
            Next
        End If

        If Not String.IsNullOrEmpty(Core.PortalSettings.GetValue("ComplaitntsNotifyEmails")) Then
            usersEmails.AddRange(Core.PortalSettings.GetValue("ComplaitntsNotifyEmails").Split(";"))
        End If

        If usersEmails.Count > 0 Then
            Dim mailData As New Dictionary(Of String, String)
            mailData.Add("UserName", "All")
            mailData.Add("Address", Address)
            mailData.Add("BBLE", BBLE)

            Core.EmailService.SendMail(String.Join(";", usersEmails), "", "ComplaintsNotify2", mailData)
        End If
    End Sub

    Public ReadOnly Property StatusString As String
        Get
            Return CType(Status, RunningStatus).ToString
        End Get
    End Property


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

    Partial Class SP_DOB_Complaints_By_BBLE_Result
        <DataMember>
        Public Property Complaints_Disposition_History As List(Of DataAPI.DOB_Complaints_Disposition_History)
        'Complaints_Disposition_History
    End Class

End Namespace
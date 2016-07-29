Imports IntranetPortal.Data

Public Class CorpManage

    Public Shared Function AssignCorp(bble As String, entityId As Integer, assignBy As String) As CorporationEntity

        Dim corp = CorporationEntity.GetEntity(entityId)
        If corp Is Nothing Then
            Throw New PortalException("Can't find the corp.")
        End If

        Dim li = LeadsInfo.GetInstance(bble)

        If li Is Nothing Then
            Throw New PortalException("Can not find the property. BBLE: " & bble)
        End If

        Dim isReserve = corp.IsReserve

        Try
            corp.AssignCorp(li.BBLE, li.PropertyAddress, assignBy)
        Catch ex As Exception
            Throw New PortalException(ex.Message)
        End Try

        Dim check = Sub(team As String)
                        Try
                            CheckAvailableCorp(team)
                        Catch ex As Exception
                            IntranetPortal.Core.SystemLog.LogError("NotifyAvailableCorpIsLow", ex,
                                                                   team, Nothing, Nothing)
                        End Try

                        Try
                            NotifyCorpIsAssigned(li, corp, team)
                        Catch ex As Exception
                            IntranetPortal.Core.SystemLog.LogError("NotifyCorpIsAssigned", ex,
                                                                   team, Nothing, bble)
                        End Try

                        Try
                            If isReserve Then
                                ReserveCorpIsAssigned(li, corp, team)
                            End If
                        Catch ex As Exception
                            IntranetPortal.Core.SystemLog.LogError("NotifyReserveCorpIsAssigned", ex,
                                                                   team, Nothing, bble)
                        End Try
                    End Sub

        System.Threading.ThreadPool.QueueUserWorkItem(check, corp.Office)

        Return corp
    End Function

    Public Shared Function CheckAvailableCorp(team As String) As Boolean
        Dim count = CorporationEntity.GetAvailableCorpAmount(team)

        If count <= 5 Then
            NotifyCorpIsLow(team, count)
        End If
    End Function

    Public Shared Sub NotifyCorpIsAssigned(li As LeadsInfo, corp As CorporationEntity, team As String)
        Dim templateName = "CorpAssignedNotify"

        Dim users = Roles.GetUsersInRole("Entity-Manager")

        If users Is Nothing OrElse users.Count = 0 Then
            Return
        End If

        Dim emp = Employee.GetInstance(users(0))

        Dim emailData As New Dictionary(Of String, String)
        emailData.Add("CorpName", corp.CorpName)
        emailData.Add("UserName", emp.Name)
        emailData.Add("Team", team)
        emailData.Add("Signer", corp.Signer)
        emailData.Add("PropertyAddress", li.PropertyAddress)

        IntranetPortal.Core.EmailService.SendMail(Employee.GetEmpsEmails(emp), Employee.GetEmpsEmails(users), templateName, emailData)
    End Sub

    Private Shared Sub ReserveCorpIsAssigned(li As LeadsInfo, corp As CorporationEntity, team As String)
        Dim templateName = "ReserveCorpIsAssigned"

        Dim users = Roles.GetUsersInRole("Entity-Manager")

        If users Is Nothing OrElse users.Count = 0 Then
            Return
        End If

        Dim emp = Employee.GetInstance(users(0))

        Dim emailData As New Dictionary(Of String, String)
        emailData.Add("CorpName", corp.CorpName)
        emailData.Add("UserName", emp.Name)
        emailData.Add("Team", team)
        emailData.Add("Signer", corp.Signer)
        emailData.Add("PropertyAddress", li.PropertyAddress)

        IntranetPortal.Core.EmailService.SendMail(Employee.GetEmpsEmails(emp), Employee.GetEmpsEmails(users), templateName, emailData)
    End Sub

    Private Shared Sub NotifyCorpIsLow(team As String, count As Integer)
        Dim templateName = "AvailableCorpsIsLowNotify"

        Dim users = Roles.GetUsersInRole("Entity-Manager")

        If users Is Nothing OrElse users.Count = 0 Then
            Return
        End If

        Dim emp = Employee.GetInstance(users(0))

        Dim emailData As New Dictionary(Of String, String)
        emailData.Add("UserName", emp.Name)
        emailData.Add("Team", team)
        emailData.Add("Count", count)

        IntranetPortal.Core.EmailService.SendMail(Employee.GetEmpsEmails(emp), Employee.GetEmpsEmails(users), templateName, emailData)
    End Sub

End Class

''' <summary>
''' Provider manage methods about User follow up instance
''' </summary>
Public Class UserFollowUpManage

    Public Shared Function AddFollowUp(bble As String, userName As String, type As LeadsActivityLog.LogCategory, followUpdate As DateTime) As Data.UserFollowUp
        Dim followup = Data.UserFollowUp.Instance(bble, userName, type)
        Dim modelSetting = SystemModelSettings.LoadModelSetting(type)
        If modelSetting Is Nothing Then
            Throw New Exception("Can not find followup type.")
        End If
        followup.CaseName = modelSetting.CaseName(bble)
        followup.URL = String.Format(modelSetting.ViewLinkTemplate, bble)
        followup.FollowUpDate = followUpdate
        followup.Create(userName)

        Return followup
    End Function

    ''' <summary>
    ''' Return a list of specific employee's missed follow up by the end time
    ''' </summary>
    ''' <param name="userName">employee Name</param>
    ''' <param name="dtEnd">End Date</param>
    ''' <returns></returns>
    Public Shared Function GetMissedFollowUp(userName As String, dtEnd As DateTime) As List(Of Data.UserFollowUp)
        Dim fps = Data.UserFollowUp.GetMyFollowUps(userName).Where(Function(f) f.FollowUpDate < dtEnd).ToList
        Return fps
    End Function

    Public Shared Function ClearFollowUp(followUpId As Integer, clearBy As String) As Data.UserFollowUp
        Dim followup = Data.UserFollowUp.Instance(followUpId)
        If followup IsNot Nothing Then
            followup.Clear(clearBy)
            Return followup
        Else
            Throw New Exception("Follow Up is not found.")
        End If
    End Function

    Public Shared Function ClearFollowUp(bble As String, userName As String, type As LeadsActivityLog.LogCategory, clearBy As String) As Data.UserFollowUp
        Dim followup = Data.UserFollowUp.Instance(bble, userName, type)
        followup.Clear(clearBy)
        Return followup
    End Function

End Class

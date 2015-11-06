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


End Class

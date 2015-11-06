

Public Class SystemModelSettings

    Private Shared Property Settings As List(Of ModelSetting)

    Private Shared Sub InitSettings()
        Settings = New List(Of ModelSetting)
        Settings.Add(New ModelSetting(LeadsActivityLog.LogCategory.Title, "/BusinessForm/Default.aspx?tag={0}", Function(bble As String)
                                                                                                                    Return TitleManage.GetTitleCaseName(bble)
                                                                                                                End Function))
        Settings.Add(New ModelSetting(LeadsActivityLog.LogCategory.Construction, "/Construction/ConstructionUI.aspx?bble={0}", Function(bble As String)
                                                                                                                                   Return ConstructionManage.GetCaseName(bble)
                                                                                                                               End Function))
    End Sub

    Public Shared Function LoadModelSetting(logcategory As LeadsActivityLog.LogCategory) As ModelSetting
        If Settings Is Nothing Then
            InitSettings()
        End If

        Return Settings.Where(Function(s) s.LogCategory = logcategory).FirstOrDefault
    End Function

    Public Class ModelSetting

        Public Sub New(category As LeadsActivityLog.LogCategory, viewLink As String, caseNameFun As CaseNameFunction)
            LogCategory = category
            ViewLinkTemplate = viewLink
            CaseName = caseNameFun
        End Sub

        Public Property LogCategory As LeadsActivityLog.LogCategory
        Public Property ViewLinkTemplate As String

        Public Property CaseName As CaseNameFunction

        Public Delegate Function CaseNameFunction(bble As String) As String

    End Class

End Class

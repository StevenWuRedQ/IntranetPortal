
''' <summary>
''' Represents the settings for business models: ShortSale, Title, Construction, Legal etc.
''' </summary>
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

    ''' <summary>
    ''' Return business model settings by category
    ''' </summary>
    ''' <param name="logcategory">The Log category</param>
    ''' <returns></returns>
    Public Shared Function LoadModelSetting(logcategory As LeadsActivityLog.LogCategory) As ModelSetting
        If Settings Is Nothing Then
            InitSettings()
        End If

        Return Settings.Where(Function(s) s.LogCategory = logcategory).FirstOrDefault
    End Function

    ''' <summary>
    ''' Represents the business model setting class
    ''' </summary>
    Public Class ModelSetting

        ''' <summary>
        ''' the business model setting instance
        ''' </summary>
        ''' <param name="category">Log category for business type</param>
        ''' <param name="viewLink">View link template</param>
        ''' <param name="caseNameFun">The function used to get case name</param>
        Public Sub New(category As LeadsActivityLog.LogCategory, viewLink As String, caseNameFun As CaseNameFunction)
            LogCategory = category
            ViewLinkTemplate = viewLink
            CaseName = caseNameFun
        End Sub

        ''' <summary>
        ''' The business model log category
        ''' </summary>
        ''' <returns></returns>
        Public Property LogCategory As LeadsActivityLog.LogCategory

        ''' <summary>
        ''' The view link for business model
        ''' </summary>
        ''' <returns></returns>
        Public Property ViewLinkTemplate As String

        ''' <summary>
        ''' The function to return business model function name
        ''' </summary>
        ''' <returns></returns>
        Public Property CaseName As CaseNameFunction

        Public Delegate Function CaseNameFunction(bble As String) As String

    End Class

End Class

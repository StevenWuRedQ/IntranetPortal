Public Class PortalSettings
    Private Shared _settings As Dictionary(Of String, String)
    Private Shared ReadOnly Property Settings As Dictionary(Of String, String)
        Get
            If _settings Is Nothing Then
                InitSettings()
            End If

            Return _settings
        End Get
    End Property

    Public Shared Function GetValue(name As String) As String
        If Settings.ContainsKey(name) Then
            Return Settings(name)
        End If

        Return Nothing
    End Function

    Public Shared Function SettingData() As List(Of PortalSetting)
        Using ctx As New Core.CoreEntities
            Return ctx.PortalSettings.ToList
        End Using
    End Function

    Public Shared Sub SaveValues(settingId As Integer, value As String)
        Using ctx As New Core.CoreEntities
            Dim ps = ctx.PortalSettings.Find(settingId)
            If ps IsNot Nothing Then
                ps.Value = value
                ctx.SaveChanges()
            End If

            InitSettings()
        End Using
    End Sub

    Private Shared Sub InitSettings()
        Using ctx As New Core.CoreEntities
            _settings = ctx.PortalSettings.ToDictionary(Of String, String)(Function(s) s.Name, Function(s) s.Value)
        End Using
    End Sub
End Class
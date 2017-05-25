Imports System.Configuration

Public Class RulesEngineSection
    Inherits ConfigurationSection

    Private Shared _settings As RulesEngineSection = CType(ConfigurationManager.GetSection("ruleEngine"), RulesEngineSection)

    Public Shared ReadOnly Property Settings As RulesEngineSection
        Get
            Return _settings
        End Get
    End Property

    <ConfigurationProperty("rulesProvider")>
    Public Property RulesProvider() As ProviderElement
        Get
            Return CType(Me("rulesProvider"), ProviderElement)
        End Get
        Set(ByVal value As ProviderElement)
            Me("rulesProvider") = value
        End Set
    End Property

End Class

Public Class ProviderElement
    Inherits ConfigurationElement

    <ConfigurationProperty("name", IsRequired:=True)>
    Public Property Name() As String
        Get
            Return CType(Me("name"), String)
        End Get
        Set(ByVal value As String)
            Me("name") = value
        End Set
    End Property

    <ConfigurationProperty("type", IsRequired:=False)>
    Public Property Type() As String
        Get
            Return CType(Me("type"), String)
        End Get
        Set(ByVal value As String)
            Me("type") = value
        End Set
    End Property
End Class

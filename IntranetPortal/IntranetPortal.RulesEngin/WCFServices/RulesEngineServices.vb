' NOTE: You can use the "Rename" command on the context menu to change the class name "RulesEngineServices" in both code and config file together.
Public Class RulesEngineServices
    Implements IRulesEngineServices

    Public Function GetRules() As BaseRule() Implements IRulesEngineServices.GetRules
        Dim services = RulesService.GetInstance
        Return services.Rules.ToArray
    End Function

    Public Sub ExecuteRule(ruleName As String) Implements IRulesEngineServices.ExecuteRule
        Dim services = RulesService.GetInstance
        services.ExecuteRule(ruleName)
    End Sub

    Public Sub StartRule(ruleName As String) Implements IRulesEngineServices.StartRule
        Dim services = RulesService.GetInstance
        services.StartRule(ruleName)
    End Sub

    Public Sub StopRule(ruleName As String) Implements IRulesEngineServices.StopRule
        Dim services = RulesService.GetInstance
        services.StopRule(ruleName)
    End Sub

    Public Function GetRulesString() As String Implements IRulesEngineServices.GetRulesString
        Return GetRules().ToJsonString()
    End Function

    Public Function GetRule(ruleName As String) As BaseRule Implements IRulesEngineServices.GetRule
        Return GetRules().FirstOrDefault(Function(r) r.RuleName = ruleName)
    End Function
End Class

' NOTE: You can use the "Rename" command on the context menu to change the class name "RulesEngineServices" in both code and config file together.
Public Class RulesEngineServices
    Implements IRulesEngineServices

    Public Function GetRules() As Rule() Implements IRulesEngineServices.GetRules
        Dim services = RulesService.GetInstance
        Return services.Rules.Select(Function(a) a.RuleData).ToArray
    End Function

    Public Sub ExecuteRule(ruleId As String) Implements IRulesEngineServices.ExecuteRule
        Dim services = RulesService.GetInstance
        services.ExecuteRule(ruleId)
    End Sub

    Public Sub StartRule(ruleId As String) Implements IRulesEngineServices.StartRule
        Dim services = RulesService.GetInstance
        services.StartRule(ruleId)
    End Sub

    Public Sub StopRule(ruleId As String) Implements IRulesEngineServices.StopRule
        Dim services = RulesService.GetInstance
        services.StopRule(ruleId)
    End Sub

    Public Function GetRulesString() As String Implements IRulesEngineServices.GetRulesString
        Return GetRules().ToJsonString()
    End Function

    Public Function GetRule(ruleId As String) As Rule Implements IRulesEngineServices.GetRule
        Return GetRules().FirstOrDefault(Function(r) r.RuleId.ToString = ruleId)
    End Function

    Public Function GetRuleById(ruleId As String) As Rule Implements IRulesEngineServices.GetRuleById
        Return GetRules().FirstOrDefault(Function(r) r.RuleId.ToString = ruleId)
    End Function
End Class

Imports System.ServiceModel

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IRulesEngineServices" in both code and config file together.
<ServiceContract()>
Public Interface IRulesEngineServices

    <OperationContract()>
    Function GetRules() As BaseRule()

    <OperationContract()>
    Function GetRulesString() As String

    <OperationContract()>
    Sub ExecuteRule(ruleName As String)

    <OperationContract()>
    Sub StartRule(ruleName As String)

    <OperationContract()>
    Sub StopRule(ruleName As String)

End Interface

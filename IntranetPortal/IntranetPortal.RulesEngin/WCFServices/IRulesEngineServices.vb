Imports System.ServiceModel
Imports System.Runtime.Serialization

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IRulesEngineServices" in both code and config file together.

<ServiceContract()>
<ServiceKnownType(GetType(LegalFollowUpRule))>
<ServiceKnownType(GetType(LeadsAndTaskRule))>
<ServiceKnownType(GetType(EmailSummaryRule))>
<ServiceKnownType(GetType(AgentActivitySummaryRule))>
<ServiceKnownType(GetType(ShortSaleActivityReportRule))>
<ServiceKnownType(GetType(LoopServiceRule))>
<ServiceKnownType(GetType(CompleteTaskRule))>
<ServiceKnownType(GetType(ExpiredAllReminderRule))>
<ServiceKnownType(GetType(RecycleProcessRule))>
<ServiceKnownType(GetType(PendingAssignRule))>
<ServiceKnownType(GetType(AssignLeadsRule))>
<ServiceKnownType(GetType(DOBComplaintsCheckingRule))>
<ServiceKnownType(GetType(ScanECourtsRule))>
<ServiceKnownType(GetType(ConstructionNotifyRule))>
<ServiceKnownType(GetType(AutoAssignRule))>
<ServiceKnownType(GetType(NewOfferNotifyRule))>
<ServiceKnownType(GetType(EcourtCasesUpdateRule))>
Public Interface IRulesEngineServices

    <OperationContract()>
    <ServiceKnownType(GetType(ScanECourtsRule))>
    Function GetRules() As Rule()

    <OperationContract()>
    <ServiceKnownType(GetType(ScanECourtsRule))>
    Function GetRule(ruleName As String) As Rule

    <OperationContract()>
    <ServiceKnownType(GetType(ScanECourtsRule))>
    Function GetRuleById(ruleId As String) As Rule

    <OperationContract()>
    Function GetRulesString() As String

    <OperationContract()>
    Sub ExecuteRule(ruleId As String)

    <OperationContract()>
    Sub StartRule(ruleId As String)

    <OperationContract()>
    Sub StopRule(ruleid As String)

End Interface

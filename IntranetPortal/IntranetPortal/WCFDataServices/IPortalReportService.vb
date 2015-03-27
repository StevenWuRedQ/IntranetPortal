Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports IntranetPortal.CallTrackingService

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IPortalReportService" in both code and config file together.
<ServiceContract()>
Public Interface IPortalReportService
    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="UserReports")>
    Function EmployeeReports() As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="CallLog/{empName}")>
    Function EmployeeCallLog(empName As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadTeamLeadsReport/{teamName}")>
    Function LoadTeamLeadsReport(teamName As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadTeamInProcessReport/{teamName}")>
    Function LoadTeamInProcessReport(teamName As String) As List(Of LeadsStatusData)

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAgentInProcessReport/{agentName}")>
    Function LoadAgentInProcessReport(agentName As String) As List(Of LeadsStatusData)

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadTeamInfo/{teamName}")>
    Function LoadTeamInfo(teamName As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAgentActivity/{teamName}/{startDate}/{endDate}")>
    Function LoadAgentActivityReport(teamName As String, startDate As String, endDate As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAgentSummaryReport/{agentName}/{startDate}/{endDate}")>
    Function LoadAgentSummaryReport(agentName As String, startDate As String, endDate As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAgentLeadsReport/{agentName}")>
    Function LoadAgentLeadsReport(agentName As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAgentLeadsData/{agentName}/{status}")>
    Function LoadAgentLeadsData(agentName As String, status As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadTeamLeadsData/{teamName}/{status}")>
    Function LoadTeamLeadsData(teamName As String, status As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadAgentActivityLeads/{agentName}/{action}/{startDate}/{endDate}")>
    Function LoadAgentActivityLeads(agentName As String, action As String, startDate As String, endDate As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LoadTeamActivityLeads/{teamName}/{action}/{startDate}/{endDate}")>
    Function LoadTeamActivityLeads(teamName As String, action As String, startDate As String, endDate As String) As Channels.Message


End Interface

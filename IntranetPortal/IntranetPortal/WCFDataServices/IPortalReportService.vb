﻿Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports IntranetPortal.CallTrackingService

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IPortalReportService" in both code and config file together.
<ServiceContract()>
Public Interface IPortalReportService
    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="UserReports")>
    Function EmployeeReports() As List(Of EmployeeStatisticData)

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="CallLog/{empName}")>
    Function EmployeeCallLog(empName As String) As Channels.Message

    <OperationContract()>
    <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LeadsStatusReport/{teamName}")>
    Function LoadLeadsStatusReport(teamName As String) As List(Of LeadsStatusData)

    <OperationContract()>
   <WebInvoke(Method:="GET", ResponseFormat:=WebMessageFormat.Json, UriTemplate:="LeadsInProcessReport/{teamName}")>
    Function LoadLeadsInProcessReport(teamName As String) As List(Of LeadsStatusData)

End Interface

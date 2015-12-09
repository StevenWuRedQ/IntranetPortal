Imports System.ServiceModel

' NOTE: You can use the "Rename" command on the context menu to change the interface name "ICommonService" in both code and config file together.
<ServiceContract()>
Public Interface ICommonService

    <OperationContract()>
    Sub SendMessage(userName As String, title As String, msg As String, bble As String, notifyTime As DateTime, createBy As String)

    <OperationContract()>
    Sub SendEmailByTemplate(userName As String, templateName As String, emailData As Dictionary(Of String, String))

    <OperationContract()>
    Sub SendEmail(userName As String, subject As String, body As String)

    <OperationContract()>
    Sub SendEmailByControl(toAddresses As String, subject As String, constrolName As String, params As Dictionary(Of String, String))

    <OperationContract()>
    Sub SendTaskSummaryEmail(userName As String)

    <OperationContract()>
    Sub UpdateLeadsSearchStatus(leadsSearchId As Integer, status As Integer)

    <OperationContract>
    Sub SendTeamActivityEmail(teamName As String)

    <OperationContract>
    Sub SendShortSaleActivityEmail()

    <OperationContract>
    Sub SendLegalActivityEmail()

    <OperationContract>
    Sub LegalFollowUp()

    <OperationContract>
    Sub SendShortSaleUserSummayEmail()

    <OperationContract>
    Sub SendUserActivitySummayEmail(type As String, startDate As DateTime, endDate As DateTime)

    <OperationContract()>
    Sub SendEmailByAddress(toAddress As String, ccAddress As String, subject As String, body As String)

End Interface

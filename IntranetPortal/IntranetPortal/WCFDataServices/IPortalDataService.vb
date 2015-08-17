Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports IntranetPortal.Data

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IPortalDataService" in both code and config file together.
<ServiceContract()>
Public Interface IPortalDataService

    <OperationContract()>
    Function CompleteDataLoad(bble As String, apiOrderNo As Integer, infoType As String, status As String, updateTime As DateTime, C1stMotgrAmt As Double, C2ndMotgrAmt As Double, TaxesAmt As Double, WaterAmt As Double, ECBViolationsAmt As Double, DOBViolationsAmt As Double, zEstimate As Integer, salesInfo As DataAPI.Acris_Last_Sales_Info) As Boolean

    <OperationContract()>
    Function CompleteServicer(bble As String, billLine1 As String, billLine2 As String, billLine3 As String, billLine4 As String) As Boolean

    <OperationContract>
    Sub TriggerIsReady(data As TriggerData)

    <OperationContract>
    Sub DataIsReady(apiOrderNum As Integer, type As String, result As String)

End Interface

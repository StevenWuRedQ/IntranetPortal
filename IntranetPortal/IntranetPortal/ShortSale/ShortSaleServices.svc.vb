﻿Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services
Imports IntranetPortal.ShortSale

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class ShortSaleServices

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml"
#Region "ShortSale Case"
    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetCase(caseId As Integer) As Channels.Message
        Dim ssCase = ShortSaleCase.GetCase(caseId)
        'Dim json As New JavaScriptSerializer
        'Return json.Serialize(ssCase)
        Dim emp = Employee.GetInstance(ssCase.ReferralContact.Name)
        If emp IsNot Nothing AndAlso Not emp.Position = "Manager" Then
            ssCase.ReferralManager = Employee.GetInstance(ssCase.ReferralContact.Name).Manager
        Else
            ssCase.ReferralManager = ssCase.ReferralContact.Name
        End If

        Core.SystemLog.Log(ShortSaleManage.OpenCaseLogTitle, Nothing, Core.SystemLog.LogCategory.Operation, ssCase.BBLE, HttpContext.Current.User.Identity.Name)

        Return ssCase.ToJson
    End Function

    <OperationContract()>
    <WebInvoke(Method:="POST", RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json)>
    Public Sub SaveCase(ssCase As ShortSaleCase)
        ssCase.SaveChanges()
    End Sub

#End Region

#Region "Page Data Service"

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetLeadsInfo(bble As String) As Channels.Message
        Return LeadsInfo.GetData(bble).ToJson
    End Function

    <OperationContract()>
   <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function ReferralManagerContact(agent As String) As Channels.Message

        Dim emp = Employee.GetInstance(agent)
        If Not emp.Position = "Manager" Then
            Return (New With {
                .Manager = Employee.GetInstance(emp.Manager).GetData,
                .Assistant = ""
            }).ToJson
        Else
            Return (New With {
                .Manager = emp.GetData,
                .Assistant = ""
                }).ToJson
        End If
    End Function

#End Region

#Region "Data Report"

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function CategoryList() As String()
        'Throw New Exception("test")
        Return ShortSale.PropertyMortgage.StatusCategory
    End Function

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function LoadCaseData(category As String, status As String) As Channels.Message
        Dim cases As List(Of ShortSale.ShortSaleCase)

        If (category = "All") Then
            cases = ShortSale.ShortSaleCase.GetCaseByCategory(status)
        Else
            cases = ShortSale.ShortSaleCase.GetCaseByMortgageStatus({status})
        End If

        Return cases.Select(Function(ss) New With {ss.CaseName, ss.BBLE, ss.Owner, ss.UpdateDate, ss.CaseId, ss.OwnerFullName, ss.ReferralContact.Name, ss.OccupiedBy}).ToList.ToJson
    End Function

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetCategoryCount(category As String) As Channels.Message

        Dim cases = ShortSale.ShortSaleCase.GetCaseByCategory(category)

        If category = "All" Then
            Return cases.GroupBy(Function(ss) ss.MortgageCategory).Select(Function(ss)
                                                                              Return New With {
                                                                                  .Category = ss.Key,
                                                                                  .Count = ss.Count
                                                                                  }
                                                                          End Function).ToList.ToJson
        Else
            Return cases.GroupBy(Function(ss) ss.MortgageStatus).Select(Function(ss)
                                                                            Return New With {
                                                                                .Category = ss.Key,
                                                                                .Count = ss.Count
                                                                                }
                                                                        End Function).ToList.ToJson

        End If
    End Function

#End Region


End Class

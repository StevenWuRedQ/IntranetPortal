Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class ShortSaleServices

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml"


    ' Add more operations here and mark them with <OperationContract()>
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
End Class

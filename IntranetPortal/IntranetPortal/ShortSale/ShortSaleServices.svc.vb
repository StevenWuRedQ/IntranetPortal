Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services
Imports IntranetPortal.Data
Imports ShortSale = IntranetPortal.Data
Imports Newtonsoft.Json

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

        ssCase.DocumentRequestDetails = ShortSaleManage.GetDocumentRequestDetail(ssCase.BBLE)

        Core.SystemLog.Log(ShortSaleManage.OpenCaseLogTitle, Nothing, Core.SystemLog.LogCategory.Operation, ssCase.BBLE, HttpContext.Current.User.Identity.Name)

        Return ssCase.ToJson
    End Function

    <OperationContract()>
   <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetCaseByBBLE(bble As String) As Channels.Message
        Return ShortSale.ShortSaleCase.GetCaseByBBLE(bble).ToJson
    End Function

    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function MoveToConstruction(bble As String) As Boolean

        Try
            ShortSaleManage.StartConstruction(bble, HttpContext.Current.User.Identity.Name)
            Return True
        Catch ex As Exception
            Throw
        End Try
    End Function

    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function SaveCase(caseData As String) As Channels.Message
        Dim ssCase = ShortSaleManage.SaveCase(caseData, HttpContext.Current.User.Identity.Name)
        ssCase.DocumentRequestDetails = ShortSaleManage.GetDocumentRequestDetail(ssCase.BBLE)
        Return ssCase.ToJson
    End Function

#End Region

#Region "Load Home Breakdown"

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function LoadHomeBreakData(bble As String) As Channels.Message
        Dim propertyBaseInfo = Data.PropertyBaseInfo.GetInstance(bble)
        If propertyBaseInfo IsNot Nothing Then
            Dim homebreak = propertyBaseInfo.PropFloors
            If homebreak IsNot Nothing Then
                Return homebreak.ToJson()
            End If
            Return Nothing
        End If
        Return Nothing
    End Function


    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function SaveBreakData(jsonData As String, bble As String) As Channels.Message
        Dim propInfo = PropertyBaseInfo.GetInstance(bble)
        propInfo.PropFloors = JsonConvert.DeserializeObject(Of PropertyFloor())(jsonData)
        propInfo.Save()
        Return propInfo.PropFloors.ToJson
    End Function

#End Region




#Region "Page Data Service"

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetLeadsInfo(bble As String) As Channels.Message
        Return LeadsInfo.GetData(bble).ToJson
    End Function

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetBankList() As Channels.Message
        'the id of "Lender" is 5
        Dim gp = GroupType.GetGroup(5)

        If gp IsNot Nothing Then
            Return gp.Contacts.Where(Function(a) Not String.IsNullOrEmpty(a.CorpName)).ToList.ToJson
        End If

        Return Nothing
    End Function

    <OperationContract()>
   <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetTeamInfo(teamName As String) As Channels.Message
        Return Team.GetTeam(teamName).ToJson
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

    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function AddComments(comment As String, caseId As Integer) As Channels.Message
        Dim comm As New ShortSaleCaseComment
        comm.Comments = comment
        'Dim name =
        comm.CreateBy = HttpContext.Current.User.Identity.Name  'OperationContext.Current.ServiceSecurityContext.PrimaryIdentity.Name
        comm.CreateDate = DateTime.Now
        comm.CaseId = caseId
        comm.Save()
        Dim json = comm.ToJson
        Return json
    End Function

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function DeleteComment(commentId As Integer) As Channels.Message
        ShortSaleCaseComment.DeleteComment(commentId)
        Return Nothing
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

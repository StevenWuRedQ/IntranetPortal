Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports System.Web.Script.Services
Imports IntranetPortal.Core
Imports Newtonsoft.Json

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class Documents


    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function getFolderItems(bble As String, folderPath As String) As String
        Dim info = DocumentService.GetCateByBBLEAndFolder(bble, folderPath)
        Return JsonConvert.SerializeObject(info)
    End Function


End Class

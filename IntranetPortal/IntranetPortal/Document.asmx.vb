Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.Web.Script.Services
Imports IntranetPortal.Core
Imports Newtonsoft.Json

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
<ScriptService> _
Public Class Document
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

    <WebMethod> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getFolderItems(bble As String, folderPath As String) As String
        Dim info = DocumentService.GetCateByBBLEAndFolder(bble, folderPath)
        Return JsonConvert.SerializeObject(info)
    End Function
End Class
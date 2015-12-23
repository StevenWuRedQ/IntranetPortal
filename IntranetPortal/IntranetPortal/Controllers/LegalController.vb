Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class LegalController
        Inherits ApiController

        <ResponseType(GetType(Core.SystemLog()))>
        <Route("api/Legal/SaveHistories/{bble}")>
        Function GetSaveHistories(ByVal bble As String) As IHttpActionResult

            Dim logs = Core.SystemLog.GetLightLogsByBBLE(LegalCase.TitleSaveLog, bble)
            Return Ok(logs)
        End Function

        <Route("api/Legal/HistoryCaseData/{logId}")>
        Function GetSavedHistory(ByVal logId As Integer) As IHttpActionResult
            Dim log = Core.SystemLog.GetLog(logId)
            If log IsNot Nothing AndAlso Not String.IsNullOrEmpty(log.Description) Then
                Dim caseData = Newtonsoft.Json.JsonConvert.DeserializeObject(Of LegalCase)(log.Description)
                Return Ok(caseData.CaseData)
            End If

            Return Ok("{}")
        End Function

    End Class
End Namespace
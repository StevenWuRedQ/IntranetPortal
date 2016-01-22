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

        <ResponseType(GetType(Data.DataStatu()))>
        <Route("api/Legal/ForeclosureStatus")>
        Function GetForeclosureStatus() As IHttpActionResult
            Dim status = Data.DataStatu.LoadAllDataStatus(LegalCase.ForeclosureStatusCategory)
            Return Ok(status.ToArray)
        End Function

        <ResponseType(GetType(Data.DataStatu()))>
        <Route("api/Legal/ForeclosureStatus/Save")>
        Function PostForeclosureStatus(status As DataStatu()) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim i = 1
            For Each item In status.OrderBy(Function(s) s.DisplayOrder).ToList
                If item.Active Then
                    item.DisplayOrder = i
                    i = i + 1

                    If String.IsNullOrEmpty(item.Category) Then
                        item.Category = LegalCase.ForeclosureStatusCategory
                    End If
                Else
                    item.DisplayOrder = Nothing
                End If

                item.Save()
            Next

            Return Ok(status)
        End Function

    End Class
End Namespace
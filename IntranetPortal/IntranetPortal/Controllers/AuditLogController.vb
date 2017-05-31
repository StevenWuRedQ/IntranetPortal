Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class AuditLogController
        Inherits ApiController

        <Route("api/AuditLog/{objectName}/{recordId}")>
        Function GetAuditLogs(objectName As String, recordId As String) As IEnumerable(Of AuditLog)
            Return AuditLog.GetLogs(objectName, recordId)
        End Function

        <Route("api/AuditLog/{objectName}/{recordId}/{propName}")>
        Function GetAuditLogsProp(objectName As String, recordId As String, propName As String) As IEnumerable(Of AuditLog)
            Return AuditLog.GetLogs(objectName, recordId).Where(Function(p) p.ColumnName = propName)
        End Function

        <Route("api/underwriting/AuditLog/{objectName}/{recordId}")>
        Function GetUnderwritingServiceAuditLogs(objectName As String, recordId As String) As IEnumerable(Of AuditLog)
            Return UnderwritingService.GetUnderwritingServiceLogs(objectName, recordId)
        End Function

        <Route("api/underwriting/AuditLog/{objectName}/{recordId}/{propName}")>
        Function GetUnderwritingServiceAuditLogsProp(objectName As String, recordId As String, propName As String) As IEnumerable(Of AuditLog)
            Return UnderwritingService.GetUnderwritingServiceLogs(objectName, recordId).Where(Function(p) p.ColumnName = propName)
        End Function

    End Class
End Namespace
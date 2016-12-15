Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class AuditLogController
        Inherits ApiController

        <Route("api/AuditLog/{objectName}/{recordId}")>
        Function GetAuditLogs(objectName As String, recordId As String) As IQueryable(Of AuditLog)
            Return AuditLog.GetLogs(objectName, recordId).AsQueryable
        End Function

        <Route("api/AuditLog/{objectName}/{recordId}/{propName}")>
        Function GetAuditLogsProp(objectName As String, recordId As String, propName As String) As IQueryable(Of AuditLog)
            Return AuditLog.GetLogs(objectName, recordId).Where(Function(p) p.ColumnName = propName).AsQueryable
        End Function

    End Class
End Namespace
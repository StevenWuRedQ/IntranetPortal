Imports Newtonsoft.Json
Imports System.Data.Entity.Infrastructure

''' <summary>
''' The Audit log model
''' </summary>
Partial Class AuditLog
    ''' <summary>
    ''' The database entity entry that related to this log
    ''' </summary>
    ''' <returns></returns>
    <JsonIgnore>
    Public Property Entity As DbEntityEntry

    ''' <summary>
    ''' Return all the audit Logs for specific record
    ''' </summary>
    ''' <param name="objName">The object Name</param>
    ''' <param name="recordId">The object record Id or key values</param>
    ''' <returns>The list of audi logs</returns>
    Public Shared Function GetLogs(objName As String, recordId As String) As IEnumerable(Of AuditLog)
        Using ctx As New PortalEntities

            Return ctx.AuditLogs.Where(Function(l) l.TableName = objName AndAlso l.RecordId = recordId).ToList

        End Using
    End Function


    Public Enum LogType
        Added = 0
        Modified = 1
        Deleted = 2
    End Enum

End Class

''' <summary>
''' The Audit Object Configuration Cache
''' </summary>
Class AuditConfigSetting

    Public Shared Property IgnoreColumns As String() = {"CreateBy", "CreateDate", "UpdateBy", "UpdateTime", "UpdateDate"}
    Public Shared Property AuditInfo As Dictionary(Of Type, AuditConfig)
End Class

''' <summary>
''' The Audit Object settings,
''' include the object properties, object table name and keynames.
''' </summary>
Class AuditConfig
    Public Property Properties As List(Of String)
    Public Property TableName As String
    Public Property KeyNames As List(Of String)

End Class
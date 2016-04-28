Imports Newtonsoft.Json
Imports System.Data.Entity.Infrastructure
Imports System.Reflection
Imports Newtonsoft.Json.Linq

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

    Public ReadOnly Property FormatOriginalValue As Object
        Get
            Return FormatValue(Me.OriginalValue)
        End Get
    End Property

    Public ReadOnly Property FormatNewValue As Object
        Get
            Return FormatValue(Me.NewValue)
        End Get
    End Property

    Private Function FormatValue(value As String) As Object
        Dim tp = Type.GetType("IntranetPortal.Data." & Me.TableName)
        Dim prop As PropertyInfo = tp.GetProperty(Me.ColumnName)

        If prop.GetCustomAttribute(GetType(JsonConverterAttribute)) IsNot Nothing Then
            Dim jsconvert = CType(prop.GetCustomAttribute(GetType(JsonConverterAttribute)), JsonConverterAttribute)
            Select Case jsconvert.ConverterType
                Case GetType(Core.JsArrayToStringConverter)
                    Dim data = JArray.Parse(value)
                    Dim result As New List(Of String)
                    For Each content In data.Children(Of JObject)
                        For Each propValue In content.Properties()
                            result.Add(propValue.Value.ToString())
                        Next
                    Next

                    Return String.Join(";", result.ToArray)

                Case GetType(Core.JsObjectToStringConverter)

                Case Else
                    Return value
            End Select
        End If

        Return CTypeDynamic(Me.OriginalValue, prop.PropertyType)
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
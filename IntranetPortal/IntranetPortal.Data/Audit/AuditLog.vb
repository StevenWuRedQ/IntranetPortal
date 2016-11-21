Imports Newtonsoft.Json
Imports System.Data.Entity.Infrastructure
Imports System.Reflection
Imports Newtonsoft.Json.Linq
Imports System.ComponentModel.DataAnnotations
Imports System.ComponentModel.DataAnnotations.Schema

''' <summary>
''' The Audit log model
''' </summary>
<MetadataType(GetType(AuditLogMetaData))>
Partial Class AuditLog
    ''' <summary>
    ''' The database entity entry that related to this log
    ''' </summary>
    ''' <returns></returns>
    <JsonIgnore>
    <NotMapped>
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
    <NotMapped>
    Public ReadOnly Property FormatOriginalValue As Object
        Get
            Return FormatValue(Me.OriginalValue)
        End Get
    End Property
    <NotMapped>
    Public ReadOnly Property FormatNewValue As Object
        Get
            Return FormatValue(Me.NewValue)
        End Get
    End Property

    Public Property CustomType As String

    Public Sub Delete()

        Using ctx As New PortalEntities
            ctx.Entry(Me).State = System.Data.Entity.EntityState.Deleted
            ctx.SaveChanges()
        End Using
    End Sub

    Private Function FormatValue(value As String) As Object
        If String.IsNullOrEmpty(value) Then
            Return value
        End If

        Dim prop = GetProperty(Me.TableName, Me.ColumnName)

        If prop IsNot Nothing AndAlso prop.GetCustomAttribute(GetType(JsonConverterAttribute)) IsNot Nothing Then
            Return FormatJSONTypeValue(prop, value)
        End If

        Return FormatSimpleTypeValue(prop, value)
    End Function

    Private Function FormatSimpleTypeValue(prop As PropertyInfo, value As String) As String
        If prop Is Nothing Then
            Return value
        End If

        Dim data = CTypeDynamic(value, prop.PropertyType)
        Select Case prop.PropertyType
            Case GetType(System.Decimal), GetType(System.Decimal?)
                Return String.Format("{0:c}", data)
            Case GetType(DateTime), GetType(System.DateTime?)
                Return String.Format("{0:d}", data)
            Case Else
                Return data
        End Select
    End Function

    Private Function FormatJSONTypeValue(prop As PropertyInfo, value As String) As Object
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
                Me.CustomType = "js"
                Return value
            Case GetType(Core.JsObjectToFileConverter)
                Me.CustomType = "file"
                Return JObject.Parse(value)
            Case Else
                Return value
        End Select

        Return value
    End Function

    Public Enum LogType
        Added = 0
        Modified = 1
        Deleted = 2
    End Enum

    Private Shared _objectProperties As New Dictionary(Of String, PropertyInfo)

    Private Function GetProperty(objName As String, propName As String) As PropertyInfo
        Dim key = String.Format("{0}-{1}", objName, propName)

        If Not _objectProperties.ContainsKey(key) Then

            Dim tp = Type.GetType("IntranetPortal.Data." & objName)

            If tp Is Nothing Then
                _objectProperties.Add(key, Nothing)
            Else
                Dim prop As PropertyInfo = tp.GetProperty(propName)

                Dim tpAttrs = tp.GetCustomAttribute(GetType(MetadataTypeAttribute), True)
                If tpAttrs IsNot Nothing Then
                    Dim metaType = CType(tpAttrs, MetadataTypeAttribute).MetadataClassType
                    If metaType.GetProperty(propName) IsNot Nothing Then
                        prop = metaType.GetProperty(propName)
                    End If
                End If

                _objectProperties.Add(key, prop)
            End If
        End If

        Return _objectProperties(key)
    End Function
End Class

Friend Class AuditLogMetaData
    <Key>
    Public Property AuditId As Integer
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
    Public Property Properties As Dictionary(Of String, Type)
    Public Property TableName As String
    Public Property KeyNames As List(Of String)

End Class
Imports System.ComponentModel.DataAnnotations
Imports System.ComponentModel.DataAnnotations.Schema
Imports System.Data.Entity
Imports System.Data.Entity.Core.Objects
Imports System.Data.Entity.Infrastructure

Partial Public Class PortalEntities

    Public Overrides Function SaveChanges() As Integer
        Return MyBase.SaveChanges()
    End Function

    ''' <summary>
    ''' The save changing Audit function, 
    ''' audit all the data changes
    ''' </summary>
    ''' <param name="userName">The UserName who perform the action</param>
    ''' <returns>The count of record effected</returns>
    Public Overloads Function SaveChanges(userName As String) As Integer
        Dim logs As New List(Of AuditLog)
        Dim modifiedEntities = From en In ChangeTracker.Entries
                               Where en.State = Entity.EntityState.Added Or en.State = Entity.EntityState.Deleted Or en.State = Entity.EntityState.Modified

        For Each ent In modifiedEntities
            logs.AddRange(GetAuditRecordsForChange(ent, userName))
        Next

        Dim result = MyBase.SaveChanges

        For Each log In logs
            If Not log.Entity.State = EntityState.Detached Then
                Dim key = CType(Me, IObjectContextAdapter).ObjectContext.ObjectStateManager.GetObjectStateEntry(log.Entity.Entity).EntityKey.EntityKeyValues
                log.RecordId = key(0).Value
            End If

            Me.AuditLogs.Add(log)
        Next

        MyBase.SaveChanges()
        Return result
    End Function

    Private Function GetAuditRecordsForChange(dbEntry As DbEntityEntry, userName As String) As List(Of AuditLog)
        Dim logs As New List(Of AuditLog)
        Dim eventTime = DateTime.Now
        Dim entityConfig = GetAuditConfig(dbEntry)

        Dim log = New AuditLog With {
                     .UserName = userName,
                     .EventDate = eventTime,
                     .TableName = entityConfig.TableName,
                     .Entity = dbEntry
                    }

        For Each prop In entityConfig.Properties
            log.ColumnName = prop.Key

            If dbEntry.State = EntityState.Deleted Then
                If Not dbEntry.OriginalValues.PropertyNames.Contains(prop.Key) Then
                    Continue For
                End If

                If dbEntry.OriginalValues.GetValue(Of Object)(prop.Key) Is Nothing Then
                    Continue For
                End If

                logs.Add(New AuditLog With {
                     .UserName = userName,
                     .EventDate = eventTime,
                     .EventType = AuditLog.LogType.Deleted,
                     .ColumnName = prop.Key,
                     .TableName = entityConfig.TableName,
                     .OriginalValue = dbEntry.OriginalValues.GetValue(Of Object)(prop.Key),
                     .Entity = dbEntry,
                     .RecordId = dbEntry.OriginalValues.GetValue(Of Object)(entityConfig.KeyNames(0))
                          })
                Continue For
            End If

            If Not dbEntry.CurrentValues.PropertyNames.Contains(prop.Key) Then
                Continue For
            End If

            Dim propValue = dbEntry.CurrentValues.GetValue(Of Object)(prop.Key)

            If dbEntry.State = EntityState.Added Then

                If propValue Is Nothing Then
                    Continue For
                End If

                logs.Add(AddLog(AuditLog.LogType.Added, log))
            End If

            If dbEntry.State = EntityState.Modified Then
                Dim originalValue = dbEntry.OriginalValues.GetValue(Of Object)(prop.Key)

                If Object.Equals(originalValue, propValue) Then
                    Continue For
                End If

                If originalValue IsNot Nothing AndAlso propValue IsNot Nothing AndAlso originalValue.ToString.Trim = propValue.ToString.Trim Then
                    Continue For
                End If
                logs.Add(AddLog(AuditLog.LogType.Modified, log))
            End If
        Next

        Return logs
    End Function
    Private Function AddLog(logType As AuditLog.LogType, dbEntry As DbEntityEntry, userName As String, eventTime As DateTime, tableName As String, propName As String) As AuditLog

        Return New AuditLog With {
            .UserName = userName,
                    .EventDate = eventTime,
                    .EventType = logType,
                    .ColumnName = propName,
                    .TableName = tableName,
                    .OriginalValue = GetVaule("OriginalValues", propName, dbEntry),
                    .NewValue = GetVaule("CurrentValues", propName, dbEntry),
                    .Entity = dbEntry
            }
    End Function
    Private Function AddLog(logType As AuditLog.LogType, log As AuditLog) As AuditLog
        Return AddLog(logType, log.Entity, log.UserName, log.EventDate, log.TableName, log.ColumnName)
    End Function

    Private Function GetVaule(values As String, propName As String, dbEntry As DbEntityEntry) As Object
        Return GetVaule(GetVauleByModel(dbEntry, values), propName)
    End Function

    ''' <summary>
    '''Becuase entry can not use OriginalValues in added state
    ''' </summary>
    ''' <param name="dbEntry"></param>
    ''' <param name="value"></param>
    ''' <returns></returns>
    Private Function GetVauleByModel(dbEntry As DbEntityEntry, value As String) As DbPropertyValues
        Dim map = New Dictionary(Of String, DbPropertyValues)()
        map.Add("OriginalValues", Nothing)
        map.Add("CurrentValues", Nothing)
        If (dbEntry.State <> EntityState.Added) Then

            map("OriginalValues") = dbEntry.OriginalValues
        End If
        If (dbEntry.State <> EntityState.Deleted) Then
            map("CurrentValues") = dbEntry.CurrentValues
        End If
        Return map(value)
    End Function

    Private Function GetVaule(dbValues As DbPropertyValues, propName As String) As Object
        Return If(dbValues Is Nothing, Nothing, dbValues.GetValue(Of Object)(propName))
    End Function

    Private Function GetAuditConfig(dbEntry As DbEntityEntry) As AuditConfig
        If AuditConfigSetting.AuditInfo Is Nothing Then
            AuditConfigSetting.AuditInfo = New Dictionary(Of Type, AuditConfig)
        End If
        Dim entityType = dbEntry.Entity.GetType
        If Not AuditConfigSetting.AuditInfo.ContainsKey(entityType) Then
            Dim config As New AuditConfig
            Dim tableAttr = CType(dbEntry.Entity.GetType().GetCustomAttributes(GetType(TableAttribute), True).SingleOrDefault(), TableAttribute)
            Dim tableName = If(tableAttr IsNot Nothing, tableAttr.Name, dbEntry.Entity.GetType().Name)

            Dim setBase = CType(Me, IObjectContextAdapter).ObjectContext.ObjectStateManager.GetObjectStateEntry(dbEntry.Entity).EntitySet
            Dim keyNames = setBase.ElementType.KeyMembers.Select(Function(k) k.Name).ToList
            config.TableName = tableName
            config.KeyNames = keyNames

            Dim propInfo As New Dictionary(Of String, Type)

            Dim fields = entityType.GetProperties().Select(Function(p) New With {p.Name, p.PropertyType}).ToList

            For Each prop In fields
                If AuditConfigSetting.IgnoreColumns.Contains(prop.Name) Then
                    Continue For
                End If

                If keyNames.Contains(prop.Name) Then
                    Continue For
                End If

                propInfo.Add(prop.Name, prop.PropertyType)
            Next
            config.Properties = propInfo

            AuditConfigSetting.AuditInfo.Add(entityType, config)
        End If

        Return AuditConfigSetting.AuditInfo(entityType)
    End Function
End Class

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
    ''' The save changing Audit function
    ''' </summary>
    ''' <param name="userName">The UserName who perform the action</param>
    ''' <returns></returns>
    Public Overloads Function SaveChanges(userName As String) As Integer
        Dim logs As New List(Of AuditLog)
        Dim modifiedEntities = From en In ChangeTracker.Entries
                               Where en.State = Entity.EntityState.Added Or en.State = Entity.EntityState.Deleted Or en.State = Entity.EntityState.Modified
        Dim entities = CType(Me, IObjectContextAdapter).ObjectContext.ObjectStateManager.GetObjectStateEntries(EntityState.Added Or EntityState.Modified)
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

        Dim tableAttr = CType(dbEntry.Entity.GetType().GetCustomAttributes(GetType(TableAttribute), True).SingleOrDefault(), TableAttribute)
        Dim tableName = If(tableAttr IsNot Nothing, tableAttr.Name, dbEntry.Entity.GetType().Name)

        Dim setBase = CType(Me, IObjectContextAdapter).ObjectContext.ObjectStateManager.GetObjectStateEntry(dbEntry.Entity).EntitySet
        Dim keyNames = setBase.ElementType.KeyMembers.Select(Function(k) k.Name).ToList

        For Each propName In FieldsToLog(dbEntry.Entity.GetType)
            'Dim keyValues = String.Join(";", keyNames.Select(Function(a)
            '                                                     Return dbEntry.CurrentValues.GetValue(Of Object)(a).ToString
            '                                                 End Function).ToArray)
            If keyNames.Contains(propName) Then
                Continue For
            End If

            If Not dbEntry.OriginalValues.PropertyNames.Contains(propName) Then
                Continue For
            End If

            If dbEntry.State = EntityState.Deleted Then
                If dbEntry.OriginalValues.GetValue(Of Object)(propName) Is Nothing Then
                    Continue For
                End If

                logs.Add(New AuditLog With {
                     .UserName = userName,
                     .EventDate = eventTime,
                     .EventType = 2,
                     .ColumnName = propName,
                     .TableName = tableName,
                     .OriginalValue = dbEntry.OriginalValues.GetValue(Of Object)(propName),
                     .Entity = dbEntry,
                     .RecordId = dbEntry.OriginalValues.GetValue(Of Object)(keyNames(0))
                          })
                Continue For
            End If

            If Not dbEntry.CurrentValues.PropertyNames.Contains(propName) Then
                Continue For
            End If

            Dim propValue = dbEntry.CurrentValues.GetValue(Of Object)(propName)
            If propValue Is Nothing Then
                Continue For
            End If

            If dbEntry.State = EntityState.Added Then
                logs.Add(New AuditLog With {
                    .UserName = userName,
                    .EventDate = eventTime,
                    .EventType = 0,
                    .ColumnName = propName,
                    .TableName = tableName,
                    .NewValue = propValue,
                    .Entity = dbEntry
                         })
            End If

            If dbEntry.State = EntityState.Modified Then
                'dbEntry.OriginalValues.SetValues(dbEntry.GetDatabaseValues())
                Dim originalValue = dbEntry.OriginalValues.GetValue(Of Object)(propName)

                If Object.Equals(originalValue, propValue) Then
                    Continue For
                End If

                If originalValue.ToString.Trim = propValue.ToString.Trim Then
                    Continue For
                End If

                logs.Add(New AuditLog With {
                    .UserName = userName,
                    .EventDate = eventTime,
                    .EventType = 1,
                    .ColumnName = propName,
                    .TableName = tableName,
                    .OriginalValue = dbEntry.OriginalValues.GetValue(Of Object)(propName),
                    .NewValue = propValue,
                    .Entity = dbEntry
                         })
            End If
        Next

        Return logs
    End Function

    Private Function FieldsToLog(entityType As Type) As IEnumerable(Of String)
        If AuditConfigSetting.AuditInfo Is Nothing Then
            AuditConfigSetting.AuditInfo = New Dictionary(Of Type, List(Of String))
        End If

        If Not AuditConfigSetting.AuditInfo.ContainsKey(entityType) Then
            Dim propInfo As New List(Of String)
            Dim fields = entityType.GetProperties().Select(Function(p) p.Name).ToList

            For Each propName In fields
                If AuditConfigSetting.IgnoreColumns.Contains(propName) Then
                    Continue For
                End If

                propInfo.Add(propName)
            Next

            AuditConfigSetting.AuditInfo.Add(entityType, propInfo)
        End If

        Return AuditConfigSetting.AuditInfo(entityType)
    End Function

End Class

Partial Class AuditLog
    Public Property Entity As DbEntityEntry

End Class

Class AuditConfigSetting

    Public Shared Property IgnoreColumns As String() = {"CreateBy", "CreateDate", "UpdateBy", "UpdateTime", "UpdateDate"}
    Public Shared Property AuditInfo As Dictionary(Of Type, List(Of String))

End Class
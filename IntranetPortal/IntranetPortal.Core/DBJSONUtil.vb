﻿Imports System.Data.SqlClient

Public Class DBJSONUtil

    Private Shared ReadOnly ConStr As String = Configuration.ConfigurationManager.ConnectionStrings("CoreEntities").ConnectionString

    Public Shared Function GetPrimayKey(tableName As String) As String()

        Using ctx As New CoreEntities
            Dim result = From p In ctx.GetPrimaryKeys("TitleCase")
                         Select p.primary_keys
            If result IsNot Nothing Then
                Return result.ToArray
            Else
                Return {}
            End If
        End Using
    End Function

    Public Function GetJsonCulumn(TableName As String, JsonColumn As String, PrimaryKeysValue As String(), ObjectString As String)

        Using conn = New SqlConnection(ConStr)


        End Using

    End Function

    Public Shared Function AddObject() As Boolean
        Using coon As New SqlConnection(ConStr)


        End Using
        Return True
    End Function


End Class
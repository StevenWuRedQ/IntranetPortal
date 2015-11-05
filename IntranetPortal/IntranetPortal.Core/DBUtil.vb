Imports System.Data.SqlClient

Public Class DBUtil

    Private Shared CoonString As String = "data source=207.97.206.29,4436;initial catalog=IntranetPortal;User ID=Chris;Password=P@ssw0rd1"

    Public Shared Function GetPrimayKey(tableName As String) As String()
        Using Adapter As New SqlDataAdapter("SELECT TOP 1 * FROM " & tableName, CoonString)
            Using table As DataTable = New DataTable(tableName)
                Return Adapter.FillSchema(table, SchemaType.Mapped).PrimaryKey.Select(Function(c) c.ColumnName).ToArray
            End Using
        End Using
    End Function

    Public Shared Function AddProperty(Table As String, JsonColumn As String, key As String) As Boolean


        Return True
    End Function


End Class

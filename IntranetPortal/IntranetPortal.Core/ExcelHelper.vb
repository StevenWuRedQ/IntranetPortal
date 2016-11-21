Imports System.Data.OleDb
Imports System.IO

Public Class ExcelHelper
    Shared Function LoadDataFromExcel(fileName As String) As DataSet

        Dim fullName = Path.GetFullPath(fileName)
        Dim data As New DataSet
        Dim connStr = String.Format("provider=Microsoft.ACE.OLEDB.12.0;" & "data source={0};Extended Properties=Excel 12.0;", fullName)

        Using cn As New System.Data.OleDb.OleDbConnection(connStr)
            Dim cmd As System.Data.OleDb.OleDbDataAdapter
            For Each table In GetExcelSheetName(connStr)
                Dim dt As New DataTable
                cn.Open()
                cmd = New System.Data.OleDb.OleDbDataAdapter(String.Format("select * from [{0}]", table), cn)
                dt.TableName = table.Replace("'", "").Replace("$", "")
                cmd.Fill(dt)
                data.Tables.Add(dt)
                cn.Close()
            Next
        End Using

        Return data
    End Function

    Shared Function GetExcelSheetName(connStr As String) As String()
        'Dim cn As System.Data.OleDb.OleDbConnection
        Using cn = New System.Data.OleDb.OleDbConnection(connStr)
            ' Select the data from Sheet1 of the workbook.
            cn.Open()

            Dim dt = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, Nothing)

            If dt Is Nothing Then
                Return Nothing
            End If

            Dim tables As New List(Of String)
            For Each row In dt.Rows
                tables.Add(row("TABLE_NAME").ToString)
            Next

            Return tables.ToArray
        End Using
    End Function

End Class

Imports ActiveDatabaseSoftware.ActiveQueryBuilder
Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxGridView

Public Class QueryBuilder
    Inherits System.Web.UI.Page

    Private connStr As String = New Entities().Database.Connection.ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub QueryBuilderControl1_Init(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim queryBuilder = QueryBuilderControl1.QueryBuilder
        Dim syntaxProvider As New MSSQLSyntaxProvider()
        queryBuilder.SyntaxProvider = syntaxProvider

        Dim sqlConn As New SqlConnection()
        sqlConn.ConnectionString = connStr

        queryBuilder.MetadataProvider = New MSSQLMetadataProvider() With {
            .Connection = sqlConn
            }

        Try
            queryBuilder.MetadataStructure.Refresh()
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub ASPxButton1_Click(sender As Object, e As EventArgs)
        'gridResult.DataSource = dt
        'gridResult.DataBind()
        ''ASPxGridView1.DataSource = dt
        gridResult2.DataBind()
    End Sub

    Public Sub BindGrid()
        Dim sql = QueryBuilderControl1.QueryBuilder.SQL   ' SQLEditor1.SQL
        If String.IsNullOrEmpty(sql) Then
            Return
        End If

        Dim sqlConn As New SqlConnection(connStr)
        Dim sqlCmd As New SqlCommand(sql, sqlConn)
        Dim dataAdaper As New SqlDataAdapter(sqlCmd)
        Dim dt As New DataTable
        dataAdaper.Fill(dt)


        gridResult2.Columns.Clear()
        For Each col As DataColumn In dt.Columns
            gridResult2.Columns.Add(New GridViewDataColumn(col.ColumnName))
        Next

        gridResult2.DataSource = dt
        gridResult2.DataBind()
    End Sub

    Protected Sub gridResult2_DataBinding(sender As Object, e As EventArgs)
        If gridResult2.DataSource Is Nothing Then
            BindGrid()
        End If
    End Sub

    Protected Sub btnExport_Click(sender As Object, e As EventArgs)
        gridExport.WriteXlsToResponse()
    End Sub
End Class
Imports System.Data.SqlClient
Imports Newtonsoft.Json.Linq
Imports Reeb.SqlOM
Imports Reeb.SqlOM.Render

Public Class QueryBuilder

    Public Function LoadReportData(json As String, baseTable As String) As DataTable
        Dim query = JToken.Parse(json)
        Return LoadReportData(query, baseTable)
    End Function

    Public Function LoadReportData(query As JToken, baseTable As String) As DataTable
        Dim sql = BuildSelectQuery(query, baseTable)
        Return ExecuteQuery(sql)
    End Function

    Public Function ExecuteQuery(sql As String) As DataTable
        Using ctx As New CoreEntities
            Dim conn = CType(ctx.Database.Connection, SqlConnection)

            If conn IsNot Nothing AndAlso conn.State = ConnectionState.Closed Then
                conn.Open()
            End If

            Dim dt As New DataTable

            Using ad As New SqlDataAdapter(sql, conn)
                ad.Fill(dt)
            End Using

            Return dt
        End Using
    End Function

    Public Function GenerateReportTemplate(tables As String) As String
        Return GenerateReportTemplate(JArray.Parse(tables)).ToString
    End Function

    Public Function GenerateReportTemplate(tables As JArray) As JToken
        Dim template As New JArray

        For Each tbl In tables
            template.Add(GenerateReportTemplate(tbl("name"), tbl("ignoreFields").Select(Function(s) s.ToString).ToArray))
        Next

        Return template
    End Function

    Public Function GenerateReportTemplate(tableName As String, ignoreFields As String()) As JToken
        Dim sql = "select * from " & tableName
        Dim dt = ExecuteQuery(sql)

        Dim js As New JObject
        js("category") = tableName

        If dt IsNot Nothing Then
            Dim fields = New JArray

            For Each col As DataColumn In dt.Columns
                If ignoreFields.Contains(col.ColumnName) Then
                    Continue For
                End If

                Dim field As New JObject
                field("name") = col.ColumnName
                field("table") = tableName
                field("column") = col.ColumnName
                field("type") = GetJsDataType(col.DataType.FullName)
                fields.Add(field)
            Next

            js("fields") = fields
        End If
        Return js
    End Function

    Public Function BuildSelectQuery() As String

        Dim emp As FromTerm = FromTerm.Table("Employee")

        Dim query As New SelectQuery
        query.Columns.Add(New SelectColumn("Name", emp))
        query.Columns.Add(New SelectColumn("Id", emp))

        query.FromClause.BaseTable = emp

        query.WherePhrase.Terms.Add(WhereTerm.CreateCompare(SqlExpression.Field("Name"), SqlExpression.String("Test"), CompareOperator.Equal))

        query.OrderByTerms.Add(New OrderByTerm("Id", OrderByDirection.Ascending))
        Return query.ToJsonString
    End Function

    Public Function BuildSelectQuery(json As String, baseTable As String) As String
        Dim jsQuery = JToken.Parse(json)
        Return BuildSelectQuery(jsQuery, baseTable)
    End Function

    Public Function BuildSelectQuery(jsQuery As JToken, baseTable As String) As String

        If jsQuery Is Nothing Then
            Throw New Exception("Unknow Query String")
        End If

        Dim selectQuery As New SelectQuery
        Dim baseTbl As FromTerm = FromTerm.Table(baseTable)
        selectQuery.FromClause.BaseTable = baseTbl

        'parse table
        Dim tables = jsQuery.Select(Function(s) s.SelectToken("table").ToString).Distinct.ToList
        For Each tbl In tables
            Dim term As FromTerm = FromTerm.Table(tbl)

            'add tables
            If tbl <> baseTable Then
                selectQuery.FromClause.Join(JoinType.Left, baseTbl, term, "BBLE", "BBLE")
            End If

            'add columns
            For Each field In jsQuery.Where(Function(s) s.SelectToken("table").ToString = tbl).ToList
                Dim col = field.SelectToken("column").ToString
                Dim name = field.SelectToken("name").ToString
                Dim hide = field.SelectToken("hide")
                If hide IsNot Nothing AndAlso CBool(hide) Then

                Else
                    selectQuery.Columns.Add(New SelectColumn(col, term, name))
                End If

                Dim type = field.SelectToken("type").ToString

                'add filters
                Dim filters As JArray = field.SelectToken("filters")
                If filters IsNot Nothing Then
                    For Each flt In filters
                        If Not String.IsNullOrEmpty(flt("WhereTerm")) Then
                            selectQuery.WherePhrase.Terms.Add(BuildWhereTerm(term, col, type, flt))
                            'selectQuery.WherePhrase.Terms.Add(WhereTerm.CreateCompare(SqlExpression.Field(col, term), SqlExpression.String(flt("value")), CompareOperator.Like))
                        End If

                    Next
                End If

            Next
        Next

        Return New SqlServerRenderer().RenderSelect(selectQuery)
    End Function

    Private Function BuildWhereTerm(term As FromTerm, col As String, type As String, filter As JToken) As WhereTerm
        Select Case filter("WhereTerm")
            Case "CreateCompare"
                Return WhereTerm.CreateCompare(SqlExpression.Field(col, term), BuildSqlExpression(type, filter("value1")), GetCompareOperator(filter("CompareOperator")))
            Case "CreateBetween"
                Return WhereTerm.CreateBetween(SqlExpression.Field(col, term), BuildSqlExpression(type, filter("value1")), BuildSqlExpression(type, filter("value2")))
            Case "CreateIn"
                Return WhereTerm.CreateIn(SqlExpression.Field(col, term), SqlConstantCollection.FromList(filter("value1").Select(Function(s) s).ToList))
        End Select

        Return WhereTerm.CreateCompare(SqlExpression.Field(col, term), BuildSqlExpression(type, filter("value")), CompareOperator.Like)
    End Function

    Private Function BuildSqlExpression(type As String, value As String) As SqlExpression
        Select Case type
            Case "string", "System.String"
                Return SqlExpression.String(value)
            Case "number", "System.Int32"
                Return SqlExpression.Number(CDbl(value))
            Case "date", "System.DateTime"
                Return SqlExpression.Date(CDate(value))
            Case "boolean", "System.Boolean"
                Return SqlExpression.Raw(value)
            Case Else
                Return SqlExpression.String(value)
        End Select
    End Function

    Private Shared DataTypeMapInfo As New Dictionary(Of String, String)

    Private Function GetJsDataType(dtType As String) As String
        If DataTypeMapInfo.Count = 0 Then
            DataTypeMapInfo.Add("System.String", "string")
            DataTypeMapInfo.Add("System.Int32", "number")
            DataTypeMapInfo.Add("System.DateTime", "date")
            DataTypeMapInfo.Add("System.Boolean", "boolean")
            DataTypeMapInfo.Add("System.Decimal", "number")
        End If

        If DataTypeMapInfo.ContainsKey(dtType) Then
            Return DataTypeMapInfo(dtType)
        End If

        Return dtType
    End Function

    Private Function GetCompareOperator(oper As String) As CompareOperator
        Dim result = CompareOperator.Like
        If [Enum].TryParse(Of CompareOperator)(oper, result) Then
            Return result
        End If

        Return result
    End Function

End Class

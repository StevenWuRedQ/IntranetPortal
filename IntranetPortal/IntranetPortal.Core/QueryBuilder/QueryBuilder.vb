Imports Newtonsoft.Json.Linq
Imports Reeb.SqlOM
Imports Reeb.SqlOM.Render

Public Class QueryBuilder

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

    Public Function BuilderSelectQuery(json As String, baseTable As String) As String

        Dim jsQuery = JToken.Parse(json)

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
                selectQuery.Columns.Add(New SelectColumn(col, term))

                Dim type = field.SelectToken("type").ToString

                'add filters
                Dim filters As JArray = field.SelectToken("filters")
                For Each flt In filters
                    selectQuery.WherePhrase.Terms.Add(BuildWhereTerm(term, col, type, flt, CompareOperator.Like))
                    'selectQuery.WherePhrase.Terms.Add(WhereTerm.CreateCompare(SqlExpression.Field(col, term), SqlExpression.String(flt("value")), CompareOperator.Like))
                Next
            Next
        Next

        Return New SqlServerRenderer().RenderSelect(selectQuery)
    End Function

    Private Function BuildWhereTerm(term As FromTerm, col As String, type As String, filter As JToken, opert As CompareOperator) As WhereTerm
        'Select Case type
        '    Case "string"
        '        Return WhereTerm.CreateCompare(SqlExpression.Field(col, term), SqlExpression.String(filter("value")), CompareOperator.Like)
        '    Case "number"
        '        Return WhereTerm.CreateCompare(SqlExpression.Field(col, term), SqlExpression.Number(CDbl(filter("value"))), CompareOperator.Greater)
        '    Case "date"
        '        Return WhereTerm.CreateCompare(SqlExpression.Field(col, term), SqlExpression.Number(CDbl(filter("value"))), CompareOperator.Greater)
        'End Select

        Return WhereTerm.CreateCompare(SqlExpression.Field(col, term), BuildSqlExpression(type, filter("value")), opert)
    End Function

    Private Function BuildSqlExpression(type As String, value As String) As SqlExpression
        Select Case type
            Case "string"
                Return SqlExpression.String(value)
            Case "number"
                Return SqlExpression.Number(CDbl(value))
            Case "date"
                Return SqlExpression.Date(CDate(value))
            Case Else
                Return SqlExpression.String(value)
        End Select
    End Function

End Class

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

        Dim jsObj = JToken.Parse(json)

        Dim baseTbl As FromTerm = FromTerm.Table(baseTable)




        Return ""

    End Function


End Class

Imports System.Data.SqlClient
Imports System.IO
Imports System.Web
Imports Newtonsoft.Json.Linq

Public Class DBJSONUtil


    Public Shared Function MapTo(ostr As String, mapPath As String) As String
        Dim jobj = JObject.Parse(ostr)

        Using sr = New StreamReader(mapPath)
            Dim line As String
            line = sr.ReadLine
            While line IsNot Nothing
                Dim token = line.Split(",")
                If token.Count = 2 Then
                    ReplaceField(jobj, token(0), token(1))
                ElseIf token.Count = 3 Then
                    Replace1AndUpdate2(jobj, token(0), token(1), token(2))
                End If

                line = sr.ReadLine
            End While
        End Using

        Return jobj.ToJsonString
    End Function

    Public Shared Sub ReplaceField(jobj As JObject, fromField As String, toField As String)
        jobj(toField) = jobj(fromField)
        If Not fromField = toField Then
            jobj.Remove(fromField)
        End If
    End Sub

    Public Shared Sub Replace1AndUpdate2(jobj As JObject, fromFiled As String, toFiled As String, additional As String)
        ReplaceField(jobj, fromFiled, toFiled)
        jobj(additional) = "true"
    End Sub


    Public Shared Function IsNullOrEmpty(token As JToken) As Boolean
        Return token Is Nothing OrElse
               (token.Type = JTokenType.Array AndAlso Not token.HasValues) OrElse
               (token.Type = JTokenType.Object AndAlso Not token.HasValues) OrElse
               (token.Type = JTokenType.String And String.IsNullOrEmpty(token.ToString)) OrElse
               (token.Type = JTokenType.Null)
    End Function

    Public Shared Function ParseDouble(token As JToken) As Double
        Try
            If token Is Nothing Then
                Return 0.0
            ElseIf token.Type = JTokenType.String Then
                If String.IsNullOrEmpty(token.ToString) Then
                    Return 0.0
                Else
                    Dim cleaned = token.ToString.Replace("$", "").Replace(",", "")
                    Return Double.Parse(cleaned)
                End If
            ElseIf token.Type = JTokenType.Integer OrElse token.Type = JTokenType.Float Then
                Return CDec(token)
            Else
                Return 0.0
            End If
        Catch ex As Exception
            Return 0.0
        End Try
    End Function
End Class

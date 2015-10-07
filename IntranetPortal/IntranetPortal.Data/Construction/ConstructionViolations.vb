﻿Imports Newtonsoft.Json

Partial Public Class ConstructionViolation

    Public Shared Function GetViolation(bble As String) As ConstructionViolation
        Using ctx = New ConstructionEntities
            Dim result = ctx.ConstructionViolations.Where(Function(c) c.BBLE = bble).FirstOrDefault
            Return result
        End Using
    End Function

    Public Shared Function GetViolationsWithin30Days() As ConstructionViolation()
        Using ctx = New ConstructionEntities
            Dim result = ctx.ConstructionViolations.Where(Function(c) Entity.DbFunctions.DiffDays(c.HPD_RegExpireDate, Now) < 30).ToArray
            Return result
        End Using
    End Function
    Public Sub Save(constructionCase As ConstructionCase, userName As String)
        Using ctx = New ConstructionEntities
            Dim caseData = constructionCase.CSCase
            Dim jtoken = JsonConvert.DeserializeObject(Of Linq.JToken)(caseData)
            Dim dateString = jtoken.SelectToken("Violations.HPD_RegExpireDate").ToString
            If Not String.IsNullOrEmpty(dateString) Then
                Dim hpdRegExpireDate = Date.Parse(dateString)
                Dim savedViolation = GetViolation(constructionCase.BBLE)
                If savedViolation Is Nothing Then
                    Me.BBLE = constructionCase.BBLE
                    Me.HPD_RegExpireDate = hpdRegExpireDate
                    ctx.ConstructionViolations.Add(Me)
                Else
                    savedViolation.HPD_RegExpireDate = hpdRegExpireDate
                End If
            End If

            Try
                ctx.SaveChanges()
                Core.SystemLog.Log("Construction Violation Save", Newtonsoft.Json.JsonConvert.SerializeObject(Me), Core.SystemLog.LogCategory.SaveData, constructionCase.BBLE, userName)
            Catch ex As Exception
                Throw
            End Try
        End Using

    End Sub

    Public Sub New()

    End Sub
End Class

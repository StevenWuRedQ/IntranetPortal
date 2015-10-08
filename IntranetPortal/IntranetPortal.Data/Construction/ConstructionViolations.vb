Imports Newtonsoft.Json

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
            Try
                Dim caseData = constructionCase.CSCase
                Dim jtoken = JsonConvert.DeserializeObject(Of Linq.JToken)(caseData)
                Dim dateToken = jtoken.SelectToken("Violations.HPD_RegExpireDate")
                If Not dateToken Is Nothing Then
                    Dim dateString = dateToken.ToString
                    If Not String.IsNullOrEmpty(DateString) Then
                        Dim hpdRegExpireDate = Date.Parse(DateString)
                        Dim savedViolation = GetViolation(constructionCase.BBLE)
                        If savedViolation Is Nothing Then
                            Me.BBLE = constructionCase.BBLE
                            Me.HPD_RegExpireDate = hpdRegExpireDate
                            ctx.ConstructionViolations.Add(Me)
                        Else
                            savedViolation.HPD_RegExpireDate = hpdRegExpireDate
                        End If
                    End If
                End If

                ctx.SaveChanges()
                Core.SystemLog.Log("Construction Violation Save", Newtonsoft.Json.JsonConvert.SerializeObject(Me), Core.SystemLog.LogCategory.SaveData, constructionCase.BBLE, userName)
            Catch ex As Exception

            End Try
        End Using

    End Sub

    Public Sub New()

    End Sub
End Class

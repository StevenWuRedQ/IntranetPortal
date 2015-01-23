Partial Public Class TitleJudgementSearch
    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = GetInstance(CaseId)
            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                pbi = ShortSaleUtility.SaveChangesObj(pbi, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetInstance(caseId As Integer) As TitleJudgementSearch
        Using context As New ShortSaleEntities
            Return context.TitleJudgementSearches.Where(Function(obj) obj.CaseId = caseId).SingleOrDefault
        End Using
    End Function

    Public Shared Function GetInstaceByBBLE(bble As String) As TitleJudgementSearch
        Using ctx As New ShortSaleEntities
            Return ctx.TitleJudgementSearches.Where(Function(obj) obj.BBLE = bble).SingleOrDefault
        End Using
    End Function

End Class

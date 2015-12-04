Partial Public Class TitleJudgementSearch
    Public Sub Save()
        Using context As New PortalEntities
            Dim pbi As TitleJudgementSearch
            If CaseId = 0 Then
                pbi = context.TitleJudgementSearches.SingleOrDefault(Function(obj) obj.BBLE = BBLE)
            Else
                pbi = context.TitleJudgementSearches.SingleOrDefault(Function(obj) obj.CaseId = CaseId)
            End If

            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                If pbi.JudgementId <> Me.JudgementId Then
                    Me.JudgementId = pbi.JudgementId
                End If

                pbi = ShortSaleUtility.SaveChangesObj(pbi, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetInstance(caseId As Integer) As TitleJudgementSearch
        Using context As New PortalEntities
            Return context.TitleJudgementSearches.Where(Function(obj) obj.CaseId = caseId).SingleOrDefault
        End Using
    End Function

    Public Shared Function GetInstaceByBBLE(bble As String) As TitleJudgementSearch
        Using ctx As New PortalEntities
            Return ctx.TitleJudgementSearches.Where(Function(obj) obj.BBLE = bble).SingleOrDefault
        End Using
    End Function
End Class

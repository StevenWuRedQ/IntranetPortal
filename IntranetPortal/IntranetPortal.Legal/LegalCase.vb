Partial Public Class LegalCase

    Public Sub SaveData()
        Using ctx As New LegalModelContainer
            Dim lc = ctx.LegalCases.Find(BBLE)

            If lc Is Nothing Then
                Me.CreateDate = DateTime.Now
                ctx.LegalCases.Add(Me)
            Else
                lc.CaseData = CaseData
            End If

            ctx.SaveChanges()
        End Using
    End Sub


End Class

Partial Public Class LegalCase

    Public Sub SaveData()
        Using ctx As New LegalModelContainer
            Dim lc = ctx.LegalCases.Find(BBLE)

            If lc Is Nothing Then
                Me.CreateDate = DateTime.Now
                ctx.LegalCases.Add(Me)
            Else
                lc = Core.Utility.SaveChangesObj(lc, Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetCase(bble As String) As LegalCase
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Find(bble)
        End Using
    End Function

    Public Shared Function GetCaseList(status As LegalCaseStatus) As List(Of LegalCase)
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Where(Function(lc) lc.Status = status).ToList
        End Using
    End Function

    Public Shared Function GetCaseList(status As LegalCaseStatus, userName As String) As List(Of LegalCase)
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Where(Function(lc) lc.Status = status AndAlso (lc.ResearchBy = userName Or lc.Attorney = userName)).ToList
        End Using
    End Function
End Class

Public Enum LegalCaseStatus
    Preview = 0
    InResearch = 1
    ManagerAssign = 2
    InCount = 3
    Closed = 4
End Enum

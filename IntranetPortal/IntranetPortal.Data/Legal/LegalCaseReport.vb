﻿Public Class LegalCaseReport
    Public Shared Function GetAllReport() As List(Of LegalCaseReport)
        Using ctx As New ShortSaleEntities
            Return ctx.LegalCaseReports.ToList
        End Using
        Return Nothing
    End Function

End Class

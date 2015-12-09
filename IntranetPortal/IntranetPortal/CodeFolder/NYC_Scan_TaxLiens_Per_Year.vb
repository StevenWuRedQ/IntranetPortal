Public Class NYC_Scan_TaxLiens_Per_Year

    Public Shared Function GetTaxLiens(bble As String) As List(Of NYC_Scan_TaxLiens_Per_Year)
        Using ctx As New Entities
            Return ctx.NYC_Scan_TaxLiens_Per_Year.Where(Function(t) t.BBLE = bble).ToList
        End Using

    End Function

End Class

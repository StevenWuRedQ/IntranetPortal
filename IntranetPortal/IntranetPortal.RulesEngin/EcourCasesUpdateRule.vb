Imports IntranetPortal.Data

''' <summary>
''' The update rule for Ecourt Cases
''' </summary>
Public Class EcourtCasesUpdateRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        Dim try_count = 0

        While try_count < 3
            Try
                LeadsEcourtData.DailyUpdate()
                Log("Ecourt Data Daily Update is completed.")
            Catch ex As Exception
                Log("Error in " & RuleName, ex)
                Threading.Thread.Sleep((try_count + 1) * 60 * 1000)
                try_count += 1
            End Try
        End While
    End Sub

End Class

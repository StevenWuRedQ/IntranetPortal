Imports System.Runtime.Serialization

<DataContract>
Public Class NoticeECourtRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        Log("======================Start Notify ECourt date==============================")
        Dim NoticeDays = {14, 6, 2, 0}

        For Each d In NoticeDays
            Log("To Notify Ecourt per lead in " & d + 1 & "days")
            Dim bbles = Data.LegalECourt.GetCaseByNoticeyDay(d).Select(Function(e) e.BBLE)

            For Each bble In bbles
                Dim names = LegalCaseManage.GetCaseRelateUsersName(bble)

                Log("To Notify Ecourt per lead : " & bble & " for")
            Next
        Next
        Log("======================End Notify ECourt date==============================")
    End Sub

End Class

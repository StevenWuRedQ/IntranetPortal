Public Class ServiceLog
    Public Delegate Sub WriteLog(msg As String)
    Public Event OnWriteLog As WriteLog

    Private Sub New()

    End Sub

    Private Shared logInstance As ServiceLog
    Public Shared Function GetInstance() As ServiceLog
        If logInstance Is Nothing Then
            logInstance = New ServiceLog
        End If

        Return logInstance
    End Function

    Public Shared Sub Log(msg As String)
        Dim log = GetInstance()
        log.WriteServiceLog(msg)
    End Sub

    Private Sub WriteServiceLog(msg As String)
        RaiseEvent OnWriteLog(msg)
    End Sub
End Class

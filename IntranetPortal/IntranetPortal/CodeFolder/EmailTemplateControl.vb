Public Class EmailTemplateControl
    Inherits UserControl

    Protected Property MailData As New Dictionary(Of String, String)

    Public Overridable Sub BindData(params As Dictionary(Of String, String))
        If params IsNot Nothing Then
            MailData = params
        End If
    End Sub

    Public Function GetMailDataItem(key As String) As String
        If MailData.ContainsKey(key) Then
            Return MailData(key)
        End If

        Return ""
    End Function

End Class

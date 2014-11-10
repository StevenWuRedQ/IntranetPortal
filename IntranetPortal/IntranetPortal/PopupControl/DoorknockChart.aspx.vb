Public Class DoorknockChart
    Inherits System.Web.UI.Page

    Public Property BBLEs As String()
    Public Property Addresses As String()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("p")) Then
            BBLEs = Request.QueryString("p").Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            Addresses = Request.QueryString("a").Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
        End If
    End Sub

    Sub CreateTasks()
        Dim logs As New ActivityLogs
        For i = 0 To BBLEs.Length - 1
            'logs.AddActivityLog2(DateTime.Now, "Set Comments logs")


        Next
    End Sub
End Class
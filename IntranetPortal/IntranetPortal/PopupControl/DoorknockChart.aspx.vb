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
            Dim bble = BBLEs(i)
            Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, "Door Knock: " & Addresses(i), bble, LeadsActivityLog.LogCategory.DoorknockTask.ToString, LeadsActivityLog.EnumActionType.DoorKnock)
            UserTask.AddUserTask(bble, Page.User.Identity.Name, "Doorknock", "Normal", "In Office", DateTime.Now.AddDays(3), "Door Knock: " & Addresses(i), log.LogID)
        Next
    End Sub
End Class
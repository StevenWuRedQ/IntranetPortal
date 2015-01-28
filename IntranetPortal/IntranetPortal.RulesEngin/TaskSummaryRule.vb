Imports System.Text
Imports System.IO
Imports System.Web.UI
Imports System.Web

Public Class TaskSummaryRule
    Public Shared Sub Execute()

        Dim emps = Employee.GetAllActiveEmps()

        For Each emp In emps
            Dim body = LoadSummaryEmail(emp)
        Next
    End Sub

    Public Shared Function LoadSummaryEmail(userName As String) As String
        Dim ts As New TaskSummary
        ts.DestinationUser = userName
        'ts.BindData()

        Using Page As New Page
            ts = Page.LoadControl(GetType(TaskSummary), Nothing)
            ts.DestinationUser = userName
            'ts.BindData()          

            Page.Controls.Add(ts)

            Dim sb As New StringBuilder
            Using tw As New StringWriter(sb)
                Using hw As New HtmlTextWriter(tw)
                    ts.RenderControl(hw)
                    hw.Write("End")
                End Using
            End Using

            Return sb.ToString
        End Using
    End Function

End Class

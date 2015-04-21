Imports MyIdealProp.Workflow.Client

Public Class PropertyListControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindProperty()
        End If
    End Sub

    Public Sub BindProperty()
        gridTasks.DataSource = PublicSiteData.ListProperty.GetListedPropertyByOwner({Page.User.Identity.Name})
        gridTasks.DataBind()

    End Sub

    Public Function GetMarkColor(priority As Integer)
        Dim colors As New Dictionary(Of Integer, String)
        colors.Add(0, "gray")
        colors.Add(1, "#a820e1")
        colors.Add(2, "#ec471b")
        colors.Add(3, "#7bb71b")
        Dim color = colors.Item(priority)
        If (color Is Nothing) Then
            Throw New Exception("Can't find color " & priority & "In GetMarkColor")
        End If
        Return color
    End Function

    Protected Sub gridTasks_DataBinding(sender As Object, e As EventArgs)
        If gridTasks.DataSource Is Nothing AndAlso gridTasks.IsCallback Then
            BindProperty()
        End If
    End Sub

    Protected Sub gridTasks_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters.StartsWith("Group") Then
            gridTasks.UnGroup(gridTasks.Columns("ProcSchemeDisplayName"))
            gridTasks.UnGroup(gridTasks.Columns("Originator"))
            gridTasks.GroupBy(gridTasks.Columns(e.Parameters.Split("|")(1)))
            'BindTask()
        End If
    End Sub

    Protected Sub gridTasks_CustomColumnSort(sender As Object, e As DevExpress.Web.ASPxGridView.CustomColumnSortEventArgs)
        If e.Column.FieldName = "ProcSchemeDisplayName" Then
            e.Handled = True
            Dim s1 = e.Value1.ToString, s2 = e.Value2.ToString

            Dim processName = "Reminder"

            If s1 = processName Then
                e.Result = 1
            ElseIf s2 = processName Then
                e.Result = -1
            Else
                e.Result = Comparer.Default.Compare(s1, s2)
            End If
        End If
    End Sub
End Class
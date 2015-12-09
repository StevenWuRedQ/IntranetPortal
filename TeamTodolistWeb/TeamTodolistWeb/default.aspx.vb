Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxCallback
Imports DevExpress.XtraCharts
Imports DevExpress.Web.ASPxTabControl
Imports DevExpress.Web.ASPxClasses

Partial Class TodoListPage
    Inherits System.Web.UI.Page
    Private dateneedItem As Integer = 15
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        BindData()
        If Not Page.IsPostBack Then

            lblLoginUser.Text = Page.User.Identity.Name
            'dateDue.MinDate = DateTime.Now
            'dateDue.Date = DateTime.Now
            For j = 0 To dateneedItem
                cbDateNeed.Items.Add(If(j = 0, "", j.ToString + " days"), If(j = 0, "", j.ToString))
            Next
        End If
    End Sub

    Sub BindData()
        Using Context As New DevAppEntities
            Dim myLists = Context.TodoLists.ToList.OrderByDescending(Function(t) t.CreateDate)
            'For Each tdlist In myLists
            '    tdlist.UpdateDuDate()
            'Next
            'Context.SaveChanges()
            gridTask.DataSource = myLists
            gridTask.DataBind()
        End Using
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs) Handles btnAdd.Click
        Using Context As New DevAppEntities
            Dim item As New TodoList
            item.Title = txtTitle.Text
            item.Description = txtMemo.Html
            item.Category = cbCategory.Text
            item.CreateBy = lblLoginUser.Text  'cbUsers.Text
            'item.DueDate = dateDue.Date
            item.Owner = cbAssign.Text
            item.CreateDate = DateTime.Now
            item.Status = TaskStatus.NewTask
            item.DateNeed = CInt(cbDateNeed.Value)

            Context.TodoLists.Add(item)
            Context.SaveChanges()
            UpDataAllDateNeed()
            Log("Create a new task.", item.ListId)
        End Using

        txtMemo.Html = ""
        BindData()
    End Sub

    Protected Sub gridTask_HtmlRowPrepared(sender As Object, e As ASPxGridViewTableRowEventArgs) Handles gridTask.HtmlRowPrepared
        If Not e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Data Then
            Return
        End If

        Dim status = CType(e.GetValue("Status"), TaskStatus)
        If status = TaskStatus.NewTask Then
            Dim chkCompleted = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("Status"), "chkCompleted"), ASPxCheckBox)
            chkCompleted.ClientSideEvents.CheckedChanged = String.Format("function(s,e){{CompleteTask({0});}}", e.KeyValue)

            Dim cbOwner = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("Owner"), "cbOwner"), ASPxComboBox)
            cbOwner.Value = e.GetValue("Owner")
            cbOwner.ClientSideEvents.SelectedIndexChanged = String.Format("function(s,e){{ChangeOwner(s, {0});}}", e.KeyValue)
            cbOwner.Visible = True

            Dim priority = e.GetValue("Priority")
            Dim cbPriority = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("Priority"), "cbPriority"), ASPxComboBox)
            cbPriority.Items.Clear()
            For i = 0 To 30
                If i = 0 Then
                    cbPriority.Items.Add("")
                Else
                    cbPriority.Items.Add(i.ToString)
                End If
            Next

            cbPriority.Value = priority
            cbPriority.ClientSideEvents.SelectedIndexChanged = String.Format("function(s,e){{ ChangeTaskPriority(s, {0}); }}", e.KeyValue)

            Dim cbDateNeed = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("DateNeed"), "cbDateNeed"), ASPxComboBox)
            cbDateNeed.Items.Clear()
            For j = 0 To 15

                cbDateNeed.Items.Add(If(j = 0, "", j.ToString + " days"), If(j = 0, "", j.ToString))

            Next
            cbDateNeed.Value = e.GetValue("DateNeed")
            cbDateNeed.Text = If(e.GetValue("DateNeed") Is Nothing, " ", e.GetValue("DateNeed") & " days")

            cbDateNeed.ClientSideEvents.SelectedIndexChanged = String.Format("function(s,e){{ChangeDateNeed(s,{0});}}", e.KeyValue)
            'Dim dueDate = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("DueDate"), "dateDue"), ASPxDateEdit)
            'dueDate.ClientSideEvents.DateChanged = String.Format("function(s,e){{ OnDueDateChange(s, {0}); }}", e.KeyValue)

            Dim colors = New String() {"#d9534f", "#f0ad4e", "#5bc0de", "#5cb85c", "#428bca"}

            If priority > 0 AndAlso priority < 6 Then
                e.Row.BackColor = Drawing.ColorTranslator.FromHtml(colors(priority - 1))
            End If

            'Select Case priority
            '    Case 1
            '        e.Row.BackColor = Drawing.ColorTranslator.FromHtml("#d9534f")
            '    Case 2
            '        e.Row.BackColor = Drawing.Color.IndianRed
            '    Case 3
            '        e.Row.BackColor = Drawing.Color.Orange
            '    Case 4
            '        e.Row.BackColor = Drawing.Color.PaleVioletRed
            '    Case 5
            '        e.Row.BackColor = Drawing.Color.MistyRose
            'End Select
        Else

        End If

        Dim txtComments = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("Comments"), "txtComments"), ASPxMemo)
        txtComments.ClientSideEvents.TextChanged = String.Format("function(s,e){{ SaveComments(s, {0}); }}", e.KeyValue)
    End Sub
    Protected Sub UpDataAllDateNeed()
        Using Context As New DevAppEntities
            For Each mList As TodoList In Context.TodoLists.Where(Function(log) log.Status = TaskStatus.NewTask).ToList()
                mList.UpdateDuDate()
            Next
            Context.SaveChanges()
        End Using
    End Sub
    Protected Sub gridTask_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gridTask.CustomCallback
        If e.Parameters.StartsWith("CompleteTask") Then
            Dim taskId = CInt(e.Parameters.Split("|")(1))

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                task.Status = TaskStatus.Completed
                task.UpdateDate = DateTime.Now
                Context.SaveChanges()

                Log("Complete Task", taskId)

                RefreshTaskPriority(task.Owner, True)
            End Using
        End If
        If (e.Parameters.StartsWith("DataNeedChange")) Then
            Dim taskId = CInt(e.Parameters.Split("|")(1))

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                If (task IsNot Nothing) Then
                    Dim dateNeed = CInt(e.Parameters.Split("|")(2))
                    task.DateNeed = dateNeed
                    task.UpdateDuDate()
                    task.UpdateDate = DateTime.Now
                    Context.SaveChanges()
                    UpDataAllDateNeed()
                End If
            End Using


        End If
        If e.Parameters.StartsWith("Priority") Then
            Dim taskId = e.Parameters.Split("|")(1)
            Dim priority = e.Parameters.Split("|")(2)

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                If task IsNot Nothing Then
                    Dim isUp = False
                    If String.IsNullOrEmpty(priority) Then
                        task.Priority = Nothing
                    Else
                        If task.Priority < CInt(priority) Then
                            isUp = True
                        End If
                        task.Priority = priority
                    End If
                    task.UpdateDate = DateTime.Now
                    Context.SaveChanges()
                    Log("Change Priority to " & priority, taskId)
                    RefreshTaskPriority(task.Owner, isUp)
                    UpDataAllDateNeed()
                End If
            End Using
        End If

        If e.Parameters.StartsWith("DueDate") Then
            Dim taskId = e.Parameters.Split("|")(1)
            Dim newDate = CDate(e.Parameters.Split("|")(2))

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                If task IsNot Nothing Then
                    task.DueDate = newDate
                    task.UpdateDate = DateTime.Now
                    Context.SaveChanges()
                    UpDataAllDateNeed()
                    Log("Due Date Change to " & newDate.ToShortDateString, taskId)
                End If
            End Using
        End If

        BindData()
    End Sub

    Sub RefreshTaskPriority(owner As String, isUp As Boolean)
        Using Context As New DevAppEntities
            Dim index = 1
            Dim tasks = Nothing

            If isUp Then
                tasks = Context.TodoLists.Where(Function(t) t.Owner = owner And t.Status = TaskStatus.NewTask And t.Priority > 0).OrderBy(Function(s) s.Priority).ThenBy(Function(s) s.UpdateDate)
            Else
                tasks = Context.TodoLists.Where(Function(t) t.Owner = owner And t.Status = TaskStatus.NewTask And t.Priority > 0).OrderBy(Function(s) s.Priority).ThenByDescending(Function(s) s.UpdateDate)
            End If

            For Each task In tasks
                If task.Priority <> index Then
                    task.Priority = index
                End If

                If index > 30 Then
                    task.Priority = Nothing
                End If

                index = index + 1
            Next

            Context.SaveChanges()
        End Using
    End Sub

    Function CalculateWorkingDays(completeDate As Date?, createDate As Date) As String

        If completeDate IsNot Nothing Then
            Return String.Format("{0:0.00}", (completeDate - createDate).Value.TotalDays)
        End If

        Return ""
    End Function

    Protected Sub txtComments_TextChanged(sender As Object, e As EventArgs)
        Dim comments = TryCast(sender, ASPxMemo)
    End Sub

    Protected Sub callbackSaveComments_Callback(source As Object, e As CallbackEventArgs)
        If Not String.IsNullOrEmpty(e.Parameter) Then
            Dim taskId = e.Parameter.Substring(0, e.Parameter.IndexOf("|"))
            Dim comments = e.Parameter.Remove(0, e.Parameter.IndexOf("|") + 1)
            Using Context As New DevAppEntities

                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                If task IsNot Nothing Then
                    task.Comments = comments '& String.Format("(Update by {0})" + Environment.NewLine, HttpContext.Current.User.Identity.Name)
                    Context.SaveChanges()

                    Log("Change Comments. The new comments: " & comments, taskId)
                End If
            End Using
        End If
    End Sub

    Protected Sub callbackChangeOwner_Callback(source As Object, e As CallbackEventArgs)
        If e.Parameter.StartsWith("ChangeOwner") Then
            Dim taskId = e.Parameter.Split("|")(1)
            Dim owner = e.Parameter.Split("|")(2)

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                If task IsNot Nothing Then

                    If Not String.IsNullOrEmpty(owner) Then
                        task.Owner = owner
                        task.Priority = Nothing
                    End If

                    task.UpdateDate = DateTime.Now

                    Context.SaveChanges()

                    Log("Change Owner to " & owner, taskId)
                    BindData()
                End If
            End Using
        End If
    End Sub

    Private Sub Log(msg As String, taskId As Integer)
        Using ctx As New DevAppEntities
            Dim log As New TaskLog
            log.CreateDate = DateTime.Now
            log.UserName = Page.User.Identity.Name
            log.LogMsg = msg
            log.TaskId = taskId

            ctx.TaskLogs.Add(log)
            ctx.SaveChanges()
        End Using
    End Sub

    Private Sub BuildChart(userName As String)

        ganttChart.Series.Clear()
        ganttChart.Titles.Clear()
        Dim title As New ChartTitle
        title.Text = String.Format("Task Plan", userName)
        ganttChart.Titles.Add(title)

        Dim userTasks = GetUserTask(userName)
        For Each ut In userTasks
            Dim planSeries As New DevExpress.XtraCharts.Series(ut.Key, DevExpress.XtraCharts.ViewType.Gantt)
            planSeries.ValueScaleType = ScaleType.DateTime
            Dim startDate = DateTime.Now
            Dim tasks = CType(ut.Group, List(Of TodoList))
            For Each t As TodoList In tasks.OrderBy(Function(todo As TodoList) todo.Priority)
                Dim sp As New SeriesPoint
                sp.DateTimeValues = {startDate.Date, t.DueDate.Value.Date}
                sp.Argument = t.ListId & " " & If(Not String.IsNullOrEmpty(t.Title), t.Title, t.Description.Substring(0, If(t.Description.Length > 10, 10, t.Description.Length)))
                planSeries.Points.Add(sp)
                startDate = t.DueDate
            Next

            CType(planSeries.View, GanttSeriesView).LinkOptions.ArrowHeight = 7
            CType(planSeries.View, GanttSeriesView).LinkOptions.ArrowWidth = 11

            For i As Integer = 1 To planSeries.Points.Count - 1
                planSeries.Points(i).Relations.Add(planSeries.Points((i - 1)))
            Next i

            ganttChart.Series.Add(planSeries)
        Next

        If ganttChart.Diagram IsNot Nothing Then
            Dim ganttDiag = CType(ganttChart.Diagram, GanttDiagram)
            ganttDiag.AxisY.WholeRange.Auto = True
        End If
    End Sub

    Public Function GetUserTask(userName As String) As Object
        Using ctx As New DevAppEntities
            Dim tasks As Object
            If String.IsNullOrEmpty(userName) Then
                tasks = ctx.TodoLists.Where(Function(todo) todo.Status = TaskStatus.NewTask And todo.Priority > 0).GroupBy(Function(todo) todo.Owner).ToList '.OrderBy(Function(todo) todo.Priority).ToList
            Else
                tasks = ctx.TodoLists.Where(Function(todo) userName.Contains(todo.Owner) And todo.Status = TaskStatus.NewTask And todo.Priority > 0).GroupBy(Function(todo) todo.Owner).ToList '.OrderBy(Function(todo) todo.Priority).ToList
            End If

            'For Each t In tasks
            '    t.UpdateDuDate()
            'Next

            Return tasks
        End Using
    End Function

    Protected Sub Unnamed_ActiveTabChanged(source As Object, e As TabControlEventArgs)
        If e.Tab.Name = "tabGantt" Then
            BuildChart("")
        End If
    End Sub

    Protected Sub Unnamed_Callback(sender As Object, e As CallbackEventArgsBase)
        BuildChart(e.Parameter)
    End Sub
End Class

Enum TaskStatus
    NewTask = 0
    Completed = 1
End Enum

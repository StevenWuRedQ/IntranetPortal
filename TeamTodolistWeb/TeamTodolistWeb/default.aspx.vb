Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxCallback

Partial Class TodoListPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        BindData()
        lblLoginUser.Text = Page.User.Identity.Name
        If Not Page.IsPostBack Then
            dateDue.MinDate = DateTime.Now
            dateDue.Date = DateTime.Now
        End If
    End Sub

    Sub BindData()
        Using Context As New DevAppEntities
            gridTask.DataSource = Context.TodoLists.ToList.OrderByDescending(Function(t) t.CreateDate)
            gridTask.DataBind()
        End Using
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs) Handles btnAdd.Click
        Using Context As New DevAppEntities
            Dim item As New TodoList
            item.Description = txtMemo.Text
            item.Category = cbCategory.Text
            item.CreateBy = lblLoginUser.Text  'cbUsers.Text
            item.DueDate = dateDue.Date
            item.Owner = cbAssign.Text
            item.CreateDate = DateTime.Now
            item.Status = TaskStatus.NewTask
            Context.TodoLists.Add(item)
            Context.SaveChanges()
        End Using

        txtMemo.Text = ""
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
        End If

        Dim txtComments = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("Comments"), "txtComments"), ASPxMemo)
        txtComments.ClientSideEvents.TextChanged = String.Format("function(s,e){{ SaveComments(s, {0}); }}", e.KeyValue)

        Dim priority = e.GetValue("Priority")
        Dim cbPriority = TryCast(gridTask.FindRowCellTemplateControl(e.VisibleIndex, gridTask.Columns("Priority"), "cbPriority"), ASPxComboBox)
        cbPriority.Value = priority
        cbPriority.ClientSideEvents.SelectedIndexChanged = String.Format("function(s,e){{ ChangeTaskPriority(s, {0}); }}", e.KeyValue)

        Select Case priority
            Case 1
                e.Row.BackColor = Drawing.Color.OrangeRed
            Case 2
                e.Row.BackColor = Drawing.Color.IndianRed
            Case 3
                e.Row.BackColor = Drawing.Color.Orange
            Case 4
                e.Row.BackColor = Drawing.Color.PaleVioletRed
            Case 5
                e.Row.BackColor = Drawing.Color.MistyRose
        End Select

    End Sub

    Protected Sub gridTask_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gridTask.CustomCallback
        If e.Parameters.StartsWith("CompleteTask") Then
            Dim taskId = CInt(e.Parameters.Split("|")(1))

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                task.Status = TaskStatus.Completed
                task.UpdateDate = DateTime.Now
                Context.SaveChanges()
            End Using
        End If

        If e.Parameters.StartsWith("Priority") Then
            Dim taskId = e.Parameters.Split("|")(1)
            Dim priority = e.Parameters.Split("|")(2)

            Using Context As New DevAppEntities
                Dim task = Context.TodoLists.Where(Function(t) t.ListId = taskId).SingleOrDefault
                If task IsNot Nothing Then
                    task.Priority = priority
                    Context.SaveChanges()
                End If
            End Using
        End If

        BindData()
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
                End If
            End Using

        End If
    End Sub
End Class

Enum TaskStatus
    NewTask = 0
    Completed = 1
End Enum

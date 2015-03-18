Public Class ShareLeads
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
            If (Not Page.IsPostBack) Then
                hfbble.Value = Request.QueryString("bble")
                BindEmps()
                BindShareList(hfbble.Value)
            End If
        End If
    End Sub

    Sub BindShareList(bble As String)
        Using Context As New Entities
            lbEmployees.DataSource = Context.SharedLeads.Where(Function(s) s.BBLE = bble).ToList
            lbEmployees.TextField = "UserName"
            lbEmployees.ValueField = "UserName"
            lbEmployees.DataBind()
        End Using

    End Sub

    Sub BindEmps()
        Using Context As New Entities
            cbEmps.DataSource = Context.Employees.Where(Function(em) em.Active = True).OrderBy(Function(em) em.Name).ToList
            cbEmps.TextField = "Name"
            cbEmps.ValueField = "EmployeeID"
            cbEmps.DataBind()
        End Using
    End Sub

    Protected Sub btnAddEmp_Click(sender As Object, e As EventArgs) Handles btnAddEmp.Click
        If String.IsNullOrEmpty(hfbble.Value) Then
            Throw New Exception("Unknow BBLE! Please check.")
        End If

        If String.IsNullOrEmpty(cbEmps.Text) Then
            Throw New Exception("Please select employee.")
        End If

        Using Context As New Entities
            Dim item = Context.SharedLeads.Where(Function(sl) sl.BBLE = hfbble.Value And sl.UserName = cbEmps.Text).FirstOrDefault

            If item Is Nothing Then
                Dim sharedItem As New SharedLead
                sharedItem.BBLE = hfbble.Value
                sharedItem.UserName = cbEmps.Text
                sharedItem.CreateBy = User.Identity.Name
                sharedItem.CreateDate = DateTime.Now

                Context.SharedLeads.Add(sharedItem)
                Context.SaveChanges()
            End If
        End Using

        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} share lead to {1}.", User.Identity.Name, cbEmps.Text), hfbble.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.SharedLeads)
        UserMessage.AddNewMessage(cbEmps.Text, "You have a new shared leads.", String.Format("{0} share a lead to you.", User.Identity.Name, cbEmps.Text), hfbble.Value)

        BindShareList(hfbble.Value)
    End Sub

    Protected Sub btnRemoveEmp_Click(sender As Object, e As EventArgs) Handles btnRemoveEmp.Click
        If String.IsNullOrEmpty(hfbble.Value) Then
            Throw New Exception("Unknow BBLE! Please check.")
        End If

        Using Context As New Entities
            Dim item = Context.SharedLeads.Where(Function(s) s.BBLE = hfbble.Value And s.UserName = lbEmployees.SelectedItem.Text).FirstOrDefault
            Context.SharedLeads.Remove(item)
            Context.SaveChanges()
        End Using

        LeadsActivityLog.AddActivityLog(DateTime.Now, String.Format("{0} stop share to {1}.", User.Identity.Name, lbEmployees.SelectedItem.Text), hfbble.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.DefaultAction)
        BindShareList(hfbble.Value)
    End Sub
End Class
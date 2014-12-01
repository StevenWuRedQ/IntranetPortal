Imports DevExpress.Web.ASPxEditors

Public Class AssignRulesControl
    Inherits System.Web.UI.UserControl

    Public portalDataContext As New Entities

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindRules()
        End If
    End Sub

    Function GetDataSource()
        Dim empNames = Employee.GetMyEmployees(Page.User.Identity.Name).Select(Function(em) em.Name).ToArray
        Return portalDataContext.AssignRules.Where(Function(rule) empNames.Contains(rule.EmployeeName)).ToList()
    End Function

    Sub BindRules()
        gridAssignRules.DataSource = GetDataSource()
        gridAssignRules.DataBind()

        gridAssignRules.GroupBy(gridAssignRules.Columns("EmployeeName"))
    End Sub

    Protected Sub Unnamed_DataBinding(sender As Object, e As EventArgs)
        Dim cbEmps = CType(sender, ASPxComboBox)
        cbEmps.DataSource = Employee.GetMyEmployees(Page.User.Identity.Name).Select(Function(em) em.Name).ToArray
        ' cbEmps.DataBind()
    End Sub

    Protected Sub cbLeadsType_DataBinding(sender As Object, e As EventArgs)
        Dim types = [Enum].GetValues(GetType(LeadsInfo.LeadsType))

        Dim cbType = CType(sender, ASPxComboBox)

        For Each t As Integer In types
            cbType.Items.Add(CType(t, LeadsInfo.LeadsType).ToString, t)
        Next
        'cbType.DataSource = types
        'cbType.DataBind()
    End Sub

    Protected Sub cbInterval_DataBinding(sender As Object, e As EventArgs)
        Dim types = [Enum].GetValues(GetType(AssignRule.RuleInterval))
        Dim cbType = CType(sender, ASPxComboBox)

        For Each t As Integer In types
            cbType.Items.Add(CType(t, AssignRule.RuleInterval).ToString, t)
        Next
    End Sub

    Protected Sub gridAssignRules_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim rule As New AssignRule
        rule.EmployeeName = e.NewValues("EmployeeName")
        rule.LeadsType = e.NewValues("LeadsType")
        rule.Count = CInt(e.NewValues("Count"))
        rule.IntervalType = CInt(e.NewValues("IntervalType"))
        Dim ve = AssignLeadsPopup.ViewEventNewVlaue(e)
        rule.CreateBy = Page.User.Identity.Name
        rule.CreateDate = DateTime.Now

        Using ctx As New Entities
            ctx.AssignRules.Add(rule)
            ctx.SaveChanges()
        End Using

        e.Cancel = True
        gridAssignRules.CancelEdit()
        BindRules()
    End Sub

    Protected Sub gridAssignRules_DataBinding(sender As Object, e As EventArgs)
        If gridAssignRules.DataSource Is Nothing Then
            gridAssignRules.DataSource = GetDataSource()
        End If
    End Sub

    Protected Sub gridAssignRules_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        Dim ruleId = CInt(e.Keys(0))

        Using ctx As New Entities
            Dim rule = ctx.AssignRules.Find(ruleId)
            ctx.AssignRules.Remove(rule)
            ctx.SaveChanges()
        End Using

        e.Cancel = True
        BindRules()
    End Sub
End Class
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxGridView
Imports IntranetPortal.AssignRule
Imports Newtonsoft.Json
Imports DevExpress.Web.Data
Imports System.ComponentModel


Public Class AssignLeadsPopup
    Inherits System.Web.UI.UserControl
    Public portalDataContext As New Entities

    Public Property LeadsSource As String
    Public Property EmployeeSource As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If Not Page.IsPostBack Then
        BindRules()
        'End If
    End Sub

    Function GetDataSource()
        If String.IsNullOrEmpty(hfSource.Value) Then
            hfSource.Value = LeadsSource
        End If

        'Dim empNames = Employee.GetMyEmployees(Page.User.Identity.Name).Select(Function(em) em.Name).ToArray
        portalDataContext = New Entities
        Return portalDataContext.AssignRules.Where(Function(rule) rule.Source = hfSource.Value).ToList()
    End Function

    Protected Sub BindRules()
        RulesGrid.DataSource = GetDataSource()
        RulesGrid.DataBind()
        initGridCombox()
    End Sub
    Protected Sub initGridCombox()

        initComboxItems("EmployeeName", GetAllEmps())
        initComboxItems("IntervalTypeText", GetAllRuleInterval())
        initComboxItems("LeadsTypeText", GetAllLeadsType())
    End Sub
    Protected Sub initComboxItems(comboxfiled As String, items As Object)
        Dim combox As GridViewDataComboBoxColumn = RulesGrid.Columns(comboxfiled)
        combox.PropertiesComboBox.Items.Clear()
        combox.PropertiesComboBox.Items.AddRange(items)
    End Sub
    Protected Sub cbEmployeeName_DataBinding(sender As Object, e As EventArgs)
        Dim cbEmps = CType(sender, ASPxComboBox)
        cbEmps.DataSource = GetAllEmps()
    End Sub
    Function GetAllRuleInterval()
        Dim types = [Enum].GetValues(GetType(AssignRule.RuleInterval))
        Dim leadsTypeText As New ListEditItemCollection

        For Each t As Integer In types
            leadsTypeText.Add(CType(t, AssignRule.RuleInterval).ToString, t)
        Next
        Return leadsTypeText
    End Function

    Function GetAllLeadsType()
        Dim types = [Enum].GetValues(GetType(LeadsInfo.LeadsType))

        Dim leadsTypeText As New ListEditItemCollection

        For Each t As Integer In types
            leadsTypeText.Add(CType(t, LeadsInfo.LeadsType).ToString, t)
        Next
        Return leadsTypeText
    End Function

    Function GetAllEmps() As String()
        If String.IsNullOrEmpty(hfEmployees.Value) Then
            hfEmployees.Value = EmployeeSource
        End If

        Return hfEmployees.Value.Split(",")

        'Return Employee.GetMyEmployees(Page.User.Identity.Name).Select(Function(em) em.Name).ToArray
    End Function
    Protected Sub cbIntervalType_DataBinding(sender As Object, e As EventArgs)
        Dim types = [Enum].GetValues(GetType(AssignRule.RuleInterval))
        Dim cbType = CType(sender, ASPxComboBox)

        For Each t As Integer In types
            cbType.Items.Add(CType(t, AssignRule.RuleInterval).ToString, t)
        Next
    End Sub

    Protected Sub cbLeadsType_DataBinding(sender As Object, e As EventArgs)
        Dim types = [Enum].GetValues(GetType(LeadsInfo.LeadsType))

        Dim cbType = CType(sender, ASPxComboBox)

        For Each t As Integer In types
            cbType.Items.Add(CType(t, LeadsInfo.LeadsType).ToString, t)
        Next
    End Sub

    Protected Sub RulesGrid_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        Dim grid As ASPxGridView = TryCast(sender, ASPxGridView)

        Dim table As List(Of AssignRule) = GetDataSource()
        Using Context As New Entities
            Dim rule = Context.AssignRules.Find(e.Keys(0))
            VarRule(rule, e)

            Context.SaveChanges()

            'no save function
        End Using
        e.Cancel = True
        grid.CancelEdit()

        BindRules()
    End Sub
    Sub VarRule(rule As AssignRule, e As Object)
        rule.EmployeeName = e.NewValues("EmployeeName")
        Dim str = ViewEventNewVlaue(e)
        rule.LeadsType = e.NewValues("LeadsTypeText")
        rule.Count = CInt(e.NewValues("Count"))
        rule.IntervalTypeText = e.NewValues("IntervalTypeText")
    End Sub
    Public Shared Function ViewEventNewVlaue(e As Object) As String
        Dim str = ""
        For Each i In e.NewValues
            str += "{k=" + i.key() + "," + "v=" + i.Value().ToString + "} "
        Next
        Return str
    End Function

    Protected Sub RulesGrid_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim rule As New AssignRule

        VarRule(rule, e)
        rule.Source = LeadsSource
        rule.CreateBy = Page.User.Identity.Name
        rule.CreateDate = DateTime.Now

        Using ctx As New Entities
            ctx.AssignRules.Add(rule)
            ctx.SaveChanges()
        End Using
        e.Cancel = True
        RulesGrid.CancelEdit()
        BindRules()
    End Sub

    Protected Sub RulesGrid_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        Dim ruleId = CInt(e.Keys(0))

        Using ctx As New Entities
            Dim rule = ctx.AssignRules.Find(ruleId)
            ctx.AssignRules.Remove(rule)
            ctx.SaveChanges()
        End Using
        e.Cancel = True
        RulesGrid.CancelEdit()
    End Sub
End Class
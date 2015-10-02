Imports System.Drawing
Imports DevExpress.Export
Imports DevExpress.Web
Imports DevExpress.XtraPrinting
Imports IntranetPortal.Data
Imports ShortSale = IntranetPortal.Data

Public Class UCTitleSummary
    Inherits System.Web.UI.UserControl

    Public CurrentUserRole As ShortSaleRole
    Private Const SSReports As String = "SSReport"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CurrentUserRole = Employee.GetShortSaleRole(Page.User.Identity.Name)
            'BindNotes()

            BindData()

            AllLeadsGrid.FilterExpression = "[StatuStr] LIKE '%Active%'"
        End If
    End Sub

    Public ReadOnly Property PortalNotes As List(Of PortalNote)
        Get
            Using Context As New Entities
                Return Context.PortalNotes.ToList
            End Using
        End Get
    End Property

    Public Function GetAddress(ssCase As ShortSaleCase) As String
        ' Return ssCase.PropertyInfo.StreetName
        If ssCase IsNot Nothing Then
            Dim shortsale = CType(ssCase, ShortSaleCase)
            Return shortsale.PropertyInfo.PropertyAddress
        End If
        Return "bad data"
    End Function

    Public Function GetLastActivity(ssCase As ShortSaleCase) As String
        ' Return ssCase.PropertyInfo.StreetName
        If ssCase IsNot Nothing Then
            Dim shortsaled = CType(ssCase, ShortSaleCase)
            Dim lastActivity = shortsaled.PropertyInfo.UpdateDate
            If (lastActivity IsNot Nothing) Then
                Return CType(lastActivity, DateTime).ToString("MM/dd/yy hh:mm tt")
            End If

        End If
        Return "bad data"
    End Function
    Public Property CurrentNote As New PortalNote

    Public Sub BindNotes()
        Dim notes = PortalNotes

        If notes IsNot Nothing AndAlso notes.Count > 0 Then
            CurrentNote = notes(0)
            txtTitle.Text = notes(0).Title
            txtNotesDescription.Text = notes(0).Description
        Else
            CurrentNote = New PortalNote
            txtTitle.Text = CurrentNote.Title
            txtNotesDescription.Text = CurrentNote.Description
        End If
    End Sub

    Public ReadOnly Property Quote As String
        Get
            Using Context As New Entities
                Dim id = New Random().Next(3, 200)
                Dim qu = Context.PortalQuotes.Where(Function(q) q.QuoteID = id).SingleOrDefault

                If qu Is Nothing Then
                    Return ""
                Else
                    Return qu.Quote
                End If
            End Using
        End Get
    End Property

    Sub BindData()

        BindUrgent()
        BindUpcomingBPO()
        BindCounterOffer()
        BindInvestorReview()
        BindTask()
        Return

        Select Case CurrentUserRole
            Case ShortSaleRole.Manager
                BindUrgent()
                BindUpcomingBPO()
                BindCounterOffer()
                BindInvestorReview()
                BindTask()
            'BindDocumentRequest()
            Case ShortSaleRole.Negotiator
                BindFollowUp()
                BindUpcomingBPO()
                BindCounterOffer()
                BindInvestorReview()
            Case ShortSaleRole.Processor
                BindUpcomingBPO()
                BindDocumentRequest()
                BindFollowUp()
                BindTask()
        End Select

        Return
        'Bind All Leads Grid
        AllLeadsGrid.DataSource = ShortSale.ShortSaleSummary.GetAllCase(Employee.CurrentAppId)
        AllLeadsGrid.DataBind()
        RefreshGrid()
    End Sub

#Region "Bind Datagridview"
    Private Sub BindUrgent()
        tdUrgent.Visible = True
        'Bind Urgent Data
        gridUrgent.DataSource = ShortSale.ShortSaleCase.GetCaseByCategory("Assign", Employee.CurrentAppId) 'ShortSaleSummary.GetUrgentCases()
        gridUrgent.DataBind()
    End Sub

    Private Sub BindUpcomingBPO()
        tdUpcomingBPO.Visible = True
        'Bind Priority Data
        Dim priorityData = ShortSale.ShortSaleCase.GetCaseByCategory("Upcoming", Employee.CurrentAppId) 'ShortSale.ShortSaleSummary.GetUpcomingClosings()

        gridUpcomingApproval.DataSource = priorityData
        gridUpcomingApproval.DataBind()

        If Not Page.IsPostBack Then
            gridUpcomingApproval.GroupBy(gridUpcomingApproval.Columns("SaleDate"))
        End If
    End Sub

    Private Sub BindCounterOffer()
        tdCounterOffer.Visible = True
        CounterOfferGrid.DataSource = ShortSale.ShortSaleCase.GetCaseByMortgageStatus({"Counter Offer - Bank", "Counter Offer - Buyer"}, Employee.CurrentAppId) 'ShortSaleSummary.GetCaseByMortStatus("Counter Offer")
        CounterOfferGrid.DataBind()
    End Sub

    Private Sub BindInvestorReview()
        tdInvestorReview.Visible = True
        InvestorReviewGrid.DataSource = ShortSale.ShortSaleCase.GetCaseByMortgageStatus({"Investor Review"}, Employee.CurrentAppId)
        InvestorReviewGrid.DataBind()
    End Sub

    Private Sub BindDocumentRequest()
        tdDocumentReq.Visible = True
        DocumentRequestsGrid.DataSource = ShortSaleSummary.GetCaseByMortStatus("Document Request")
        DocumentRequestsGrid.DataBind()
    End Sub

    Private Sub BindTask()
        tdTask.Visible = True
        gridTask.DataSource = WorkflowService.GetMyWorklist()
        gridTask.DataBind()
    End Sub

    Private Sub BindFollowUp()
        tdFollowup.Visible = True
        'Bind Callback data
        Dim callbackleads = ShortSale.ShortSaleSummary.GetFollowUpCases()
        gridFollowUp.DataSource = callbackleads
        gridFollowUp.DataBind()
        CType(gridFollowUp.Columns("UpdateDate"), GridViewDataColumn).GroupBy()
        'gridCallback.GroupBy(gridCallback.Columns("CallbackDate"))
    End Sub

    Private Sub gridview_OnDataBinding(sender As Object, e As EventArgs) Handles gridUrgent.DataBinding, gridUpcomingApproval.DataBinding, CounterOfferGrid.DataBinding, InvestorReviewGrid.DataBinding, DocumentRequestsGrid.DataBinding, gridTask.DataBinding, gridFollowUp.DataBinding, AllLeadsGrid.DataBinding
        Dim grid = CType(sender, ASPxGridView)
        If grid.DataSource Is Nothing AndAlso grid.IsCallback Then
            If grid Is gridUrgent Then
                BindUrgent()
            End If

            If grid Is gridUpcomingApproval Then
                BindUpcomingBPO()
            End If

            If grid Is CounterOfferGrid Then
                BindCounterOffer()
            End If

            If grid Is InvestorReviewGrid Then
                BindInvestorReview()
            End If

            If grid Is DocumentRequestsGrid Then
                BindDocumentRequest()
            End If

            If grid Is gridTask Then
                BindTask()
            End If

            If grid Is gridFollowUp Then
                BindFollowUp()
            End If

            If grid Is AllLeadsGrid Then
                'Bind All Leads Grid
                AllLeadsGrid.DataSource = ShortSale.ShortSaleSummary.GetAllCase(Employee.CurrentAppId)
            End If
        End If
    End Sub
#End Region

    Public Function CaseNameOfDocumentRequest() As String
        Return ""
    End Function

    'change the quote to the UI by steven
    Public Function HtmlBlackQuote(quote As String) As String
        Dim spliteSymble As String = "-"
        If (quote.IndexOf("~") <> 0) Then
            spliteSymble = "~"
        End If
        If (quote.IndexOf("–") <> 0) Then
            spliteSymble = "–"
        End If

        If (quote.IndexOf("~") <> 0) Then
            spliteSymble = "~"
        End If
        Dim strArry As String() = quote.Split(New Char() {spliteSymble})
        If strArry Is Nothing Or strArry.Length < 2 Then
            Return quote
        End If
        Dim FontStr As String = ""
        Dim EndStr As String = ""

        FontStr = strArry(0)

        EndStr = strArry(1)

        Return String.Format("{0}<br>-<span style=""font-weight:700;"">{1}</span>", FontStr, EndStr)
        'Return "<span style=""font-weight: 900;""> 720 QUINCY ST</span> - " & leadData
    End Function

    'Change to span let it show the blod font by steven <span style="font-weight: 900;"> 720 QUINCY ST</span> by steven
    Public Function HtmlBlackInfo(leadData As String) As String
        Dim symble = "-"

        Dim strArry As String() = leadData.Split(New Char() {symble})
        If strArry Is Nothing Or strArry.Length < 2 Then
            Return leadData
        End If
        Dim FontStr As String = ""
        Dim EndStr As String = ""

        FontStr = strArry(0)

        EndStr = strArry(1)

        If strArry.Length > 2 Then
            FontStr = FontStr + "-" + EndStr
            EndStr = strArry(2)
        End If

        Return String.Format("<span style=""font-weight: 900;"">{0}</span>-{1}", FontStr, EndStr)
        'Return "<span style=""font-weight: 900;""> 720 QUINCY ST</span> - " & leadData
    End Function

    Public Function GroupText(groupDateText As String) As String
        Dim today = DateTime.Now.Date

        If String.IsNullOrEmpty(groupDateText) Then
            Return "Today"
        End If

        Dim groupDate = Date.Parse(groupDateText).Date
        If today >= groupDate Then
            Return "Today"
        Else
            If today.AddDays(1).Equals(groupDate) Then
                Return "Tomorrow"
            Else
                Return "Future"
            End If
        End If
    End Function

    Protected Sub gridAppointment_CustomColumnGroup(sender As Object, e As CustomColumnSortEventArgs) Handles gridTask.CustomColumnGroup, gridFollowUp.CustomColumnGroup
        If e.Column.FieldName = "ScheduleDate" Or e.Column.FieldName = "CallbackDate" Then
            Dim today = DateTime.Now.Date
            Dim day1 = CDate(e.Value1).Date
            Dim day2 = CDate(e.Value2).Date

            If day1 <= today Then
                day1 = today
            Else
                If day1 >= today.AddDays(2) Then
                    day1 = today.AddDays(2)
                End If
            End If

            If day2 <= today Then
                day2 = today
            Else
                If day2 >= today.AddDays(2) Then
                    day2 = today.AddDays(2)
                End If
            End If

            Dim res As Integer
            If day1 = day2 Then
                res = 0
            End If

            If day1 < day2 Then
                res = 1
            End If

            If day1 > day2 Then
                res = -1
            End If

            e.Result = res
            e.Handled = True

        End If
    End Sub

    Protected Sub gridAppointment_CustomColumnDisplayText(sender As Object, e As ASPxGridViewColumnDisplayTextEventArgs) Handles gridTask.CustomColumnDisplayText, gridFollowUp.CustomColumnDisplayText
        If e.Column.FieldName = "ScheduleDate" Or e.Column.FieldName = "CallbackDate" Then
            e.DisplayText = GroupText(e.Value)
        End If
    End Sub

    Protected Sub notesCallbackPanel_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        Using Context As New Entities

            If e.Parameter.StartsWith("Show") Then
                Dim note = Context.PortalNotes.Find(CInt(e.Parameter.Split("|")(1)))
                If note IsNot Nothing Then
                    CurrentNote = note
                    txtTitle.Text = note.Title
                    txtNotesDescription.Text = note.Description
                End If
            End If

            If e.Parameter.StartsWith("Save") Then
                Dim noteId = CInt(e.Parameter.Split("|")(1))

                If noteId <= 0 Then
                    Dim newNote = New PortalNote
                    newNote.Title = txtTitle.Text
                    newNote.Description = txtNotesDescription.Text
                    newNote.Createby = Page.User.Identity.Name
                    newNote.CreateTime = DateTime.Now

                    Context.PortalNotes.Add(newNote)
                    Context.SaveChanges()
                    CurrentNote = newNote
                Else
                    Dim note = Context.PortalNotes.Find(CInt(e.Parameter.Split("|")(1)))
                    If note IsNot Nothing Then
                        note.Title = txtTitle.Text
                        note.Description = txtNotesDescription.Text
                        note.UpdateBy = Page.User.Identity.Name
                        note.UpdateTime = DateTime.Now

                        Context.SaveChanges()
                        CurrentNote = note
                    End If
                End If
                'Side Notes: Input area should always be at default status (always clear), List should be pushed below. When clicked on a existing item, should be able to edit directly.
                txtTitle.Text = ""
                txtNotesDescription.Text = ""
            End If

            If e.Parameter.StartsWith("Delete") Then
                Dim note = Context.PortalNotes.Find(CInt(e.Parameter.Split("|")(1)))
                If note IsNot Nothing Then
                    Context.PortalNotes.Remove(note)
                    Context.SaveChanges()

                    BindNotes()
                End If
            End If

            If e.Parameter.StartsWith("Add") Then
                Dim note As New PortalNote
                note.NoteId = -1
                CurrentNote = note

                txtTitle.Text = ""
                txtNotesDescription.Text = ""
            End If
        End Using
    End Sub

    Protected Sub todayScheduler_PopupMenuShowing(sender As Object, e As DevExpress.Web.ASPxScheduler.PopupMenuShowingEventArgs)
        e.Menu.Items.Clear()
    End Sub

    Protected Sub ExportExcel_Click(sender As Object, e As EventArgs)
        'If AllLeadsGrid.DataSource Is Nothing Then
        '    AllLeadsGrid.DataSource = ShortSaleCase.GetAllCase
        '    AllLeadsGrid.DataBind()
        'End If

        gridData.DataSource = ShortSaleCase.CaseReport2(Employee.CurrentAppId)
        gridData.DataBind()

        AllLeadGridViewExporter.FileName = String.Format("All-{0}-{1}-{2}.xlsx", Today.Month, Today.Day, Today.Year)
        AllLeadGridViewExporter.WriteXlsToResponse(New XlsExportOptionsEx() With {.ExportType = ExportType.WYSIWYG})
    End Sub

    Protected Sub ExportPdf_Click(sender As Object, e As EventArgs)
        AllLeadsGrid.DataSource = ShortSale.ShortSaleSummary.GetAllCase(Employee.CurrentAppId)
        AllLeadsGrid.DataBind()

        gridExporter.FileName = String.Format("GridData-{0}-{1}-{2}.xlsx", Today.Month, Today.Day, Today.Year)
        gridExporter.WriteXlsToResponse(New XlsExportOptionsEx() With {.ExportType = ExportType.WYSIWYG})
    End Sub

    'Protected Sub SearchBtn_Click(sender As Object, e As EventArgs)
    '    If QuickSearch.Value IsNot Nothing AndAlso QuickSearch.Value.Length > 0 Then
    '        AllLeadsGrid.DataColumns("PropertyInfo.StreetName").Settings.AllowAutoFilter = AutoFilterCondition.Like

    '        AllLeadsGrid.AutoFilterByColumn(AllLeadsGrid.Columns("PropertyInfo.StreetName"), QuickSearch.Value)
    '    End If
    'End Sub  
    Private Sub RefreshGrid()
        Dim showColumn = chkFields.SelectedValues
        For Each c In AllLeadsGrid.AllColumns
            Dim column = CType(c, GridViewDataColumn)
            Dim name = column.FieldName

            If String.IsNullOrEmpty(name) Then
                name = column.Name
            End If

            c.Visible = showColumn.Contains(name)
        Next
    End Sub

    Protected Sub AllLeadsGrid_OnCustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs)
        RefreshGrid()

        If e.Parameters = "Load" Then
            AllLeadsGrid.DataBind()
        End If

        'If e.Parameters.StartsWith("SaveLayout") Then

        '    Dim name = e.Parameters.Split("|")(1)

        '    Dim up = Employee.GetProfile(Page.User.Identity.Name)

        '    Dim ssReport As Dictionary(Of String, Object) = up.GetData("SSReport")

        '    If ssReport Is Nothing Then
        '        ssReport = New Dictionary(Of String, Object)
        '    End If

        '    If Not ssReport.ContainsKey(name) Then
        '        ssReport.Add(name, AllLeadsGrid.SaveClientLayout())
        '    Else
        '        ssReport(name) = AllLeadsGrid.SaveClientLayout()
        '    End If

        '    up.SetData("SSReport", ssReport)
        '    Employee.SaveProfile(Page.User.Identity.Name, up)
        'End If

        If e.Parameters.StartsWith("LoadLayout") Then
            Dim report = e.Parameters.Split("|")(1)
            Dim up = Employee.GetProfile(Page.User.Identity.Name)
            Dim ssReport As Dictionary(Of String, Object) = up.GetData(SSReports)

            If ssReport IsNot Nothing Then
                AllLeadsGrid.LoadClientLayout(ssReport(report))
            End If
        End If
    End Sub

    Public ReadOnly Property SavedReports() As String()
        Get
            Dim up = Employee.GetProfile(Page.User.Identity.Name)
            Dim ssReport As Dictionary(Of String, Object) = up.GetData(SSReports)
            If ssReport IsNot Nothing Then
                Return ssReport.Keys.ToArray
            End If

            Return {}
        End Get
    End Property

    Protected Sub cbpSavedReport_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If e.Parameter.StartsWith("SaveLayout") Then

            Dim name = e.Parameter.Split("|")(1)

            Dim up = Employee.GetProfile(Page.User.Identity.Name)

            Dim ssReport As Dictionary(Of String, Object) = up.GetData(SSReports)

            If ssReport Is Nothing Then
                ssReport = New Dictionary(Of String, Object)
            End If

            If Not ssReport.ContainsKey(name) Then
                ssReport.Add(name, AllLeadsGrid.SaveClientLayout())
            Else
                ssReport(name) = AllLeadsGrid.SaveClientLayout()
            End If

            up.SetData(SSReports, ssReport)
            Employee.SaveProfile(Page.User.Identity.Name, up)
        End If

        If e.Parameter.StartsWith("RemoveReport") Then
            Dim name = e.Parameter.Replace("RemoveReport|", "")
            Dim up = Employee.GetProfile(Page.User.Identity.Name)

            Dim ssReport As Dictionary(Of String, Object) = up.GetData(SSReports)

            If ssReport IsNot Nothing Then
                If ssReport.ContainsKey(name) Then
                    ssReport.Remove(name)
                End If

                up.SetData(SSReports, ssReport)
            End If

            Employee.SaveProfile(Page.User.Identity.Name, up)
        End If
    End Sub

End Class
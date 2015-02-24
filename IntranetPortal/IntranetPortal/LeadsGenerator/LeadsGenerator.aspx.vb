Imports DevExpress.Web.ASPxGridView

Public Class LeadsGenerator
    Inherits System.Web.UI.Page
    Public ZipCodes As List(Of String)
    Public AllNeighName As List(Of String)
    Public AllZoning As List(Of String)
    Public AllPropertyCode As List(Of String)
    Public CompletedTask As New List(Of LeadsSearchTask)
#If DEBUG Then
    Public MaxSelect = 250
#Else
    Public MaxSelect = 250
#End If

    Public LoadLeadsCount = 0
    Public bfilterOutExist As Boolean = False
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Not Page.IsPostBack) Then
            hfFilterOutExist.Value = "false"
            DataBinds()
            Dim SearchName = (Request.QueryString("n"))
            If (Not String.IsNullOrEmpty(SearchName)) Then
                BindGrid(SearchName)

            End If


            'If (Not String.IsNullOrEmpty(hfSearchName.Value)) Then
            '    BindGrid(hfSearchName.Value)
            'End If
        End If
    End Sub

    Private Sub DataBinds()
        Using context As New Entities

            CompletedTask = context.LeadsSearchTasks.Where(Function(s) s.Status = LeadsSearchTaskStauts.Completed And s.CreateBy = Page.User.Identity.Name).ToList
            ZipCodes = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "ZIP").Select(Function(c) c.Data).ToList
            AllNeighName = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "Neighborhood").Select(Function(c) c.Data).ToList
            AllZoning = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "ZONING").Select(Function(c) c.Data).ToList
            AllPropertyCode = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "PropertyDesc").Select(Function(c) c.Data).ToList
            Dim agents = context.Employees.Where(Function(e) e.Active Or e.Name.Contains("Office")).OrderBy(Function(f) f.Name).Select(Function(e) e.Name).ToList
            EmployeeList.DataSource = agents
            EmployeeList.DataBind()
        End Using
    End Sub

    Public Sub SaveSearchPopup_WindowCallback(Parameter As String)
        Using Context As New Entities
            Dim s = New LeadsSearchTask
            s.TaksName = Parameter.Split("|")(0)

            Dim hasSameTask = Context.LeadsSearchTasks.Where(Function(l) l.TaksName = s.TaksName).FirstOrDefault
            If (hasSameTask IsNot Nothing) Then

                Alert("Already has Search named " + s.TaksName + " please picker another name!")
                Return

            End If
            s.SearchFileds = Parameter.Split("|")(1)
            s.CreateBy = Page.User.Identity.Name
            s.CreateTime = Date.Now
            Context.LeadsSearchTasks.Add(s)
            Context.SaveChanges()

            WorkflowService.StartLeadsSearchProcess(s.TaksName, s.TaksName, s.SearchFileds, s.Id)
            Alert(" Your request has been submitted. Estimated time is 48 hours to upload.<br>The system will notify you upon completion._call_funcClosePupUp")
        End Using
    End Sub


    Protected Sub BindGrid(SearchName As String)
        Using context As New Entities



            Dim results = (From sr In context.SearchResults.Where(Function(s) s.Type = SearchName)
                      From ld In context.Leads.Where(Function(l) sr.BBLE = l.BBLE).DefaultIfEmpty
                      Select New With {
                          .Id = sr.Id,
                          .BBLE = sr.BBLE,
                          .LeadsName = sr.LeadsName,
                          .Neigh_Name = sr.Neigh_Name,
                          .MotgCombo = sr.MotgCombo,
                          .TaxCombo = sr.TaxCombo,
                          .ORIG_SQFT = sr.ORIG_SQFT,
                          sr.CLass,
                          sr.LOT_DIM,
                          sr.Servicer,
                          sr.Type,
                          .AgentInLeads = ld.EmployeeName,
                          sr.PropertyAddress,
                          sr.BLOCK,
                          sr.LOT
                          }).ToList



            'Dim s As SearchResult

            If (String.IsNullOrEmpty(hfFilterOutExist.Value)) Then
                hfFilterOutExist.Value = "false"
            End If
            bfilterOutExist = CBool(hfFilterOutExist.Value)
            If (bfilterOutExist) Then
                results = results.Where(Function(s) s.AgentInLeads Is Nothing).ToList()
            End If
            LoadLeadsCount = results.Count
            QueryResultsGrid.DataSource = results
            QueryResultsGrid.DataBind()
            hfSearchName.Value = SearchName
        End Using
    End Sub

    Protected Sub QueryResultsGrid_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)
        If e.RowType <> GridViewRowType.Data Then
            Return
        End If
        If QueryResultsGrid.DataSource Is Nothing Then
            RefreshGrid()
        End If
        Dim resultId As Integer = Convert.ToInt32(e.GetValue("Id"))

        If (resultId = 0) Then
            Return
        End If
        Dim s = SearchResult.getSeachResult(resultId)

        If Not String.IsNullOrEmpty(s.AgentInLeads) Then
            Dim c = System.Drawing.Color.FromArgb(194, 193, 193)

            e.Row.BackColor = c ' rgb(194, 193, 193)
        End If
    End Sub

    Public Sub Select250_ServerClick()
        If (AlertEmployee()) Then
            Return
        End If
        Dim count = 0
        Dim maxAdd = LeadMaxAdd()
        If (maxAdd < 0) Then
            Alert("You have enough leads in your bank !")
            Return
        End If
        Dim i = 0
        For Each tr In QueryResultsGrid.DataSource
            'Dim resultId As Integer = Convert.ToInt32(rt.Item("Id"))
            'Dim s = SearchResult.getSeachResult(resultId)
            If String.IsNullOrEmpty(tr.AgentInLeads) Then
                QueryResultsGrid.Selection.SelectRow(i)
                count = count + 1
                If (count >= maxAdd) Then
                    Exit For
                End If
            End If
            i = i + 1
        Next

    End Sub
    Protected Sub Alert(message As String)
        ErrorMessage.Item("hidden_value") = message

        'Throw New Exception(message)
    End Sub
    Protected Function HasNewLeadsInProtal() As Integer
        Dim OfficeName = GetImportToUser()
        Using Context As New Entities
            Return Context.Leads.Where(Function(l) l.EmployeeName = OfficeName And l.Status = LeadStatus.NewLead).Count()
        End Using

        Return 0
    End Function
    Protected Function GetImportToUser() As String

        If (AdminLogIn()) Then
            Return EmployeeList.Value
        End If

        Return Employee.GetOfficeAssignAccount(Page.User.Identity.Name)
    End Function

    Protected Function AlertEmployee() As Boolean
        If (AdminLogIn()) Then
            If (String.IsNullOrEmpty(EmployeeList.Value)) Then
                Alert("You have to select Agent")
                Return True
            End If
        End If
        Return False
    End Function
    Public Function AdminLogIn() As Boolean
        Return Employee.IsAdmin(Page.User.Identity.Name)
    End Function
    Protected Function LeadMaxAdd() As Integer
        Return MaxSelect - HasNewLeadsInProtal()
    End Function

    Public Sub ImportSelect_ServerClick()
        If (AlertEmployee()) Then
            Return
        End If
        Dim maxAdd As Integer = LeadMaxAdd()
        Dim selectrows = QueryResultsGrid.GetSelectedFieldValues("BBLE")
        If selectrows.Count <= 0 Then
            Alert("You didn't select leads !")
            Return
        ElseIf (selectrows.Count > maxAdd) Then
            Alert("You have enough leads in bank !")
            Return
        End If
        Dim empOffice = Employee.GetInstance(GetImportToUser())
        If selectrows.Count <= maxAdd Then
            Using Context As New Entities
                For Each row In selectrows
                    Dim l = New Lead
                    l.EmployeeName = empOffice.Name
                    l.EmployeeID = empOffice.EmployeeID
                    l.BBLE = row
                    l.Status = LeadStatus.NewLead
                    l.AssignBy = Page.User.Identity.Name
                    l.AssignDate = Date.Now
                    Dim li = Context.LeadsInfoes.Find(row)
                    If (li Is Nothing) Then
                        li = New LeadsInfo
                        li.BBLE = row
                        Context.LeadsInfoes.Add(li)
                    End If
                   
                    Context.Leads.Add(l)
                Next
                Context.SaveChanges()

                runbDataLoop()
            End Using
        Else
            Alert("Only can import " & maxAdd & " Leads !")
        End If
        RefreshGrid()
    End Sub
    Public Sub RefreshGrid()
        If (Not String.IsNullOrEmpty(hfSearchName.Value)) Then
            BindGrid(hfSearchName.Value)
        End If
    End Sub

    Protected Sub runbDataLoop()
        'To do Chris Need run data loop here!
        'Dim service = LeadsDataManage.LeadsDataService.GetInstance
        'service.DataLoop("New")
        Core.DataLoopRule.AddRules(LeadsInfo.GetNewLeads, Core.DataLoopRule.DataLoopType.All, Page.User.Identity.Name)
    End Sub

    Protected Sub cpTableView_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If (e.Parameter.StartsWith("loadFunction")) Then
            Dim funName = e.Parameter.Split("|")(1)
            Dim funCall = "|" + funName + "|"
            Dim indexFunCall = e.Parameter.IndexOf(funCall)
            If (indexFunCall > 0) Then

                Dim parameter = e.Parameter.Substring(indexFunCall + funCall.Length)
                CallByName(Me, funName, CallType.Method, parameter)
            Else
                CallByName(Me, funName, CallType.Method)
            End If

        Else
            Dim SearchName = e.Parameter

            BindGrid(SearchName)

        End If
    End Sub

    Protected Sub btnXlsxExport_Click(sender As Object, e As EventArgs)
        gridExport.WriteXlsxToResponse()
    End Sub

    Protected Sub QueryResultsGrid_CommandButtonInitialize(sender As Object, e As ASPxGridViewCommandButtonEventArgs)
        'If (QueryResultsGrid.DataSource Is Nothing) Then
        '    BindGrid(hfSearchName.Value)
        'End If

        Dim gvCommandButton = CType(e, ASPxGridViewCommandButtonEventArgs)
        Dim ag = CType(QueryResultsGrid.GetRow(e.VisibleIndex), Object)
        If ag IsNot Nothing Then
            If Not String.IsNullOrEmpty(ag.AgentInLeads) Then
                e.Visible = False
                e.Enabled = False
            End If
        End If

    End Sub




    Public Sub dxfilterOutExist_CheckedChanged(e As String)
        hfFilterOutExist.Value = e
        If (Not String.IsNullOrEmpty(hfSearchName.Value)) Then
            BindGrid(hfSearchName.Value)
        End If
    End Sub

    Protected Sub QueryResultsGrid_DataBinding(sender As Object, e As EventArgs)
        If QueryResultsGrid.DataSource Is Nothing Then
            BindGrid(hfSearchName.Value)
        End If
    End Sub
End Class
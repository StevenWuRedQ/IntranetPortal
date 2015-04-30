Imports DevExpress.Web.ASPxGridView

Public Class LeadsGenerator
    Inherits System.Web.UI.Page
    Public ZipCodes As List(Of String)
    Public AllNeighName As List(Of String)
    Public AllZoning As List(Of String)
    Public AllPropertyCode As List(Of String)
    Public CompletedTask As New List(Of LeadsSearchTask)
#If DEBUG Then
    Public MaxSelect = 500
#Else
    Public MaxSelect = 500
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
            s.Type = s.TaksName.Split(",")(1)
            s.TaksName = s.TaksName.Split(",")(0)
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
                      Let ld = context.Leads.Where(Function(l) sr.BBLE = l.BBLE).FirstOrDefault
                      Let pendingAgent = context.PendingAssignLeads.Where(Function(p) p.BBLE = sr.BBLE).FirstOrDefault
                      Let AgentInLeads = If(pendingAgent IsNot Nothing, pendingAgent.EmployeeName, ld.EmployeeName)
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
                          .AgentInLeads = AgentInLeads,
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
            Dim st = context.LeadsSearchTasks.Where(Function(f) f.TaksName = SearchName).FirstOrDefault

            hfSearchType.Value = If(st IsNot Nothing, st.Type, "0")


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
        Dim maxAdd = If(AdminLogIn(), MaxSelect, LeadMaxAdd())
        If (maxAdd <= 0) Then
            Alert(GetImportToUser() & " has enough leads in his bank !")
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
            Dim inPadding = Context.PendingAssignLeads.Where(Function(p) p.EmployeeName = OfficeName AndAlso (p.Status = 0 Or p.Status = 1)).Count
            Return Context.Leads.Where(Function(l) l.EmployeeName = OfficeName And l.Status = LeadStatus.NewLead).Count() + inPadding
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
        'admin can import more than 250
        If (AdminLogIn()) Then
            Return 99999999
        End If
        Return MaxSelect - HasNewLeadsInProtal()
    End Function

    Public Sub ImportSelect_ServerClick()

        If (Core.TLOApiLog.LimiteIsExceed) Then
            Alert("Monthly resource used up please try it next month !")
            Return
        End If
        If (AlertEmployee()) Then
            Return
        End If
        Dim maxAdd As Integer = LeadMaxAdd()
        Dim selectrows = QueryResultsGrid.GetSelectedFieldValues("BBLE")
        If selectrows.Count <= 0 Then
            Alert("You didn't select leads !")
            Return
        ElseIf (selectrows.Count > maxAdd) Then
            Alert(GetImportToUser() & " has enough leads in bank !")
            Return
        End If
        Dim empOffice = Employee.GetInstance(GetImportToUser())
        ' Dim BBlesList = New List(Of String)
        If selectrows.Count <= maxAdd Then
            Using Context As New Entities
                For Each row In selectrows

                    'l.EmployeeName = empOffice.Name
                    'l.EmployeeID = empOffice.EmployeeID
                    'l.BBLE = row
                    'l.Status = LeadStatus.NewLead
                    'l.AssignBy = Page.User.Identity.Name
                    'l.AssignDate = Date.Now


                    Dim pa = Context.PendingAssignLeads.Find(row)
                    If (pa Is Nothing) Then
                        pa = New PendingAssignLead
                        pa.BBLE = row
                        Context.PendingAssignLeads.Add(pa)
                    End If
                    pa.EmployeeName = empOffice.Name
                    pa.CreateBy = Page.User.Identity.Name
                    pa.CreateDate = Date.Now
                    pa.Status = 0
                    If (hfSearchType.Value IsNot Nothing AndAlso hfSearchType.Value <> "") Then
                        pa.Type = CInt(hfSearchType.Value)
                    Else
                        pa.Type = 0
                    End If


                    'li = New LeadsInfo
                    'li.Type = CInt(hfSearchType.Value)
                    'li.BBLE = row
                    'Context.LeadsInfoes.Add(li)



                    'BBlesList.Add(row.ToString)
                Next
                Context.SaveChanges()

                'UploadSearchInfo2Portal take long time for right now terminate it 
                'Context.UploadSearchInfo2Portal()
                'Context.SaveChanges()
            End Using
            'please build address after loop finish
            'runDataLoop(BBlesList)
        Else
            Alert("Only can import " & maxAdd & " Leads !")
        End If
        RefreshGrid()
        QueryResultsGrid.Selection.UnselectAll()
    End Sub
    Public Sub RefreshGrid()
        If (Not String.IsNullOrEmpty(hfSearchName.Value)) Then
            BindGrid(hfSearchName.Value)
        End If
    End Sub

    Protected Sub runDataLoop(bbles As List(Of String))
        'To do Chris Need run data loop here!
        'Dim service = LeadsDataManage.LeadsDataService.GetInstance
        'service.DataLoop("New")
        Core.DataLoopRule.AddRulesUnique(bbles.ToArray, Core.DataLoopRule.DataLoopType.All, Page.User.Identity.Name)
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
            Dim nameUrl = HttpUtility.UrlDecode(SearchName)
            BindGrid(nameUrl)

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
Imports DevExpress.Web.ASPxEditors

Public Class LeadsManagement
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindData()
        End If
    End Sub

    Sub BindData()
        If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
            Dim mgrName = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            BindTeamList(mgrName)
            BindTeamEmployees(mgrName)
            AssignLeadsPopup.LeadsSource = mgrName
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("office")) Then
            Dim office = Request.QueryString("office").ToString
            BindOfficeLeads(office)
            BindOfficeEmployee(office)
            AssignLeadsPopup.LeadsSource = office & " Office"
        Else
            BindNewestLeads()
            'gridLeads.DataBind()
            BindEmployeeList()
        End If
    End Sub
 
    Sub BindLeads()
        If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
            Dim mgrName = Employee.GetInstance(CInt(Request.QueryString("mgr"))).Name
            BindTeamList(mgrName)
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("office")) Then
            Dim office = Request.QueryString("office").ToString
            BindOfficeLeads(office)
        Else
            BindNewestLeads()
        End If
    End Sub

    Sub BindNewestLeads()
        Using Context As New Entities
            If User.IsInRole("Admin") Then

                Dim lds = From ld In Context.LeadsInfoes.Where(Function(l) l.Lead Is Nothing)
                          Let TaxCobo = Context.LeadsTaxLiens.Where(Function(t) t.BBLE = ld.BBLE).FirstOrDefault
                          Let Mort = Context.LeadsMortgageDatas.Where(Function(l) l.BBLE = ld.BBLE).FirstOrDefault
                          Let Recycle = Context.LeadsActivityLogs.Any(Function(l) l.BBLE = ld.BBLE)
                          Let MortgageCombo = (If(ld.C1stMotgrAmt.HasValue, ld.C1stMotgrAmt, 0) + If(ld.C2ndMotgrAmt.HasValue, ld.C2ndMotgrAmt, 0) + If(ld.C3rdMortgrAmt.HasValue, ld.C3rdMortgrAmt, 0))
                          Select New With {
                              .BBLE = ld.BBLE,
                              .PropertyAddress = ld.PropertyAddress,
                              .Number = ld.Number,
                              .Street = ld.StreetName,
                              .Owner = ld.Owner,
                              .CoOwner = ld.CoOwner,
                              .Neighborhood = ld.NeighName,
                              .NYCSqft = ld.NYCSqft,
                              .C1 = ld.C1stMotgrAmt,
                              .C2 = ld.C2ndMotgrAmt,
                              .C3 = ld.C3rdMortgrAmt,
                              .LotDem = ld.LotDem,
                              .PropertyClass = ld.PropertyClass,
                              .MortgageCombo = MortgageCombo,
                              .C1stServicer = Mort.C1stServicer,
                              .TaxLiensAmount = If(TaxCobo.Amount = 0, "Not Avaiable", ""),
                              .Type = ld.Type,
                              .IsRecycled = Recycle
                              }

                gridLeads.DataSource = lds.ToList ' Context.LeadsInfoes.Where(Function(l) l.Lead Is Nothing).ToList
                gridLeads.DataBind()
            Else
                If Employee.IsManager(User.Identity.Name) Then
                    Dim name = User.Identity.Name
                    'gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = name And li.Lead.Status = LeadStatus.NewLead).ToList

                    Dim lds = From ld In Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = name And li.Lead.Status = LeadStatus.NewLead)
                       Let TaxCobo = Context.LeadsTaxLiens.Where(Function(t) t.BBLE = ld.BBLE).FirstOrDefault
                       Let Mort = Context.LeadsMortgageDatas.Where(Function(l) l.BBLE = ld.BBLE).FirstOrDefault
                       Let Recycle = Context.LeadsActivityLogs.Any(Function(l) l.BBLE = ld.BBLE)
                       Let MortgageCombo = (If(ld.C1stMotgrAmt.HasValue, ld.C1stMotgrAmt, 0) + If(ld.C2ndMotgrAmt.HasValue, ld.C2ndMotgrAmt, 0) + If(ld.C3rdMortgrAmt.HasValue, ld.C3rdMortgrAmt, 0))
                       Select New With {
                           .BBLE = ld.BBLE,
                           .PropertyAddress = ld.PropertyAddress,
                           .Number = ld.Number,
                           .Street = ld.StreetName,
                           .Owner = ld.Owner,
                           .CoOwner = ld.CoOwner,
                           .Neighborhood = ld.NeighName,
                           .NYCSqft = ld.NYCSqft,
                           .C1 = ld.C1stMotgrAmt,
                           .C2 = ld.C2ndMotgrAmt,
                           .C3 = ld.C3rdMortgrAmt,
                           .LotDem = ld.LotDem,
                           .PropertyClass = ld.PropertyClass,
                           .MortgageCombo = MortgageCombo,
                           .C1stServicer = Mort.C1stServicer,
                           .TaxLiensAmount = If(TaxCobo.Amount = 0, "Not Avaiable", ""),
                           .Type = ld.Type,
                           .IsRecycled = Recycle
                           }

                    gridLeads.DataSource = lds.ToList
                    gridLeads.DataBind()

                    AssignLeadsPopup.LeadsSource = name
                End If
            End If
        End Using
    End Sub

    Sub BindTeamList(mgrName As String)
        Using Context As New Entities
            'gridLeads.DataSource = Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = mgrName And li.Lead.Status = LeadStatus.NewLead).ToList
            Dim lds = From ld In Context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = mgrName And li.Lead.Status = LeadStatus.NewLead)
                      Let TaxCobo = Context.LeadsTaxLiens.Where(Function(t) t.BBLE = ld.BBLE).FirstOrDefault
                      Let Mort = Context.LeadsMortgageDatas.Where(Function(l) l.BBLE = ld.BBLE).FirstOrDefault
                      Let Recycle = Context.LeadsActivityLogs.Any(Function(l) l.BBLE = ld.BBLE)
                      Let MortgageCombo = (If(ld.C1stMotgrAmt.HasValue, ld.C1stMotgrAmt, 0) + If(ld.C2ndMotgrAmt.HasValue, ld.C2ndMotgrAmt, 0) + If(ld.C3rdMortgrAmt.HasValue, ld.C3rdMortgrAmt, 0))
                      Select New With {
                          .BBLE = ld.BBLE,
                          .PropertyAddress = ld.PropertyAddress,
                          .Number = ld.Number,
                          .Street = ld.StreetName,
                          .Owner = ld.Owner,
                          .CoOwner = ld.CoOwner,
                          .Neighborhood = ld.NeighName,
                          .NYCSqft = ld.NYCSqft,
                          .C1 = ld.C1stMotgrAmt,
                          .C2 = ld.C2ndMotgrAmt,
                          .C3 = ld.C3rdMortgrAmt,
                          .LotDem = ld.LotDem,
                          .PropertyClass = ld.PropertyClass,
                          .MortgageCombo = MortgageCombo,
                          .C1stServicer = Mort.C1stServicer,
                          .TaxLiensAmount = If(TaxCobo.Amount = 0, "Not Avaiable", ""),
                          .Type = ld.Type,
                          .IsRecycled = Recycle
                          }

            gridLeads.DataSource = lds.ToList
            gridLeads.DataBind()
        End Using
    End Sub

    Sub BindOfficeLeads(office As String)
        Dim officeName = office & " Office"

        Dim unActiveUser = Employee.GetDeptUsersList(office, False).Select(Function(emp) emp.Name).ToArray
        Using Context As New Entities
            Dim lds = (From li In Context.LeadsInfoes
                                   Join ld In Context.Leads On ld.BBLE Equals li.BBLE
                                   Let TaxCobo = Context.LeadsTaxLiens.Where(Function(t) t.BBLE = ld.BBLE).FirstOrDefault
                                   Let Mort = Context.LeadsMortgageDatas.Where(Function(l) l.BBLE = ld.BBLE).FirstOrDefault
                                   Let Recycle = Context.LeadsActivityLogs.Any(Function(l) l.BBLE = ld.BBLE)
                                   Let MortgageCombo = (If(li.C1stMotgrAmt.HasValue, li.C1stMotgrAmt, 0) + If(li.C2ndMotgrAmt.HasValue, li.C2ndMotgrAmt, 0) + If(li.C3rdMortgrAmt.HasValue, li.C3rdMortgrAmt, 0))
                                   Where ld.EmployeeName = officeName Or (unActiveUser.Contains(ld.EmployeeName) And ld.Status <> LeadStatus.InProcess)
                                    Select New With {
                                      .BBLE = ld.BBLE,
                                      .PropertyAddress = li.PropertyAddress,
                                      .Number = li.Number,
                                      .Street = li.StreetName,
                                      .Owner = li.Owner,
                                      .CoOwner = li.CoOwner,
                                      .Neighborhood = li.NeighName,
                                      .NYCSqft = li.NYCSqft,
                                      .C1 = li.C1stMotgrAmt,
                                      .C2 = li.C2ndMotgrAmt,
                                      .C3 = li.C3rdMortgrAmt,
                                      .LotDem = li.LotDem,
                                      .PropertyClass = li.PropertyClass,
                                      .MortgageCombo = MortgageCombo,
                                      .C1stServicer = Mort.C1stServicer,
                                      .TaxLiensAmount = If(TaxCobo.Amount = 0, "Not Avaiable", ""),
                                      .Type = li.Type,
                                      .IsRecycled = Recycle
                                      })
            gridLeads.DataSource = lds.ToList
            gridLeads.DataBind()
        End Using
    End Sub

    Sub BindOfficeEmployee(office As String)
        Using Context As New Entities
            'If Page.User.IsInRole("Admin") Then
            '    Dim emps = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
            '    listboxEmployee.DataSource = emps
            '    listboxEmployee.DataBind()

            '    AssignLeadsPopup.LeadsSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)
            '    Return
            'End If

            If String.IsNullOrEmpty(Request.QueryString("team")) Then
                Dim emps = Employee.GetDeptUsersList(office)
                listboxEmployee.DataSource = emps
                listboxEmployee.DataBind()

                AssignLeadsPopup.EmployeeSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)
            Else
                Dim teamId = CInt(Request.QueryString("team"))
                Dim emps = Employee.GetTeamUserList(teamId)
                listboxEmployee.DataSource = emps
                listboxEmployee.DataBind()

                AssignLeadsPopup.EmployeeSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)
            End If

            AddDeadLeadsFolderToEmpList()
        End Using
    End Sub

    Sub BindEmployeeList()
        Using Context As New Entities
            If Page.User.IsInRole("Admin") Then
                Dim emps1 = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
                listboxEmployee.DataSource = emps1
                listboxEmployee.DataBind()

                AssignLeadsPopup.EmployeeSource = String.Join(",", emps1.Select(Function(em) em.Name).ToArray)
                Return
            End If

            If String.IsNullOrEmpty(Page.User.Identity.Name) Then
                Return
            End If


            Dim mgr = Employee.GetInstance(Page.User.Identity.Name)
            Dim emps = Employee.GetSubOrdinate(mgr.EmployeeID)
            emps.Add(mgr)

            listboxEmployee.DataSource = emps
            listboxEmployee.DataBind()
            AssignLeadsPopup.EmployeeSource = String.Join(",", emps.Select(Function(em) em.Name).ToArray)

            AddDeadLeadsFolderToEmpList()
        End Using
    End Sub

    Sub BindTeamEmployees(teamMgr As String)
        Dim mgr = Employee.GetInstance(teamMgr)
        Dim emps = Employee.GetSubOrdinate(mgr.EmployeeID)
        emps.Add(mgr)

        listboxEmployee.DataSource = emps
        listboxEmployee.DataBind()

        AssignLeadsPopup.EmployeeSource = String.Join(",", emps)

        AddDeadLeadsFolderToEmpList()
    End Sub

    Sub AddDeadLeadsFolderToEmpList()
        Dim dealleads = Employee.GetInstance("Dead Leads")
        listboxEmployee.Items.Add(New ListEditItem(dealleads.Name, dealleads.EmployeeID))
    End Sub

    Protected Sub btnAssign_Click(sender As Object, e As EventArgs)
        If gridLeads.Selection.Count > 0 AndAlso listboxEmployee.SelectedItem IsNot Nothing Then
            Dim selectedLeads = gridLeads.GetSelectedFieldValues("BBLE", "LeadsName", "Neighborhood")

            Using Context As New Entities
                For Each lead In selectedLeads
                    Dim bble = lead(0).ToString
                    Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault
                    If newlead Is Nothing Then
                        newlead = New Lead() With {
                                          .BBLE = lead(0).ToString,
                                          .LeadsName = lead(1).ToString,
                                          .Neighborhood = lead(2),
                                          .EmployeeID = CInt(listboxEmployee.SelectedItem.Value),
                                          .EmployeeName = listboxEmployee.SelectedItem.Text,
                                          .Status = LeadStatus.NewLead,
                                          .AssignDate = DateTime.Now,
                                        .AssignBy = User.Identity.Name
                                          }
                        Context.Leads.Add(newlead)
                    Else
                        newlead.LeadsName = lead(1)
                        newlead.Neighborhood = lead(2)
                        newlead.EmployeeID = CInt(listboxEmployee.SelectedItem.Value)
                        newlead.EmployeeName = listboxEmployee.SelectedItem.Text
                        newlead.Status = LeadStatus.NewLead
                        newlead.AssignDate = DateTime.Now
                        newlead.AssignBy = User.Identity.Name
                    End If
                Next
                If Context.GetValidationErrors().Count > 0 Then
                    Throw New Exception("Exception Occured in Assign: " & Context.GetValidationErrors()(0).ValidationErrors(0).ErrorMessage)
                Else
                    Context.SaveChanges()
                End If
            End Using

            'BindNewestLeads()

            'gridLeads.DataBind()
        End If
        'BindData()
        Dim script = "<script type=""text/javascript"">"
        script += "gridLeads.Refresh();"

        script += "</script>"

        If Not Page.ClientScript.IsStartupScriptRegistered("Refresh") Then
            Page.ClientScript.RegisterStartupScript(Me.GetType, "Refresh", script)
        End If
    End Sub

    Protected Sub gridLeads_DataBinding(sender As Object, e As EventArgs)
        If gridLeads.DataSource Is Nothing Then
            BindLeads()
        End If
    End Sub

    Protected Sub gridLeads_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)
        If Not e.RowType = DevExpress.Web.ASPxGridView.GridViewRowType.Data Then
            Return
        End If

        Dim imgType = TryCast(gridLeads.FindRowCellTemplateControl(e.VisibleIndex, gridLeads.Columns("Type"), "imgType"), ASPxImage)
        imgType.ClientSideEvents.Click = String.Format("function(s,e){{tempBBLE={0};leadsTypeMenu.ShowAtElement(s.GetMainElement());}}", e.GetValue("BBLE"))

        If e.GetValue("Type") IsNot Nothing Then
            Dim type = CType(e.GetValue("Type"), LeadsInfo.LeadsType)
            imgType.ToolTip = type.ToString
            imgType.Visible = True
            imgType.ImageUrl = TypeImages(e.GetValue("Type"))
        End If
    End Sub

    Protected Sub updateLeadsType_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If Not String.IsNullOrEmpty(e.Parameter) Then
            Dim bble = e.Parameter.Split("|")(0)
            Dim type = e.Parameter.Split("|")(1)

            Using Context As New Entities
                Dim ld = Context.LeadsInfoes.Find(bble)
                If ld IsNot Nothing Then
                    ld.Type = ld.GetLeadsType(type)
                    Context.SaveChanges()
                End If
            End Using
        End If
    End Sub

    Private _typeImages As StringDictionary
    Public ReadOnly Property TypeImages As StringDictionary
        Get
            If _typeImages Is Nothing Then
                _typeImages = New StringDictionary
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.DevelopmentOpportunity, "~/images/lr_dev_opportunity.png")
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.Foreclosure, "~/images/lr_forecosure.png")
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.HasEquity, "~/images/lr_has_equity.png")
                _typeImages.Add(IntranetPortal.LeadsInfo.LeadsType.TaxLien, "~/images/lr_tax_lien.png")
            End If

            Return _typeImages
        End Get
    End Property

    Protected Sub gridLeads_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters.StartsWith("AssignLeads") Then
            If gridLeads.Selection.Count > 0 AndAlso listboxEmployee.SelectedItem IsNot Nothing Then
                Dim selectedLeads = gridLeads.GetSelectedFieldValues("BBLE", "LeadsName", "Neighborhood")

                Using Context As New Entities
                    For Each lead In selectedLeads
                        Dim bble = lead(0).ToString
                        Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault
                        If newlead Is Nothing Then
                            newlead = New Lead() With {
                                              .BBLE = lead(0).ToString,
                                              .LeadsName = lead(1).ToString,
                                              .Neighborhood = lead(2),
                                              .EmployeeID = CInt(listboxEmployee.SelectedItem.Value),
                                              .EmployeeName = listboxEmployee.SelectedItem.Text,
                                              .Status = LeadStatus.NewLead,
                                              .AssignDate = DateTime.Now,
                                            .AssignBy = User.Identity.Name
                                              }
                            Context.Leads.Add(newlead)
                        Else
                            newlead.LeadsName = lead(1)
                            newlead.Neighborhood = lead(2)
                            newlead.EmployeeID = CInt(listboxEmployee.SelectedItem.Value)
                            newlead.EmployeeName = listboxEmployee.SelectedItem.Text
                            newlead.Status = LeadStatus.NewLead
                            newlead.AssignDate = DateTime.Now
                            newlead.AssignBy = User.Identity.Name
                        End If
                    Next
                    If Context.GetValidationErrors().Count > 0 Then
                        Throw New Exception("Exception Occured in Assign: " & Context.GetValidationErrors()(0).ValidationErrors(0).ErrorMessage)
                    Else
                        Context.SaveChanges()
                    End If
                End Using

                gridLeads.DataBind()
            End If
        End If
    End Sub

    Protected Sub btnExport_Click(sender As Object, e As EventArgs)
        gridExport.WriteXlsxToResponse()
    End Sub
End Class
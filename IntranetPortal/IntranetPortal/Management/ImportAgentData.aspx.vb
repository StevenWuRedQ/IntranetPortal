Imports System.Threading
Imports DevExpress.Web.ASPxEditors

Public Class ImportAgentData
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindAgents()
        BindGrid()
    End Sub

    Sub BindAgents()
        Using Context As New Entities
            cbAgents.DataSource = Context.Agent_Properties.Where(Function(a) a.Active = True).Select(Function(a) a.Agent_Name).Distinct.OrderBy(Function(em) em.ToString).ToList
            cbAgents.DataBind()

            cbImportAgent.DataSource = Context.Employees.Where(Function(emp) emp.Active = True Or emp.Name.EndsWith("Office")).ToList.OrderBy(Function(em) em.Name)
            cbImportAgent.DataBind()
            cbImportAgent.Items.Insert(0, New ListEditItem())
        End Using
    End Sub

    Protected Sub btnLoad_Click(sender As Object, e As EventArgs)
        BindGrid()
    End Sub

    Sub BindGrid()
        Using Context As New Entities
            Dim agent = cbAgents.Text
            If String.IsNullOrEmpty(agent) Then
                Return
            End If

            gridLead.DataSource = Context.Agent_Properties.Where(Function(ap) ap.Agent_Name = agent And ap.BBLE IsNot Nothing And (ap.Active = True Or Not ap.Active.HasValue)).ToList
            gridLead.DataBind()
        End Using
    End Sub

    Protected Sub btnImport_Click(sender As Object, e As EventArgs) Handles btnImport.Click
        Try
            Dim agent = cbAgents.Text
            Using Context As New Entities
                Dim bbles As New List(Of String)

                For Each prop In Context.Agent_Properties.Where(Function(ap) ap.Agent_Name = agent And ap.BBLE IsNot Nothing And (ap.Active = True Or Not ap.Active.HasValue))
                    Dim li = Context.LeadsInfoes.Where(Function(l) l.BBLE = prop.BBLE).SingleOrDefault
                    If li Is Nothing Then
                        li = New LeadsInfo
                        li.PropertyAddress = prop.Property_Address
                        li.BBLE = prop.BBLE
                        li.StreetName = prop.Out_Address
                        li.NeighName = prop.Out_City
                        li.State = prop.Out_State
                        li.ZipCode = prop.Out_Zipcode
                        li.CreateBy = Page.User.Identity.Name
                        li.CreateDate = DateTime.Now

                        If Not String.IsNullOrEmpty(prop.Type) Then
                            li.Type = li.GetLeadsType(prop.Type)
                        End If

                        If Context.LeadsInfoes.Local.Where(Function(tmp) tmp.BBLE = li.BBLE).Count = 0 Then
                            Context.LeadsInfoes.Add(li)
                            bbles.Add(prop.BBLE)
                        End If
                    Else
                        'Dim lead = Context.Leads.Where(Function(l) l.BBLE = prop.BBLE).SingleOrDefault
                        'If lead IsNot Nothing Then
                        '    Context.Leads.Remove(lead)
                        'End If
                    End If

                    prop.Active = False
                    Dim replaceExsited = chkReplace.Checked

                    If Not String.IsNullOrEmpty(cbImportAgent.Value) Then
                        Dim bble = prop.BBLE
                        Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault
                        If newlead Is Nothing Then
                            newlead = New Lead() With {
                                              .BBLE = bble,
                                              .LeadsName = li.LeadsName,
                                              .Neighborhood = li.NeighName,
                                              .EmployeeID = CInt(cbImportAgent.SelectedItem.Value),
                                              .EmployeeName = cbImportAgent.SelectedItem.Text,
                                              .Status = LeadStatus.NewLead,
                                              .AssignDate = DateTime.Now,
                                              .AssignBy = User.Identity.Name
                                              }

                            If Context.Leads.Local.Where(Function(tmp) tmp.BBLE = bble).Count = 0 Then
                                Context.Leads.Add(newlead)
                            End If
                        Else
                            If replaceExsited Then
                                newlead.LeadsName = li.LeadsName
                                newlead.Neighborhood = li.NeighName
                                newlead.EmployeeID = CInt(cbImportAgent.SelectedItem.Value)
                                newlead.EmployeeName = cbImportAgent.SelectedItem.Text
                                newlead.Status = LeadStatus.NewLead
                                newlead.AssignDate = DateTime.Now
                                newlead.AssignBy = User.Identity.Name
                            End If
                        End If
                    End If
                Next

                Context.SaveChanges()
                lblMsg.Text = "Import Complete!"
            End Using
        Catch ex As Exception

            Dim msg = "Error: " & ex.Message
            If ex.InnerException IsNot Nothing Then
                msg += msg & ex.InnerException.Message

                If ex.InnerException.InnerException IsNot Nothing Then
                    msg += msg & ex.InnerException.InnerException.Message
                End If
            End If

            lblMsg.Text = msg
        End Try
    End Sub

    Protected Sub ASPxButton2_Click(sender As Object, e As EventArgs) Handles ASPxButton2.Click
        Dim bbles = LeadsData(cbLeadsType.Value).Select(Function(b) b.BBLE).ToArray

        If Not CBool(Application("InLoop")) Then

            Dim ctx = HttpContext.Current
            ctx.Application.Lock()
            ctx.Application("TotalCount") = bbles.Count
            ctx.Application("Processed") = 0
            ctx.Application("InLoop") = True
            ctx.Application.UnLock()

            For i = 0 To 1
                Dim TestThread As New System.Threading.Thread(New ThreadStart(Sub()
                                                                                  HttpContext.Current = ctx
                                                                                  InitialData(bbles, ctx.Application)
                                                                              End Sub))
                TestThread.Start()
            Next
        End If

        Dim script = "<script type=""text/javascript"">"
        script += "RefreshProgress(0);"
        script += "</script>"

        If Not Page.ClientScript.IsStartupScriptRegistered("Refresh") Then
            Page.ClientScript.RegisterStartupScript(Me.GetType, "Refresh", script)
        End If
    End Sub

    Public Shared Sub InitialData(bbles As String(), appState As HttpApplicationState)
        Dim count = 0

        While count < bbles.Length
            appState.Lock()
            count = CInt(appState("Processed"))
            appState("Processed") = count + 1
            appState.UnLock()

            If count >= bbles.Length Then
                Continue While
            End If

            Dim bble = bbles(count)
            Dim attemps = 0
InitialLine:
            attemps += 1
            Try

                'UpdatePropertyAddress(bble)
                Dim lead = LeadsInfo.GetInstance(bble)

                'If String.IsNullOrEmpty(lead.Owner) Then
                '    DataWCFService.UpdateAssessInfo(bble)
                'End If

                If String.IsNullOrEmpty(lead.Owner) Then
                    If DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, False, True) Then
                        UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("All BBLE: {0} data is loaded. ", bble), bble, DateTime.Now, "Initial Data")
                    End If
                Else
                    If Not lead.C1stMotgrAmt.HasValue Then
                        If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                            UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("BBLE: {0} Morgatage data is loaded. ", bble), bble, DateTime.Now, "Initial Data")
                        End If
                    Else
                        If lead.IsUpdating Then
                            If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                                UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("Refresh BBLE: {0} data is Finished. ", bble), bble, DateTime.Now, "Initial Data")
                            End If
                        Else
                            If Not lead.HasOwnerInfo Then
                                If DataWCFService.UpdateLeadInfo(bble, False, False, False, False, False, False, True) Then
                                    UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("Refresh BBLE: {0} homeowner info is finished.", bble), bble, DateTime.Now, "Initial Data")
                                End If
                            End If
                        End If
                    End If
                End If
                'Thread.Sleep(1000)
            Catch ex As Exception
                UserMessage.AddNewMessage("Service Error", "Initial Data Error " & bble & " Attemps: " & attemps, "Error: " & ex.Message & " StackTrace: " & ex.StackTrace, bble, DateTime.Now, "Initial Data")
                Select Case attemps
                    Case 1
                        Thread.Sleep(30000)
                    Case 2
                        Thread.Sleep(60000)
                    Case 3
                        Thread.Sleep(300000)
                    Case Else
                        Thread.Sleep(1000000)
                End Select

                GoTo InitialLine
            End Try
        End While

        appState.Lock()
        appState("InLoop") = False
        appState.UnLock()
    End Sub

    Public Shared Sub UpdatePropertyAddress(bble As String)
        Using Context As New Entities
            Dim ld = Context.LeadsInfoes.Find(bble)
            If ld IsNot Nothing Then
                ld.PropertyAddress = Utility.BuildPropertyAddress(ld.Number, ld.StreetName, ld.Borough, ld.NeighName, ld.ZipCode)
                Context.SaveChanges()
            End If
        End Using
    End Sub

    Protected Sub ASPxButton1_Click(sender As Object, e As EventArgs) Handles ASPxButton1.Click
        gridNewLeads.DataBind()
    End Sub

    Public Function LeadsData(type As String) As List(Of LeadsInfo)
        Dim newLeads As New List(Of LeadsInfo)
        Using Context As New Entities

            Select Case type
                Case ""
                    newLeads = Context.LeadsInfoes.ToList
                Case "Unassign"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) ld.Lead Is Nothing).ToList
                Case "New"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) String.IsNullOrEmpty(ld.PropertyAddress)).ToList
                Case "HomeOwner"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) String.IsNullOrEmpty(ld.Owner)).ToList
                Case "MotgrAmt"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) ld.C1stMotgrAmt Is Nothing).OrderByDescending(Function(ld) ld.CreateDate).ToList
                Case "Existed"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) Not String.IsNullOrEmpty(ld.Owner)).ToList
            End Select
        End Using
        Return newLeads
    End Function

    Protected Sub gridNewLeads_DataBinding(sender As Object, e As EventArgs)
        gridNewLeads.DataSource = LeadsData(cbLeadsType.Value)
    End Sub

    Protected Sub checkProgress_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Application.Lock()
        Dim total = Application("TotalCount")
        Dim count = Application("Processed")
        Application.UnLock()

        e.Result = CDbl(count / total)
    End Sub
End Class
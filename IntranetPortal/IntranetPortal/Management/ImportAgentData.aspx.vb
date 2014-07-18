Imports System.Threading

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
                        newlead.LeadsName = li.LeadsName
                        newlead.Neighborhood = li.NeighName
                        newlead.EmployeeID = CInt(cbImportAgent.SelectedItem.Value)
                        newlead.EmployeeName = cbImportAgent.SelectedItem.Text
                        newlead.Status = LeadStatus.NewLead
                        newlead.AssignDate = DateTime.Now
                        newlead.AssignBy = User.Identity.Name
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

    Public Shared Sub InitialData(bbles As String())
        For Each bble In bbles
            Try
                DataWCFService.UpdateLeadInfo(bble, True)
            Catch ex As Exception
                UserMessage.AddNewMessage("123", "Initial Data Error " & bble, "Error: " & ex.Message, bble, DateTime.Now, "Initial Data")
            End Try
        Next
    End Sub

    Protected Sub ASPxButton2_Click(sender As Object, e As EventArgs) Handles ASPxButton2.Click
        Dim bbles = LeadsData(cbLeadsType.Value).Select(Function(b) b.BBLE).ToArray

        Dim ctx = HttpContext.Current
        Dim TestThread As New System.Threading.Thread(New ThreadStart(Sub()
                                                                          HttpContext.Current = ctx
                                                                          InitialData(bbles)
                                                                      End Sub))
        TestThread.Start()
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
                Case "New"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) String.IsNullOrEmpty(ld.Owner)).ToList
                Case "Existed"
                    newLeads = Context.LeadsInfoes.Where(Function(ld) Not String.IsNullOrEmpty(ld.Owner)).ToList
            End Select
        End Using
        Return newLeads
    End Function

    Protected Sub gridNewLeads_DataBinding(sender As Object, e As EventArgs)
        gridNewLeads.DataSource = LeadsData(cbLeadsType.Value)
    End Sub
End Class
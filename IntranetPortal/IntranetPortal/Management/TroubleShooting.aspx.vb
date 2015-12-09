Imports System.Data.SqlClient

Public Class TroubleShooting
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        Dim bble = txtBble.Text
        Using Context As New Entities
            If Context.Leads.Where(Function(l) l.BBLE = bble).Count > 0 Then
                Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
                Throw New Exception(String.Format("You cann't create this leads. Lead is already created by {0}. <a href=""#"" id=""linkRequestUpdate"" onclick=""OnRequestUpdate('{1}');return false;"">Request update?</a>", lead.EmployeeName, lead.BBLE))
            End If

            Dim lf As LeadsInfo = DataWCFService.UpdateAssessInfo(bble)
            DataWCFService.UpdateLeadInfo(bble)

            'Save Lead
            Dim ld = New Lead
            ld.BBLE = bble
            ld.LeadsName = lf.LeadsName
            ld.EmployeeID = Employee.GetInstance(Page.User.Identity.Name).EmployeeID
            ld.EmployeeName = Page.User.Identity.Name
            ld.Neighborhood = lf.NeighName
            ld.Status = LeadStatus.NewLead
            ld.AssignDate = DateTime.Now
            ld.AssignBy = Page.User.Identity.Name
            Context.Leads.Add(ld)
            Context.SaveChanges()

            linkInfo.Text = "View Lead Info: " & bble
            linkInfo.NavigateUrl = "/default.aspx?t=search&key=" & bble
            linkInfo.Target = "_black"
        End Using
    End Sub

    Protected Sub btnGetphone_Click(sender As Object, e As EventArgs) Handles btnGetphone.Click

        Using Context As New Entities
            Dim owners = Context.HomeOwners.Where(Function(ho) ho.LocateReport IsNot Nothing).ToList

            For Each owner In owners
                owner.SavePhoneField(owner.TLOLocateReport)
            Next
        End Using

        lblMsg.Text = "All the phone data is saved."
    End Sub

    Protected Sub btnTestIsManager_Click(sender As Object, e As EventArgs) Handles btnTestIsManager.Click
        lblMsg.Text = Roles.IsUserInRole(txtName.Text, "SeniorAgent") 'Employee.IsManager(txtName.Text).ToString
    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Using Context As New Entities
            Context.UpdateEmployeeName("Test", "Test")
        End Using

        Return
        'Dim cn As SqlConnection
        'Dim strCn As String
        'Dim cmd As SqlCommand
        'Dim prm As SqlParameter
        'strCn = "Data Source=(local);Initial Catalog=IntranetPortal;" & _
        '    "Integrated Security=SSPI"
        'cn = New SqlConnection(strCn)
        'cmd = New SqlCommand("UpdateEmployeeName", cn)
        'cmd.CommandType = CommandType.StoredProcedure
        'prm = New SqlParameter("@OldName", SqlDbType.VarChar)
        'prm.Direction = ParameterDirection.Input
        'cmd.Parameters.Add(prm)
        'cmd.Parameters("@OldName").Value = "Test"
        'prm = New SqlParameter("@NewName", SqlDbType.VarChar)
        'prm.Direction = ParameterDirection.Input
        'cmd.Parameters.Add(prm)
        'cmd.Parameters("@NewName").Value = "Test"
        'cn.Open()
        'Dim dr As SqlDataReader = cmd.ExecuteReader
        'While dr.Read
        '    Console.WriteLine("Product ordered: {0}", dr.GetSqlString(0))
        'End While
        'dr.Close()
        'cn.Close()

    End Sub

    Protected Sub btnTestDataService_Click(sender As Object, e As EventArgs) Handles btnTestDataService.Click
        Dim bble = txtBble.Text
        DataWCFService.UpdateAssessInfo(bble)
    End Sub

    Protected Sub ASPxButton1_Click(sender As Object, e As EventArgs) Handles ASPxButton1.Click
        Dim bble = txtBble.Text
        DataWCFService.UpdateHomeOwner(bble, 12354)
    End Sub
End Class
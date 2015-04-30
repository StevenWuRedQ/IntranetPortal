Imports System.IO
Imports System.Data.OleDb
Imports IntranetPortal
Imports IntranetPortal.ShortSale

Public Class Troubleshooting

    Private Sub btnLeadsRule_Click(sender As Object, e As EventArgs) Handles btnLeadsRule.Click
        Dim bble = TextBox1.Text
        IntranetPortal.RulesEngine.LeadsEscalationRule.Execute(bble)
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        IntranetPortal.RulesEngine.TaskEscalationRule.Excute(CInt(txtTaskId.Text))
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        IntranetPortal.AssignRule.GetRuleById(CInt(txtRuleId.Text)).Execute()
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        'IntranetPortal.RulesEngine.TaskSummaryRule.LoadSummaryEmail("Chris Yan")
        'Return

        Using client As New PortalService.CommonServiceClient
            client.SendTaskSummaryEmail(txtName.Text)
        End Using
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Dim rule As New IntranetPortal.RulesEngine.LoopServiceRule
        rule.Execute()
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Dim rule As New IntranetPortal.RulesEngine.CompleteTaskRule
        rule.ExpiredReminderTask("4032340101", 9685, 747)
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        Dim rule As New IntranetPortal.RulesEngine.RecycleProcessRule
        rule.Execute()
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Dim name = txtName.Text
        Try
            IntranetPortal.RecycleManage.BatchPostponeRecycle(name, 5)
        Catch ex As Exception
            IntranetPortal.RulesEngine.ServiceLog.Log("Error messager: ", ex)
        End Try
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Dim name = txtName.Text
        Try
            IntranetPortal.RecycleManage.PostponeRecyle(name, 5, "Michael Gendin")
        Catch ex As Exception
            IntranetPortal.RulesEngine.ServiceLog.Log("Error messager: ", ex)
        End Try
    End Sub

    Private Sub Button9_Click(sender As Object, e As EventArgs) Handles Button9.Click
        Dim name = txtRecycleFrom.Text
        Dim recycleTo = txtRecycleTo.Text
        Dim startDate = txtRecycleDate.Text

        Dim result = IntranetPortal.RecycleManage.UndoRecycle(name, recycleTo, startDate)
        MessageBox.Show(String.Format("{0} leads are undo recycled.", result))
    End Sub

    Private Sub Troubleshooting_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub

    Private Sub btnEmailSend_Click(sender As Object, e As EventArgs) Handles btnEmailSend.Click
        Using client As New PortalService.CommonServiceClient
            Try
                client.SendTeamActivityEmail(cbTeams.Text)
                MessageBox.Show("Mail is send!")
            Catch ex As Exception
                MessageBox.Show("Exception: " & ex.Message)
            End Try
        End Using
    End Sub

    Private Sub txtTeamName_TextChanged(sender As Object, e As EventArgs)

    End Sub

    Private Sub TabControl1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles TabControl1.SelectedIndexChanged
        If TabControl1.SelectedTab.Name = "tabEmail" Then
            cbTeams.DataSource = IntranetPortal.Team.GetAllTeams().Select(Function(t) t.Name).ToList
        End If
    End Sub

    Private Sub Button10_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        Dim dictionary = IO.Path.GetFullPath("Files")

        Dim dics As New IO.DirectoryInfo(dictionary)

        For Each file In dics.GetFiles()
            lbFiles.Items.Add(file.Name)
        Next
    End Sub

    Private Sub btnImportFile_Click(sender As Object, e As EventArgs) Handles btnImportFile.Click

        For Each name As String In lbFiles.SelectedItems
            'Dim name = lbFiles.SelectedItem.ToString
            Dim ds = LoadDataFromExcel(name)

            Try
                'Save property
                Dim ssCase = SavePropertyInfo(ds)
                SaveSellerInfo(ssCase, ds)
                SaveMortgages(ssCase, ds)
                SaveParties(ssCase, ds)

                AddResultToListBox(String.Format("{0} is done.", name))
                MoveFile(name)
            Catch ex As Exception
                AddResultToListBox(String.Format("Error on importing {0}. Message: {1}", name, ex.Message))
                Logger.Log.Error(String.Format("Error on importing {0}. Message: {1}", name, ex.Message), ex)
                'MessageBox.Show(ex.Message)
            End Try
        Next
    End Sub

    Sub MoveFile(fileName As String)
        Dim fullName = Path.GetFullPath("Files\" & fileName)
        'fl.MoveTo("Files\Done\fileName")
        Dim path2 = "Files\Done\" & fileName
        If File.Exists(path2) Then
            File.Delete(path2)
        End If

        File.Move(fullName, path2)
    End Sub

    Sub AddResultToListBox(msg As String)
        Me.Invoke(New MethodInvoker(Sub()
                                        Me.lbResult.Items.Insert(0, String.Format("[{0}] {1}", DateTime.Now.ToString, msg))
                                        Logger.Log.Info(msg)
                                    End Sub))

    End Sub

    Sub SaveMortgages(ssCase As ShortSaleCase, ds As DataSet)
        For Each mort In ds.Tables("Liens_Mortgage").Rows
            If Not IsDBNull(mort("Loan #")) Then
                Dim mtg = PropertyMortgage.GetMortgage(ssCase.CaseId, mort("Loan #").ToString)
                mtg.CaseId = ssCase.CaseId
                mtg.Lender = mort("Company Name").ToString
                mtg.Loan = mort("Loan #").ToString
                SetDecimal(mort("Total Loan Amount").ToString, mtg.LoanAmount)
                'mtg.LoanAmount = CDec()
                mtg.CounterOffer = mort("Counter Offer").ToString

                If Not String.IsNullOrEmpty(mort("Payoff Expires").ToString) Then
                    SetDate(mort("Payoff Expires").ToString, mtg.PayoffExpired)
                End If

                mtg.Status = mort("Progress").ToString
                mtg.LenderContactId = PartyContact.GetContactByName(mtg.Lender, mtg.Lender, mort("Customer Service Phone/Fax 1").ToString, mort("ATR 1 Fax").ToString, "").ContactId

                mtg.Save()
            End If
        Next
    End Sub

    Public Sub SetDecimal(data As String, obj As Decimal?)
        Dim result As Decimal
        If Decimal.TryParse(data, result) Then
            obj = result
        End If
    End Sub

    Public Sub SetDate(data As String, obj As DateTime?)
        Dim retDate As DateTime
        If DateTime.TryParse(data, retDate) Then
            obj = retDate
        End If
    End Sub

    Public Sub SetBool(data As String, obj As Boolean?)
        Dim result As Boolean
        If Boolean.TryParse(data, result) Then
            obj = result
        End If
    End Sub

    Sub SaveParties(ssCase As ShortSaleCase, ds As DataSet)
        If ds.Tables("Contacts").Rows.Count > 0 Then
            Dim contact = ds.Tables("Contacts").Rows(0)
            ssCase.Processor = PartyContact.GetContactByName(contact("Processor").ToString, "", "", "", "").ContactId
            ssCase.Referral = PartyContact.GetContactByName(contact("Referral").ToString, "", "", "", "").ContactId
        End If

        If ds.Tables("Liens_Summary_Foreclosure Info").Rows.Count > 0 Then
            Dim fc = ds.Tables("Liens_Summary_Foreclosure Info").Rows(0)
            ssCase.SellerAttorney = PartyContact.GetContactByName(fc("Trustee/ Attorney").ToString, "", "", "", "").ContactId
        End If

        ssCase.Save()
    End Sub

    Sub SaveSellerInfo(ssCase As ShortSaleCase, ds As DataSet)
        For Each seller In ds.Tables("Seller").Rows
            Dim owner As New PropertyOwner
            owner.BBLE = ssCase.BBLE

            If Not IsDBNull(seller("First Name")) Then
                Dim firstName = seller("First Name").ToString
                Dim lastName = seller("Last Name").ToString
                If lastName.Split(" ").Count > 0 Then
                    Dim middleName = lastName.Split(" ")(0)
                    firstName = firstName & " " & middleName
                    lastName = lastName.Replace(middleName, "")
                End If
                owner.FirstName = firstName
                owner.LastName = lastName
            End If

            owner.Phone = seller("Phone Number").ToString
            owner.Email = seller("Email").ToString

            If Not IsDBNull(seller("SSN")) Then
                owner.SSN = seller("SSN").ToString.Replace("-", "")
            End If

            If Not String.IsNullOrEmpty(seller("Alt# Address").ToString) Then
                Dim ads = seller("Alt# Address").ToString
                owner.MailNumber = ads.Split(" ")(0)
                owner.MailStreetName = ads.Remove(0, owner.MailNumber.Length).Trim
            End If

            owner.MailCity = seller("City").ToString
            owner.MailState = seller("ST").ToString
            owner.MailZip = seller("Zip").ToString

            If Not String.IsNullOrEmpty(seller("Bankruptcy").ToString) Then
                SetBool(seller("Bankruptcy").ToString, owner.Bankruptcy)
            End If

            owner.Save()
        Next
    End Sub

    Function SavePropertyInfo(ds As DataSet) As ShortSaleCase
        If ds.Tables("Property").Rows.Count = 0 Then
            Throw New Exception("No Property Info on " & Name)
        End If

        Dim prop = ds.Tables("Property").Rows(0)

        Dim strNo = prop("Street Number").ToString
        Dim strName = prop("Street Name").ToString

        Dim li = LeadsInfo.GetLeadsInfoByStreet(strNo, strName)

        If li Is Nothing Then
            Throw New Exception("Cannot find this leads in system.")
        End If

        Dim bble = li.BBLE

        'load property info
        Dim ssCase = ShortSale.ShortSaleCase.GetCaseByBBLE(bble)

        If ssCase Is Nothing Then
            ShortSaleManage.MoveLeadsToShortSale(bble, "DataImport")
            ssCase = ShortSale.ShortSaleCase.GetCaseByBBLE(bble)
        End If

        ssCase.OccupiedBy = prop("Occupied By").ToString
        ssCase.ListMLS = prop("MLS #").ToString
        ssCase.MLSStatus = prop("MLS Status").ToString

        If Not String.IsNullOrEmpty(prop("Listing Expiry Date").ToString) Then
            ssCase.ListingExpireDate = CDate(prop("Listing Expiry Date").ToString)
        End If

        ssCase.Lockbox = prop("LockBox").ToString

        If Not String.IsNullOrEmpty(prop("List Price").ToString) Then
            ssCase.ListPrice = CDec(prop("List Price").ToString)
        End If


        If prop.Table.Columns.Contains("Listing Agent") AndAlso Not String.IsNullOrEmpty(prop("Listing Agent").ToString) Then
            Dim contact = ShortSale.PartyContact.GetContactByName(prop("Listing Agent").ToString)
            If contact Is Nothing Then
                contact = New ShortSale.PartyContact(prop("Listing Agent").ToString, Nothing, Nothing)
                contact.Save()
            End If

            ssCase.ListingAgent = contact.ContactId
        End If

        Return ssCase
    End Function

    Function LoadDataFromExcel(fileName As String) As DataSet

        Dim fullName = Path.GetFullPath("Files\" & fileName)
        Dim data As New DataSet
        Dim connStr = String.Format("provider=Microsoft.ACE.OLEDB.12.0;" & "data source={0};Extended Properties=Excel 12.0;", fullName)

        Using cn As New System.Data.OleDb.OleDbConnection(connStr)

            Dim cmd As System.Data.OleDb.OleDbDataAdapter

            For Each table In GetExcelSheetName(connStr)
                Dim dt As New DataTable
                cn.Open()
                cmd = New System.Data.OleDb.OleDbDataAdapter(String.Format("select * from [{0}]", table), cn)
                dt.TableName = table.Replace("'", "").Replace("$", "")
                cmd.Fill(dt)
                data.Tables.Add(dt)
                cn.Close()
            Next
        End Using

        Return data
    End Function

    Function GetExcelSheetName(connStr As String) As String()
        'Dim cn As System.Data.OleDb.OleDbConnection
        Using cn = New System.Data.OleDb.OleDbConnection(connStr)
            ' Select the data from Sheet1 of the workbook.
            cn.Open()

            Dim dt = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, Nothing)

            If dt Is Nothing Then
                Return Nothing
            End If

            Dim tables As New List(Of String)
            For Each row In dt.Rows
                tables.Add(row("TABLE_NAME").ToString)
            Next

            Return tables.ToArray
        End Using
    End Function
End Class
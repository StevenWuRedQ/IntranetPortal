Imports System.IO
Imports System.Data.OleDb
Imports IntranetPortal
Imports IntranetPortal.ShortSale
Imports System.Threading

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
     



        Using client As New PortalService.CommonServiceClient
            'client.SendShortSaleActivityEmail()
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
        gvFiles.Rows.Clear()
        For Each file In dics.GetFiles()
            gvFiles.Rows.Add(file.Name, "")

            'lbFiles.Items.Add(file.Name)
        Next

        AddResultToListBox("Total Files: " & gvFiles.Rows.Count)
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
                MoveFile(name, ssCase.BBLE)
            Catch ex As Exception
                AddResultToListBox(String.Format("Error on importing {0}. Message: {1}", name, ex.Message))
                Logger.Log.Error(String.Format("Error on importing {0}. Message: {1}", name, ex.Message), ex)
                'MessageBox.Show(ex.Message)
            End Try
        Next
    End Sub

    Private Sub btnGetBBLE_Click(sender As Object, e As EventArgs) Handles btnGetBBLE.Click
        Dim td As New Threading.Thread(New ThreadStart(Sub()
                                                           For Each row As DataGridViewRow In gvFiles.SelectedRows
                                                               ThreadPool.QueueUserWorkItem(Sub()
                                                                                                ImportFiles(row)
                                                                                            End Sub)
                                                           Next
                                                       End Sub))
        td.Start()
    End Sub

    Private Sub btnImportLogs_Click(sender As Object, e As EventArgs) Handles btnImportLogs.Click
        Dim td As New Threading.Thread(New ThreadStart(Sub()
                                                           For Each row As DataGridViewRow In gvFiles.SelectedRows
                                                               ThreadPool.QueueUserWorkItem(Sub()
                                                                                                ImportLogs(row)
                                                                                            End Sub)
                                                           Next
                                                       End Sub))
        td.Start()
    End Sub

    Private Sub ImportLogs(row As DataGridViewRow)
        Try
            row.Cells(3).Value = ""
            Dim fileName = row.Cells(0).Value
            UpdateStatus(row, "Loading data from Excel...")
            Dim ds = LoadDataFromExcel(fileName)
            UpdateStatus(row, "Loading... BBLE")

            Dim bble = ""
            If fileName.ToString.StartsWith("bble_") Then
                bble = fileName.ToString.Replace("bble_", "").Replace(".xlsx", "")
            Else
                bble = LoadBBLE(ds)
            End If

            If String.IsNullOrEmpty(bble) Then
                Throw New Exception("Can't find address")
            End If

            UpdateStatus(row, bble, 1)

            UpdateStatus(row, "Save Logs")

            SaveActivityLogs(bble, ds)

            UpdateStatus(row, "Imported is done")
            AddResultToListBox(String.Format("{0} is done.", fileName))
            MoveFile(fileName, bble)
            UpdateStatus(row, "Move to filed")
        Catch ex As Exception
            row.Cells(3).Value = "Exception: " & ex.Message
        End Try
    End Sub

    Private Sub ImportFiles(row As DataGridViewRow)
        Try
            row.Cells(3).Value = ""
            Dim fileName = row.Cells(0).Value
            UpdateStatus(row, "Loading data from Excel...")
            Dim ds = LoadDataFromExcel(fileName)
            UpdateStatus(row, "Loading... BBLE")

            Dim bble = ""
            If fileName.ToString.StartsWith("bble_") Then
                bble = fileName.ToString.Replace("bble_", "").Replace(".xlsx", "")
            Else
                bble = LoadBBLE(ds)
            End If

            UpdateStatus(row, bble, 1)
            UpdateStatus(row, "Save... Property Info")
            Dim ssCase = SavePropertyInfo(ds, bble)
            UpdateStatus(row, "Save... Seller info")
            SaveSellerInfo(ssCase, ds)
            UpdateStatus(row, "Save... Mortgages")
            SaveMortgages(ssCase, ds)
            UpdateStatus(row, "Save... parties")
            SaveParties(ssCase, ds)
            UpdateStatus(row, "Save Logs")
            SaveActivityLogs(bble, ds)
            UpdateStatus(row, "Imported is done")
            AddResultToListBox(String.Format("{0} is done.", fileName))
            MoveFile(fileName, bble)
            UpdateStatus(row, "Move to filed")
        Catch ex As Exception
            row.Cells(3).Value = "Exception: " & ex.Message
        End Try
    End Sub

    Private Sub UpdateStatus(row As DataGridViewRow, status As String, Optional index As Integer = 2)
        Me.Invoke(New MethodInvoker(Sub()
                                        row.Cells(index).Value = status
                                    End Sub))
    End Sub

    Private Sub SaveActivityLogs(bble As String, ds As DataSet)
        Dim logs As New List(Of ShortSaleActivityLog)
        For Each row In ds.Tables("Activity Log").Rows
            Dim log As New ShortSaleActivityLog
            log.BBLE = bble
            log.ActivityDate = SetDate(row("Activity Date"), log.ActivityDate)
            log.Source = row("Source").ToString
            log.ActivityType = row("Activity Type").ToString
            log.ActivityTitle = row("Activity Title").ToString
            log.Description = row("Activity Description").ToString
            log.Shared = row("Shared").ToString

            logs.Add(log)
        Next
        ShortSaleActivityLog.ClearLogs(bble)
        ShortSaleActivityLog.AddLogs(logs.ToArray)
    End Sub

    Private Function LoadBBLE(ds As DataSet) As String

        Dim prop = ds.Tables("Property").Rows(0)

        Dim strNo = prop("Street Number").ToString
        Dim strPrefix = prop("Street Prefix").ToString
        Dim strName = prop("Street Name").ToString
        Dim city = prop("City").ToString
        Dim zip = prop("Zip").ToString

        If Not String.IsNullOrEmpty(strPrefix) Then
            strName = strPrefix.Trim & " " & strName.Trim
        End If

        Return LeadsInfo.GetLeadsInfoByStreet(strNo, strName, city, zip)
    End Function

    Sub MoveFile(fileName As String, newName As String)
        Dim fullName = Path.GetFullPath("Files\" & fileName)
        'fl.MoveTo("Files\Done\fileName")
        Dim path2 = "Files\Done\bble_" & newName & ".xlsx"
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
                mtg.LoanAmount = SetDecimal(mort("Total Loan Amount").ToString, mtg.LoanAmount)
                'mtg.LoanAmount = CDec()
                mtg.CounterOffer = mort("Counter Offer").ToString

                If Not String.IsNullOrEmpty(mort("Payoff Expires").ToString) Then
                    mtg.PayoffExpired = SetDate(mort("Payoff Expires").ToString, mtg.PayoffExpired)
                End If

                mtg.Status = mort("Progress").ToString
                mtg.LenderContactId = PartyContact.GetContactByName(mtg.Lender, mtg.Lender, mort("Customer Service Phone/Fax 1").ToString, mort("ATR 1 Fax").ToString, "").ContactId

                mtg.Save()
            End If
        Next
    End Sub

    Public Function SetDecimal(data As String, obj As Decimal?) As Decimal?
        Dim result As Decimal
        If Decimal.TryParse(data, result) Then
            obj = result
        End If

        Return obj
    End Function

    Public Function SetDate(data As String, obj As DateTime?) As DateTime?
        Dim retDate As DateTime
        If DateTime.TryParse(data, retDate) Then
            obj = retDate
        End If

        Return obj
    End Function

    Public Function SetBool(data As String, obj As Boolean?) As Boolean?
        Dim result As Boolean
        If Boolean.TryParse(data, result) Then
            obj = result
        End If

        Return obj
    End Function

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
                If lastName.Trim.Split(" ").Count > 1 Then
                    Dim middleName = lastName.Trim.Split(" ")(0)
                    firstName = firstName & " " & middleName
                    lastName = lastName.Trim.Replace(middleName, "")
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
                owner.Bankruptcy = SetBool(seller("Bankruptcy").ToString, owner.Bankruptcy)
            End If

            owner.Save()
        Next
    End Sub

    Function SavePropertyInfo(ds As DataSet, Optional bble As String = "") As ShortSaleCase
        If ds.Tables("Property").Rows.Count = 0 Then
            Throw New Exception("No Property Info on " & Name)
        End If

        Dim prop = ds.Tables("Property").Rows(0)
        Dim li As LeadsInfo

        If String.IsNullOrEmpty(bble) Then
            Dim strNo = prop("Street Number").ToString
            Dim strName = prop("Street Name").ToString
            Dim city = prop("City").ToString
            Dim zip = prop("Zip").ToString

            li = LeadsInfo.GetLeadsInfoByStreet(strNo, strName)

        Else
            li = LeadsInfo.GetInstance(bble)

            If li Is Nothing Then
                li = DataWCFService.UpdateAssessInfo(bble)
            End If
        End If

        If li Is Nothing Then
            Throw New Exception("Cannot find this leads in system.")
        End If

        bble = li.BBLE

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

        ssCase.Save()

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



    Private Sub Button10_Click_1(sender As Object, e As EventArgs) Handles Button10.Click
        IntranetPortal.ShortSaleManage.UpdateReferral()
        MessageBox.Show("Complete!")
    End Sub

    Private Sub Button11_Click(sender As Object, e As EventArgs) Handles Button11.Click
        Dim rule As New IntranetPortal.RulesEngine.PendingAssignRule
        rule.Execute()
    End Sub

    Private Sub btnRemove_Click(sender As Object, e As EventArgs) Handles btnRemove.Click
        Try
            ShortSaleCase.Remove(txtSSBBLE.Text)
            MessageBox.Show("Done")
            'Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message)
        End Try
    End Sub

    Private Sub btnMove_Click(sender As Object, e As EventArgs) Handles btnMove.Click

        Try

            ShortSaleCase.Remove(txtSSBBLE.Text)
            Lead.InThirdParty(txtSSBBLE.Text, "Outside SS", "", "Chris Yan")
            MessageBox.Show("Done")
        Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message)
        End Try
    End Sub

    Private Sub btnMoveStraight_Click(sender As Object, e As EventArgs) Handles btnMoveStraight.Click
        Try
            ShortSaleCase.Remove(txtSSBBLE.Text)
            Lead.InThirdParty(txtSSBBLE.Text, "Straight Sale", "", "Chris Yan")
            MessageBox.Show("Done")
        Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message)
        End Try
    End Sub
End Class
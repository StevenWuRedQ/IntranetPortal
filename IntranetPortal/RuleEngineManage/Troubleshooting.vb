Imports System.IO
Imports System.Data.OleDb
Imports IntranetPortal
Imports System.Threading
Imports IntranetPortal.Data
Imports Newtonsoft.Json.Linq
Imports System.Text
Imports IntranetPortal.RulesEngine
Imports System.Configuration
Imports Newtonsoft.Json
Imports System.Reflection

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

    Private Sub btnSSUserReport_Click(sender As Object, e As EventArgs) Handles btnSSUserReport.Click
        Using client As New PortalService.CommonServiceClient
            client.SendShortSaleActivityEmail()
            'client.SendShortSaleUserSummayEmail()
        End Using
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Dim rule As New IntranetPortal.RulesEngine.LoopServiceRule
        ThreadPool.QueueUserWorkItem(AddressOf rule.Execute)
        'rule.Execute()
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
        Dim formTypes As New List(Of Type)()
        For Each formType As Type In System.Reflection.Assembly.GetExecutingAssembly().GetTypes()
            If GetType(Form).IsAssignableFrom(formType) Then
                If formType.FullName <> "RuleEngineManage.Troubleshooting" AndAlso formType.FullName <> "RuleEngineManage.RuleEngineManagement" Then
                    formTypes.Add(formType)
                End If
            End If
        Next formType

        For Each type As Type In formTypes
            Me.cbForms.Items.Add(type.Name)
        Next type
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

#Region "Short Sale"

    Private Sub btnInitChecklist_Click(sender As Object, e As EventArgs) Handles btnInitChecklist.Click
        ShortSaleManage.UpdateCheckList()
        MessageBox.Show("Complete!")
    End Sub

    Private Sub Button10_Click_1(sender As Object, e As EventArgs) Handles Button10.Click
        IntranetPortal.ShortSaleManage.UpdateReferral()
        MessageBox.Show("Complete!")
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

                mtg.Save("Portal")
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
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        If ssCase Is Nothing Then
            ShortSaleManage.MoveLeadsToShortSale(bble, "DataImport", 1)
            ssCase = ShortSaleCase.GetCaseByBBLE(bble)
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
            Dim contact = PartyContact.GetContactByName(prop("Listing Agent").ToString)
            If contact Is Nothing Then
                contact = New PartyContact(prop("Listing Agent").ToString, Nothing, Nothing)
                contact.Save()
            End If

            ssCase.ListingAgent = contact.ContactId
        End If

        ssCase.Save()

        Return ssCase
    End Function

    Function LoadDataFromExcel(fileName As String) As DataSet

        Dim fullName = Path.GetFullPath("D:\Data\" & fileName)
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

    'makeup the missed short sale datetime
    Private Sub Button19_Click(sender As Object, e As EventArgs) Handles Button19.Click
        If Not String.IsNullOrEmpty(txtSSResult.Text) Then
            For Each bble In txtSSResult.Lines
                Dim lastLog = Core.SystemLog.GetLastLogs("ShortSaleSave", New Date(2015, 11, 18), bble)
                If lastLog IsNot Nothing Then
                    Dim log = lastLog.Description

                    Dim logData = JsonConvert.DeserializeObject(Of ShortSaleCase)(log)
                    Dim ssData = ShortSaleCase.GetCaseByBBLE(bble)

                    If logData.BBLE = ssData.BBLE Then

                        'check owner date
                        If logData.PropertyInfo IsNot Nothing AndAlso logData.PropertyInfo.Owners IsNot Nothing Then
                            For Each pOwner In logData.PropertyInfo.Owners
                                Dim ssOwner = PropertyOwner.Instance(pOwner.OwnerId)

                                If pOwner.DOB.HasValue And Not ssOwner.DOB.HasValue Then
                                    ssOwner.DOB = pOwner.DOB
                                End If

                                ssOwner.Save()
                            Next
                        End If

                        'check Mortagages
                        If logData.Mortgages IsNot Nothing AndAlso logData.Mortgages.Length > 0 Then
                            For Each mort In logData.Mortgages
                                Dim ssMort = PropertyMortgage.Instance(mort.MortgageId)

                                'Auction Date
                                If mort.AuctionDate.HasValue AndAlso Not ssMort.AuctionDate.HasValue Then
                                    ssMort.AuctionDate = mort.AuctionDate
                                End If

                                'DateofSale
                                If mort.DateOfSale.HasValue AndAlso Not ssMort.DateOfSale.HasValue Then
                                    ssMort.DateOfSale = mort.DateOfSale
                                End If

                                If mort.DateVerified.HasValue AndAlso Not ssMort.DateVerified.HasValue Then
                                    ssMort.DateVerified = mort.DateVerified
                                End If

                                If mort.PayoffExpired.HasValue AndAlso Not ssMort.PayoffExpired.HasValue Then
                                    ssMort.PayoffExpired = mort.PayoffExpired
                                End If

                                If mort.PayoffRequested.HasValue AndAlso Not ssMort.PayoffRequested.HasValue Then
                                    ssMort.PayoffRequested = mort.PayoffRequested
                                End If

                                If mort.LastPaymentDate.HasValue AndAlso Not ssMort.LastPaymentDate.HasValue Then
                                    ssMort.LastPaymentDate = mort.LastPaymentDate
                                End If

                                If mort.CancelationSent.HasValue AndAlso Not ssMort.CancelationSent.HasValue Then
                                    ssMort.CancelationSent = mort.CancelationSent
                                End If

                                If mort.DateAssigned.HasValue AndAlso Not ssMort.DateAssigned.HasValue Then
                                    ssMort.DateAssigned = mort.DateAssigned
                                End If

                                If mort.LastBPOUpdate.HasValue AndAlso Not ssMort.LastBPOUpdate.HasValue Then
                                    ssMort.LastBPOUpdate = mort.LastBPOUpdate
                                End If

                                If mort.UpcomingBPODate.HasValue AndAlso Not ssMort.UpcomingBPODate.HasValue Then
                                    ssMort.UpcomingBPODate = mort.UpcomingBPODate
                                End If

                                mort.Save("Makeupdate")
                            Next
                        End If
                    End If
                End If
            Next
        End If
    End Sub



#End Region

    Private Sub Button11_Click(sender As Object, e As EventArgs) Handles Button11.Click
        Dim rule As New IntranetPortal.RulesEngine.PendingAssignRule
        rule.Execute()
    End Sub

    Private Sub btnRemove_Click(sender As Object, e As EventArgs) Handles btnRemove.Click
        Try
            ShortSaleCase.Remove(txtSSBBLE.Text)
            MessageBox.Show("Done")
        Catch ex As Exception
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

    Private Sub btnGeoBBLE_Click(sender As Object, e As EventArgs) Handles btnGeoBBLE.Click
        txtGeoBBLE.Text = DataWCFService.GeoCode(txtGeoAddress.Text)
    End Sub

    Private Sub Button12_Click(sender As Object, e As EventArgs) Handles Button12.Click
        Using client As New PortalService.CommonServiceClient
            'sending email by email address
            client.SendEmailByAddress("chrisy@myidealprop.com", "georgev@myidealprop.com", "testing eamil api", "this is email send by portal api.")

            'sending email by User Name
            client.SendEmail("Chris Yan", "testing eamil api", "this is email send by portal api.")

        End Using
    End Sub

    Private Sub btnImportOffer_Click(sender As Object, e As EventArgs) Handles btnImportOffer.Click

        For Each ssCase In ShortSaleCase.GetAllCase

            ImportCaseOffer(ssCase)

        Next
    End Sub

    Private Sub ImportCaseOffer(ssCase As ShortSaleCase)
        If ssCase.HasOfferSubmit Then
            Dim offers = ShortSaleOffer.GetOffers(ssCase.BBLE)

            If offers IsNot Nothing AndAlso offers.Count > 0 Then
                Return
            End If

            Dim offer = New ShortSaleOffer
            offer.BBLE = ssCase.BBLE
            offer.OfferAmount = ssCase.OfferSubmited
            offer.DateSubmited = ssCase.OfferDate
            offer.CreateBy = "Imported"
            offer.CreateDate = DateTime.Now

            offer.Save("Imported")
        End If
    End Sub

    Private Sub btnInitialContact_Click(sender As Object, e As EventArgs) Handles btnInitialContact.Click

        For Each ssCase In ShortSaleCase.GetAllCase

            If ssCase.Referral.HasValue Then
                ssCase.ReferralUserName = PartyContact.GetContactName(ssCase.Referral)
            End If

            If ssCase.Processor.HasValue Then
                ssCase.ProcessorName = PartyContact.GetContactName(ssCase.Processor)
            End If

            If ssCase.ListingAgent.HasValue Then
                ssCase.ListingAgentName = PartyContact.GetContactName(ssCase.ListingAgent)
            End If

            If ssCase.SellerAttorney.HasValue Then
                ssCase.SellerAttorneyName = PartyContact.GetContactName(ssCase.SellerAttorney)
            End If

            If ssCase.TitleCompany.HasValue Then
                ssCase.TitleCompanyName = PartyContact.GetContactName(ssCase.TitleCompany)
            End If

            If ssCase.BuyerAttorney.HasValue Then
                ssCase.BuyerAttorneyName = PartyContact.GetContactName(ssCase.BuyerAttorney)
            End If

            ssCase.Save()
        Next
    End Sub


    Private Sub btnRefreshLegalReport_Click(sender As Object, e As EventArgs) Handles btnRefreshLegalReport.Click

        If txtBBLE.Text = "*" Then

            For Each item In LegalCase.GetAllCases
                item.SaveData("Portal")
            Next
        Else
            Dim lCase = LegalCase.GetCase(txtBBLE.Text)
            lCase.SaveData("Portal")
        End If
    End Sub

    Private Sub btnRefreshComplains_Click(sender As Object, e As EventArgs) Handles btnRefreshComplains.Click

        Dim rule = New IntranetPortal.RulesEngine.DOBComplaintsCheckingRule
        rule.SendingNotifyEmail = False
        rule.Execute()
    End Sub

    Private Sub btnFollowUp_Click(sender As Object, e As EventArgs) Handles btnFollowUp.Click
        Dim rule = New IntranetPortal.RulesEngine.LegalFollowUpRule
        rule.Execute()
    End Sub

    Private Sub btnSummaryEmail_Click(sender As Object, e As EventArgs) Handles btnSummaryEmail.Click
        Dim rule = New IntranetPortal.RulesEngine.AgentActivitySummaryRule
        rule.Execute()
    End Sub

    Private Sub btnComplaintsRefresh_Click(sender As Object, e As EventArgs) Handles btnComplaintsRefresh.Click
        Dim bble = txtBBLE.Text

        If String.IsNullOrEmpty(bble) Then
            Dim complaints = CheckingComplain.GetAllComplains()

            For Each cpl In complaints
                cpl.UpdateComplaintsResult()
            Next

        Else
            Dim complaints = CheckingComplain.Instance(bble)
            complaints.UpdateComplaintsResult()

        End If


    End Sub

    Private Sub btnComplaintsNotify_Click(sender As Object, e As EventArgs) Handles btnComplaintsNotify.Click
        Dim filepath = "notifyusers.xlsx"
        Dim data = LoadDataFromExcel(filepath)

        Dim userList As New Dictionary(Of String, String)
        userList.Add("Gendin", "Michael Gendin")
        userList.Add("Bobby", "Bobby Panday")
        userList.Add("Jamie", "Jamie Ventura")
        userList.Add("Isaac A", "Isaac Aronov")
        userList.Add("Isaac", "Isaac Aronov")
        userList.Add("Melissa", "Melissa Ramlakhan")
        userList.Add("Ron B", "Ron Borovinsky")
        userList.Add("Albert", "Albert Gavriyelov")
        userList.Add("Albert G", "Albert Gavriyelov")
        userList.Add("Jay G", "Jay Gottlieb")
        userList.Add("Mike K", "Michael Kay")
        userList.Add("Paul", "Paul Rechsteiner")
        userList.Add("Arthur", "Arthur Gukasyan")
        userList.Add("Tara", "Tara Persaud")

        Dim properties = data.Tables("Property")

        For Each prop In properties.Rows
            Dim address = prop(0).ToString
            Dim complaints = CheckingComplain.GetComplaints(address.Split(" ")(0) & " ")

            If complaints IsNot Nothing Then
                Dim users As New List(Of String)

                If Not String.IsNullOrEmpty(prop(1)) AndAlso userList.ContainsKey(prop(1)) Then
                    users.Add(userList(prop(1)))
                End If

                If Not IsDBNull(prop(2)) AndAlso Not String.IsNullOrEmpty(prop(2)) AndAlso userList.ContainsKey(prop(2)) Then
                    users.Add(userList(prop(2)))
                End If

                If Not IsDBNull(prop(3)) AndAlso Not String.IsNullOrEmpty(prop(3)) AndAlso userList.ContainsKey(prop(3)) Then
                    users.Add(userList(prop(3)))
                End If

                If users.Count > 0 Then
                    If String.IsNullOrEmpty(complaints.NotifyUsers) Then
                        complaints.NotifyUsers = String.Join(";", users)
                        complaints.Save("UpdateNotifyUser")

                        MessageBox.Show(String.Format("{0} updated. users: {1}", complaints.Address, complaints.NotifyUsers))
                    End If

                    Continue For
                End If
            End If

            MessageBox.Show("No update on " & address)
            txtComplaintsResult.Text += address & Environment.NewLine
        Next
    End Sub

    Private Sub btnNotify_Click(sender As Object, e As EventArgs) Handles btnNotify.Click
        Dim bble = txtBBLE.Text

        If String.IsNullOrEmpty(bble) Then
            Dim complaints = CheckingComplain.GetAllComplains()

            For Each cpl In complaints
                cpl.NotifyAction(Nothing)
            Next

        Else
            Dim complaints = CheckingComplain.Instance(bble)
            complaints.NotifyAction(Nothing)
        End If
    End Sub

    Private Sub Button14_Click(sender As Object, e As EventArgs) Handles Button14.Click
        Dim bbles = txtSSBBLE.Lines()

        For Each bble In bbles

            If Not String.IsNullOrEmpty(bble) Then
                Dim sCase = ShortSaleCase.GetCaseByBBLE(bble)

                If String.IsNullOrEmpty(sCase.FirstMortgage.Status) AndAlso String.IsNullOrEmpty(sCase.FirstMortgage.Category) Then

                    Dim log = ShortSaleActivityLog.GetLogs(bble, 1).Where(Function(l) l.ActivityType = "1st Lien").OrderByDescending(Function(l) l.ActivityDate).FirstOrDefault

                    If log IsNot Nothing Then
                        Dim title = log.ActivityTitle

                        If Not String.IsNullOrEmpty(title) AndAlso title.Split("-").Length > 0 Then
                            Dim data = title.Split("-")

                            sCase.FirstMortgage.Category = data(0).Trim
                            sCase.FirstMortgage.Status = title.Substring(title.IndexOf("-") + 1).Trim

                            sCase.FirstMortgage.Save("UpdateEngine")
                        End If
                    End If
                End If
            End If

        Next



    End Sub

    Private Sub btnNotifyAll_Click(sender As Object, e As EventArgs) Handles btnNotifyAll.Click

        'Dim cps = Data.CheckingComplain.GetAllComplains("", txtNotifyNames.Text)

        Dim rule As New IntranetPortal.RulesEngine.DOBComplaintsCheckingRule With {
            .SendingNotifyEmail = True,
            .IsTesting = True
            }
        rule.Execute()

    End Sub

    Private Sub uploadActivity(bble As String, file As String)
        If Not String.IsNullOrEmpty(file) And Not String.IsNullOrEmpty(bble) Then
            Dim data = LoadDataFromExcel(file)
            Dim logs = From l In data.Tables
                       Where l.TableName = "log" Select l
            If Not logs Is Nothing Then
                For Each row As DataRow In logs.FirstOrDefault.Rows
                    Dim vdate = row.Item(0).ToString
                    If Not IsDBNull(vdate) Then
                        Dim logDate = DateTime.Parse(vdate)
                        Dim log = row.Item(1).ToString.Trim
                        Dim ename = row.Item(2).ToString.Trim.ToLower
                        Dim eid As Integer
                        Select Case ename
                            Case "jamie"
                                ename = "Jamie Ventura"
                                eid = 26
                            Case "heidi"
                                ename = "Heidi Velovic"
                                eid = 46
                            Case "melissa"
                                ename = "Melissa Ramlakhan"
                                eid = 30
                            Case "yvette"
                                ename = "Yvette Guizie"
                                eid = 52
                            Case "iskyo"
                                ename = "Isaac Aronov"
                                eid = 24
                            Case "aneesa"
                                ename = "Aneesa Ramlakhan"
                                eid = 2322
                            Case Else
                                ename = "Jamie Ventura"
                                eid = 26
                        End Select
                        LeadsActivityLog.AddActivityLog(logDate, log, bble, LeadsActivityLog.LogCategory.Construction.ToString, eid, ename)
                        TextBox4.AppendText(logDate)
                    End If
                Next
            Else
                TextBox4.AppendText("logs sheet is not here.")
            End If
            TextBox4.AppendText(String.Format("{0}: {1}: is finished.", bble, file))
        Else
            TextBox4.AppendText("File Empty")
        End If
    End Sub

    Private Sub Button15_Click(sender As Object, e As EventArgs) Handles Button15.Click
        Dim file = TextBox5.Text.Trim
        Dim BBLE = txtBBLE.Text.Trim
        uploadActivity(BBLE, file)
    End Sub

    Private Sub Button16_Click(sender As Object, e As EventArgs) Handles Button16.Click
        For Each foundFile As String In My.Computer.FileSystem.GetFiles("D:\data\")
            ' TextBox4.AppendText(Path.GetFileNameWithoutExtension(foundFile))
            Dim bble = Path.GetFileNameWithoutExtension(foundFile).Trim
            Dim file = Path.GetFileName(foundFile).Trim
            TextBox4.AppendText(bble & "start!")
            uploadActivity(bble, file)
        Next
    End Sub

    Private Sub Button17_Click(sender As Object, e As EventArgs) Handles Button17.Click

    End Sub

    Private Sub Button18_Click(sender As Object, e As EventArgs) Handles Button18.Click
        TextBox4.Text = ""
        Dim input = TextBox5.Text
        Dim tokens = input.Split("|")
        Dim BBLE = tokens(0)
        Dim owner = tokens(1)
        Dim caseName = LeadsInfo.GetInstance(BBLE).PropertyAddress
        Try
            ConstructionManage.StartConstruction(BBLE, caseName, "Chris Yan", owner)
            TextBox4.AppendText("Success")
        Catch ex As Exception
            TextBox4.AppendText("Fails \n")
        End Try
    End Sub

    Private Sub OnTestHDPClick(sender As Object, e As EventArgs) Handles TestHPD.Click
        Core.WebGrabber.GetHPDInfo()
    End Sub

    Private Sub btnGeneratTemplate_Click(sender As Object, e As EventArgs) Handles btnGeneratTemplate.Click
        Try
            Dim qb As New Core.QueryBuilder
            Dim txt = qb.GenerateReportTemplate(txtReportTables.Text)
            txtTemplateResult.Text = txt
        Catch ex As Exception
            MessageBox.Show(ex.Message)
        End Try
    End Sub

    Private Sub Button21_Click(sender As Object, e As EventArgs) Handles Button21.Click
        Dim rule As New IntranetPortal.RulesEngine.ScanECourtsRule
        rule.Execute()
    End Sub

    Private Sub SpotCheckTest_Click(sender As Object, e As EventArgs) Handles SpotCheckTest.Click
        Dim sc = New Data.ConstructionSpotCheck
        Dim cs = Data.ConstructionCase.GetAllCasesByStatus(Data.ConstructionCase.CaseStatus.Intake).ToList
        For Each c In cs
            sc.StartSpotCheck(c.BBLE, "Andrew Aronoff")
        Next
    End Sub

    Private Sub Organize_Click(sender As Object, e As EventArgs) Handles Organize.Click
        TextBox4.Text = ""
        Dim filen = TextBox5.Text
        Dim fs = New StreamReader("D:\Data\" & filen)
        Dim line = fs.ReadLine
        While Not line Is Nothing
            Dim tokens = line.Split(",")
            Dim token = tokens(0)
            Try
                Dim BBLE = Core.Utility.Address2BBLE(token)
                TextBox4.AppendText("'" & BBLE & "'" & ",")
            Catch ex As Exception
                TextBox4.AppendText("null,")
            End Try
            line = fs.ReadLine
        End While
        fs.Close()

    End Sub

    Private Sub TestRegExp_Click(sender As Object, e As EventArgs) Handles TestRegExp.Click
        Dim cn = New IntranetPortal.RulesEngine.ConstructionNotifyRule
        cn.NotifyHPDRegExpired()
    End Sub

    Private Sub btnRefreshComplaints_Click(sender As Object, e As EventArgs) Handles btnRefreshComplaints.Click
        Dim bble = txtBBLE.Text

        If Not String.IsNullOrEmpty(bble) Then
            Dim complaintServer = ConfigurationManager.AppSettings("DOBComplaintServer").ToString
            Dim complaints = CheckingComplain.Instance(bble)
            complaints.RefreshComplains("RuleEngine", complaintServer)
        End If
    End Sub

    Private Sub CleanBudgetData_Click(sender As Object, e As EventArgs) Handles CleanBudgetData.Click

        Dim cases = Data.ConstructionCase.GetAllCases()
        For Each c In cases
            Dim datax = c.CSCase
            If Not String.IsNullOrEmpty(datax) Then
                Dim casedata = JObject.Parse(datax)
                If Not casedata("BudateData") Is Nothing Then
                    casedata.Remove("BudateData")
                End If
                If Not casedata("budgetData") Is Nothing Then
                    casedata.Remove("budgetData")
                End If
                c.CSCase = casedata.ToString
                c.Save("Chris Yan")
                TextBox4.AppendText(c.BBLE & " finished;")
            End If

        Next
    End Sub

    Private Sub BtnNoticeECourt_Click(sender As Object, e As EventArgs) Handles BtnNoticeECourt.Click
        Dim r = New NoticeECourtRule()
        r.Execute()
    End Sub

    Private Sub btnLegalTeamActivity_Click(sender As Object, e As EventArgs) Handles btnLegalTeamActivity.Click
        Dim rule = New IntranetPortal.RulesEngine.LegalActivityReportRule
        rule.Execute()
    End Sub

    Private Sub btnShortSaleUserFollowUp_Click(sender As Object, e As EventArgs) Handles btnShortSaleUserFollowUp.Click
        Dim rule = New IntranetPortal.RulesEngine.ShortSaleFollowUpRule
        rule.Execute()
    End Sub

    Private Sub TitleButton1_Click(sender As Object, e As EventArgs) Handles TitleButton1.Click

        Using ctx = New Data.PortalEntities
            Dim forms = From f In ctx.FormDataItems Select f
            For Each form In forms
                If form IsNot Nothing Then
                    Dim formdata = form.FormData
                    Dim jo = JObject.Parse(formdata)
                    If jo("Owners") IsNot Nothing Then
                        For Each o In jo("Owners")
                            If o("Bankruptcy_Notes") IsNot Nothing Then
                                For Each b In o("Bankruptcy_Notes")
                                    If b("Bankruptcy_Status") IsNot Nothing Then
                                        b("status") = b("Bankruptcy_Status")
                                        CType(b, JObject).Property("Bankruptcy_Status").Remove()
                                    End If
                                Next
                            End If
                        Next
                    End If
                    form.FormData = jo.ToJsonString
                End If
            Next

            ctx.SaveChanges()
        End Using

    End Sub

    Private Sub CacheAllEmail_Click(sender As Object, e As EventArgs) Handles CacheAllEmail.Click
        Dim serv = New Core.ParseEmailService("Portal.etrack@myidealprop.com", "ColorBlue1")
        If (Not serv.IsLogedIn()) Then

        End If
        Using ctx As New PortalEntities
            Dim allmessage = serv.GetAllEmail()
            For Each l In allmessage
                Dim c = New LegalECourtsAll()
                c.BodyText = l.Body.Text
                c.BodyHtml = l.Body.Html
                c.RecivedData = l.Date
                c.Subject = l.Subject
                ctx.LegalECourtsAlls.Add(c)
            Next
            ctx.SaveChanges()
        End Using

    End Sub
    Private Sub btnRefreshMtgs_Click(sender As Object, e As EventArgs) Handles btnRefreshMtgs.Click
        MessageBox.Show(DataWCFService.UpdateLeadInfo(txtBBLE.Text, False, True, True, True, True, False, False))
    End Sub

    Private Sub btnOpenWindow_Click(sender As Object, e As EventArgs) Handles btnOpenWindow.Click
        Dim type = cbForms.SelectedItem

        Dim frm = CType(Assembly.GetExecutingAssembly().CreateInstance("RuleEngineManage." & type), Form)
        frm.ShowDialog()
    End Sub

    Private Sub AutoAssignRules_Click(sender As Object, e As EventArgs) Handles AutoAssignRules.Click

        Dim rule = New AutoAssignRule()
        rule.Execute()
        MsgBox("auto assign finished !")
    End Sub
End Class

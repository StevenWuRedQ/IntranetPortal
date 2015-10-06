Imports IntranetPortal.Data
Imports IntranetPortal
Imports IntranetPortal.Data.DataAPI
Imports IntranetPortal.RulesEngine

Public Class Form1

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        ImportShortSale(txtBBLE.Text)
    End Sub

    Public Sub ImportShortSale(bble As String)
        Dim li = LeadsInfo.GetInstance(bble)

        If li IsNot Nothing Then
            Dim propBase = SaveProp(bble)
            Dim ssCase As New ShortSaleCase(propBase)
            ssCase.BBLE = bble
            ssCase.CaseName = li.LeadsName
            ssCase.CreateBy = "TestForm"
            ssCase.CreateDate = DateTime.Now
            ssCase.Save()
        End If
    End Sub

    Public Function SaveProp(bble As String) As PropertyBaseInfo
        Dim li = LeadsInfo.GetInstance(bble)
        Dim propBase = New PropertyBaseInfo
        propBase.BBLE = li.BBLE
        propBase.Block = li.Block
        propBase.Lot = li.Lot
        propBase.Number = li.Number
        propBase.StreetName = li.StreetName
        propBase.City = li.NeighName
        propBase.Zipcode = li.ZipCode
        propBase.TaxClass = li.TaxClass
        propBase.NumOfStories = li.NumFloors
        propBase.CreateDate = DateTime.Now
        propBase.CreateBy = "Testing"
        propBase.Save()
        Return propBase
    End Function

    Public Sub SaveChanges()
        Dim ssCase As New ShortSaleCase
        ssCase.CaseId = 1
        ssCase.BBLE = "3080090064"
        ssCase.CaseName = "testing"
        ssCase.PropertyInfo.Number = "700"

        Dim mg As New PropertyMortgage
        mg.Lender = "Bank of America"
        mg.Loan = "testing"
        mg.LoanAmount = 750000
        mg.AuthorizationSent = "test"
        mg.CreateBy = "Testing"

        'ssCase.Mortgages.Add(mg)

        ssCase.Save()
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        SaveProp(txtBBLE.Text)
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        SaveChanges()
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        'IntranetPortal.Core.EmailService.SendMail("chris@gvs4u.com", "stevenwu@gvs4u.com", "testing mail", "<span style='color:red'>testing mail</span>", New String() {"b70ddcff-8d22-4b65-8fc8-42b46f8b1380", "326926da-d5c9-419a-b8b0-57b6d09b6043"})
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Using ctx As New Entities
            For Each t In ctx.UserTasks.Where(Function(tk) tk.Status = UserTask.TaskStatus.Active)
                IntranetPortal.RulesEngine.TaskEscalationRule.Excute(t)
            Next
        End Using
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        'MessageBox.Show(IntranetPortal.RulesEngine.WorkingHours.GetWorkingDays(startDt.Value, DateTime.Now).ToString)

    End Sub

    Private Sub DateTimePicker2_ValueChanged(sender As Object, e As EventArgs)

    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Using client As New IntranetPortal.Data.DataAPI.WCFMacrosClient
            MessageBox.Show(client.Requests_Waiting)
            Return


            Dim data As New DataAPI.DOB_Complaints_In
            data.BBLE = "1022150377"
            data.DOB_PenOnly = True
            data.APIorderNum = (New Random()).Next(1000)
            data.SecurityCode = "DS543&8"
            'Dim result = client.DOB_Complaints_Get(data)
            Dim result = client.DOB_Complaints_Delete(data.BBLE)
            'Dim tbl = client.Get_DBO_Complaints_List("1022150377", False)
            'Dim bble = "1004490043"
            'Dim data = client.Get_NYC_TaxLien(bble, "")

            Return

            'Dim nameBase As New NameBase
            'nameBase.firstNameField = "George"
            'nameBase.lastNameField = "Vinsky"

            'Dim rresult = client.Get_TLO_Person(100, Nothing, Nothing, False, False, Nothing, "13074497", Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing)

            ''client.Get_LocateReport(100, "3015340029 ", "BUZHAKER, IGOR", "284 MACDOUGAL STREET", "", "BROOKLYN", "NY", "11234", "US", "", "")



            ''Dim result = client.AB_GetFederalTaxLien("Test123", "Queens", "0000-00-00", "0000-00-00", "", "", "", "", "D & S ELECTRICAL CORP", "ByCorpName")
            ''Dim result = client.AB_GetPatriot("Test123", "Queens", "0000-00-00", "0000-00-00", "ABU SITTA", "", "", "ByPersonName")
            ''Dim result = client.AB_GetParkingViolations("Test123", "Queens", "0000-00-00", "0000-00-00", "", "", "CORPORATION", "ByCorpName")
            ''Dim result = client.AAbs_GetUcc("Test123", "Queens", "0000-00-00", "0000-00-00", "", "", "Smith", "", "", "ByPersonName")
            ''Dim result = client.AAbs_GetEmergencyRepair("Test123", "Queens", "0000-00-00", "0000-00-00", "", "", "111-08", "207 STREET", "ByAddress")
            'Dim SelectedOwners As New List(Of OwnerInfo)

            ''1st person Element
            'Dim NewItem = New OwnerInfo() With {.FirstName = "mohammad", .LastName = "moamem", .IsOwnerPerson = True, .CorpName = Nothing, .HouseNum = "18", .St_Name = "CLOVERDALE BLVD", .Apt = "6", .City = "OAKLAND GDNS", .State = "NY", .Zip = "11364"}
            'SelectedOwners.Add(NewItem)


            ''2nd person Element
            'NewItem = New OwnerInfo() With {.FirstName = "shaun", .LastName = "moamem", .IsOwnerPerson = True, .CorpName = Nothing, .HouseNum = "18", .St_Name = "CLOVERDALE BLVD", .Apt = "6", .City = "OAKLAND GDNS", .State = "NY", .Zip = "11364"}
            'SelectedOwners.Add(NewItem)



            ''3rd person Element
            'NewItem = New OwnerInfo() With {.FirstName = "DALTON", .LastName = "SMITH", .IsOwnerPerson = True, .CorpName = Nothing, .HouseNum = "18", .St_Name = "CLOVERDALE BLVD", .Apt = "6", .City = "OAKLAND GDNS", .State = "NY", .Zip = "11364"}
            'SelectedOwners.Add(NewItem)



            ''4th Element s Corp
            'NewItem = New OwnerInfo() With {.FirstName = Nothing, .LastName = Nothing, .IsOwnerPerson = False, .CorpName = "D & S ELECTRICAL CORP", .HouseNum = "18", .St_Name = "CLOVERDALE BLVD", .Apt = "6", .City = "OAKLAND GDNS", .State = "NY", .Zip = "11364"}
            'SelectedOwners.Add(NewItem)




            ''5ft person Element
            'NewItem = New OwnerInfo() With {.FirstName = "ANDREW", .LastName = "SMITH", .IsOwnerPerson = True, .CorpName = Nothing, .HouseNum = "18", .St_Name = "CLOVERDALE BLVD", .Apt = "6", .City = "OAKLAND GDNS", .State = "NY", .Zip = "11364"}
            'SelectedOwners.Add(NewItem)



            ''6th Element Corp
            'NewItem = New OwnerInfo() With {.FirstName = Nothing, .LastName = Nothing, .IsOwnerPerson = False, .CorpName = "The Caprise Organization Inc", .HouseNum = "18", .St_Name = "CLOVERDALE BLVD", .Apt = "6", .City = "OAKLAND GDNS", .State = "NY", .Zip = "11364"}
            'SelectedOwners.Add(NewItem)
            'Dim result = client.AAbs_GetAreAbstractReport("4075321006", SelectedOwners.ToArray, True, True, True, True, True, True, True, True, True, True, True, False)

            ''client.NYC_Address_Search()
        End Using
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Dim shareFrom = "Jay Gottlieb"
        Dim shareTo = "Karol Rodriguez"

        Using ctx As New Entities
            Dim lds = ctx.Leads.Where(Function(ld) ld.EmployeeName = shareFrom And ld.Status = LeadStatus.NewLead).ToList

            For Each ld In lds
                Dim item = ctx.SharedLeads.Where(Function(sl) sl.BBLE = ld.BBLE And sl.UserName = shareTo).FirstOrDefault

                If item Is Nothing Then
                    Dim sharedItem As New SharedLead
                    sharedItem.BBLE = ld.BBLE
                    sharedItem.UserName = shareTo
                    sharedItem.CreateBy = "System"
                    sharedItem.CreateDate = DateTime.Now

                    ctx.SharedLeads.Add(sharedItem)
                End If
            Next
            ctx.SaveChanges()
        End Using

        MessageBox.Show("Compplete.")
    End Sub

    Private Sub Button9_Click(sender As Object, e As EventArgs) Handles Button9.Click
        Dim emailData As New Dictionary(Of String, String)
        emailData.Add("UserName", "Chris YAN")
        emailData.Add("Action", "Request Update")
        emailData.Add("BBLE", "4073820030")
        emailData.Add("Description", "princess need to get extra numbers for this owner of the lead, the  number i have is disconnected and family members dont know this person and are not related ")
        IntranetPortal.Core.EmailService.SendMail("portal@myidealprop.com", "", "UrgentTaskNotify", emailData)
    End Sub

    Private Sub btnInitialOwnerToken_Click(sender As Object, e As EventArgs) Handles btnInitialOwnerToken.Click
        For i = 0 To 100
            IntranetPortal.HomeOwner.InitalOwnerToken()
        Next

        MessageBox.Show("This is done!")
    End Sub

    Private Sub Button10_Click(sender As Object, e As EventArgs) Handles Button10.Click
        IntranetPortal.HomeOwner.CheckLocateReportObject(txtReportToken.Text)
    End Sub

    Private Sub ParseEamil_Click(sender As Object, e As EventArgs) Handles ParseEamil.Click
        Dim r = New ScanECourtsRule
        r.Execute()
        ParseText.Text = "Success"
        '''''''''''''''''''''''''''''''''
        'Dim msg = serv.GetNewEmails
        'For Each m In msg
        '    LegalECourt.Parse(m)
        'Next



    End Sub
End Class

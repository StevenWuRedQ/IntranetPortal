Imports IntranetPortal.ShortSale
Imports IntranetPortal

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

    Public Function SaveProp(bble As String) As IntranetPortal.ShortSale.PropertyBaseInfo
        Dim li = LeadsInfo.GetInstance(bble)
        Dim propBase = New IntranetPortal.ShortSale.PropertyBaseInfo
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

        ssCase.Mortgages.Add(mg)

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
        Dim client As New IntranetPortal.DataAPI.WCFMacrosClient

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
End Class

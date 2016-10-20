Imports IntranetPortal.Data
Public Class UnderwritingManager

    Public Shared Function getInstance(bble As String) As Underwriting
        Using ctx As New CodeFirstEntity
            Dim uw = From c In ctx.Underwritings
                     Where c.BBLE = bble
            Dim rt = uw.FirstOrDefault

            If Nothing IsNot rt Then
                For Each p In Core.EntityHelper(Of Underwriting).GetNavigationProperties(ctx)
                    ctx.Entry(rt).Reference(p.ToString).Load()
                Next
            End If

            Return rt
        End Using

    End Function


    Public Shared Function save(uw As Underwriting, saveby As String) As Underwriting

        Using ctx As New CodeFirstEntity

            Dim u = ctx.Underwritings.SingleOrDefault(Function(t) t.BBLE = uw.BBLE)

            If u IsNot Nothing Then

                uw.UpdateBy = saveby
                uw.UpdateDate = DateTime.Now
                ctx.Entry(u).CurrentValues.SetValues(uw)
                Core.EntityHelper(Of Underwriting).ReferenceUpdate(ctx, u, uw)
            Else
                uw.CreateBy = saveby
                uw.CreateDate = DateTime.Now
                ctx.Underwritings.Add(uw)

            End If
            ctx.SaveChanges()
            Return u
        End Using

    End Function


    Public Shared Function create(BBLE As String, createby As String) As Underwriting
        Using ctx As New CodeFirstEntity
            Dim u = New Underwriting
            u.PropertyInfo = New UnderwritingPropertyInfo
            u.DealCosts = New UnderwritingDealCosts
            u.RehabInfo = New UnderwritingRehabInfo
            u.RentalInfo = New UnderwritingRentalInfo
            u.LienInfo = New UnderwritingLienInfo
            u.LienCosts = New UnderwritingLienCosts
            u.MinimumBaselineScenario = New UnderwritingMinimumBaselineScenario
            u.BestCaseScenario = New UnderwritingBestCaseScenario
            u.CashScenario = New UnderwritingCashScenario
            u.LoanScenario = New UnderwritingLoanScenario
            u.RentalModel = New UnderwritingRentalModel
            u.Others = New UnderwritingOthers

            u.CreateBy = createby
            u.CreateDate = DateTime.Now
            u.Status = Underwriting.UnderwritingStatusEnum.NewCreated
            ctx.Underwritings.Add(u)
            Return u
        End Using
    End Function

    Public Shared Function archive(uw As Underwriting, archivedBy As String) As Underwriting

    End Function

End Class
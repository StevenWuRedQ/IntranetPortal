Imports System
Imports System.Data.Entity
Imports System.ComponentModel.DataAnnotations.Schema
Imports System.Linq
Imports System.ComponentModel.DataAnnotations

Partial Public Class CodeFirstEntity
    Inherits DbContext

    Public Property Underwritings As DbSet(Of Underwriting)
    Public Property UnderwritingPropertyInfos As DbSet(Of UnderwritingPropertyInfo)

    Public Property UnderwritingDealCosts As DbSet(Of UnderwritingDealCosts)
    Public Property UnderwritingRehabInfo As DbSet(Of UnderwritingRehabInfo)

    Public Property UnderwritingRentalInfo As DbSet(Of UnderwritingRentalInfo)
    Public Property UnderwritingLienInfo As DbSet(Of UnderwritingLienInfo)
    Public Property UnderwritingLienCosts As DbSet(Of UnderwritingLienCosts)

    Public Property UnderwritingMinimumBaselineScenario As DbSet(Of UnderwritingMinimumBaselineScenario)

    Public Property UnderwritingBestCaseScenario As DbSet(Of UnderwritingBestCaseScenario)

    Public Property UnderwritingCashScenario As DbSet(Of UnderwritingCashScenario)

    Public Property UnderwritingLoanScenario As DbSet(Of UnderwritingLoanScenario)

    Public Property UnderwritingRentalModel As DbSet(Of UnderwritingRentalModel)

    Public Property UnderwritingOthers As DbSet(Of UnderwritingOthers)


    Public Sub New()
        MyBase.New("name=CodeFirstEntity")
    End Sub


    Protected Overrides Sub OnModelCreating(ByVal modelBuilder As DbModelBuilder)
    End Sub
End Class
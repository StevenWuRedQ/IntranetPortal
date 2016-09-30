Imports System.ComponentModel.DataAnnotations
Imports System.ComponentModel.DataAnnotations.Schema

Public Class Underwriting
    <Key>
    Public Property Id As Integer
    Public Property BBLE As String
    Public Property CreateBy As String
    Public Property UpdateBy As String
    Public Property CreateDate As DateTime?
    Public Property UpdateDate As DateTime?

    Public Overridable Property PropertyInfo As UnderwritingPropertyInfo
    Public Overridable Property DealCosts As UnderwritingDealCosts
    Public Overridable Property RehabInfo As UnderwritingRehabInfo
    Public Overridable Property RentalInfo As UnderwritingRentalInfo
    Public Overridable Property LienInfo As UnderwritingLienInfo
    Public Overridable Property LienCosts As UnderwritingLienCosts

End Class

Public Class UnderwritingBestCaseScenario
    Public Property CashRequirement As Decimal
    Public Property NetProfit As Decimal
    Public Property PurchasePriceAllIn As Decimal
    Public Property ROI As Decimal
    Public Property TotalInvestment As Decimal
End Class

Public Class UnderwritingCarryingCost
    Public Property RETaxs As Decimal
    Public Property Utilities As Decimal
    Public Property Insurance As Decimal
    Public Property Sums As Decimal
End Class

Public Class UnderwritingCashScenario
    Public Property CashRequired As Decimal
    Public Property Purchase_CarryingCosts As Decimal
    Public Property Purchase_ClosingCost As Decimal
    Public Property Purchase_Construction As Decimal
    Public Property Purchase_DealCosts As Decimal
    Public Property Purchase_LienPayoffs As Decimal
    Public Property Purchase_OffHUDCosts As Decimal
    Public Property Purchase_TotalInvestment As Decimal
    Public Property ROI As Decimal
    Public Property ROIAnnual As Decimal
    Public Property Resale_ClosingCost As Decimal
    Public Property Resale_Commissions As Decimal
    Public Property Resale_Concession As Decimal
    Public Property Resale_NetProfit As Decimal
    Public Property Resale_SalePrice As Decimal
    Public Property Time As Integer
End Class

Public Class UnderwritingClosingCost
    Public Property TitleBill As Decimal
    Public Property BuyerAttorney As Decimal
    Public Property PartialSums As Decimal
    Public Property OwnersPolicy As Decimal
    Public Property Sums As Decimal
End Class

Public Class UnderwritingConstruction
    Public Property Construction As Decimal
    Public Property Architect As Decimal
    Public Property Sums As Decimal
End Class

Public Class UnderwritingDealCosts
    Public Property MoneySpent As Decimal
    Public Property HOI As Decimal
    Public Property COSTermination As Decimal
    Public Property AgentCommission As Decimal
End Class

Public Class UnderwritingDealExpenses
    Public Property Agent As Decimal
    Public Property COSTermination As Decimal
    Public Property HOILien As Decimal
    Public Property HOILienSettlement As Decimal
    Public Property MoneySpent As Decimal
    Public Property Sums As Decimal
    Public Property Tenants As Decimal
End Class

Public Class UnderwritingFlipCalculation
    Public Property FlipROI As Decimal
    Public Property FlipPrice As Decimal
End Class

Public Class UnderwritingFlipScenario
    Public Property CashRequirement As Decimal
    Public Property FlipPrice_SalePrice As Decimal
    Public Property FlipProfit As Decimal
    Public Property Purchase_CarryingCosts As Decimal
    Public Property Purchase_ClosingCost As Decimal
    Public Property Purchase_Construction As Decimal
    Public Property Purchase_PurchasePrice As Decimal
    Public Property Purchase_TotalCost As Decimal
    Public Property Purchase_TotalInvestment As Decimal
    Public Property ROI As Decimal
    Public Property Resale_ClosingCost As Decimal
    Public Property Resale_Commissions As Decimal
    Public Property Resale_Concession As Decimal
    Public Property Resale_NetProfit As Decimal
    Public Property Resale_SalePrice As Decimal
End Class

Public Class UnderwritingHOI
    Public Property Value As Decimal
    Public Property PurchasePriceAllIn As Decimal
    Public Property TotalInvestment As Decimal
    Public Property CashRequirement As Decimal
    Public Property NetProfit As Decimal
    Public Property ROILoan As Decimal
End Class

Public Class UnderwritingHOIBestCase
    Public Property PurchasePriceAllIn As Decimal
    Public Property TotalInvestment As Decimal
    Public Property CashRequirement As Decimal
    Public Property NetProfit As Decimal
    Public Property ROILoan As Decimal
End Class

Public Class UnderwritingInsurancePremium
    Public Property From() As Decimal
    Public Property _To() As Decimal
    Public Property OwnersPolicyRate() As Decimal
    Public Property LoanPolicyRate() As Decimal
    Public Property CostOwnersPolicy() As Decimal?
    Public Property CostLoanPolicy() As Decimal?
    Public Property PurchasePrice As Decimal
    Public Property LoanAmountDiscounted As Decimal
    Public Property LoanAmountFullPremium As Decimal
    Public Property OwnersPolicy As Decimal
    Public Property OwnersLoanPolicyDiscounted As Decimal
    Public Property OwnersLoanPolicyFullPremium As Decimal
    Public Property TitleInsurance As Decimal
End Class

Public Class UnderwritingLiens
    Public Property LienPayoffsSettlement As Decimal
    Public Property TaxLienSettlement As Decimal
    Public Property PropertyTaxesSettlement As Decimal
    Public Property WaterChargesSettlement As Decimal
    Public Property HPDChargesSettlement As Decimal
    Public Property ECBDOBViolationsSettlement As Decimal
    Public Property DOBCivilPenaltiesSettlement As Decimal
    Public Property PersonalJudgementsSettlement As Decimal
    Public Property HPDJudgementsSettlement As Decimal
    Public Property RelocationLienSettlement As Decimal
    Public Property TaxLien As Decimal
    Public Property PropertyTaxes As Decimal
    Public Property WaterCharges As Decimal
    Public Property HPDCharges As Decimal
    Public Property ECBDOBViolations As Decimal
    Public Property DOBCivilPenalties As Decimal
    Public Property PersonalJudgements As Decimal
    Public Property HPDJudgements As Decimal
    Public Property IRSNYSTaxLienSettlement As Decimal
    Public Property IRSNYSTaxLien As Decimal
    Public Property RelocationLien As Decimal
    Public Property Sums As Decimal
    Public Property AdditonalCostsSums As Decimal
    Public Property LienPayoffs As Decimal
End Class


Public Class UnderwritingLienCosts
    Public Property TaxLienCertificate As Decimal
    Public Property PropertyTaxes As Decimal
    Public Property WaterCharges As Decimal
    Public Property HPDCharges As Decimal
    Public Property ECBDOBViolations As Decimal
    Public Property DOBCivilPenalty As Decimal
    Public Property PersonalJudgements As Decimal
    Public Property HPDJudgements As Decimal
    Public Property IRSNYSTaxLiens As Decimal
    Public Property VacateOrder As Boolean
    Public Property RelocationLien As Decimal
    Public Property RelocationLienDate As DateTime?
End Class

Public Class UnderwritingLienInfo
    Public Property AuctionDate As DateTime?
    Public Property COSRecorded As Boolean
    Public Property CurrentPayoff As Decimal
    Public Property CurrentSSValue As Decimal
    Public Property DeedRecorded As Boolean
    Public Property DefaultDate As DateTime?
    Public Property FHA As Boolean
    Public Property FannieMae As Boolean
    Public Property FirstMortgage As Decimal
    <MaxLength(50)>
    Public Property ForeclosureIndexNum As String
    <MaxLength(256)>
    Public Property ForeclosureNote As String
    Public Property ForeclosureStatus As String
    Public Property FreddieMac As Boolean
    Public Property OtherLiens As OtherLiensEnum
    Public Property PayoffDate As String
    Public Property SecondMortgage As Decimal
    <MaxLength(50)>
    Public Property Servicer As String

    Enum OtherLiensEnum
        No = 1
        CourtOrder = 2
        MechanicsLien = 3
        SpecificPerformance = 4
        SundryAgreement = 5
        UCC = 6
    End Enum
    Enum ForeclosureStatusEnum
        NotSure = 1
        NoActionDismissed = 2
        SummonsComplaint = 3
        SettlementConference = 4
        RJI = 5
        OrderOfReference = 6
        JudgmentOfForeclosureAndSale = 7

    End Enum

End Class


Public Class UnderwritingLoanCosts
    Public Property LoanClosingCost As Decimal
    Public Property Points As Decimal
    Public Property LoanInterest As Decimal
    Public Property LoanPolicy As Decimal
    Public Property Sums As Decimal
End Class


Public Class UnderwritingLoanScenario
    Public Property Purchase_PurchasePrice As Decimal
    Public Property Purchase_AdditonalCosts As Decimal
    Public Property Purchase_DealCosts As Decimal
    Public Property Purchase_ClosingCost As Decimal
    Public Property Purchase_Construction As Decimal
    Public Property Purchase_CarryingCosts As Decimal
    Public Property Purchase_LoanClosingCost As Decimal
    Public Property Purchase_LoanInterest As Decimal
    Public Property Purchase_TotalInvestment As Decimal
    Public Property Resale_SalePrice As Decimal
    Public Property Resale_Concession As Decimal
    Public Property Resale_Commissions As Decimal
    Public Property Resale_ClosingCost As Decimal
    Public Property Resale_NetProfit As Decimal
    Public Property Time As Integer
    Public Property LoanAmount As Decimal
    Public Property LTV As Decimal
    Public Property CashRequirement As Decimal
    Public Property ROI As Decimal
    Public Property ROIAnnual As Decimal
    Public Property CashROI As Decimal
    Public Property CashROIAnnual As Decimal
End Class


Public Class UnderwritingLoanTerms
    Public Property LoanRate As Decimal
    Public Property LoanPoints As Decimal
    Public Property LoanTermMonths As Integer
    Public Property LTV As Decimal
    Public Property LoanAmount As Decimal
End Class


Public Class UnderwritingMinimumBaselineScenario
    Public Property PurchasePriceAllIn As Decimal
    Public Property TotalInvestment As Decimal
    Public Property CashRequirement As Decimal
    Public Property NetProfit As Decimal
    Public Property ROI As Decimal
End Class


Public Class UnderwritingMoneyFactor
    Public Property CostOfMoney As Decimal
    Public Property InterestOnMoney As Decimal
End Class


Public Class UnderwritingOthers
    Public Property MaximumLienPayoff As Decimal
    Public Property MaximumSSPrice As Decimal
    Public Property MaxHOI As Decimal
End Class



Public Class UnderwritingPropertyInfo
    <Key>
    Public Property Id As Integer

    Public Property ActualNumOfUnits As Integer
    <MaxLength(50)>
    Public Property BuildingDimension As String
    <MaxLength(50)>
    Public Property LotSize As String
    Public Property NumOfTenants As Integer
    Public Property OccupancyStatus As OccupancyStatusEnum

    Public Property PropertyAddress As String
    Public Property PropertyTaxYear As Decimal

    Public Property PropertyType As PropertyTypeEnum
    Public Property SellerOccupied As Boolean
    <MaxLength(50)>
    Public Property TaxClass As String
    <MaxLength(50)>
    Public Property Zoning As String

    Enum OccupancyStatusEnum
        Unknown = 1
        Vacant = 2
        Seller = 3
        SellerTenant = 4
        Tenant = 5
        MultipleTenant = 6
    End Enum

    Enum PropertyTypeEnum
        Residential = 1
        NotResidential = 2
    End Enum

End Class

Public Class UnderwritingRehabInfo
    Public Property AverageLowValue As Decimal
    Public Property DealROICash As Decimal
    Public Property DealTimeMonths As Integer
    Public Property RenovatedValue As Decimal
    Public Property RepairBid As Decimal
    Public Property SalesCommission As Decimal
End Class

Public Class UnderwritingRentalInfo
    Public Property DeedPurchase As Decimal
    Public Property CurrentlyRented As Boolean
    Public Property RepairBidTotal As Decimal
    Public Property NumOfUnits As Integer
    Public Property MarketRentTotal As Decimal
    Public Property RentalTime As Integer
End Class

Public Class UnderwritingRentalModel
    Public Property CostOfMoneyRate As Decimal
    Public Property MinROI As Decimal
    Public Property Insurance As Decimal
    Public Property NumOfUnits As Integer
    Public Property DeedPurchase As Decimal
    Public Property TotalRepairs As Decimal
    Public Property AgentCommission As Decimal
    Public Property TotalUpfront As Decimal
    Public Property Rent As Decimal
    Public Property ManagementFee As Decimal
    Public Property Maintenance As Decimal
    Public Property MiscRepairs As Decimal
    Public Property NetMontlyRent As Decimal
    Public Property TotalMonth As Integer
    Public Property CostOfMoney As Decimal
    Public Property TotalCost As Decimal
    Public Property Breakeven As Integer
    Public Property TargetTime As Integer
    Public Property TargetProfit As Decimal
    Public Property ROIYear As Decimal

    Public Property ROITotal As Decimal
End Class

Public Class UnderwritingResale
    Public Property Concession As Decimal
    Public Property Attorney As Decimal
    Public Property NDC As Decimal
    Public Property ProbableResale As Decimal
    Public Property Commissions As Decimal
    Public Property TransferTax As Decimal
    Public Property Sums As Integer
End Class
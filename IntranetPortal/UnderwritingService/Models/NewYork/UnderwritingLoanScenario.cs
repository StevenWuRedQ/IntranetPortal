using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingLoanScenario
    {
        [Key()]
        public int Id { get; set; }
        public int Time { get; set; }

        public double PurchasePurchasePrice { get; set; }
        public double PurchaseAdditonalCosts { get; set; }
        public double PurchaseDealCosts { get; set; }
        public double PurchaseClosingCost { get; set; }
        public double PurchaseConstruction { get; set; }
        public double PurchaseCarryingCosts { get; set; }
        public double PurchaseLoanClosingCost { get; set; }
        public double PurchaseLoanInterest { get; set; }
        public double PurchaseTotalInvestment { get; set; }
        public double ResaleSalePrice { get; set; }
        public double ResaleConcession { get; set; }
        public double ResaleCommissions { get; set; }
        public double ResaleClosingCost { get; set; }
        public double ResaleNetProfit { get; set; }
        public double LoanAmount { get; set; }
        public double LTV { get; set; }
        public double CashRequirement { get; set; }
        public double ROI { get; set; }
        public double ROIAnnual { get; set; }
        public double CashROI { get; set; }
        public double CashROIAnnual { get; set; }
    }
}
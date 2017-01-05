using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingCashScenario
    {
        [Key()]
        public int Id { get; set; }
        public double  CashRequired { get; set; }
        public double  PurchaseCarryingCosts { get; set; }
        public double  PurchaseClosingCost { get; set; }
        public double  PurchaseConstruction { get; set; }
        public double  PurchaseDealCosts { get; set; }
        public double  PurchaseLienPayoffs { get; set; }
        public double  PurchaseOffHUDCosts { get; set; }
        public double  PurchaseTotalInvestment { get; set; }
        public double  ROI { get; set; }
        public double  ROIAnnual { get; set; }
        public double  ResaleClosingCost { get; set; }
        public double  ResaleCommissions { get; set; }
        public double  ResaleConcession { get; set; }
        public double  ResaleNetProfit { get; set; }
        public double  ResaleSalePrice { get; set; }
        public int Time { get; set; }
    }
}
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingFlipScenario
    {
        [Key()]
        public int Id { get; set; }

        public double  CashRequirement { get; set; }
        public double  FlipPriceSalePrice { get; set; }
        public double  FlipProfit { get; set; }
        public double  PurchaseCarryingCosts { get; set; }
        public double  PurchaseClosingCost { get; set; }
        public double  PurchaseConstruction { get; set; }
        public double  PurchasePurchasePrice { get; set; }
        public double  PurchaseTotalCost { get; set; }
        public double  PurchaseTotalInvestment { get; set; }
        public double  ROI { get; set; }
        public double  ResaleClosingCost { get; set; }
        public double  ResaleCommissions { get; set; }
        public double  ResaleConcession { get; set; }
        public double  ResaleNetProfit { get; set; }
        public double  ResaleSalePrice { get; set; }
    }
}
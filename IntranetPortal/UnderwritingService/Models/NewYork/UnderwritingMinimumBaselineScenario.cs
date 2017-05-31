using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingMinimumBaselineScenario
    {
        [Key()]
        public int Id { get; set; }

        public double PurchasePriceAllIn { get; set; }
        public double TotalInvestment { get; set; }
        public double CashRequirement { get; set; }
        public double NetProfit { get; set; }
        public double ROI { get; set; }
    }
}
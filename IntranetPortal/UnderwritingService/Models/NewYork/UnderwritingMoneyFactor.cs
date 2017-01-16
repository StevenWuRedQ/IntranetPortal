using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingMoneyFactor
    {
        public double CostOfMoney { get; set; }
        public double InterestOnMoney { get; set; } = 0.18;
    }
}
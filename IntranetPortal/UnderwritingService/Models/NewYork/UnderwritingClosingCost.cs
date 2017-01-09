using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingClosingCost
    {
        public int Id { get; set; }

        public double TitleBill { get; set; } = 1200;
        public double BuyerAttorney { get; set; } = 1250;
        public double OwnersPolicy { get; set; }
        public double PartialSums { get; set; }
        public double Sums { get; set; }
    }
}
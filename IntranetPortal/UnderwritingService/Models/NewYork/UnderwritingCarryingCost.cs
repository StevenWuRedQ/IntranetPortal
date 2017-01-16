using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingCarryingCost
    {
        public double RETaxs { get; set; }
        public double Utilities { get; set; }
        public double Insurance { get; set; }
        public double Sums { get; set; }
    }
}
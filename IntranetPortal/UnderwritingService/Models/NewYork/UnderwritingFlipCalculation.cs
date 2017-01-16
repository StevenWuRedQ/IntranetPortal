using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingFlipCalculation
    {
        public double FlipROI { get; set; } = 0.15;
        public double  FlipPrice { get; set; }
    }
}
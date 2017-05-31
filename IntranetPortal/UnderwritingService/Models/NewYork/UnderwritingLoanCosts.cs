using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingLoanCosts
    {

        public double LoanClosingCost { get; set; }
        public double Points { get; set; }
        public double LoanInterest { get; set; }
        public double LoanPolicy { get; set; }
        public double Sums { get; set; }
    }
}
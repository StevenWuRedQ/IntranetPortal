using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingLoanTerms
    {

        public double LoanRate { get; set; } = 0.12;
        public double LoanPoints { get; set; } = 2;
        public int LoanTermMonths { get; set; } = 12;
        public double LTV { get; set; } = 0.6;
        public double LoanAmount { get; set; }
    }
}
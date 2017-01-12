using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingInsurancePremium
    {
        public int[] _From = { 35001, 50001, 100001, 500001, 1000001, 5000001, 10000001, 15000001 };
        public int[] _To = { 50000, 100000, 500000, 1000000, 5000000, 10000000, 15000000 };
        public double[] OwnersPolicyRate = { .00667, .00543, .00436, .00398, .00366, .00325, .00307, .00276 };
        public double[] LoanPolicyRate = { 0.00555, 0.00454, 0.00364, 0.00331, 0.00305, 0.00271, 0.00255, 0.00231 };
        public double[] CostOwnersPolicy = { 502.04, 773.54, 2517.53, 4507.53, 19147.53, 35397.52, 50747.52 };
        public double[] CostLoanPolicy = { 427.24, 654.24, 2110.24, 3765.23, 15965.23, 29515.23, 42265.22 };

        public double PurchasePrice { get; set; }
        public double LoanAmountDiscounted { get; set; }
        public double LoanAmountFullPremium { get; set; }
        public double OwnersPolicy { get; set; }
        public double OwnersLoanPolicyDiscounted { get; set; }
        public double OwnersLoanPolicyFullPremium { get; set; }
        public double TitleInsurance { get; set; }
    }
}
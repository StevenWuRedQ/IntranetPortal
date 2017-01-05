using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingResale
    {
        [Key()]
        public int Id { get; set; }

        public double Concession { get; set; }
        public double Attorney { get; set; } = 1250;
        public double NDC { get; set; } = 500;
        public double  ProbableResale { get; set; }
        public double  Commissions { get; set; }
        public double  TransferTax { get; set; }
        public double Sums { get; set; }
    }
}
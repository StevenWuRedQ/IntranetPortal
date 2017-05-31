using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingDealCosts
    {
        [Key()]
        public int Id { get; set; }

        public double  MoneySpent { get; set; }
        public bool HAFA { get; set; }
        public double  HOI { get; set; }
        public double  HOIRatio { get; set; }
        public double  COSTermination { get; set; }
        public double  AgentCommission { get; set; }
    }
}
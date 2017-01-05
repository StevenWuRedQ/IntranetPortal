using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingDealExpenses
    {
        public double  Agent { get; set; }
        public double  COSTermination { get; set; }
        public double  HOILien { get; set; }
        public double  HOILienSettlement { get; set; }
        public double  MoneySpent { get; set; }
        public double  Tenants { get; set; }
        public double  Sums { get; set; }
    }
}
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingRehabInfo
    {
        [Key()]
        public int Id { get; set; }

        public double  AverageLowValue { get; set; }
        public double  RenovatedValue { get; set; }
        public double  RepairBid { get; set; }
        public bool NeedsPlans { get; set; }
        public int DealTimeMonths { get; set; }
        public double  SalesCommission { get; set; } = 0.05;
        public double  DealROICash { get; set; } = 0.35;
    }
}
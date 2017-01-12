using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingRentalModel
    {
        [Key()]
        public int Id { get; set; }
        public int NumOfUnits { get; set; }
        public int TotalMonth { get; set; }
        public int Breakeven { get; set; }
        public int TargetTime { get; set; }

        public double CostOfMoneyRate { get; set; } = 0.16;
        public double MinROI { get; set; } = 0.18; 
        public double Insurance { get; set; } = 85;
        public double DeedPurchase { get; set; }
        public double TotalRepairs { get; set; }
        public double AgentCommission { get; set; }
        public double TotalUpfront { get; set; }
        public double Rent { get; set; }
        public double ManagementFee { get; set; }
        public double Maintenance { get; set; }
        public double MiscRepairs { get; set; }
        public double NetMontlyRent { get; set; }
        public double CostOfMoney { get; set; } = 0.16;
        public double TotalCost { get; set; }
        public double TargetProfit { get; set; }
        public double ROIYear { get; set; }
        public double ROITotal { get; set; }
    }
}
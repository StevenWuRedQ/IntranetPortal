using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingRentalInfo
    {
        [Key()]
        public int Id { get; set; }

        public double  DeedPurchase { get; set; }
        public bool CurrentlyRented { get; set; }
        public double  RepairBidTotal { get; set; }
        public int NumOfUnits { get; set; }
        public double  MarketRentTotal { get; set; }
        public int RentalTime { get; set; }
    }
}
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingSummary
    {
        [Key()]
        public int Id { get; set; }

        public double MaximumLienPayoff { get; set; }
        public double MaximumSSPrice { get; set; }
        public double MaxHOI { get; set; }
    }
}
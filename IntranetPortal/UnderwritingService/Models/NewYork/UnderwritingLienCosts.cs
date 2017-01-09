

using System;
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingLienCosts
    {
        [Key()]
        public int Id { get; set; }

        public double TaxLienCertificate { get; set; }
        public double PropertyTaxes { get; set; }
        public double WaterCharges { get; set; }
        public double ECBCityPay { get; set; }
        public double DOBCivilPenalty { get; set; }
        public double HPDCharges { get; set; }
        public double HPDJudgements { get; set; }
        public double PersonalJudgements { get; set; }
        public double NYSTaxWarrants { get; set; }
        public double FederalTaxLien { get; set; }
        public double ParkingViolation { get; set; }
        public double TransitAuthority { get; set; }
        public double RelocationLien { get; set; }

        public bool SidewalkLiens { get; set; }
        public bool VacateOrder { get; set; }
        public DateTime? RelocationLienDate { get; set; }
    }

}
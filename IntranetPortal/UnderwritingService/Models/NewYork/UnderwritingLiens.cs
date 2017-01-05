using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingLiens
    {
        public double TaxLienCertificate;
        public double PropertyTaxes;
        public double WaterCharges;
        public double HPDCharges;
        public double ECBCityPay;
        public double DOBCivilPenalties;
        public double PersonalJudgements;
        public double HPDJudgements;
        public double NYSTaxWarrants;
        public double FederalTaxLien;
        public double ParkingViolation;
        public double RelocationLien;
        public double TransitAuthority;
        public double LienPayoffs;
        public double Sums;
        public double AdditonalCostsSums;
    }
}
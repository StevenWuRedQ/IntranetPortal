using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingSettlement
    {
        public double LienPayoffsSettlement = 1.0;
        public double TaxLienCertificateSettlement = 0.09 / 12;
        public double WaterChargesSettlement = 1.0;
        public double PropertyTaxesSettlement = 1.0;
        public double ECBCityPaySettlement = 1.0;
        public double DOBCivilPenaltiesSettlement = 1.0;
        public double HPDChargesSettlement = 1.0;
        public double HPDJudgementsSettlement = 0.15;
        public double PersonalJudgementsSettlement = 0.40;
        public double ParkingViolationSettlement = 1.0;
        public double TransitAuthoritySettlement = 1.0;
        public double RelocationLienSettlement = .09 / 365;
        public double NYSTaxWarrantsSettlement = 0.0;
        public double FederalTaxLienSettlement = 0.0;
    }
}
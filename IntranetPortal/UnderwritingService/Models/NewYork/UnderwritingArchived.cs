using System;
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingArchived
    {
        [Key()]
        public int Id { get; set; }
        public string BBLE { get; set; }
        public string ArchivedBy { get; set; }
        public DateTime ArchivedDate { get; set; }

        [MaxLength(50)]
        public string ArchivedNote { get; set; }
        // input
        public virtual UnderwritingPropertyInfo PropertyInfo { get; set; }
        public virtual UnderwritingDealCosts DealCosts { get; set; }
        public virtual UnderwritingRehabInfo RehabInfo { get; set; }
        public virtual UnderwritingLienInfo LienInfo { get; set; }
        public virtual UnderwritingLienCosts LienCosts { get; set; }
        public virtual UnderwritingRentalInfo RentalInfo { get; set; }
        // output
        public virtual UnderwritingCashScenario CashScenario { get; set; }
        public virtual UnderwritingLoanScenario LoanScenario { get; set; }
        public virtual UnderwritingFlipScenario FlipScenario { get; set; }
        public virtual UnderwritingMinimumBaselineScenario MinimumBaselineScenario { get; set; }
        public virtual UnderwritingBestCaseScenario BestCaseScenario { get; set; }
        public virtual UnderwritingRentalModel RentalModel { get; set; }
    }
}
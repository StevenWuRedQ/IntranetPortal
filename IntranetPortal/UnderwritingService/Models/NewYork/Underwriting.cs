using System;
using System.ComponentModel.DataAnnotations;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class Underwriting
    {
        [Key()]
        public int Id { get; set; }

        public string BBLE { get; set; }
        public string CreateBy { get; set; }
        public string UpdateBy { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string StatusNote { get; set; }
        public DateTime? CompletedOn { get; set; }
        public UnderwritingStatusEnum Status { get; set; }
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

        public enum UnderwritingStatusEnum
        {
            Deleted = 0,
            NewCreated = 1,
            Processing = 2,
            Accpeted = 3,
            Rejected = 4
        }
    }
}
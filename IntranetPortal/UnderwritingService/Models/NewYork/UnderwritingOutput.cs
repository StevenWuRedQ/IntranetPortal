using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingOutput
    {
        public UnderwritingCashScenario CashScenario;
        public UnderwritingLoanScenario LoanScenario;
        public UnderwritingFlipScenario FlipScenario;
        public UnderwritingMinimumBaselineScenario MinimumBaselineScenario;
        public UnderwritingBestCaseScenario BestCaseScenario;
        public UnderwritingRentalModel RentalModel;
        public UnderwritingSummary Summary;
    }
}
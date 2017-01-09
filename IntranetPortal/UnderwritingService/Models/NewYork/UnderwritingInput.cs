using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RedQ.UnderwritingService.Models.NewYork
{
    public class UnderwritingInput
    {
        public UnderwritingPropertyInfo PropertyInfo;
        public UnderwritingDealCosts DealCosts;
        public UnderwritingRehabInfo RehabInfo;
        public UnderwritingLienInfo LienInfo;
        public UnderwritingRentalInfo RentalInfo;
        public UnderwritingLienCosts LienCosts;
    }
}